<CsoundSynthesizer>
<CsOptions>
;-+rtaudio=alsa -odac -b1024 -B8192 -m103 -d --sched
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 8
nchnls = 2
0dbfs = 1
nchnls = 6

seed 0 ; seed from system clock
gisaw = ftgen(1, 0, 4096, 10, 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10, 1/11, 1/12)
gkcoeffs[] = fillarray(1, 1.01, 1.03, 1.09, .99, .97, .91)
gkamp[] = fillarray(0, -6, -12, -18, -6, -12, -18)

alwayson "supersaw"
instr supersaw
kvol = ampdbfs(-3)
kfreq = 200
iphi[] init 7
aosc[] init 7
idx = 0
while idx < lenarray(iphi) do
  iphi[idx] = rnd(1)
  aosc[idx] = poscil(kvol, kfreq*gkcoeffs[idx], gisaw, iphi[idx])
  idx += 1
od
aosc *= gkamp
aout sumarray aosc
outs aout, aout
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
