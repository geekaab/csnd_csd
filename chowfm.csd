<CsoundSynthesizer>
<CsOptions>
-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched --expression-opt
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 16
nchnls = 2
0dbfs = 1

seed 0 ; seed from system clock

gitwopi = 2.0 * $M_PI
#define verysmall #0.000001#

gisine ftgen 1, 0, 8192, 10, 1

;                               0    1    2   3   4   5
gipreset ftgen 11, 0, 16, -2,   -6, 6.6, 10, 0, .3,  .6

; preset table indexes:
#define vol #0#
#define mod_ratio #1#
#define maxindex #2#
#define minindex #3#
#define v_att #4#
#define v_rel #5#

alwayson "mix"
alwayson "verb"

connect "chowfm", "leftout", "mix", "synleftin"
connect "chowfm", "rightout", "mix", "synrightin"
connect "chowfm", "leftout", "verb", "leftin"
connect "chowfm", "rightout", "verb", "rightin"
connect "verb", "leftout", "mix", "verbleftin"
connect "verb", "rightout", "mix", "verbrightin"

;instr 1	
;; generate events to trigger pm synthesizer
;krate randomi .1, .03, .1
;ktrig metro krate
;koct random 3, 9
;kdur random 5, 45
;schedkwhen ktrig, 0, 0, "chowfm", 0, kdur, cpsoct(koct), ampdbfs(-12)
;endin

schedule 1, 0.01, .5, 0,0
;schedule 1,.075, .5, 1, 0

gipch[] fillarray 4,01,4.03,4.06,4.08,4.10,8.01,8.03,8.06,8.08,8.10
giamp[] fillarray .1,.02,.2,.3

instr chowfm
  indx = p6
  i1 lenarray gipch
  i2 lenarray giamp
  irnddur = gauss(.05)+.25
  idur = p3
  icarfreq = p4
  iratio = table($mod_ratio, gipreset)
  imodfreq = icarfreq / iratio

  index = table($maxindex, gipreset)
  iminindex = table($minindex, gipreset)
  imaxdev = index * imodfreq
  imindev = iminindex * imodfreq
  ivardev = imaxdev - imindev

  iamp = ampdbfs(p5) * ampdbfs(table($vol, gipreset))
  iattack = table($v_att, gipreset) * idur
  isustain = idur - iattack
  irelease = table($v_rel, gipreset) * idur

  kenv expsegr $verysmall, iattack, iamp, isustain, iamp, irelease, $verysmall
  kmod = imindev + imaxdev*kenv
  amod oscili kmod, imodfreq, gisine
  asig oscili iamp*kenv, icarfreq+amod
  outleta "leftout", asig * kenv
  outleta "rightout", asig * kenv
  schedule "chowfm", irnddur*5, irnddur*7, cpspch(gipch[indx%i1]+p4), giamp[indx%i2]*ampdbfs(-12), int(linrand:i(100))
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
; hp @120Hz on synth input
asynthleftin buthp asynthleftin, 400
asynthleftin buthp asynthleftin, 400
asynthrightin buthp asynthrightin, 400
asynthrightin buthp asynthrightin, 400
; verb input
averbleftin inleta "verbleftin"
averbrightin inleta "verbrightin"
; gain and summing
ksynthvol = ampdbfs(-18)
kverbvol = ampdbfs(-3)
amixl sum asynthleftin*ksynthvol, averbleftin*kverbvol
amixr sum asynthrightin*ksynthvol, averbrightin*kverbvol
kmaster = ampdbfs(-3)
outs kmaster*amixl, kmaster*amixr
endin

</CsInstruments>
<CsScore>
i 1 0 3600
e
</CsScore>
</CsoundSynthesizer>
