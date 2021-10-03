(require [amb3 [*]]) (import [amb3 [*]])

(defn get-env []
  {:nphys-per-day 48
   :xticks (, 5 10 20 38 43 49 57 68 85)})

(defn parse-timer-summary-file [fname]
  (defn parse-name [ln]
    (sv parts (.split ln "."))
    (, (int (last parts)) (+ (first parts) "." (second parts))))
  (sv txt (.split (readall fname) "\n")
      d {})
  (for [ln txt]
    (cond [(< (len ln) 2) (break)]
          [(or (in "FC5AV1C" ln) (in "F2010" ln))
           (sv (, nodecount compset) (parse-name ln))]
          [:else
           (sv ln (.replace ln " - " "")
               (, timer nrank nthr callcnt tsum tmax)
               (sscanf ln "s,i,i,f,f,f"))
           (assoc-nested d (, nodecount compset (.replace timer "\"" ""))
                         {"nrank" nrank "nthr" nthr "callcnt" callcnt
                          "tsum" tsum "tmax" tmax})]))
  d)

(defn sypd [ttot t fld]
  (sv e (get-env)
      nphys-per-day (:nphys-per-day e)
      simyrs (/ (get ttot "callcnt") (get ttot "nthr") nphys-per-day 365)
      walldays (/ (get t fld) 24 3600))
  (/ simyrs walldays))

(defn plot [d]
  (sv ncs (sort (list (.keys d)))
      e (get-env)
      xticks (:xticks e)
      yticks (, 1 10 100 1000)
      v1-name "FC5AV1C-L.ne30_ne30"
      v2-name "F2010-CICE.ne30pg2_ne30pg2"
      timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:CAM_run3" "a:PAT_remap")
      timer-names (, "Total" "Atmosphere" "Dycore" "Tracer transport")
      clrs (, "b" "r")
      linestyles (, "--" "-")
      markers "o^s*"
      fs 14
      y {})
  (for [nc ncs]
    (sv d1 (get d nc))
    (for [vname (, v1-name v2-name)
          timer timers]
      (assoc-nested-append y (, vname timer)
                           (sypd (get d1 vname (first timers))
                                 (get d1 vname timer)
                                 "tmax"))))
  (for [fmt (, "pdf")]
    (with [(pl-plot (, 8 6) "f1" :format fmt)]
      (for [(, vi vname) (enumerate (, v1-name v2-name))
            (, ti timer) (enumerate timers)]
        (when (= timer "CPL:ATM_RUN")
          ;; too close to CPL:RUN_LOOP to be interesting
          (continue))
        (pl.semilogy (npy.log ncs) (get y vname timer)
                     (+ (nth clrs vi) (nth linestyles vi) (nth markers ti))
                     ))
      (my-grid)
      (pl.title (+ "Performance of maint-1.0 " v1-name "\n and v2.0.0 " v2-name)
                :fontsize fs)
      (pl.xticks (npy.log xticks) xticks :fontsize fs)
      (pl.yticks yticks yticks :fontsize fs)
      (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes" :fontsize fs)
      (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))))

(when-inp ["parse-and-plot"]
  (sv d (parse-timer-summary-file "../timers0.txt"))
  (plot d))
