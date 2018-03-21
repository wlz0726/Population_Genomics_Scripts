cat  LQC.BRM.allchr.psmc LQC.GIR.allchr.psmc LQC.NEL.allchr.psmc> aa;

perl plot_psmc_MAR_SAT_SL.pl -M "LQC.BRM.allchr,LQC.GIR.allchr,LQC.NEL.allchr" -u 9.796e-9 -g 5 -x 10000 -X 10000000 -Y 400000 LQC2 aa;
rm LQC2*txt LQC2*par *eps *epss aa* *Good;

