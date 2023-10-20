(require [amb3 [*]])
(import [amb3 [*]]
        glob re)

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-context [&optional [eul False] [threaded True]]
  (sv prefix (+ "frontier-v1-*-nnodes"
                (if eul "eul-" "")
                (if threaded "" "nothrd-"))
      timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:tl-sc prim_run_subcycle_c"
                "a:compute_stage_value_dirk" "a:caar compute"
                "a:EAMxx::physics::run"
                (if eul
                    "a:tl-at prim_advec_tracers_remap_RK2"
                    "a:compose_transport")
                "CPL:LND_RUN" "l:interpMonthlyVeg"))
  {:prefix prefix
   :machine-name "Frontier"
   :compset "ne1024pg2_ne1024pg2.F2010-SCREAMv1"
   :glob-data (+ "../data/" prefix "*-model_timing_stats")
   :timers0 (cut timers 0 1)
   :timers1 (cut timers 0 2)
   :timers2 (cut timers 0 5)
   :timers3 timers
   :timersa (cut timers 0 3)
   :timersb (cut timers 3 6)
   :timersacut (cut timers 0 2)
   :timersbcut (cut timers 3 6)
   :linepats (dfor (, t p)
                   (zip timers
                        (, "ko-" "rv-" "gs-" "ko-" "rv-" "gs-"))
                   [t p])
   :timer-aliases (dfor (, t a)
                        (zip timers
                             (, "Model" "Atmosphere" "Dycore" "Dycore::DIRK"
                                "Dycore::CAAR" "Physics" "Dycore::SL" "Land"
                                "Land::interpMonthlyVeg"))
                        [t a])
   :timer-short-aliases (dfor (, t a)
                              (zip timers
                                   (, "Model" "Atm." "Dycore" "DIRK"
                                              "CAAR" "Physics" "SL" "Land"
                                              "Land::interpMonthlyVeg"))
                              [t a])
   :re-timer-ln (re.compile
                 "\"(.*)\"\s+-\s+(\d+)\s+(\d+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)")
   :nnodes (, 512 1024 2048 4096 8192)
   :ngpu-per-node 8
   :machpat "-"
   :dt_physics 100})

(defn get-context-summit []
  (sv c (get-context)
      timers (:timers3 c)
      prefix "scream-v1-scaling2-")
  (assoc c
         :prefix prefix
         :machine-name "Summit"
         :glob-data (+ "../../screamv1-summit-oct2022/data/" prefix
                       "*-model_timing_stats")
         :nnodes (, 1024 2048 3072 4096 4608)
         :ngpu-per-node 6
         :machpat "--")
  c)

(defn get-context-pmgpu []
  (sv c (get-context)
      timers (:timers3 c)
      prefix "pm-gpu-v1-scaling1")
  (assoc c
         :prefix prefix
         :machine-name "Perlmutter-GPU"
         :glob-data (+ "../../screamv1-pm-gpu-mar2023/data/" prefix
                       "*-model_timing_stats")
         :nnodes (, 384 512 1024 1536)
         :ngpu-per-node 4
         :machpat ":")
  c)

(defn get-context-pmcpu []
  (sv c (get-context)
      timers (:timers3 c)
      prefix "pm-cpu-v1-scaling1")
  (assoc c
         :prefix prefix
         :machine-name "Perlmutter-CPU"
         :glob-data (+ "../../screamv1-pm-cpu-mar2023/data/" prefix
                       "*-model_timing_stats")
         :nnodes (, 1536 2048)
         ;; 128 cores gives correct nnodes; of course, there are 0 GPUs/node
         :ngpu-per-node 128
         :machpat "-.")
  c)

(defn parse-timer-line [c ln]
  (sv m (re.findall (:re-timer-ln c) ln))
  (unless (empty? m)
    (assert (= (len m) 1))
    (sv m (first m))
    (dfor (, i k)
          (enumerate (, :name :nproc :nthread :count :total :max))
          [k (nth m i)])))

(defn calc-calls-per-sec [t]
  (/ (:count t) (:nthread t) (:max t)))

(defn calc-sypd [c d t]
  (sv rcl (get d "CPL:RUN_LOOP"))
  (/ (* (:dt_physics c) (/ (:count rcl) (:nthread rcl)))
     (:max (get d t))))

