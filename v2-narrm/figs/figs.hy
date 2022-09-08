(require [amb3 [*]])
(import [amb3 [*]])

(do
 (pl-require-type1-fonts)
 (assoc matplotlib.rcParams "savefig.dpi" 300))

(defn get-wccase-context []
  {:ncore 64
   :nphys-per-day 48
   :pelayouts (, "T" "XS" "S" "M" "L")
   :xticks (, 14 16 28 40 53 59 80 100 105)
   :prefix "v2-overview-wccase-chrysalis-r0."
   :lr-name "WCYCL20TR.ne30pg2_EC30to60E2r2"
   :narrm-name "WCYCL20TR.northamericax4v1pg2_WC14to60E2r3"
   :lr-atm-nelem (* 6 (** 30 2))
   ;; /lcrc/group/e3sm/public_html/inputdata/atm/cam/inic/homme/northamericax4v1.g
   :narrm-atm-nelem 14454
   ;; /lcrc/group/acme/public_html/inputdata/ocn/mpas-o/EC30to60E2r2/ocean.EC30to60E2r2.200908.nc
   :lr-ocn-ncell 236853
   ;; /lcrc/group/acme/public_html/inputdata/ocn/mpas-o/WC14to60E2r3/ocean.WC14to60E2r3.210210.nc
   :narrm-ocn-ncell 407420
   ;; atm_in dtime and se_tstep
   :lr-atm-physics-dt 1800
   :lr-atm-dycore-dt 300
   :narrm-atm-physics-dt 1800
   :narrm-atm-dycore-dt 75
   ;; mpaso_in config_dt
   :lr-ocn-dt (* 30 60)
   :narrm-ocn-dt (* 10 60)
   ;; mpassi_in config_dt
   :lr-ice-dt (* 30 60)
   :narrm-ice-dt (* 30 60)})

(defn slash-underscore [s] (.replace s "_" "\_"))

(defn parse-timer-summary-file [fname &optional case]
  (svifn case "f")
  (defn parse-name [ln]
    (sv parts (.split ln "."))
    (, (first (.split (last parts) "-")) (+ (nth parts 1) "." (nth parts 2))))
  (defn parse-fcase-name [ln]
    (sv (, a b) (parse-name ln))
    (, (int a) b))
  (defn parse-wccase-name [ln] (parse-name ln))
  (sv txt (.split (readall fname) "\n")
      d {})
  (for [ln txt]
    (cond [(< (len ln) 2) (break)]
          [(and (= case "wc") (in "WCYCL20TR" ln))
           (sv (, nodecount compset) (parse-wccase-name ln))]
          [:else
           (sv ln (.replace ln " - " "")
               (, timer nrank nthr callcnt tsum tmax)
               (sscanf ln "s,i,i,f,f,f"))
           (assoc-nested d (, nodecount compset (.replace timer "\"" ""))
                         {"nrank" nrank "nthr" nthr "callcnt" callcnt
                          "tavg" (/ tsum nthr) "tmax" tmax})]))
  d)

(defn sypd-sec [ttot tsec]
  (sv e (get-wccase-context)
      nphys-per-day (:nphys-per-day e)
      simyrs (/ (get ttot "callcnt") (get ttot "nthr") nphys-per-day 365)
      walldays (/ tsec 24 3600))
  (/ simyrs walldays))

(defn sypd [ttot t fld]
  (sypd-sec ttot (get t fld)))

