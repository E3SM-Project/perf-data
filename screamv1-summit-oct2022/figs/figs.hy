(require [amb3 [*]])
(import [amb3 [*]]
        glob re)

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-context [&optional prefix]
  (svifn prefix "scream-v1-scaling2-")
  (sv timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:tl-sc prim_run_subcycle_c"
                "a:EAMxx::physics::run" "a:compute_stage_value_dirk"
                "a:compose_transport" "CPL:LND_RUN" "l:interpMonthlyVeg"))
  {:prefix prefix
   :compset "ne1024pg2_ne1024pg2.F2010-SCREAMv1"
   :glob-data (+ "../data/" prefix "*-model_timing_stats")
   :timers0 (cut timers 0 1)
   :timers1 (cut timers 0 2)
   :timers2 (cut timers 0 5)
   :timers3 timers
   :timersa (cut timers 0 3)
   :timersb (cut timers 3 5)
   :linepats (dfor (, t p)
                   (zip timers
                        (, "ko-" "rv-" "bs--" "g.--" "b.:" "b*:"))
                   [t p])
   :timer-aliases (dfor (, t a)
                        (zip timers
                             (, "Model" "Atmosphere" "Dycore" "Physics"
                                "Dycore::DIRK" "Dycore::SL" "Land" "Land::interpMonthlyVeg"))
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
      d {})
  (for [ln txt]
    (sv t (parse-timer-line c ln))
    (unless (none? t)
      (assoc d (:name t)
             (dfor (, k coerce)
                   (, [:nproc int] [:nthread int] [:count float]
                      [:total float] [:max float])
                   [k (coerce (get t k))]))))
  d)

(defn parse-timer-files [c fnames]
  (sv d {})
  (for [fname fnames]
    (sv d1 (parse-timer-file c fname))
    (sv nnode (// (:nproc (get d1 "CPL:RUN_LOOP")) (:ngpu-per-node c)))
    (assoc-nested-append d (, nnode) d1))
  d)

(defn plot-sdpd-vs-nnode [c d timer-set plot-extra-points
                          &optional ylabel title]
  (svifn ylabel True title True)
  (sv xform (fn [x] (npy.log x))
      yform (fn [sim-sec y] (/ sim-sec (npy.array y)))
      plot pl.semilogy)
  (sv timers (get c timer-set)
      fs 14
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
               :fontsize (- fs 2) :ha "center")))
  (sv g 0.2
      x [(first (:nnodes c)) (last (:nnodes c))])
  (sv t (get (first (get d (first (:nnodes c)))) "CPL:RUN_LOOP")
      sim-sec (* (:dt_physics c) (/ (:count t) (:nthread t))))
  (for [timer timers]
    (sv pat (get (:linepats c) timer)
        y [])
    (for [nnode (:nnodes c)]
      (sv max-times (sort (lfor d1 (get d nnode) (:max (get d1 timer)))))
      (.append y (min max-times))
      (when plot-extra-points
        (for [mt (cut max-times 1)]
          (plot (xform nnode) (yform sim-sec mt) (cut pat 0 -1)))))
    (plot xval (yform sim-sec y) pat
          :lw 2 :markersize 10 :fillstyle "none"
          :label (get (:timer-aliases c) timer))
    (sv annotate-atm (and (= timer-set :timers1) (= timer "CPL:ATM_RUN")))
    (when (or (= timer "CPL:RUN_LOOP") annotate-atm)
      (annotate xval (yform sim-sec y) :above annotate-atm)))
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
         (sv y [50 60 100 125 150 175 200 250 300]
             yscale 110)
         (pl.ylim (, 50 300))]
        [(= timer-set :timersb)
         (sv y [400 500 600 700 800 900 1000 1200 1400 1600 1800]
             yscale 420)
         (pl.ylim (, 350 1950))])
  (when (none? yscale)
    (sv yscale (* 1.1 (first (pl.ylim)))))
  (plot (xform x) [yscale (* (/ (second x) (first x)) yscale)] "-"
        :color (, g g g) :lw 1)
  (pl.yticks y y :fontsize (dec fs))
  (pl.legend :loc "lower right" :fontsize fs :ncol (if (= timer-set :timers2) 2 3))
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
    (with [(pl-plot (, (* 6 n) 6.2)
                    "screamv1overview-summit-sdpd-vs-nnode"
                    :format format)]
      (sv fig (pl.gcf))
      (for [i (range n)]
        (pl.subplot 1 n (inc i))
        (plot-sdpd-vs-nnode c d (nth timer-sets i) False
                            :ylabel True :title False)
        (fig.text (+ (/ i n) 0.03) 0.04 (+ "(" (nth "abcde" i) ")")
                  :fontsize 16)))))

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

(when-inp ["plot-separate"]
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

(when-inp ["plot-proportions"]
  (sv cperf (get-context)
      cprod (get-context "scream-v1-production")
      dperf (parse-timer-files cperf (glob.glob (:glob-data cperf)))
      dprod (parse-timer-files cprod (glob.glob (:glob-data cprod)))))
