(require [amb3 [*]])
(import [amb3 [*]]
        glob re)

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-context [&optional [eul False] [threaded True]]
  (sv prefix (+ "frontier-v1-scaling1-rocm5?-"
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
   :compset "ne1024pg2_ne1024pg2.F2010-SCREAMv1"
   :glob-data (+ "../data/" prefix "nnodes*-model_timing_stats")
   :timers0 (cut timers 0 1)
   :timers1 (cut timers 0 2)
   :timers2 (cut timers 0 5)
   :timers3 timers
   :timersa (cut timers 0 3)
   :timersb (cut timers 3 6)
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
   :re-timer-ln (re.compile
                 "\"(.*)\"\s+-\s+(\d+)\s+(\d+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)")
   :nnodes (, 512 1024 2048 4096 8192)
   :ngpu-per-node 8
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
                                  [(= timer-set :timers1) 0.82]
                                  [(= timer-set :timersa) 0.8]
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
            (prf "Using {} for nnode {} with max {}"
                 (:fname d1) nnode (:max (get d1 "CPL:RUN_LOOP"))))
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
      (annotate xval (yform sim-sec y) :above annotate-atm)))
  (my-grid)
  (pl.xticks xval (:nnodes c) :fontsize fs)
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
         (sv y [50 60 70 80 90 100 125 150 175 200 250 300 350 400 450 500 550 600]
             yscale 90)
         (pl.ylim (, 45 600))]
        [(= timer-set :timersb)
         (sv y [200 300 400 500 600 700 800 900 1000 1200 1400 1600 1800 2000 2250 2500 2750 3000 3400]
             yscale 400)
         (pl.ylim (, 200 3400))])
  (pl.xlim (, (xform 430) (xform 10000)))
  (when (none? yscale)
    (sv yscale (* 1.1 (first (pl.ylim)))))
  (plot (xform x) [yscale (* (/ (second x) (first x)) yscale)] "-"
        :color (, g g g) :lw 1)
  (pl.yticks y y :fontsize (dec fs))
  (pl.legend :loc "lower right" :fontsize fs
             :ncol 2)
  (pl.xlabel "Number of Frontier nodes" :fontsize (inc fs))
  (when ylabel
    (pl.ylabel "Simulated days per wallclock day (SDPD)" :fontsize (inc fs)))
  (when title
    (pl.title (+ (:compset c) "\nFrontier performance, Oct 2022")
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
      d (parse-timer-files c fnames))
  (fig-sdpd-vs-nnode-ab c d (, :timersa :timersb)))

