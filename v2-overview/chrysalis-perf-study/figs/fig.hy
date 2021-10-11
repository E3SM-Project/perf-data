(require [amb3 [*]]) (import [amb3 [*]])

;; todo
;; - F-case figs: short titles; give res and compset details in caption
;; - WC-case tot sypd vs nodes
;; - PE layout fig for one WC-case

(pl-require-type1-fonts)
(assoc matplotlib.rcParams "savefig.dpi" 300)

(defn get-fcase-context []
  (sv prefix "v2-overview-fcase-chrysalis-r0.")
  {:nphys-per-day 48
   :xticks (, 5 10 20 29 38 43 49 57 68 85)
   :prefix prefix
   :v1-name "FC5AV1C-L.ne30_ne30"
   :v2-name "F2010-CICE.ne30pg2_ne30pg2"})

(defn get-wccase-context []
  (sv prefix "v2-overview-wccase-chrysalis-r0.")
  {:ncore 64
   :nphys-per-day 48
   :pelayouts (, "S" "M" "L")
   :xticks (, 28 30 53 60 105 115)
   :prefix prefix
   :v1-name "A_WCYCL1850S_CMIP6.ne30_oECv3"
   :v2-name "WCYCL1850.ne30pg2_EC30to60E2r2"})

(defn slash-underscore [s] (.replace s "_" "\_"))

(defn parse-timer-summary-file [fname &optional case]
  (svifn case "f")
  (defn parse-name [ln]
    (sv parts (.split ln "."))
    (, (last parts) (+ (nth parts 1) "." (nth parts 2))))
  (defn parse-fcase-name [ln]
    (sv (, a b) (parse-name ln))
    (, (int a) b))
  (defn parse-wccase-name [ln] (parse-name ln))
  (sv txt (.split (readall fname) "\n")
      d {})
  (for [ln txt]
    (cond [(< (len ln) 2) (break)]
          [(and (= case "f") (or (in "FC5AV1C" ln) (in "F2010" ln)))
           (sv (, nodecount compset) (parse-fcase-name ln))]
          [(and (= case "wc") (in "WCYCL1850" ln))
           (sv (, nodecount compset) (parse-wccase-name ln))]
          [:else
           (sv ln (.replace ln " - " "")
               (, timer nrank nthr callcnt tsum tmax)
               (sscanf ln "s,i,i,f,f,f"))
           (assoc-nested d (, nodecount compset (.replace timer "\"" ""))
                         {"nrank" nrank "nthr" nthr "callcnt" callcnt
                          "tavg" (/ tsum nthr) "tmax" tmax})]))
  d)

(defn sypd [ttot t fld]
  (sv e (get-fcase-context)
      nphys-per-day (:nphys-per-day e)
      simyrs (/ (get ttot "callcnt") (get ttot "nthr") nphys-per-day 365)
      walldays (/ (get t fld) 24 3600))
  (/ simyrs walldays))

(defn plot-fcase-vs-nodecount [d]
  (defn text [x y dx fy]
    (sv subselect (npy.log (, 5 10 20 29 43 85)))
    (for [i (range (len x))]
      (unless (in (nth x i) subselect) (continue))
      (pl.text (+ dx (nth x i)) (* fy (nth y i))
               (.format "{:1.2f}" (nth y i))
               :fontsize fs :ha "center")))
  (sv ncs (sort (list (.keys d)))
      x (npy.log ncs)
      e (get-fcase-context)
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
      (pl.title (+ "Performance of maint-1.0 "
                   (slash-underscore v1-name)
                   "\n and v2.0.0 "
                   (slash-underscore v2-name))
                :fontsize fs)
      (pl.xticks log-xticks xticks :fontsize fs)
      (pl.yticks yticks yticks :fontsize fs)
      (pl.xlim (npy.log (, 4.3 100)))
      (pl.ylim (, 0.37 1800))
      (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes" :fontsize fs)
      (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))))

(defn plot-fcase-bar-chart [d &optional [nc 85]]
  (sv npa npy.array
      e (get-fcase-context)
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
      (pl.title (+ "Performance of maint-1.0 "
                   (slash-underscore v1-name)
                   "\n and v2.0.0 "
                   (slash-underscore v2-name)
                   " on " (str nc) " nodes")
                :fontsize fs)
      (pl.ylabel "Normalized time" :fontsize fs))))

