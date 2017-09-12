import os, strutils, sequtils
import hvoxpkg/voice, hvoxpkg/specials

const DefaultVoice = "hgrunt"

var words = commandLineParams()

if words.len == 0 or (words.len < 3 and words[0] == "-v"):
  echo("usage: hvox [-v voice] <sentence>")
  quit(QuitFailure)

var vox: Voice = nil

if words[0] == "-v":
  let vname = words[1]
  var fvox = loadVoice(vname)
  if fvox != nil:
    vox = fvox
  else:
    echo("could not find voice '", vname, "', using default")
  words = words[2 .. ^1]

words.expandSpecials()

if vox == nil:
  vox = loadVoice(DefaultVoice)
  if vox == nil:
    echo("could not load default voice ('", DefaultVoice, "')!")
    quit(QuitFailure)

vox.speak(words)
sleep(50)
