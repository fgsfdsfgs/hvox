import os, strutils, sequtils, times
import utils

proc timeToWords(t: Time): string =
  let ti = getLocalTime(t)
  let hours = numToWords(if ti.hour > 12: ti.hour - 12 else: ti.hour)
  let minutes = numToWords(ti.minute)
  let ampm = if ti.hour >= 12: "pm" else: "am"
  result = "$1 $2 $3" % [hours, minutes, ampm]

proc curTimeToWords(): string {.inline.} =
  timeToWords(getTime())


proc specialTime(words: var seq[string], i: int) =
  let timeWords = curTimeToWords().strip().split()
  words.delete(i, i)
  words.insert(timeWords, i)

proc specialBrk(words: var seq[string], i: int) =
  words.delete(i, words.high)


var specials = [
  ("$time$", specialTime),
  ("$brk$", specialBrk)
]

proc expandSpecials*(words: var seq[string]) =
  var i = 0
  while i < words.len:
    for tup in specials:
      let (stok, sproc) = tup
      if words[i].startsWith(stok):
        words.sproc(i)
    i += 1