(defn parse-timer-file [c fname]
  (assert (in (:compset c) fname))
  (sv txt (.split (readall fname) "\n")
      d {:fname fname})
  (for [ln txt]
    (sv t (parse-timer-line c ln))
    (unless (none? t)
      (assoc d (:name t)
             (dfor (, k coerce)
                   (, [:nproc int] [:nthread int] [:count float]
                      [:total float] [:max float])
                   [k (coerce (get t k))]))))
  d)

;;   key: nnode, timer
;; value: dict with keys :nproc, :nthread, :count, :total, :max
(defn parse-timer-files [c fnames]
  (sv d {})
  (for [fname fnames]
    (sv d1 (parse-timer-file c fname))
    (sv nnode (// (:nproc (get d1 "CPL:RUN_LOOP")) (:ngpu-per-node c)))
    (assoc-nested-append d (, nnode) d1))
  d)

(defn plot-sdpd-vs-nnode [c d timer-set plot-extra-points
                          &optional ylabel title fontsize legend annotations
                          cpu-sizing ref-line machpat smaller-legend]
  (svifn ylabel True title True fontsize 14 legend True annotations True
         cpu-sizing False ref-line True machpat False smaller-legend False)
  (sv xform (fn [x] (npy.log x))
      plot pl.semilogy
      timers (get c timer-set)
      fs fontsize
      xval (xform (:nnodes c)))
  (defn annotate [x y &optional [above False]]
    (for [i (range (len x))]
      (pl.text (nth x i) (* (nth y i)
                            (cond [(= timer-set :timers2) 0.8]
                                  [(and above (= timer-set :timers1)) 1.05]
                                  [(= timer-set :timers1) 0.82]
                                  [(= timer-set :timersa) 0.8]
                                  [(and above (= timer-set :timersa)) 1.05]))
               (.format "{:1.1f}" (nth y i))
               :fontsize (- fs 0) :ha "center")))
  (sv g 0.2
      x [(first (:nnodes c)) (last (:nnodes c))])
  (sv fnames []
      hs [])
  (for [(, itimer timer) (enumerate timers)]
    (sv pat (get (:linepats c) timer)
        y [])
    (for [(, inode nnode) (enumerate (:nnodes c))]
      ;; Sort redundantly since the nnode loop is inside the timer one.
      (sv (, top-times p) (sort-with-p (lfor d1 (get d nnode)
                                             (calc-sypd c d1 "CPL:RUN_LOOP")))
          d1 (nth (get d nnode) (first p)))
      (if (zero? itimer)
        (do (.append fnames (:fname d1))
            (prf "Using {} for nnode {} with max {}"
                 (:fname d1) nnode (:max (get d1 "CPL:RUN_LOOP"))))
        (assert (= (:fname d1) (nth fnames inode))))
      (.append y (calc-sypd c d1 timer))
      (when plot-extra-points
        (for [idx (cut p 1)]
          (plot (xform nnode)
                (calc-sypd c (nth (get d nnode) idx) timer)
                (cut pat 0 -1)))))
    (when machpat
      (sv pat (+ (cut pat 0 -1) (:machpat c))))
    (sv h (plot xval y pat
                :lw 2 :markersize 10 :fillstyle "none"
                :label (if legend (get (:timer-aliases c) timer))))
    (.append hs (first h))
    (when annotations
      (sv annotate-atm (and (= timer-set :timers1) (= timer "CPL:ATM_RUN")))
      (when (or (= timer "CPL:RUN_LOOP") annotate-atm)
        (annotate xval y :above annotate-atm))))
  (my-grid)
  (pl.xticks xval (:nnodes c) :fontsize fs)
  (sv yscale None)
  (if cpu-sizing
    (cond [(= timer-set :timersa)
           (sv y [20 30 40 50 60 70 80 90 100 125 150 175 200 250 300 350
                  400 450 500 550 600 700]
               yscale 90)
           (pl.ylim (, 20 750))]
          [(= timer-set :timersbcut)
           (sv y [80 90 100 125 150 175 200 250 300 350 400 450 500 600 700 800 900
                  1000 1200 1400 1600 1800 2000 2500 3000 3500]
               yscale 500)
           (pl.ylim (, 80 3800))])
    (cond [(= timer-set :timers2)
           (sv y [50 100 150 200 300 400 500 600 700 800 900 1000
                  1200 1400 1600 1800]
               yscale 150)
           (pl.ylim (, 35 1800))]
          [(= timer-set :timers1)
           (sv y [60 100 125 150 175 200 250]
               yscale 90)
           (pl.ylim (, 60 250))]
          [(= timer-set :timersa)
           (sv y [50 60 70 80 90 100 125 150 175 200 250 300 350
                  400 450 500 550 600]
               yscale 90)
           (pl.ylim (, 45 600))]
          [(= timer-set :timersb)
           (sv y [200 300 400 500 600 700 800 900 1000 1200 1400
                  1600 1800 2000 2250 2500 2750 3000 3400]
               yscale 400)
           (pl.ylim (, 200 3400))]))
  (pl.xlim (, (xform 450) (xform 9400)))
  (when (none? yscale)
    (sv yscale (* 1.1 (first (pl.ylim)))))
  (when ref-line
    (plot (xform x) [yscale (* (/ (second x) (first x)) yscale)] "-"
          :color (, g g g) :lw 1))
  (pl.yticks y y :fontsize (dec fs))
  (when legend
    (pl.legend :loc "lower right" :fontsize (if smaller-legend (dec fs) fs)
               :handles hs :ncol (if cpu-sizing 1 2)
               :framealpha 1))
  (pl.xlabel "Number of nodes" :fontsize (inc fs))
  (when ylabel
    (pl.ylabel "Simulated days per wallclock day (SDPD)" :fontsize (inc fs)))
  (when title
    (pl.title (+ (:compset c) "\nFrontier performance, Feb 2023")
              :fontsize (inc fs))))

(defn plot-one-panel [cf cs df ds show-dycore show-summit]
  (sv fs 14
      xform (fn [x] (npy.log x))
      yform (fn [y] (npy.log y))
      yfn (fn [sim-sec y] (/ sim-sec (npy.array y)))
      ax (pl.gca)
      hs []
      plot ax.plot
      g 0.2
      x [(first (:nnodes cf)) (last (:nnodes cf))]
      t (get (first (get df (first (:nnodes cf)))) "CPL:RUN_LOOP")
      sim-sec (* (:dt_physics cf) (/ (:count t) (:nthread t)))
      timers ["CPL:RUN_LOOP" "CPL:ATM_RUN"])
  (when show-dycore (.append timers "a:tl-sc prim_run_subcycle_c"))
  (defn annotate [x y &optional [above False] [drop-middle False]
                  [tweak-x False]]
    (sv nx (len x))
    (for [i (range (len x))]
      (when (and drop-middle
                 (and (> i 0) (< i (dec nx))))
        (continue))
      (sv xi (xform (nth x i))
          yi (nth (yform y) i))
      (pl.text (cond [(zero? i) xi]
                     [(= i (dec nx)) xi]
                     [tweak-x (- xi 0.08)]
                     [:else xi])
               (cond [(zero? i) (+ yi
                                   (cond [above 0.14]
                                         [:else -0.1]))]
                     [(= i (dec nx)) (+ yi
                                        (cond [above 0.08]
                                              [:else -0.13]))]
                     [:else (+ yi
                               (cond [above 0.1]
                                     [:else -0.1]))])
               (.format "{:1.1f}" (nth y i))
               :fontsize (- fs 0)
               :va "center"
               :ha (cond [(zero? i) "center"]
                         [(= i (dec nx)) "center"]
                         [:else (if above "right" "left")]))))
  (when show-summit
    (pl.plot 0 0 "k-" :label "Frontier")
    (pl.plot 0 0 "k--" :label "Summit")
    (sv l1 (pl.legend :loc "upper left" :fontsize fs :ncol 1))
    (ax.add-artist l1))
  (for [(, mi (, d c)) (enumerate (, (, ds cs) (, df cf)))]
    (unless (or (> mi 0) show-summit) (continue))
    (sv fnames [])
    (for [(, itimer timer) (enumerate timers)]
      (sv pat (+ (get (:linepats cf) timer)
                 (if (zero? mi) "-" ""))
          pat (.replace pat "g" "b")
          y [])
      (for [(, inode nnode) (enumerate (:nnodes c))]
        ;; Sort redundantly since the nnode loop is inside the timer one.
        (sv (, top-times p) (sort-with-p (lfor d1 (get d nnode)
                                               (:max (get d1 "CPL:RUN_LOOP"))))
            d1 (nth (get d nnode) (first p)))
        (if (zero? itimer)
          (do (.append fnames (:fname d1))
              (prf "Using {} for nnode {} with max {}"
                   (:fname d1) nnode (:max (get d1 "CPL:RUN_LOOP"))))
          (assert (= (:fname d1) (nth fnames inode))))
        (.append y (:max (get d1 timer))))
      (sv lbl (if-not (zero? mi) (get (:timer-aliases cf) timer))
          h (plot (xform (:nnodes c)) (yform (yfn sim-sec y)) pat
                  :lw 2 :markersize 10 :fillstyle "none"
                  :label lbl))
      (unless (none? lbl)
        (.append hs (first h)))
      (unless (zero? mi)
        (sv annotate-mdl (= timer "CPL:RUN_LOOP")
            annotate-atm (= timer "CPL:ATM_RUN")
            annotate-dycore (= timer "a:tl-sc prim_run_subcycle_c"))
        (when (or annotate-mdl annotate-atm annotate-dycore)
          (annotate (:nnodes cf) (yfn sim-sec y)
                    :above (or annotate-atm annotate-dycore)                    
                    :drop-middle (or (and show-dycore annotate-atm)
                                     (and show-dycore show-summit
                                          (not annotate-dycore)))
                    :tweak-x (and show-summit annotate-mdl))))))
  (my-grid)
  (pl.xticks (xform (:nnodes cf)) (:nnodes cf) :fontsize fs)
  (sv y [50 60 70 80 90 100 125 150 175 200 250 300 350 400 450 500 550 600]
      yscale (if show-dycore 125 100))
  (pl.yticks (yform y) y :fontsize (dec fs))
  (pl.ylim (yform (, (if show-dycore (if show-summit 47 50) 50)
                     (if show-dycore 630 450))))
  (pl.xlim (, (xform 430) (xform 10000)))
  (when (none? yscale)
    (sv yscale (* 1.1 (first (pl.ylim)))))
  (plot (xform x)
        (yform [yscale (* (/ (second x) (first x)) yscale)]) "-"
        :color (, g g g) :lw 1)
  (pl.legend :loc "lower right" :fontsize fs :ncol 2 :handles hs :framealpha 1)
  (pl.xlabel (if show-summit "Number of nodes" "Number of Frontier nodes")
             :fontsize (inc fs))
  (pl.ylabel "Simulated days per wallclock day (SDPD)" :fontsize (inc fs))
  (when False
    (pl.title (+ (:compset c) "\nFrontier performance, Feb 2023")
              :fontsize (inc fs))))

(defn fig-sdpd-vs-nnode [c d &optional timer-set plot-extra-points]
  (svifn timer-set :timers2 plot-extra-points False)
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, 6 6.2)
                    (+ "screamv1-frontier-tlvl" (last (str timer-set)))
                    :format format)]
      (plot-sdpd-vs-nnode c d timer-set plot-extra-points))))

