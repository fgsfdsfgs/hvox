import os, ospaths

when defined(windows):
  let rootPath = getAppDir()
else:
  let rootPath = "~/.hvox"

let voicePath = rootPath / "voices"

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
