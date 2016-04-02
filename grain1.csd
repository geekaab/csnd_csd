<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1

gisaw ftgen 1, 0, 4096, 7, 0, 4096, 1
gisq ftgen 2, 0, 4096, 7, 0, 2046, 0, 0, 1, 2046, 1
gitri ftgen 3, 0, 4096, 7, 0, 2046, 1, 2046, 0
gipls ftgen 4, 0, 4096, 7, 1, 200, 1, 0, 0, 4096-200, 0
gibuzz ftgen 5, 0, 4096, 11, 20, 1, 1
gisine ftgen 6, 0, 4096, 10, 1

giwfn ftgen 7, 0, 16384, 20, 2, 1

instr 1
koct rspline 4, 8, .1, .5
kcps = cpsoct(koct)
kphs = 0
kfmd = 0
kpmd = 0
kgdur rspline .01, .2, .05, .2
kgdens rspline 10, 200, .05, .5
imaxovr = 1000
kfn randomh 1, 5.99, .1
asig grain3 kcps, kphs, kfmd, kpmd, kgdur, kgdens, imaxovr, kfn, giwfn, 0, 0
outs asig*.06, asig*.06
endin

</CsInstruments>
<CsScore>
i 1 0 300
e
</CsScore>
</CsoundSynthesizer>
