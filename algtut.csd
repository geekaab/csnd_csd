<CsoundSynthesizer>
<CsOptions>
-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched --expression-opt
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 512
nchnls = 1
0dbfs = 1

; seed from system clock
seed 0
schedule 1, 0, .5, 0,0
schedule 1,.075, .5, 1, 0

gipch[] fillarray 8.01,8.03,8.06,8.08,8.10
giamp[] fillarray .1,.02,.2,.3

instr 1
  indx = p5
  i1 lenarray gipch
  i2 lenarray giamp
  kctl linen giamp[indx%i2]*ampdbfs(-12),.01,p3,.1
  asig oscili kctl, cpspch(gipch[indx%i1]+p4)
  out asig
  idur = gauss(.05)+.25
  schedule 1, idur, idur*2, p4, int(linrand:i(100))
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
