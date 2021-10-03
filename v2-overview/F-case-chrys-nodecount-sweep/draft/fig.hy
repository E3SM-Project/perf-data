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
      x (npy.log ncs)
      e (get-env)
      xticks (:xticks e)
      log-xticks (npy.log xticks)
      yticks (, 1 10 100 1000)
      dx 0
      v1-name "FC5AV1C-L.ne30_ne30"
      v2-name "F2010-CICE.ne30pg2_ne30pg2"
      v-short-names (, "v1" "v2")
      timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "a:CAM_run3" "a:PAT_remap")
      timer-names (, "Total" "Atmosphere" "Dycore" "Tracer transport")
      clrs (, "b" "r")
      linestyles (, "--" "-")
      markers "o^s*"
      fs 14
      y {})
  (defn text [x y dx fy]
    (sv subselect (npy.log (, 5 10 20 43 85)))
    (for [i (range (len x))]
      (unless (in (nth x i) subselect) (continue))
      (pl.text (+ dx (nth x i)) (* fy (nth y i))
               (.format "{:1.2f}" (nth y i))
               :fontsize fs :ha "center")))
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
        (when (= ti 0) (text x (get y vname timer) dx 0.6))
        (when (= ti 3) (text x (get y vname timer) dx 1.2))
        (pl.semilogy x (get y vname timer)
                     (+ (nth clrs vi) (nth linestyles vi) (nth markers ti))
                     :label (+ (nth v-short-names vi) " " (nth timer-names ti))))
      (pl.legend :loc "best" :fontsize fs :ncol 2)
      (my-grid)
      (pl.title (+ "Performance of maint-1.0 " v1-name "\n and v2.0.0 " v2-name)
                :fontsize fs)
      (pl.xticks log-xticks xticks :fontsize fs)
      (pl.yticks yticks yticks :fontsize fs)
      (pl.xlim (npy.log (, 4.2 103)))
      (pl.ylim (, 0.4 1800))
      (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes" :fontsize fs)
      (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))))

(when-inp ["parse-and-plot"]
  (sv d (parse-timer-summary-file "../timers0.txt"))
  (plot d))
