import os, ospaths, strutils, parseutils, tables, math
import sound, utils

type
  Voice* = ref object
    name*: string
    words: TableRef[string, Sound]

  WordParams = tuple
    pitch: float
    wait: int
    startTime: float
    endTime: float
    volume: float

proc loadVoice*(vname: string): Voice =
  let vpath = getVoiceDir(vname)
  if not existsDir(vpath):
    return nil
  if dirEmpty(vpath):
    return nil

  result = Voice(name: vname)
  result.words = newTable[string, Sound]()

  for kind, fpath in walkDir(vpath):
    if kind != pcFile and kind != pcLinkToFile:
      continue
    let snd = loadSound(fpath)
    if snd == nil: continue 
    let (_, fname, _) = splitFile(fpath)
    result.words[fname] = snd

proc readCtrlSeq(ctrl: string): WordParams =
  result.wait = 0
  result.pitch = 1.0
  result.startTime = 0.0
  result.endTime = 1.0
  result.volume = 1.0
  var tok = ""
  var i = 0
  var kind = 'z'
  while i < ctrl.len:
    kind = ctrl[i]
    if kind in {'p', 't', 's', 'e', 'v'}:
      i += 1
      i += ctrl.parseUntil(tok, Letters, i)
      if tok != "":
        case kind
        of 'p': result.pitch = parseFloat(tok) / 100.0
        of 't': result.wait = parseInt(tok)
        of 's': result.startTime = parseFloat(tok) / 100.0
        of 'e': result.endTime = parseFloat(tok) / 100.0
        of 'v': result.volume = parseFloat(tok) / 100.0
        else: discard
    else: i += 1

proc speak*(vox: Voice, words: openArray[string]) =
  var
    pitch = 1.0
    wait = 0
    startTime = 0.0
    endTime = 1.0
    volume = 1.0
    ctrl = ""

  for w in words:
    var word = w

    var punctWait = 0
    if word.endsWith('.'):
      punctWait = 200
      word = word[0 .. ^2]
    elif word.endsWith(','):
      punctWait = 100
      word = word[0 .. ^2]

    ctrl = ""
    if word.endsWith(')'):
      let pos = word.find('(')
      if pos == 0:
        ctrl = word[1 .. ^2]
        word = ""
      elif pos != -1:
        ctrl = word[pos .. ^2]
        word = word[0 .. pos-1]

    (pitch, wait, startTime, endTime, volume) = readCtrlSeq(ctrl)

    if word in vox.words:
      var snd = vox.words[word]
      snd.play(volume, pitch)
      sleep(round(snd.getDuration(pitch).float * endTime).int)
      snd.stop()

    sleep(wait + punctWait)