(defn write-wccase-table [d]
  (sv e (get-wccase-context))
  (print (+ "                                                       "
            "SYPD     SYPD   SYPD     SYPD\n"
            "PE                                        "
            "Case #node  Total |    ATM    ICE |    OCN | Factor"))
  (sv sypd-tot-lr None)
  (for [pe (:pelayouts e)
        (, ci compset) (enumerate (, (:lr-name e) (:narrm-name e)))]
    (sv d1 (geton d pe compset))
    (when (none? d1) (continue))
    (sv ttot (get d1 "CPL:RUN_LOOP")
        tatm (get d1 "CPL:ATM_RUN")
        tocn (get d1 "CPL:OCN_RUN")
        tice (get d1 "CPL:ICE_RUN")
        sypd-tot (sypd ttot ttot "tmax")
        nrank (get ttot "nrank"))
    (when (in "ne30pg2" compset)
      (sv sypd-tot-lr sypd-tot
          nrank-lr nrank))
    (prf "{:>2s} {:>43s}   {:3d} {:6.2f} | {:6.2f} {:6.2f} | {:6.2f} | {}"
         pe compset
         (// nrank (:ncore e))
         sypd-tot
         (sypd ttot tatm "tmax") (sypd ttot tice "tmax")
         (sypd ttot tocn "tmax")
         (if (or (in "ne30pg2" compset) (none? sypd-tot-lr))
           ""
           (.format "{:4.2f}"
                    (* (/ sypd-tot-lr sypd-tot)
                       (/ nrank nrank-lr)))))))

(defn sum-timers [d timers fld]
  (reduce (fn [a x] (+ a (get d x fld)))
          timers 0))

(defn model-rrm-performance [d]
  (sv e (get-wccase-context)
      atm-params-timers (, "a:CAM_run1" "a:CAM_run2" "a:CAM_run3")
      atm-dycore-timers (, "a:CAM_run3")
      d-lr (get d "XS" (:lr-name e))
      ttot-lr (get d-lr "CPL:RUN_LOOP"))
  (defn atm-model [d-rrm top-timer]
    (* (/ (get d-rrm top-timer "nrank") (get d-lr top-timer "nrank"))
       (sypd-sec ttot-lr
                 (+ (* (/ (:narrm-atm-nelem e)
                          (:lr-atm-nelem e))
                       (+ (* (/ (:lr-atm-physics-dt e)
                                (:narrm-atm-physics-dt e))
                             (sum-timers d-lr atm-params-timers "tmax"))
                          (* (/ (:lr-atm-dycore-dt e)
                                (:narrm-atm-dycore-dt e))
                             (sum-timers d-lr atm-dycore-timers "tmax"))))))))
  (defn ocn-model [d-rrm top-timer]
    (* (/ (get d-rrm top-timer "nrank") (get d-lr top-timer "nrank"))
       (sypd-sec ttot-lr
                 (* (/ (:narrm-ocn-ncell e)
                       (:lr-ocn-ncell e))
                    (/ (:lr-ocn-dt e)
                       (:narrm-ocn-dt e))
                    (get d-lr top-timer "tmax")))))
  (defn ice-model [d-rrm top-timer]
    (* (/ (get d-rrm top-timer "nrank") (get d-lr top-timer "nrank"))
       (sypd-sec ttot-lr
                 (* (/ (:narrm-ocn-ncell e)
                       (:lr-ocn-ncell e))
                    (/ (:lr-ice-dt e)
                       (:narrm-ice-dt e))
                    (get d-lr top-timer "tmax")))))
  (sv comps (, {:timer "CPL:ATM_RUN" :fn atm-model :name "atm"}
               {:timer "CPL:OCN_RUN" :fn ocn-model :name "ocn"}
               {:timer "CPL:ICE_RUN" :fn ice-model :name "ice"})
      p {})
  (for [pe (:pelayouts e)]
    (sv d-rrm (get d pe (:narrm-name e))
        ttot-rrm (get d-rrm "CPL:RUN_LOOP"))
    (for [c comps]
      (sv sypd-predict ((:fn c) d-rrm (:timer c))
          sypd-true (sypd ttot-rrm (get d-rrm (:timer c)) "tmax")
          n (:name c))
      (assoc-nested p (, pe (+ n "-true")) sypd-true)
      (assoc-nested p (, pe (+ n "-modeled")) sypd-predict)
      (assoc-nested p (, pe (+ n "-nrank")) (get d-rrm (:timer c) "nrank"))))
  p)

(defn make-perf-title [lr-name rrm-name &optional [newline True]]
  (+ "Performance of "
     (slash-underscore lr-name)
     (if newline "\n" " ")
     "and "
     (slash-underscore rrm-name)))

(defn plot-wccase-vs-nodecount [d &optional ax]
  (sv fys (, 0.77 1.13))
  (defn text [x y pes dx fy]
    (for-last [i (range (len x))]
      (pl.text (+ dx (nth x i))
               (* (cond [(and (> fy 1) (zero? i)) 1.33]
                        [(and (< fy 1) last?) 0.7]
                        [:else fy])
                  (nth y i))
               (.format "{:1.2f} {:s}" (nth y i) (nth pes i))
               :fontsize (- fs 2)
               :ha (cond [(zero? i) "left"]
                         [last? "right"]
                         [:else (if (< fy 1) "left" "right")]))))
  (sv e (get-wccase-context)
      xticks (:xticks e)
      log-xticks (npy.log xticks)
      yticks (, 1 2 3 4 5 6 8 10 15 20 30 40 50)
      lr-name (:lr-name e)
      rrm-name (:narrm-name e)
      v-short-names (, "LR" "NARRM")
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
    (for [vname (, lr-name rrm-name)]
      (when (none? (geton d1 vname)) (continue))
      (assoc-nested-append xs (, vname "nnode")
                           (// (get d1 vname "CPL:RUN_LOOP" "nrank") (:ncore e)))
      (assoc-nested-append xs (, vname "pe")
                           (case/in pe
                                    [(, "T" "XS" "S" "M" "L") pe]
                                    [:else "st"]))
      (for [timer timers]
        (assoc-nested-append ys (, vname timer)
                             (sypd (get d1 vname (first timers))
                                   (get d1 vname timer)
                                   "tmax")))))
  (defn plot []
    (sv g 0.5 r 28
        x (, 5 115))
    (pl.semilogy (npy.log x)
                 (, (* r (/ (first x) (last x))) r) "--" :color (, g g g))
    (for [(, vi vname) (enumerate (, lr-name rrm-name))
          (, ti timer) (enumerate timers)]
      (unless (= timer (first timers)) (continue))
      (sv x (npy.log (get xs vname "nnode"))
          pes (get xs vname "pe")
          y (get ys vname timer))
      (when (zero? ti) (text x y pes 0 (nth fys vi)))
      (pl.semilogy x y
                   (+ (nth clrs vi) (nth linestyles vi) (nth markers ti))
                   :label (+ (nth v-short-names vi) " " (nth timer-names ti))))
    (pl.legend :loc "best" :fontsize fs :ncol 2 :framealpha 1)
    (my-grid)
    (pl.title (make-perf-title lr-name rrm-name) :fontsize fs)
    (pl.xticks log-xticks xticks :fontsize fs :rotation 0)
    (sv (, xtv xto) (pl.xticks))
    (for [(, v t) (zip xtv xto)]
      (when (in v (npy.log (, 14 53 80 100))) (.set-ha t "right"))
      (when (in v (npy.log (, 16 59 105))) (.set-ha t "left")))
    (pl.yticks yticks yticks :fontsize (- fs 2))
    (pl.xlim (npy.log (, 13 110)))
    (pl.ylim (, 2 50))
    (pl.xlabel "Number of Chrysalis AMD Epyc 7532 64-core nodes"
               :fontsize fs)
    (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))
  (if (none? ax)
      (for [fmt (, "pdf" "png")]
        (with [(pl-plot (, 7 6)
                        "NARRM-nodecount"
                        :format fmt)]
          (plot)))
      (plot)))

(defn plot-wccase-pelayout-perf [d &optional pelayout timer-type sbs
                                 ax-xlim ax-ylim
                                 [title True]]
  (svifn pelayout "L" timer-type "tmax" sbs False)
  (sv compact (not (none? ax-xlim))
      e (get-wccase-context)
      ice-tname "CPL:ICE_RUN" atm-tname "CPL:ATM_RUN"
      lnd-tname "CPL:LND_RUN" rof-tname "CPL:ROF_RUN"
      tot-tname "CPL:RUN_LOOP" ocn-tname "CPL:OCN_RUN" cpl-tname "CPL:RUN"
      timers (, atm-tname cpl-tname ice-tname lnd-tname rof-tname ocn-tname
                tot-tname)
      lr-name (:lr-name e)
      rrm-name (:narrm-name e)
      v-short-names (, "LR" "NARRM")
      clrs (, (if sbs "c" "b") "r" "y" (, 0.7 0.5 0) (if sbs "m" "c") "g" "k")
      lss (if sbs (, "-" "-" "-" "-" "-" "-" "-") (, "-" ":" "--" "-" "-" "-" "-"))
      hatches (if sbs (, "" "") (, "\\" "//"))
      fs 15 fs1 (+ fs 2)
      T (get d pelayout rrm-name tot-tname timer-type)
      boxes {})
  (defn calc-rank0 [nrank] (* (:ncore e) (math.ceil (/ nrank (:ncore e)))))
  (defn draw-box [ax b ls lw color hatch fill]
    (.add-patch
     ax
     (matplotlib.patches.Rectangle (, (inc (:rank0 b)) (/ (:time0 b) T))
                                   (:nrank b) (/ (:time b) T)
                                   :fill fill :linestyle ls :lw lw
                                   :color color :hatch hatch)))
  (for [vname (, lr-name rrm-name)
        timer timers]
    (sv d1 (get d pelayout vname))
    (assoc-nested boxes (, vname timer)
                  {:nrank (cond [(= timer cpl-tname)
                                 ;; for some reason this is not the ranks
                                 ;; reported in CPL:RUN.
                                 (calc-rank0 (get d1 atm-tname "nrank"))]
                                [:else (get d1 timer "nrank")])
                   :time (get d1 timer timer-type)
                   :rank0 (cond [(and (= vname rrm-name) (= timer rof-tname))
                                 0]
                                [(in timer (, rof-tname lnd-tname))
                                 (calc-rank0 (get d1 ice-tname "nrank"))]
                                [(= timer ocn-tname)
                                 (calc-rank0 (get d1 atm-tname "nrank"))]
                                [:else 0])
                   :time0 (cond [(= timer cpl-tname)
                                 (+ (get d1 ice-tname timer-type)
                                    (get d1 atm-tname timer-type))]
                                [(and (= vname rrm-name) (= timer rof-tname))
                                 (get d1 ice-tname timer-type)]
                                [(= timer rof-tname)
                                 (get d1 lnd-tname timer-type)]
                                [(and (= vname rrm-name) (= timer atm-tname))
                                 (+ (get d1 ice-tname timer-type)
                                    (get d1 rof-tname timer-type))]
                                [(= timer atm-tname)
                                 (get d1 ice-tname timer-type)]
                                [:else 0])}))
  (defn plot []
    (sv ax0 (first ax-xlim) adx (- (last ax-xlim) ax0)
        ay0 (first ax-ylim) ady (- (last ax-ylim) ay0))
    (unless sbs (sv ax (pl.axes (, ax0 ay0 adx ady))))
    (for [(, vi vname) (enumerate (, lr-name rrm-name))]
      (when sbs
        (sv ax (pl.axes (, (+ ax0 (* 0.5 adx vi)) ay0 (* 0.47 adx) ady))))
      (for [(, ti timer) (enumerate timers)]
        (draw-box ax (get boxes vname timer)
                  (nth lss ti)
                  (if (= timer tot-tname) (if sbs 2 3) (if sbs 0 2))
                  (nth clrs ti)
                  (if (= timer tot-tname) "" (nth hatches vi))
                  (and sbs (not (= timer tot-tname)))))
      (pl.axis "tight")
      (sv ocn-rank0 (get boxes lr-name ocn-tname :rank0)
          lr-max-rank (get d pelayout lr-name tot-tname "nrank")
          narrm-max-rank (get d pelayout rrm-name tot-tname "nrank")
          xmax (max lr-max-rank narrm-max-rank))
      (pl.xticks (, ocn-rank0 lr-max-rank narrm-max-rank) :fontsize fs
                 :rotation (if compact -45 0))
      (sv (, xtv xto) (pl.xticks))
      (for [(, v t) (zip xtv xto)]
        (when (in v (, 6720)) (.set-ha t "left")))
      (sv delta 10)
      (pl.xlim (, (- delta) (+ xmax delta)))
      (if (or (not sbs) (zero? vi))
          (do
            (pl.yticks (npy.linspace 0 1 11) :fontsize fs)
            (pl.ylabel "Normalized time" :fontsize fs))
          (pl.yticks (npy.linspace 0 1 11) (* [] 11)))
      (pl.ylim (, 0 1))
      (sv xtxt "Number of Chrysalis AMD Epyc 7532 cores")
      (if (and compact sbs)
          (when (= vi 1)
            (pl.text (+ ax0 (* 0.5 adx)) (- ay0 0.14) xtxt
                     :ha "center" :va "top"
                     :fontsize fs :transform (. (pl.gcf) transFigure)))
          (pl.xlabel xtxt :fontsize fs))
      (when title
        (sv txt (make-perf-title lr-name rrm-name :newline (not sbs)))
        (if sbs
            (if (zero? vi) (pl.text lr-max-rank 1.05 txt :fontsize fs :ha "center"))
            (pl.title txt :fontsize fs)))
      (when (or (not sbs) (= vi 1))
        (pl.text (* 0.02 xmax) 0.0 "ICE" :fontsize fs1 :va "bottom")
        (pl.text (* 0.89 xmax) 0.9 "OCN" :fontsize fs1 :va "top" :ha "right")
        (pl.text (* 0.02 xmax) 0.9 "CPL" :fontsize fs1 :va "top")
        (pl.text (* 0.02 xmax) 0.78 "ATM" :fontsize fs1 :va "top"))
      (when (or (not sbs) (zero? vi))
        (pl.text lr-max-rank
                 (+ 0.02 (/ (get d pelayout lr-name tot-tname timer-type) T))
                 "LR" :fontsize (+ 2 fs1) :ha "right"))
      (when (or (not sbs) (= vi 1))
        (pl.text narrm-max-rank
                 (+ 0.02 (/ (get d pelayout rrm-name tot-tname timer-type) T))
                 "NARRM" :fontsize (+ 2 fs1) :ha "right"))
      (for [s (, "top" "right")]
        (.set-visible (get ax.spines s) False))))
  (if (none? ax-xlim)
      (do
        (sv ax-xlim (, 0 1)
            ax-ylim (, 0 1))
        (for [fmt (, "pdf" "png")]
          (with [(pl-plot (if sbs (, 10 5) (, 6 6))
                          (+ "NARRM-pelayout-perf-" pelayout "-" timer-type
                             (if sbs "-sbs" ""))
                          :format fmt :tight (not sbs))]
            (plot))))
      (plot)))

(defn plot-wccase [d &optional pelayout]
  (svifn pelayout "L")
  (sv e (get-wccase-context)
      fs 16)
  (for [fmt (, "pdf" "png")]
    (with [(pl-plot (, 12 4) "perf-WC-case" :format fmt :tight False)]
      (sv ax-xlim (, 0.46 1)
          ax-ylim (, 0.1 0.9)
          axs (, (pl.axes (, 0 0 0.4 1))))
      (sv ax (first axs))
      (pl.axes ax)
      (plot-wccase-vs-nodecount d :ax ax)
      (pl.title "")
      (plot-wccase-pelayout-perf d :pelayout pelayout :sbs True :title False
                                 :ax-xlim ax-xlim :ax-ylim ax-ylim)
      (sv trans (. (pl.gcf) transFigure)
          dy -0.1)
      (pl.text -0.05 dy "(a)" :transform trans :fontsize fs)
      (pl.text 0.44 dy "(b)" :transform trans :fontsize fs)
      (pl.text 0.5 1.05 (make-perf-title (:lr-name e) (:narrm-name e)
                                         :newline False)
               :transform trans :fontsize fs :ha "center"))))

(defn plot-rrm-details [d]
  (sv e (get-wccase-context)
      p (model-rrm-performance d)
      xticks (, 300 400 600 800 1000 2000 3000 4000 5000)
      yticks (, 1 2 3 4 5 6 7 8 9 10 12 14 16 18 20)
      rrm-name (:narrm-name e)
      fs 15
      curves (, {:x "atm-nrank" :y "atm-true" :line "-" :mark "o" :clr "b"
                 :lbl "Atm." :fillstyle "full"}
                {:x "atm-nrank" :y "atm-modeled" :line "--" :mark "o" :clr "b"
                 :lbl "Atm. (predicted)" :fillstyle "none"}
                {:x "ocn-nrank" :y "ocn-true" :line "-" :mark "v" :clr "r"
                 :lbl "Ocean" :fillstyle "full"}
                {:x "ocn-nrank" :y "ocn-modeled" :line "--" :mark "v" :clr "r"
                 :lbl "Ocean (predicted)" :fillstyle "none"}))
  (defn plot []
    (for [c curves]
      (sv x [] y [])
      (for [pe (:pelayouts e)]
        (.append x (get p pe (:x c)))
        (.append y (get p pe (:y c))))
      (pl.loglog x y
                 (+ (:clr c) (:mark c) (:line c)) :fillstyle (:fillstyle c)
                 :label (:lbl c)))
    (pl.legend :loc "lower left" :fontsize fs :ncol 2 :framealpha 1)
    (my-grid)
    (pl.title (+ "True and predicted performance of\n" rrm-name) :fontsize fs)
    (pl.xticks xticks xticks :fontsize (- fs 2) :rotation -45)
    (pl.yticks yticks yticks :fontsize (- fs 2))
    (pl.xlim (, 230 5400))
    (pl.ylim (, 1 20))
    (pl.xlabel "Number of Chrysalis AMD Epyc 7532 cores"
               :fontsize fs)
    (pl.ylabel "Simulated Years Per Day (SYPD)" :fontsize fs))
  (for [fmt (, "pdf" "png")]
    (with [(pl-plot (, 6 6)
                    "NARRM-modeled-performance"
                    :format fmt)]
      (plot))))

(sv *timers-summary-file*
    "../chrysalis-perf-study/v2-narrm-wccase-chrysalis-r1-timers.txt")

(when-inp ["table"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc"))
  (write-wccase-table d))

(when-inp ["analysis"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc")
      p (model-rrm-performance d))
  (for [(, k v) (.items p)]
    (print k v)))

(when-inp ["parse-and-plot-wccase-vs-nodecount"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc"))
  (for [details (, False True)]
    (plot-wccase-vs-nodecount d :details details)))

(when-inp ["parse-and-plot-wccase-pelayout-perf"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc"))
  (for [tt (, "tmax") sbs (, True)]
    (plot-wccase-pelayout-perf d :timer-type tt :sbs sbs)))

(when-inp ["parse-and-plot-wccase"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc"))
  (plot-wccase d))

(when-inp ["parse-and-plot-rrm-details"]
  (sv d (parse-timer-summary-file *timers-summary-file* :case "wc"))
  (plot-rrm-details d))
