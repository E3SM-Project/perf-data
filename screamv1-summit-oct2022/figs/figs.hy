(require [amb3 [*]])
(import [amb3 [*]]
        glob re)

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-context [&optional prefix]
  (svifn prefix "scream-v1-scaling2-")
  (sv timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:tl-sc prim_run_subcycle_c"
                "a:compute_stage_value_dirk" "a:caar compute" "a:EAMxx::physics::run"
                "a:compose_transport" "CPL:LND_RUN" "l:interpMonthlyVeg"))
  {:prefix prefix
   :compset "ne1024pg2_ne1024pg2.F2010-SCREAMv1"
   :glob-data (+ "../data/" prefix "*-model_timing_stats")
   :timers3 timers
   :timersa (cut timers 0 3)
   :timersb (cut timers 3 6)
   :linepats (dfor (, t p)
                   (zip timers
                        (, "ko-" "rv-" "bs--" "ko-" "rv-" "bs--"))
                   [t p])
   :timer-aliases (dfor (, t a)
                        (zip timers
                             (, "Model" "Atmosphere" "Dycore"
                                "Dycore::DIRK" "Dynamics::CAAR" "Physics"
                                "Dycore::SL" "Land" "Land::interpMonthlyVeg"))
                        [t a])
   :re-timer-ln (re.compile
                 "\"(.*)\"\s+-\s+(\d+)\s+(\d+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)")
   :nnodes (, 1024 2048 3072 4096 4608)
   :ngpu-per-node 6
   :dt_physics 100})

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

(defn parse-timer-file [c fname]
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
                          &optional ylabel title fontsize]
  (svifn ylabel True title True fontsize 14)
  (sv xform (fn [x] (npy.log x))
      yform (fn [sim-sec y] (/ sim-sec (npy.array y)))
      plot pl.semilogy)
  (sv timers (get c timer-set)
      fs fontsize
      xval (xform (:nnodes c)))
  (defn annotate [x y &optional [above False]]
    (for [i (range (len x))]
      (pl.text (nth x i) (* (nth y i)
                            (cond [(= timer-set :timers2) 0.8]
                                  [(and above (= timer-set :timers1)) 1.05]
                                  [(= timer-set :timers1) 0.92]
                                  [(= timer-set :timersa) 0.9]
                                  [(and above (= timer-set :timersa)) 1.05]))
               (.format "{:1.1f}" (nth y i))
               :fontsize (- fs 0) :ha "center")))
  (sv g 0.2
      x [(first (:nnodes c)) (last (:nnodes c))])
  (sv t (get (first (get d (first (:nnodes c)))) "CPL:RUN_LOOP")
      sim-sec (* (:dt_physics c) (/ (:count t) (:nthread t)))
      fnames [])
  (for [(, itimer timer) (enumerate timers)]
    (sv pat (get (:linepats c) timer)
        y [])
    (for [(, inode nnode) (enumerate (:nnodes c))]
      ;; Sort redundantly since the nnode loop is inside the timer one.
      (sv (, top-times p) (sort-with-p (lfor d1 (get d nnode)
                                             (:max (get d1 "CPL:RUN_LOOP"))))
          d1 (nth (get d nnode) (first p)))
      (if (zero? itimer)
        (do (.append fnames (:fname d1))
            (prf "Using {} for nnode {}" (:fname d1) nnode))
        (assert (= (:fname d1) (nth fnames inode))))
      (.append y (:max (get d1 timer)))
      (when plot-extra-points
        (for [idx (cut p 1)]
          (plot (xform nnode)
                (yform sim-sec (get (nth (get d nnode) idx) timer :max))
                (cut pat 0 -1)))))
    (plot xval (yform sim-sec y) pat
          :lw 2 :markersize 10 :fillstyle "none"
          :label (get (:timer-aliases c) timer))
    (sv annotate-atm (and (= timer-set :timers1) (= timer "CPL:ATM_RUN")))
    (when (or (= timer "CPL:RUN_LOOP") annotate-atm)
      (annotate (cut xval 0 -1) (cut (yform sim-sec y) 0 -1)
                :above annotate-atm)))
  (my-grid)
  (pl.xticks xval (:nnodes c) :fontsize fs :rotation -45)
  (sv yscale None)
  (cond [(= timer-set :timers2)
         (sv y [50 100 150 200 300 400 500 600 700 800 900 1000 1200 1400 1600 1800]
             yscale 150)
         (pl.ylim (, 35 1800))]
        [(= timer-set :timers1)
         (sv y [60 100 125 150 175 200 250]
             yscale 90)
         (pl.ylim (, 60 250))]
        [(= timer-set :timersa)
         (sv y [60 70 80 90 100 125 150 175 200 250 300]
             yscale 110)
         (pl.ylim (, 60 300))]
        [(= timer-set :timersb)
         (sv y [300 400 500 600 700 800 900 1000 1200 1400 1600 1800 2000]
             yscale 420)
         (pl.ylim (, 250 2000))])
  (when (none? yscale)
    (sv yscale (* 1.1 (first (pl.ylim)))))
  (plot (xform x) [yscale (* (/ (second x) (first x)) yscale)] "-"
        :color (, g g g) :lw 1)
  (pl.yticks y y :fontsize (dec fs))
  (pl.legend :loc "lower right" :fontsize fs
             :ncol 2)
  (pl.xlabel "Number of Summit nodes" :fontsize (inc fs))
  (when ylabel
    (pl.ylabel "Simulated days per wallclock day (SDPD)" :fontsize (inc fs)))
  (when title
    (pl.title (+ (:compset c) "\nSummit performance, Oct 2022")
              :fontsize (inc fs))))

