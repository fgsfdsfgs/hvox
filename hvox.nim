import os, strutils, sequtils
import hvoxpkg/voice, hvoxpkg/specials

const DefaultVoice = "hgrunt"

var words = commandLineParams()

if words.len == 0 or (words.len < 3 and words[0] == "-v"):
  echo("usage: hvox [-voice voice] [-volume x] [-pitch y] <sentence>")
  quit(QuitFailure)

var vox: Voice = nil
var volMod = 1.0
var pitchMod = 1.0

var i = 0
while (words[i][0] == '-') and (i + 1 < words.len):
  if words[i] == "-voice":
    i.inc
    let vname = words[i]
    var fvox = loadVoice(vname)
    if fvox != nil:
      vox = fvox
    else:
      echo("could not find voice '", vname, "', using default")
  elif words[i] == "-volume":
    i.inc
    volMod = parseFloat(words[i])
  elif words[i] == "-pitch":
    i.inc
    pitchMod = parseFloat(words[i])
  i.inc

words = words[i .. ^1]

words.expandSpecials()

if vox == nil:
  vox = loadVoice(DefaultVoice)
  if vox == nil:
    echo("could not load default voice ('", DefaultVoice, "')!")
    quit(QuitFailure)

vox.speak(words, volMod, pitchMod)
sleep(50)
