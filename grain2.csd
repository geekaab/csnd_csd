<CsoundSynthesizer>
<CsOptions>
;-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched -j8
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 16
nchnls = 2
0dbfs = 1

; seed from system clock
seed 0

gisine ftgen 6, 0, 8192, 10, 1
giwfn ftgen 7, 0, 32768, 20, 2, 1

maxalloc "grain", 50

alwayson  "mix"
alwayson "verb"
alwayson "comp"

instr 1	
; generate events to trigger grain instrument
krate randomi .01, .3, .1
ktrig metro krate
koct random 6, 11
kdur random 15, 45
schedkwhen ktrig, 0, 0, "grain", 0, kdur, cpsoct(koct)
endin

instr grain
krmin = 1.0/p3
krmax = krmin * 3
kcps = p4
kphs rspline -1.0, 1.0, .002, .05
;kphs = 0
;kfmd rspline .3*p4, .3*p4, .005, .2
kfmd rspline -.3, .3, .005, 1
kpmd = 0
kgdur rspline .1, .002, .01, .1
kgdens rspline 10, 500, .001, .01
imaxovr = 1000
kfn = gisine
asig grain3 kcps, kphs, kfmd, kpmd, kgdur, kgdens, imaxovr, kfn, giwfn, 0, 16
kenv linseg 0, p3*.5, 1, p3*.5, 0, 1, 0
outleta "leftout", asig*kenv*ampdbfs(-12)
outleta "rightout", asig*kenv*ampdbfs(-12)
endin

; signal routing
connect "grain", "leftout", "comp", "leftin"
connect "grain", "rightout", "comp", "rightin"
connect "comp", "leftout", "verb", "leftin"
connect "comp", "rightout", "verb", "rightin"
connect "comp", "leftout", "mix", "synthleftin"
connect "comp", "rightout", "mix", "synthrightin"
connect "verb", "leftout", "mix", "verbleftin"
connect "verb", "rightout", "mix", "verbrightin"

instr comp
aleftin inleta "leftin"
arightin inleta "rightin"
; clip input @-24dBfs using tanh clipping
aleftgain clip aleftin, 2, ampdbfs(-32)
arightgain clip arightin, 2, ampdbfs(-32)
outleta "leftout", aleftgain
outleta "rightout", arightgain
endin

instr verb
aleftin inleta "leftin"
arightin inleta "rightin"
iroom = .999
idamp = .666
aleftout, arightout freeverb aleftin, arightin, iroom, idamp
outleta "leftout", aleftout
outleta "rightout", arightout
endin

instr mix
;synth input
asynthleftin inleta "synthleftin"
asynthrightin inleta "synthrightin"
; hp @80Hz on synth input
asynthleftin = buthp(buthp(asynthleftin, 80), 80)
asynthrightin = buthp(buthp(asynthrightin, 80), 80)
; verb input
averbleftin inleta "verbleftin"
averbrightin inleta "verbrightin"
; gain and summing
ksynthvol = ampdbfs(-6)
kverbvol = ampdbfs(-9)
kmaster = ampdbfs(-6)

amixl = kmaster * sum(asynthleftin*ksynthvol, averbleftin*kverbvol)
amixr = kmaster * sum(asynthrightin*ksynthvol, averbrightin*kverbvol)

outs amixl, amixr
endin

</CsInstruments>
<CsScore>
i 1 0 3600
e
</CsScore>
</CsoundSynthesizer>
