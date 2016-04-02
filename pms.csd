<CsoundSynthesizer>
<CsOptions>
-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched --expression-opt
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1

seed 0 ; seed from system clock

gitwopi = 2.0 * $M_PI

gisine ftgen 1, 0, 8192, 10, 1

;                               0    1    2     3     4     5     6     7
gipreset ftgen 11, 0, 16, -2,   -12, 1.3, 1.0,  0.6,  1.0,  5.0,  0.05, 0.01

; preset table indexes:
#define preset_vol #0#
#define carrier_fac #1#
#define carrier_fac_mod #2#
#define modulator_fac #3#
#define modulator_fac_mod #4#
#define ndx #5#
#define vol_att #6#
#define vol_dec #6#

alwayson "mix"
alwayson "verb"

connect "pms", "leftout", "mix", "synleftin"
connect "pms", "rightout", "mix", "synrightin"
connect "pms", "leftout", "verb", "leftin"
connect "pms", "rightout", "verb", "rightin"
connect "verb", "leftout", "mix", "verbleftin"
connect "verb", "rightout", "mix", "verbrightin"

instr 1	
; generate events to trigger pm synthesizer
krate randomi .1, .03, .1
ktrig metro krate
koct random 3, 9
kdur random 5, 45

schedkwhen ktrig, 0, 0, "pms", 0, kdur, cpsoct(koct), ampdbfs(-12)
endin


instr pms
iamp = ampdbfs(table($preset_vol, gipreset)) * p5
kdetune = rspline(.00001, .0001, -.3, .3)
kf0 = p4+kdetune

kcfac = table($carrier_fac, gipreset) + table($carrier_fac_mod, gipreset)*rspline(.0001, .0033, .9, 1.1)
kmfac = table($modulator_fac, gipreset) + table($modulator_fac_mod, gipreset)*rspline(.0000001, .000001, .6, .9)
indx = table($ndx, gipreset) / gitwopi
ieva = table($vol_att, gipreset) * p3
ievd = table($vol_dec, gipreset) * p3

iamp2 = iamp*2
ievr = .2*p3
ievss = p3-ieva-ievd
indx1 = indx*0
idxa = .1*p3
idxd = .5*p3
indx2 = indx*.25
idxr = .25*p3
idxss = p3-idxa-idxd

kndx = linsegr(indx1, idxa, indx, idxd, indx2, idxss, indx2, idxr, indx1)
amodsig = oscili(kndx, kf0*kmfac, gisine) ; modulator
acarphs = phasor(kf0*kcfac) ; move phase at carrier frequency

asig = linsegr(0, ieva, iamp, ievd, iamp2, ievss, iamp2, ievr, 0) * tablei(acarphs+amodsig, gisine, 1, 0, 1)

; panning
asigl, asigr pan2 asig, rspline(.2, .8, .1, 10), 1

outleta "leftout", asigl
outleta "rightout", asigr
endin


instr verb
aleftin inleta "leftin"
arightin inleta "rightin"

iroom = .999
idamp = .111

aleftout, arightout freeverb aleftin, arightin, iroom, idamp

outleta "leftout", aleftout
outleta "rightout", arightout
endin

instr mix
;synth input
asynthleftin inleta "synthleftin"
asynthrightin inleta "synthrightin"

; hpf on synth input
asynthleftin = buthp(buthp(asynthleftin, 400), 400)
asynthrightin = buthp(buthp(asynthrightin, 400), 400)

; verb input
averbleftin inleta "verbleftin"
averbrightin inleta "verbrightin"

; gain and summing
ksynthvol = ampdbfs(-21)
kverbvol = ampdbfs(-3)
kmaster = ampdbfs(-3)

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