(defn fig-sdpd-vs-nnode-ab [c d timer-sets]
  (sv n (len timer-sets))
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, (* 4.5 n) 5)
                    "screamv1-frontier-sdpd-vs-nnode"
                    :format format)]
      (sv fig (pl.gcf))
      (for [i (range n)]
        (pl.subplot 1 n (inc i))
        (plot-sdpd-vs-nnode c d (nth timer-sets i) False
                            :ylabel True :title False :fontsize 13)
        (fig.text (+ (/ i n) 0.03) 0.04 (+ "(" (nth "abcde" i) ")")
                  :fontsize 13)))))

(defn select-best-at-each-nnode [d]
  (sv nnodes (list (.keys d))
      d1 {})
  (for [nnode nnodes]
    (sv ds (get d nnode))
    (when (= 1 (len ds))
      (assoc d1 nnode ds)
      (continue))
    (sv perf (lfor e ds (calc-calls-per-sec (get e "CPL:RUN_LOOP")))
        (, - p) (sort-with-p perf))
    (assoc d1 nnode [(get ds (last p))]))
  d1)

(defn v1paper-table [cs ds timer-sets &optional out-fname]
  (svifn out-fname "perf-table.tex")
  (with [fh (open out-fname "w")]
    (sv c (first cs)
        timers [])
    (for [tg timer-sets]
      (.extend timers (get c tg)))
    (prff fh "\\begin{{tabular}}{{lr|rrrrrr}}")
    (prffno fh "Machine & Nodes")
    (for [t timers]
      (prffno fh " & {}" (get (:timer-short-aliases c) t)))
    (prff fh " \\\\")
    (for [i (range (len cs))]
      (sv c (get cs i) d (get ds i)
          nnodes (list (.keys d)))
      (.sort nnodes)
      (prff fh "\\hline")
      (for-first-last [nnode nnodes]
        (prffno fh "{} & {}" (if first? (:machine-name c) "") nnode)
        (for [t timers]
          (prffno fh " & {:4.1f}" (calc-sypd c (first (get d nnode)) t)))
        (prff fh " \\\\")))
    (prff fh "\\end{{tabular}}")))