(defn write-wccase-table [d]
  (sv e (get-wccase-context))
  (print (+ "                                          "
            "SYPD     SYPD   SYPD     SYPD   Efficiency\n"
            "PE                           "
            "Case #node  Total |    ATM    ICE |    OCN   Gain"))
  (for [pe (:pelayouts e)
        (, ci compset) (enumerate (, (:v1-name e) (:v2-name e)))]
    (sv d1 (get d pe compset)
        ttot (get d1 "CPL:RUN_LOOP")
        tatm (get d1 "CPL:ATM_RUN")
        tocn (get d1 "CPL:OCN_RUN")
        tice (get d1 "CPL:ICE_RUN")
        sypd-tot (sypd ttot ttot "tmax")
        nrank (get ttot "nrank"))
    (prf " {} {:>30s}   {:3d} {:6.2f} | {:6.2f} {:6.2f} | {:6.2f} |{}"
         pe compset
         (// nrank (:ncore e))
         sypd-tot
         (sypd ttot tatm "tmax") (sypd ttot tice "tmax")
         (sypd ttot tocn "tmax")
         (if (odd? ci)
             (.format " {:4.2f}" (* (/ sypd-tot sypd-tot-v1) (/ nrank-v1 nrank)))
             ""))
    (when (even? ci)
      (sv sypd-tot-v1 sypd-tot
          nrank-v1 nrank))))

(defn get-node-counts [e d]
  (sv ncs [])
  (for [pe (:pelayouts e)
        compset (, (:v2-name e) (:v1-name e))]
    (sv nrank (get d pe compset "CPL:RUN_LOOP" "nrank")
        nc (/ nrank (:ncore e)))
    (assert (zero? (- nc (int nc))))
    (.append ncs (int nc)))
  ncs)

(defn plot-wccase-vs-nodecount [d &optional [details False]]
  (defn text [x y dx fy]
    (for [i (range (len x))]
      (pl.text (+ dx (nth x i)) (* fy (nth y i))
               (.format "{:1.2f}" (nth y i))
               :fontsize fs :ha "center")))
  (sv e (get-wccase-context)
      ncs (get-node-counts e d)
      xticks (:xticks e)
      log-xticks (npy.log xticks)
      yticks (if details
                 (, 1 10 100)
                 (, 6 7 8 9 10 20 30 40 50))
      v1-name (:v1-name e)
      v2-name (:v2-name e)
      v-short-names (, "v1" "v2")
      timers (, "CPL:RUN_LOOP" "CPL:ATM_RUN" "CPL:ICE_RUN" "CPL:OCN_RUN")
      timer-names (, "Total" "Atmosphere" "Sea ice" "Ocean")
      clrs (, "b" "r")
      linestyles (, "--" "-")
      markers "os*^"
      fs 15
      xs {}
      ys {})
  (for [pe (:pelayouts e)]
    (sv d1 (get d pe))
    (for [vname (, v1-name v2-name)]
      (assoc-nested-append xs (, vname)
                           (// (get d1 vname "CPL:RUN_LOOP" "nrank") (:ncore e)))
      (for [timer timers]
        (assoc-nested-append ys (, vname timer)
                             (sypd (get d1 vname (first timers))
                                   (get d1 vname timer)
                                   "tmax")))))
  (for [fmt (, "pdf" "png")]
    (with [(pl-plot (, (if details 6.5 6.5) 6)
                    (+ "WC-case-nodecount" (if details "-detailed" ""))
                    :format fmt)]
      (for [(, vi vname) (enumerate (, v1-name v2-name))
            (, ti timer) (enumerate timers)]
        (unless (or details (= timer (first timers))) (continue))
        (sv x (npy.log (get xs vname))
            y (get ys vname timer))
        (when (zero? ti) (text x y 0 (if details 0.8 1.1)))
        (pl.semilogy x y
                     (+ (nth clrs vi) (nth linestyles vi) (nth markers ti))
                     :label (+ (nth v-short-names vi) " " (nth timer-names ti))))
      (sv g 0.5 r (if details 100 40)
          x (, 28 115))
      (pl.semilogy (npy.log x)
                   (, (* r (/ (first x) (last x))) r) "--" :color (, g g g))
      (pl.legend :loc "lower right" :fontsize fs :ncol 2 :framealpha 1)
      (my-grid)
      (pl.title (+ "Performance of maint-1.0 "
                   (slash-underscore v1-name)
                   "\n and v2.0.0 "
                   (slash-underscore v2-name))
                :fontsize fs)
      (pl.xticks log-xticks xticks :fontsize fs :rotation -45)
      (pl.yticks yticks yticks :fontsize fs)
      (pl.xlim (npy.log (, 25.5 126)))
      (pl.ylim (if details (, 3 250) (, 7 53)))
      (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes"
                 :fontsize fs)
      (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))))

(defn plot-wccase-pelayout-perf [d &optional pelayout timer-type]
  (svifn pelayout "L" timer-type "tavg")
  (sv e (get-wccase-context)
      ice-tname "CPL:ICE_RUN" atm-tname "CPL:ATM_RUN"
      lnd-tname "CPL:LND_RUN" rof-tname "CPL:ROF_RUN"
      tot-tname "CPL:RUN_LOOP" ocn-tname "CPL:OCN_RUN" cpl-tname "CPL:RUN"
      timers (, atm-tname cpl-tname ice-tname lnd-tname rof-tname ocn-tname
                tot-tname)
      v1-name (:v1-name e)
      v2-name (:v2-name e)
      v-short-names (, "v1" "v2")
      clrs (, "b" "g" (, 0.5 0.5 0.5) (, 0.7 0.5 0) (, 0.1 0.1 0.1) "r" "k")
      lss (, "-" ":" "--" "-" "-" "-" "-")
      hatches (, "\\" "//")
      T (get d pelayout v1-name tot-tname timer-type)
      boxes {})
  (defn calc-rank0 [nrank] (* (:ncore e) (math.ceil (/ nrank (:ncore e)))))
  (defn draw-box [ax b ls lw color hatch]
    (.add-patch ax
      (matplotlib.patches.Rectangle (, (:rank0 b) (/ (:time0 b) T))
                                    (:nrank b) (/ (:time b) T)
                                    :fill False :linestyle ls :lw lw
                                    :color color :hatch hatch)))
  (for [vname (, v1-name v2-name)
        timer timers]
    (sv d1 (get d pelayout vname))
    (assoc-nested boxes (, vname timer)
                  {:nrank (cond [(= timer cpl-tname)
                                 ;; for some reason this is not the ranks
                                 ;; reported in CPL:RUN.
                                 (calc-rank0 (get d1 atm-tname "nrank"))]
                                [:else (get d1 timer "nrank")])
                   :time (get d1 timer timer-type)
                   :rank0 (cond [(in timer (, rof-tname lnd-tname))
                                 (calc-rank0 (get d1 ice-tname "nrank"))]
                                [(= timer ocn-tname)
                                 (calc-rank0 (get d1 atm-tname "nrank"))]
                                [:else 0])
                   :time0 (cond [(= timer cpl-tname)
                                 (+ (get d1 ice-tname timer-type)
                                    (get d1 atm-tname timer-type))]
                                [(= timer atm-tname)
                                 (get d1 ice-tname timer-type)]
                                [:else 0])}))
  (for [fmt (, "pdf")]
    (with [(pl-plot (, 6 6)
                    (+ "WC-case-pelayout-perf-" pelayout "-" timer-type)
                    :format fmt)]
      (sv ax (pl.axes))
      (for [(, vi vname) (enumerate (, v1-name v2-name))
            (, ti timer) (enumerate timers)]
        (draw-box ax (get boxes vname timer)
                  (nth lss ti)
                  (if (= timer tot-tname) 3 2)
                  (nth clrs ti)
                  (if (= timer tot-tname) "" (nth hatches vi))))
      (pl.axis "tight")
      (dont pl.xlim (, 0 6000))
      (dont pl.ylim (, 0 1)))))

(when-inp ["parse-and-plot-fcase-vs-nodecount"]
  (sv d (parse-timer-summary-file "../fcase-timers1.txt"))
  (plot-fcase-vs-nodecount d))

(when-inp ["parse-and-plot-fcase-bar-chart"]
  (sv d (parse-timer-summary-file "../fcase-timers1.txt"))
  (plot-fcase-bar-chart d 85))

(when-inp ["dev-wc"]
  (sv d (parse-timer-summary-file "../wccase-timers1.txt" :case "wc"))
  (write-wccase-table d))

(when-inp ["parse-and-plot-wccase-vs-nodecount"]
  (sv d (parse-timer-summary-file "../wccase-timers1.txt" :case "wc"))
  (for [details (, False True)]
    (plot-wccase-vs-nodecount d :details details)))

(when-inp ["parse-and-plot-wccase-pelayout-perf"]
  (sv d (parse-timer-summary-file "../wccase-timers1.txt" :case "wc"))
  (for [tt (, "tavg" "tmax")]
    (plot-wccase-pelayout-perf d :timer-type tt)))