(defn fig-sdpd-vs-nnode [c d &optional timer-set plot-extra-points]
  (svifn timer-set :timers2 plot-extra-points False)
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, 6 6.2)
                    (+ "screamv1-summit-tlvl" (last (str timer-set)))
                    :format format)]
      (plot-sdpd-vs-nnode c d timer-set plot-extra-points))))

(defn fig-sdpd-vs-nnode-ab [c d timer-sets]
  (sv n (len timer-sets))
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, (* 4.5 n) 5)
                    "screamv1overview-summit-sdpd-vs-nnode"
                    :format format)]
      (sv fig (pl.gcf))
      (for [i (range n)]
        (pl.subplot 1 n (inc i))
        (plot-sdpd-vs-nnode c d (nth timer-sets i) False
                            :ylabel True :title False :fontsize 13)
        (fig.text (+ (/ i n) 0.03) 0.04 (+ "(" (nth "abcde" i) ")")
                  :fontsize 13)))))

(defn get-three-runs-of-interest [de dr &optional verbose]
  (svifn verbose False)
  (sv de1 (get de 1024) ; perf 1024
      de2 (get de 4096) ; perf 4096
      drs (get dr 1024) ; production 1024 median
      run-loop "CPL:RUN_LOOP")
  (.sort drs :key (fn [d] (:max (get d run-loop))))
  (assert (= (% (len drs) 2) 1))
  (assert (= (max (len de1) (len de2)) 1))
  (sv de1 (first de1) de2 (first de2) dr1 (nth drs (// (len drs) 2)))
  (when verbose
    (for [d (, de1 dr1 de2)]
      (print (get d run-loop))))
  (, de1 de2 dr1))

(defn fig-proportions [c de dr]
  (sv (, de1 de2 dr1) (get-three-runs-of-interest de dr :verbose True)
      tmr-dycore "a:tl-sc prim_run_subcycle_c"
      tmr-physics "a:EAMxx::physics::run"
      tmr-atm "CPL:ATM_RUN"
      tmr-total "CPL:RUN_LOOP"
      lbls (, "Dycore" "Physics" "Rest of Atm" "Rest of Model")
      fs 16)
  (defn sec-per-step [d]
    (sv d1 (get d tmr-total))
    (/ (:max d1) (/ (:count d1) (:nthread d1))))
  (sv t-tot-ref (sec-per-step dr1)
      clrs "grby"
      hatches (, "o" "////" "" "x"))
  (with [(pl-plot (, 6.6 5) "screamv1overview-summit-bar")]
    (for [(, i d) (enumerate (, de1 dr1 de2))]
      (defn calc-p [tmr]
        (/ (get d tmr :max) (get d tmr-total :max)))
      (sv fac (/ (sec-per-step d) t-tot-ref)
          - (print fac)
          ps (* fac (npy.array [(calc-p tmr-dycore)
                                (calc-p tmr-physics)
                                (calc-p tmr-atm)
                                (calc-p tmr-total)]))
          ;; tot - atm
          (get ps 3) (- (get ps 3) (get ps 2))
          ;; atm - (dycore + physics)
          (get ps 2) (- (get ps 2) (get ps 1) (get ps 0))
          acc 0)
      (print ps)
      (for [j (range 4)]
        (pl.bar i (get ps j) :bottom acc :facecolor (nth clrs j)
                :hatch (nth hatches j) :edgecolor "k"
                :label (if (zero? i) (nth lbls j)))
        (+= acc (get ps j))))
    (pl.legend :loc "upper right" :fontsize (dec fs) :ncol 1 :framealpha 1)
    (defn nnode [d] (// (get d tmr-total :nproc) (:ngpu-per-node c)))
    (pl.xticks [0 1 2]
               (, (.format "Performance\n{} nodes" (nnode de1))
                  (.format "Production\n{} nodes" (nnode dr1))
                  (.format "Performance\n{} nodes" (nnode de2)))
               :fontsize fs)
    (sv y (/ (npy.array (range 11)) 10))
    (pl.yticks y y :fontsize fs)
    (pl.ylabel "Wallclock proportion" :fontsize fs)
    (sv g 0.7)
    (pl.grid True :lw 0.5 :ls "-" :color (, g g g) :zorder -1
             :which "both" :axis "y")
    (.set_axisbelow (pl.gca) True)))

(when-inp ["summary" {:set str}]
  ;; set is performance or production
  (sv c (get-context (if (= set "production") "scream-v1-production"))
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

(when-inp ["plot-throughput-ab"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c))
      d (parse-timer-files c fnames))
  (fig-sdpd-vs-nnode-ab c d (, :timersa :timersb)))

(when-inp ["plot-proportions"]
  (sv cperf (get-context)
      cprod (get-context "scream-v1-production")
      dperf (parse-timer-files cperf (glob.glob (:glob-data cperf)))
      dprod (parse-timer-files cprod (glob.glob (:glob-data cprod))))
  (fig-proportions cperf dperf dprod))
