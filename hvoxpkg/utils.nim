import os, ospaths, strutils

when defined(windows):
  let rootPath = getAppDir()
else:
  let rootPath = "~/.hvox"

let voicePath = rootPath / "voices"

const
  ErrorWords* = "beep(e75) beep(e75) beep"
  NumberWords* = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ]
  TensWords* = [
    "zero",
    "ten",
    "twenty",
    "thirty",
    "fourty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ]

proc getVoiceDir*(vname: string): string =
  voicePath / vname

proc dirEmpty*(path: string, checkDirs: bool = false): bool =
  if not existsDir(path):
    return true
  result = true
  for kind, fpath in walkDir(path):
    if kind == pcFile or kind == pcLinkToFile or checkDirs:
      return false

proc readBinFile*(path: string): seq[byte] =
  result = nil
  if not existsFile(path):
    return
  var f = open(path)
  let sz = f.getFileSize()
  result = newSeq[byte](sz)
  discard f.readBuffer(addr result[0], sz)
  f.close()

proc numToWords*(tn: int, silentZero: bool = true): string =
  if tn > 199 or tn < 0: return ErrorWords
  result = ""
  if tn == 0: 
    if silentZero:
      return
    else:
      return "zero"
  var n = tn
  if n >= 100:
    result = "onehundred"
    n -= 100
  if n >= 20:
    if result != "": result &= ' '
    result &= TensWords[n div 10]
    n = n mod 10
  if n > 0:
    if result != "": result &= ' '
    result &= NumberWords[n]
