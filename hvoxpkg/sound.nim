import os, ospaths, math
import cmixer/cmixer_sdl2
import utils

type
  Sound* = ref object
    name*: string
    chunk: Source
    duration: int
    chan: cuint

proc loadSound*(fname: string): Sound =
  if not existsFile(fname):
    return nil

  let (_, sname, _) = splitFile(fname)
  result = Sound(name: sname)

  try:
    result.chunk = newSourceFromFile(fname)
  except:
    echo("could not load ", fname)
    return nil

  result.duration = round(result.chunk.getLength() * 1000.0).int

proc getDuration*(sound: Sound, pitch: float = -1.0): int =
  if sound == nil: return 0
  if pitch > 0.0:
    result = (sound.duration.float * (1.0 / pitch)).int
  else:
    result = sound.duration

proc isPlaying*(sound: Sound): bool =
  if sound == nil or sound.chunk == nil: return false
  result = sound.chunk.getState() == STATE_PLAYING

proc stop*(sound: Sound) =
  if sound == nil or sound.chunk == nil: return
  sound.chunk.stop()

proc play*(sound: Sound, volume: float = 1.0, pitch: float = 1.0) =
  # TODO: start time/end time
  if sound == nil: return
  if sound.chunk == nil: return
  sound.chunk.setPitch(pitch.cdouble)
  sound.chunk.setGain(volume.cdouble)
  sound.chunk.play()

cmixer_sdl2.init(44100, 1024)
