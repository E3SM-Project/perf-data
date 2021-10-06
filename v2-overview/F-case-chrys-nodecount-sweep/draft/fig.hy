(require [amb3 [*]]) (import [amb3 [*]])

(pl-require-type1-fonts)
(assoc matplotlib.rcParams "savefig.dpi" 300)

(defn get-env []
  {:nphys-per-day 48
   :xticks (, 5 10 20 29 38 43 49 57 68 85)
   :v1-name "FC5AV1C-L.ne30_ne30"
   :v2-name "F2010-CICE.ne30pg2_ne30pg2"})

(defn slash-underscore [s] (.replace s "_" "\_"))

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

(defn plot-fcase-vs-nodecount [d]
  (sv ncs (sort (list (.keys d)))
      x (npy.log ncs)
      e (get-env)
      xticks (:xticks e)
      log-xticks (npy.log xticks)
      yticks (, 1 10 100 1000)
      dx 0
      v1-name (:v1-name e)
      v2-name (:v2-name e)
      v-short-names (, "v1" "v2")
      timers (, "CPL:RUN_LOOP" "a:CAM_run1" "a:CAM_run3" "a:PAT_remap")
      timer-names (, "Total" "BC Physics" "Dycore" "Tracer transport")
      clrs (, "b" "r")
      linestyles (, "--" "-")
      markers "o*s^"
      fs 15
      y {})
  (defn text [x y dx fy]
    (sv subselect (npy.log (, 5 10 20 29 43 85)))
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
  (for [fmt (, "pdf" "png")]
    (with [(pl-plot (, 8 6) "F-case-nodecount" :format fmt)]
      (for [(, vi vname) (enumerate (, v1-name v2-name))
            (, ti timer) (enumerate timers)]
        (when (or (= timer "CPL:ATM_RUN") (= timer "a:CAM_run1"))
          ;; too close to CPL:RUN_LOOP to be interesting
          (continue))
        (when (= ti 0) (text x (get y vname timer) dx 0.6))
        (when (= ti 3) (text x (get y vname timer) dx 1.2))
        (pl.semilogy x (get y vname timer)
                     (+ (nth clrs vi) (nth linestyles vi) (nth markers ti))
                     :label (+ (nth v-short-names vi) " " (nth timer-names ti))))
      (sv g 0.5 r 0.8)
      (pl.semilogy (, (first x) (last x))
                   (, r (* r (/ (last ncs) (first ncs)))) "--" :color (, g g g))
      (pl.legend :loc "lower right" :fontsize fs :ncol 2 :framealpha 1)
      (my-grid)
      (pl.title (+ "Performance of maint-1.0 " (slash-underscore v1-name)
                   "\n and v2.0.0 " (slash-underscore v2-name))
                :fontsize fs)
      (pl.xticks log-xticks xticks :fontsize fs)
      (pl.yticks yticks yticks :fontsize fs)
      (pl.xlim (npy.log (, 4.3 101)))
      (pl.ylim (, 0.37 1800))
      (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes" :fontsize fs)
      (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))))

(defn plot-fcase-bar-chart [d &optional [nc 85]]
  (sv npa npy.array
      e (get-env)
      fs 16
      d (get d nc)
      v1-name (:v1-name e)
      v2-name (:v2-name e)
      timer-names (, "Tracer transport" "Rest of dycore" "Rest of atmosphere" "Rest of model")
      tot (get d v1-name "CPL:RUN_LOOP" "tmax")
      hatches (, "o" "////" "" "x")
      ;;hatches (, "" "" "" "")
      clrs "rbgy"
      ys (npy.linspace 0 1 11)
      ds [])
  (for [(, ti timer) (enumerate (, "a:PAT_remap" "a:CAM_run3" "CPL:ATM_RUN" "CPL:RUN_LOOP"))]
    (.append ds [])
    (for [(, vi vname) (enumerate (, v1-name v2-name))]
      (.append (get ds ti) (get d vname timer "tmax"))))
  (for [i (range (dec (len ds)) 0 -1)
        j (range 2)]
    (-= (get ds i j) (get ds (dec i) j)))
  (for [i (range (len ds))
        j (range 2)]
    (sv (get ds i j) (/ (get ds i j) tot)))
  (for [fmt (, "pdf" "png")]
    (with [(pl-plot (, 6 6) "F-case-bar-chart" :format fmt)]
      (sv g 0.6)
      (for [y ys]
        (pl.plot (, -1 3) [y y] "-" :color (, g g g) :zorder -1 :lw 0.5))
      (sv acc (npa [0.0 0.0]))
      (for [i (range (len ds))]
        (pl.bar [1 2] (get ds i) :bottom acc :label (nth timer-names i)
                :hatch (nth hatches i) :facecolor (nth clrs i) :edgecolor "k")
        (+= acc (npa (get ds i))))
      (pl.yticks ys :fontsize fs)
      (pl.ylim (, 0 1.01))
      (pl.xlim (, 0.5 2.5))
      (pl.xticks [1 2] (, "v1" "v2") :fontsize fs)
      (pl.legend :loc "upper right" :fontsize (dec fs) :ncol 1 :framealpha 1)
      (pl.title (+ "Performance of maint-1.0 " (slash-underscore v1-name)
                   "\n and v2.0.0 " (slash-underscore v2-name)
                   " on " (str nc) " nodes")
                :fontsize fs)
      (pl.ylabel "Normalized time" :fontsize fs))))

(when-inp ["parse-and-plot-fcase-vs-nodecount"]
  (sv d (parse-timer-summary-file "../timers1.txt"))
  (plot-fcase-vs-nodecount d))

(when-inp ["parse-and-plot-fcase-bar-chart"]
  (sv d (parse-timer-summary-file "../timers1.txt"))
  (plot-fcase-bar-chart d 85))
