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
   :glob-data (+ "../data/" prefix
                 "nnodes*.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.*"
                 "-model_timing_stats")
   :timers0 (cut timers 0 1)
   :timers1 (cut timers 0 2)
   :timers2 timers
   :timer-aliases (dfor (, t a)
                        (zip timers
                             (, "Model" "Atmosphere" "Dycore" "Physics"
                                "Dycore::DIRK" "Dycore::SL"))
                        [t a])
   :re-timer-ln (re.compile
                 "\"(.*)\"\s+-\s+(\d+)\s+(\d+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)")})

(defn parse-timer-line [c ln]
  (sv m (re.findall (:re-timer-ln c) ln))
  (unless (empty? m)
    (assert (= (len m) 1))
    (sv m (first m))
    (dfor (, i k)
          (enumerate (, :name :nproc :nthread :count :total :max))
          [k (nth m i)])))

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

(defn calc-calls-per-sec [t]
  (/ (:count t) (:nthread t) (:max t)))

(when-inp ["summary"]
  (sv c (get-context)
      fnames (glob.glob (:glob-data c)))
  (for [fname fnames]
    (print fname)
    (sv t (parse-timer-file c fname))
    (prf "          Timer    Max (s) calls/sec")
    (for [k (:timers2 c)]
      (prf "{:>15s}     {:6.2f}    {:6.2f}"
           (get (:timer-aliases c) k) (:max (get t k))
           (calc-calls-per-sec (get t k))))))
