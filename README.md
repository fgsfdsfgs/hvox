# hvox
A small program that emulates the sentence system from Half-Life.

## Building
### Requirements
* nim >= 0.17.0
* nimble >= 0.8.0
* libsdl2 >= 2.0.0
### Instructions
Run ```nimble build``` in the root directory.

## Usage
### Running
```hvox [-voice voice] [-volume x] [-pitch y] <sentence>```

```<sentence>``` consists of words separated by spaces, which can include special control sequences at the end of them:
* ```(tNUM)```: waits NUM milliseconds after this word;
* ```(pNUM)```: sets voice pitch to NUM for this word (100 is normal);
* ```(vNUM)```: sets voice volume to NUM for this word (100 is normal);
* ```(eNUM)```: ends this word after NUM% of it plays.

Control sequences can be combined, e. g. ```(p50v50)```, or used on their own, e. g. ```my! (t30) god!```, though in that case only t will have any effect.

Example:
```hvox clik(t30) my ass is(e90p110) heavy clik(p120) clik```

If `-voice` is not specified, hvox tries to load the "hgrunt" voice pack. You can copy it over from Half-Life (```valve/sound/hgrunt```).

`-volume` and `-pitch` act as global multipliers to the current volume and pitch values set by the `v` and `p` control sequences.

### Special words
`$time$` will insert the current time into the sentence at the word's position. Example: `time_is_now $time$ safe_day` would result in something like `time_is_now four twenty pm safe_day`.

`$brk$` removes any words after it. I don't even remember why I added it.

### Voice packs
Voice packs are stored either in ```~/.hvox/voices/``` (on \*nix) or in a ```voices``` directory beside the executable (on Windows).

A voice pack is a directory that contains sound files (WAV or OGG Vorbis) for each word that you wish to use. The directory must not contain anything else. See the ```valve/sound/hgrunt``` directory in your Half-Life distribution for an example.

## Credits
* [cmixer library](https://github.com/rxi/cmixer) and the [Nim](https://github.com/rxi/cmixer-nim) [headers](https://github.com/rxi/cmixer_sdl2-nim) by rxi (had to edit the headers a little to make it work on 0.17.2; not sure if it's a Nim bug or not, so no pull request yet);
* inspired by [Marphy Black's video](https://www.youtube.com/watch?v=YfoTP0Yyidk) on hgrunt voices.
