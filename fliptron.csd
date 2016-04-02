<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 16
nchnls = 2
0dbfs = 1

gisine ftgen 1, 0, 4096, 10, 1
gimix ftgen 2, 0, 4096, 17, 0, 0
girec1 ftgen 3, 0, 131072, 2, 0, 0
girec2 ftgen 4, 0, 131072, 2, 0, 0
giratios ftgen 5, 0, 0, -23, "2_3ratios.txt"

gal init 0
gar init 0

gitlen init 131073
giratlen init 32
gkglis init 127

instr 10
ar = 0
al = 0

kstatus, kchn, kdata1, kdata2 midiin
khash = kdata1 + (128 * (kchn-1))
if (khash > 0) then
  tabw kdata2, khash, 2
  printks "rd : %d %d %d %d %d\n", 1.0, khash, kstatus, kchn, kdata1, kdata2
endif
endin

instr 15
kfader init 127
kpan init 1
kfadert tab p4, gimix, 0
kpant tab p5, gimix, 0
ktop tab p6, gimix, 0
kbot tab p7, gimix, 0
printks "len : %d %1.4f %1.4f %d %d\n", 1, p4, kfader, kpan, ktop, kbot
kglis = kfader
kpan = ((1023*kpan + kpant/127) / 1024)
gktlen = (kpan * (gitlen-ksmps) + ksmps) / gitlen ; play at least ksmps samples
endin

instr 19 ; rec head
kfader init 1
kpan init 1
ktoptg init 0 ; top button toggle state
ktopp init 0 ; top button prev state
kfadert tab p4, gimix, 0 ; dry vol
kpant tab p5, gimix, 0 ; rec speed
ktop tab p6, gimix, 0
kbot tab p7, gimix, 0

kfader = ((63*kfader + kfadert/127) / 64) ; smooth fader
kpantr tab kpant/127, giratios, 1
kpan = ((63*kpan + kpantr) / 64) ; smooth pan

if (ktopp == 0) && (ktop != 0) then
  ktoptg = ~ktoptg ; toggle top button
endif
ktopp = ktop

printks "rec : %d %1.4f %1.4f %d %d\n", 1, p4, kfader, kpantr, ktop, kbot
al, ar ins

gat phasor kpan * sr / (gitlen * gktlen)
if ktoptg == 2 then
  tabw al, gat*gitlen*gktlen, girec1
  tabw ar, gat*gitlen*gktlen, girec2
endif

outs al*kfader, ar*kfader
endin

instr 20 ; play head
atoff init 0 ; offset to sync with rechead
at init 0 ; playhead pos
ktoptg init 0 ; top button toggle state
ktopp init 0 ; ktop prev state
kat init 0
kfader init 0
kpan init 1
kfadert tab p4, gimix, 0 ; playhead vol
kpant tab p5, gimix, 0 ; playhead speed
ktop tab p6, gimix, 0
kbot tab p7, gimix, 0

kfader = ((63*kfader + kfadert/127) / 64)
kpantr tab kpant/127, giratios, 1
kpan = ((63*kpan + kpantr) / 64)

if (ktopp == 0) && (ktop != 0) then
  katoff = frac(1 + at - gat)
endif
ktopp = ktop

printks "pb : %d %1.4f %1.4f %d %d\n", 1, p4, kfader, kpan, ktop, kbot
at phasor kpan * sr / (gktlen * gitlen)

ainl tab frac(at+katoff) * gitlen * gktlen, girec1
ainr tab frac(at+katoff) * gitlen * gktlen, girec2

ar = kfader * ainr
al = kfader * ainl
outs al, ar
endin

instr 99 ; record to file
al, ar monitor
fout "tape_echo.wav", 14, al, ar
endin

</CsInstruments>
<CsScore>
i10 0 36000
;  table interperters
;  hash function: gkdata1+(128*gkchan)
;  order:  fader, pan, top, bottom



; this set is default for scene 1

        ;; len
i15 0 36000 2  14 23 33
        ;; rec
i19 0 36000 3  15 24 34

        ;; pb

i20 0 36000 4  16 25 35
i20 0 36000 5  17 26 36
i20 0 36000 6  18 27 37
i20 0 36000 8  19 28 38
i20 0 36000 9  20 29 39
i20 0 36000 12 21 30 40
i20 0 36000 13 22 31 41

        ;; file record 
;i99 0 36000                             ; 

;  scene  4 table interpreters
</CsScore>