(defn v1paper-fig-sdpd-vs-nnode [cs ds timer-sets]
  (sv n (len timer-sets)
      order (, "Perlmutter-CPU" "Perlmutter-GPU" "Summit" "Frontier")
      use-384 True)
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, (* 4.5 n) 5)
                    "v1paper-sdpd-vs-nnode"
                    :format format)]
      (sv fig (pl.gcf))
      (for [i (range n)]
        (pl.subplot 1 n (inc i))
        (for [j (range (len order))]
          (sv mn (get order j)
              fnd False)
          (for [k (range (len cs))]
            (when (= mn (:machine-name (get cs k)))
              (sv fnd True)
              (break)))
          (unless fnd (continue))
          (sv decorate (zero? k))
          (plot-sdpd-vs-nnode (get cs k) (get ds k) (nth timer-sets i) False
                              :ylabel True :title False :fontsize 12
                              :legend decorate :annotations False
                              :cpu-sizing True :ref-line decorate
                              :machpat True :smaller-legend use-384)
          (when (and (zero? i) (zero? j))
            (sv hs [])
            (for [c cs]
              (sv h (pl.plot 0 0 (+ "k" (:machpat c)) :label (:machine-name c)))
              (.append hs (first h)))
            (sv l1 (pl.legend :loc "upper left" :fontsize 12 :ncol 1
                              :handles hs :framealpha 1)
                ax (pl.gca))
            (ax.add-artist l1))
          (when use-384
            (sv nnodes (, 384 512 1024 2048 4096 8192))
            (pl.xticks (npy.log nnodes) nnodes :fontsize 13)
            (pl.xlim (, (npy.log 330) (npy.log 9500)))))
        (fig.text (+ (/ i n) 0.03) 0.04 (+ "(" (nth "abcde" i) ")")
                  :fontsize 13)))))

