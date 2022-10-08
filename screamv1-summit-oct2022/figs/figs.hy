(require [amb3 [*]])
(import [amb3 [*]]
        glob re)

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-context []
  (sv prefix "scream-v1-scaling1-"
      timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:tl-sc prim_run_subcycle_c"
                "a:EAMxx::physics::run" "a:compute_stage_value_dirk"
                "a:compose_transport"))
  {:prefix prefix
   :compset "ne1024pg2_ne1024pg2.F2010-SCREAMv1"
   :glob-data (+ "../data/" prefix
                 "nnodes*.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.*"
                 "-model_timing_stats")
   :timers0 (cut timers 0 1)
   :timers1 (cut timers 0 2)
   :timers2 (cut timers 0 5)
   :timers3 timers
   :linepats (dfor (, t p)
                   (zip timers
                        (, "ko-" "rv-" "bs--" "g.--" "b.:" "b*:"))
                   [t p])
   :timer-aliases (dfor (, t a)
                        (zip timers
                             (, "Model" "Atmosphere" "Dycore" "Physics"
                                "Dycore::DIRK" "Dycore::SL"))
                        [t a])
   :re-timer-ln (re.compile
                 "\"(.*)\"\s+-\s+(\d+)\s+(\d+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)")
   :nnodes (, 1024 3072 4096 4608)
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
  (assert (in (:compset c) fname))
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

(defn plot-sdpd-vs-nnode [c d &optional timer-set plot-extra-points]
  (svifn timer-set :timers2 plot-extra-points False)
  (sv xform (fn [x] (npy.log x))
      yform (fn [sim-sec y] (/ sim-sec (npy.array y)))
      plot pl.semilogy)
  (sv timers (get c timer-set)
      fs 14
      xval (xform (:nnodes c)))
  (defn annotate [x y]
    (for [i (range (len x))]
      (pl.text (nth x i) (* (nth y i)
                            (case/eq timer-set [:timers2 0.8] [:timers1 0.9]))
               (.format "{:1.1f}" (nth y i))
               :fontsize (- fs 2) :ha "center")))
  (for [format (, "pdf" "png")]
    (with [(pl-plot (, 6 6.2)
                    (+ "screamv1-summit-tlvl" (last (str timer-set)))
                    :format format)]
      (sv g 0.2
          x [(first (:nnodes c)) (last (:nnodes c))]
          y 90)
      (plot (xform x) [y (* (/ (second x) (first x)) y)] "-"
            :color (, g g g) :lw 1)
      (sv t (get (first (get d (first (:nnodes c)))) "CPL:RUN_LOOP")
          sim-sec (* (:dt_physics c) (/ (:count t) (:nthread t))))
      (for-first-last [timer timers]
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
        (when first?
          (annotate xval (yform sim-sec y))))
      (my-grid)
      (pl.xticks xval (:nnodes c) :fontsize fs :rotation -45)
      (cond [(= timer-set :timers2)
             (sv y [50 100 150 200 300 400 500 600 700 800 900 1000 1200 1400 1600 1800])
             (pl.yticks y y :fontsize (dec fs))
             (pl.ylim (, 30 1800))]
            [(= timer-set :timers1)
             (sv y [60 100 125 150 175 200 250])
             (pl.yticks y y :fontsize (dec fs))
             (pl.ylim (, 50 250))])
      (pl.legend :loc "lower right" :fontsize fs :ncol 2)
      (pl.xlabel "Number of Summit nodes" :fontsize (inc fs))
      (pl.ylabel "Simulated days per wallclock day (SDPD)" :fontsize (inc fs))
      (pl.title (+ (:compset c) "\nSummit performance, Oct 2022")
                :fontsize (inc fs)))))

(when-inp ["summary"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c)))
  (for [fname fnames]
    (print fname)
    (sv t (parse-timer-file c fname))
    (prf "          Timer    Max (s) calls/sec")
    (for [k (:timers3 c)]
      (prf "{:>15s}     {:6.2f}    {:6.2f}"
           (get (:timer-aliases c) k) (:max (get t k))
           (calc-calls-per-sec (get t k))))))

(when-inp ["plot"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c))
      d (parse-timer-files c fnames))
  (for [timer-set (, :timers1 :timers2)]
    (plot-sdpd-vs-nnode c d :timer-set timer-set)))
