<CsoundSynthesizer>
<CsOptions>
;-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched -j8
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 8
nchnls = 2
0dbfs = 1

; seed from system clock
seed 0

alwayson "mix"
alwayson "verb"
alwayson "comp"

; signal routing
connect "subsyn", "leftout", "comp", "leftin"
connect "subsyn", "rightout", "comp", "rightin"
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
outleta "leftout", clip(aleftin, 2, ampdbfs(-24))
outleta "rightout", clip(arightin, 2, ampdbfs(-24))
endin

instr verb
aleftin inleta "leftin"
arightin inleta "rightin"
iroom = .999
idamp = .66
aleftout, arightout freeverb aleftin, arightin, iroom, idamp
outleta "leftout", aleftout
outleta "rightout", arightout
endin

instr mix
;synth input
asynthleftin inleta "synthleftin"
asynthrightin inleta "synthrightin"
; hp @80Hz on synth input
ihpfreq = 80
asynthleftin = buthp(buthp(asynthleftin, ihpfreq), ihpfreq)
asynthrightin = buthp(buthp(asynthrightin, ihpfreq), ihpfreq)
; verb input
averbleftin inleta "verbleftin"
averbrightin inleta "verbrightin"
; gain and summing
ksynthvol = ampdbfs(-24)
kverbvol = ampdbfs(-3)
kmaster = ampdbfs(-3)
amixl = kmaster * clip(ampdbfs(12) * sum(asynthleftin*ksynthvol, averbleftin*kverbvol), 2, ampdbfs(-12))
amixr = kmaster * clip(ampdbfs(12) * sum(asynthrightin*ksynthvol, averbrightin*kverbvol), 2, ampdbfs(-12))
outs amixl, amixr
endin

instr 1	
; generate events to trigger subsyn instrument
krate = randomi(.0025, .1, .1)
ktrig = metro(krate)
koct = random(2, 8)
kdur = random(5, 15)
schedkwhen(ktrig, 0, 0, "subsyn", 0, kdur, cpsoct(koct))
endin

instr subsyn
idur = p3
; sound source: crossfade between a noise and a pulse generator
apulse = mpulse(15, rspline(.3, .05, .2, 2))
ainput = ntrpol(apulse, pinkish(1), rspline(0, 1, .1, 1))

; limit source bandwidth by casading two lp and two hp filters
klpf_cf = rspline(11, 7, .1, .4)
khpf_cf = rspline(6, 9, .1, .4)

ainput = butlp(butlp(ainput, cpsoct(klpf_cf)), cpsoct(klpf_cf))
ainput = buthp(buthp(ainput, cpsoct(khpf_cf)), cpsoct(khpf_cf))

; generate partials using a bank resonant bp filters
; generate frequency sweeps
kcf rspline p4*1.05, p4*.95, .01, .1
; generate bandwidths for each filter
kbw01 rspline .00001, 10, .2, 1
kbw02 rspline .00001, 10, .2, 1
kbw03 rspline .00001, 10, .2, 1
kbw04 rspline .00001, 10, .2, 1
kbw05 rspline .00001, 10, .2, 1
kbw06 rspline .00001, 10, .2, 1
kbw07 rspline .00001, 10, .2, 1
kbw08 rspline .00001, 10, .2, 1
kbw09 rspline .00001, 10, .2, 1
kbw10 rspline .00001, 10, .2, 1
kbw11 rspline .00001, 10, .2, 1
kbw12 rspline .00001, 10, .2, 1
kbw13 rspline .00001, 10, .2, 1
kbw14 rspline .00001, 10, .2, 1
kbw15 rspline .00001, 10, .2, 1
kbw16 rspline .00001, 10, .2, 1
kbw17 rspline .00001, 10, .2, 1
kbw18 rspline .00001, 10, .2, 1
kbw19 rspline .00001, 10, .2, 1
kbw20 rspline .00001, 10, .2, 1
kbw21 rspline .00001, 10, .2, 1
kbw22 rspline .00001, 10, .2, 1
; generate partials
imode = 0
a01 reson ainput, kcf*1.3862943611198906, kbw01, imode
a02 reson ainput, kcf*2.1972245773362196, kbw02, imode
a03 reson ainput, kcf*2.7725887222397811, kbw03, imode
a04 reson ainput, kcf*3.2188758248682006, kbw04, imode
a05 reson ainput, kcf*3.5835189384561099, kbw05, imode
a06 reson ainput, kcf*3.8918202981106265, kbw06, imode
a07 reson ainput, kcf*4.1588830833596715, kbw07, imode
a08 reson ainput, kcf*4.3944491546724391, kbw08, imode
a09 reson ainput, kcf*4.6051701859880918, kbw09, imode
a10 reson ainput, kcf*4.7957905455967413, kbw10, imode
a11 reson ainput, kcf*4.9698132995760007, kbw11, imode
a12 reson ainput, kcf*5.1298987149230735, kbw12, imode
a13 reson ainput, kcf*5.2781146592305168, kbw13, imode
a14 reson ainput, kcf*5.4161004022044201, kbw14, imode
a15 reson ainput, kcf*5.5451774444795623, kbw15, imode
a16 reson ainput, kcf*5.6664266881124323, kbw16, imode
a17 reson ainput, kcf*5.7807435157923290, kbw17, imode
a18 reson ainput, kcf*5.8888779583328805, kbw18, imode
a19 reson ainput, kcf*5.9914645471079817, kbw19, imode
a20 reson ainput, kcf*6.0890448754468460, kbw20, imode
a21 reson ainput, kcf*6.1820849067166321, kbw21, imode
a22 reson ainput, kcf*6.2709884318582994, kbw22, imode
; generate amplitudes for each partial
kamp01 rspline 0, 1, .3, 1
kamp02 rspline 0, 1, .3, 1
kamp03 rspline 0, 1, .3, 1
kamp04 rspline 0, 1, .3, 1
kamp05 rspline 0, 1, .3, 1
kamp06 rspline 0, 1, .3, 1
kamp07 rspline 0, 1, .3, 1
kamp08 rspline 0, 1, .3, 1
kamp09 rspline 0, 1, .3, 1
kamp10 rspline 0, 1, .3, 1
kamp11 rspline 0, 1, .3, 1
kamp12 rspline 0, 1, .3, 1
kamp13 rspline 0, 1, .3, 1
kamp14 rspline 0, 1, .3, 1
kamp15 rspline 0, 1, .3, 1
kamp16 rspline 0, 1, .3, 1
kamp17 rspline 0, 1, .3, 1
kamp18 rspline 0, 1, .3, 1
kamp19 rspline 0, 1, .3, 1
kamp20 rspline 0, 1, .3, 1
kamp21 rspline 0, 1, .3, 1
kamp22 rspline 0, 1, .3, 1

; summing mixer
kenv = expsegr(.0001, idur*.3, 1, idur*.7, 1, idur*.5, .0001)
kmaster = ampdbfs(-42)

amixl = kenv * \
        sum(a01*kamp01, a03*kamp03, a05*kamp05, a07*kamp07, a09*kamp09, \
            a11*kamp11, a13*kamp13, a15*kamp15, a17*kamp17, a19*kamp19, a21*kamp21)
amixr = kenv * \
        sum(a02*kamp02, a04*kamp04, a06*kamp06, a08*kamp08, a10*kamp10, \
            a12*kamp12, a14*kamp14, a16*kamp16, a18*kamp18, a20*kamp20, a22*kamp22)
outleta "leftout", kmaster * amixl
outleta "rightout", kmaster * amixr
endin

</CsInstruments>
<CsScore>
i1 0 z
</CsScore>
</CsoundSynthesizer>