(when-inp ["summary"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c)))
  (prf "Prefix: {}" (:prefix c))
  (for [fname fnames]
    (print fname)
    (sv t (parse-timer-file c fname)
        trl (get t "CPL:RUN_LOOP")
        sim-sec (* (:dt_physics c) (/ (:count trl) (:nthread trl))))
    (prf "                  Timer      Max (s)  calls/sec     SDPD")
    (for [k (:timers3 c)]
      (prf "{:>23s}     {:8.2f}    {:7.2f} {:8.1f}"
           (get (:timer-aliases c) k) (:max (get t k))
           (calc-calls-per-sec (get t k))
           (/ sim-sec (:max (get t k)))))))

(when-inp ["plot-separate"]
  (print "WARNING: Not specialized to Frontier yet.")
  (sv c (get-context)
      fnames (glob.glob (:glob-data c))
      d (parse-timer-files c fnames))
  (for [timer-set (, :timers1 :timers2)]
    (fig-sdpd-vs-nnode c d :timer-set timer-set)))

(when-inp ["plot-throughput-ab"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c))
      d (select-best-at-each-nnode (parse-timer-files c fnames)))
  (fig-sdpd-vs-nnode-ab c d (, :timersa :timersb)))

(when-inp ["plot-one-panel"]
  (sv cf (get-context)
      cs (get-context-summit)
      df (parse-timer-files cf (glob.glob (:glob-data cf)))
      ds (parse-timer-files cs (glob.glob (:glob-data cs))))
  (for [format (, "pdf" "png") sd (, 0 1) ss (, 0 1)]
    (with [(pl-plot (, 5 6)
                    (+ "screamv1-frontier-onepanel-sd" (str sd) "-ss" (str ss))
                    :format format)]
      (plot-one-panel cf cs df ds sd ss))))

(when-inp ["plot-throughput-v1paper"]
  (sv cs [(get-context)
          (get-context-summit)
          (get-context-pmgpu)
          (get-context-pmcpu)]
      ds [])
  (for [c cs]
    (.append ds (select-best-at-each-nnode
                 (parse-timer-files c (glob.glob (:glob-data c))))))
  (v1paper-table cs ds (, :timersa :timersb))
  (v1paper-fig-sdpd-vs-nnode cs ds (, :timersa :timersbcut)))
