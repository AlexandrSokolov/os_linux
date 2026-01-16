
- [Extracting just a segment](#extracting-just-a-segment)
- [High‑quality extraction, smaller file](#highquality-extraction-smaller-file)
- [Best settings for speech (language learning)](#best-settings-for-speech-language-learning)
- [Recommended Best Practice for music](#recommended-best-practice-for-music)
- [Best quality for music](#best-quality-for-music)
- [All songs same loudness](#all-songs-same-loudness)
- [Low‑size extraction](#lowsize-extraction)
- [Extract without converting if the audio is already MP3](#extract-without-converting-if-the-audio-is-already-mp3)
- [Volume and loudness normalization](#volume-and-loudness-normalization)
- [Extremely quiet sources](#extremely-quiet-sources)
- [Increase all file volumes AFTER loudness normalization](#increase-all-file-volumes-after-loudness-normalization)
- [Batch extraction](#batch-extraction)
  
### Extracting just a segment

1. If you want a specific part (e.g., 10:05 to 12:30):
    ```bash
    ffmpeg -ss 00:10:05 -to 00:12:30 -i input.mp4 -vn -acodec libmp3lame -b:a 128k output.mp3
    ```
2. If you want duration instead of end time:
    ```bash
    ffmpeg -ss 00:10:05 -t 30 -i input.mp4 output.mp3
    ```

### High‑quality extraction, smaller file

```bash
ffmpeg -i input.mp4 -vn -acodec libmp3lame -b:a 192k output.mp3
```

- `-vn` → ignore video
- `-acodec libmp3lame` → use LAME MP3 encoder (best)
- `-b:a 192k` → high‑quality MP3 bitrate. 
- `192k` MP3 bitrate is excellent for speech, podcasts, learning material.

### Best settings for speech (language learning)

```bash
ffmpeg -i input.mp4 -vn -acodec libmp3lame -b:a 128k -ar 44100 -ac 1 -af loudnorm output.mp3
```

- `-vn` → ignore video
- `-acodec libmp3lame` → use LAME MP3 encoder (best)
- `-b:a 128k` → perfect bitrate for voice
- `-ac 1` → mono (saves space, keeps clarity) - mono voice recordings sound identical but are 50% smaller.
- `-ar 44100 Hz` → standard sample rate
- `-af loudnorm` loudness normalization - only for speech no a dynamic range, but not for music

### Recommended Best Practice for music

- Use [ReplayGain / EBU R128](#replaygain--ebu-r128)
- Don't try to apply [loudness normalization](#volume-and-loudness-normalization)
- Never try to apply [volume normalization](#volume-and-loudness-normalization)

### Best quality for music

This is better for music, but also fine for high‑quality speech:
```bash
ffmpeg -i input.mp4 -vn -codec:a libmp3lame -qscale:a 2 output.mp3
```
- `-vn` → ignore video
- `-acodec libmp3lame` → use LAME MP3 encoder (best)
- `-qscale:a` uses VBR (variable bitrate):
   - `0` = best possible
   - `2` = ~192–220 kbps VBR (excellent)
   - `5` = ~120 kbps (good)
- Don't use `-af loudnorm` loudness normalization for music. 
  Music must keep its contrast (quiet vs. loud parts), otherwise it becomes flat and lifeless.

### All songs same loudness

Goals:
- Align volume of all tracks
- Maintain their musical dynamic range
- Avoid compression and loudness war
- Make listening comfortable across your library


You cannot solve it with `ffmpeg`. 
Do NOT use `loudnorm` for a music collection.
You need to use `ReplayGain / EBU R128` gain tags.


ReplayGain and R128 are non-destructive loudness normalization systems.

They do NOT:
- modify audio samples
- compress dynamics
- overwrite original tracks


Instead, they:
- measure the track loudness
- write a loudness correction value (gain tag) into metadata
- your music player applies the correction during playback


This achieves:
- same perceived loudness across tracks
- full dynamic range preserved
- zero distortion
- zero quality loss

`ReplayGain` and `R128` are the industry standards for music normalization WITHOUT affecting dynamics.


On Linux use: `r128gain`
```bash
r128gain *.mp3
```
or for recursive folders:
```bash
r128gain -r .
```

Each music file gets tags like:
- `REPLAYGAIN_TRACK_GAIN`
- `REPLAYGAIN_ALBUM_GAIN`
- `R128_TRACK_GAIN`

This allows identical loudness during playback.


On Windows (best) use: `MusicBee` or `Foobar2000`. They are free tools with perfect `ReplayGain/R128` support.

### Low‑size extraction

```bash
ffmpeg -i input.mp4 -vn -acodec libmp3lame -b:a 64k -ar 22050 -ac 1 output.mp3
```
Useful for:

- big collections of study audio
- offline listening
- low‑bandwidth storage

But below 64k, voice gets robotic.

### Extract without converting if the audio is already MP3

Works only if the source is already MP3:
```bash
ffmpeg -i input.mp4 -vn -acodec copy output.mp3
```
- `-vn` → ignore video
- `-acodec copy` → copy audio without re‑encoding

To check the codec of your source:
```bash
ffmpeg -i input.mp4
```
Look for:
- `Audio: mp3` or
- `Audio: aac`
  Example:
```text
  Stream #0:1[0x2](und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 125 kb/s (default)
```

### Volume and loudness normalization

Note: Never apply both and prefer loudness normalization over low volume normalization!

1. Many videos have low volume. You can normalize:
    ```bash
    ffmpeg -i input.mp4 -af "volume=1.5" output.mp3
    ```
   - `-af "volume=1.5"` or
   - `-af "volume=5dB"`

   Useful when:
   - A video is simply too quiet.
   - You want to make speech louder.
   - You want a quick, simple fix.
   
   What it does:
   - It multiplies the amplitude of the entire audio signal.
   - It is literally “turn the volume up”.
   - It does not analyze the audio.
   - It does not prevent peaks from clipping.
   - It does not make different files consistent.

2. Or loudness normalization:
    
    Notes: 
    - Don't use it if the source contains music intended to have dynamic range.
      Music must keep its contrast (quiet vs. loud parts), otherwise it becomes flat and lifeless.
    - for professional audio mastering (e.g., podcast) use two‑pass to ensure perfect compliance with LUFS targets.
   
    ```bash
    ffmpeg -i input.mp4 -af loudnorm output.mp3
    ```
   What it does
   - It measures the perceived loudness of the audio (not just amplitude).
   - Uses the ITU‑R BS.1770 algorithm (industry standard).
   - Adjusts:
     - integrated loudness (LUFS)
     - true peak
     - loudness range
     - short‑term loudness

   Effects
   - The final audio sounds consistent in volume across devices. 
   - No clipping — true peak limiting is applied.
   - Different files become the same loudness (e.g. ‑16 LUFS).

   When to use it
   - For podcasts
   - For audio courses
   - For YouTube content
   - For mastering your language-learning audio
   - For making all your extracted MP3s equally loud

### Extremely quiet sources

You should never apply both loudness and volume normalizations!
But if sources are extremely quiet, it is the right option.

Apply those normalizations separately, but never as parameters of the single command:
Step 1: apply a small gain
```bash
-af "volume=2"
```
Step 2: apply `loudnorm`
```bash
-af loudnorm
```
But this should only be done carefully, usually manually after checking levels.

### Increase all file volumes AFTER loudness normalization

You want to increase all file volumes AFTER loudness normalization.

For example:
- You run `loudnorm` on 50 files (all now matched at ‑16 LUFS)
- But you want EVERYTHING to be a bit louder overall (e.g., because you listen outdoors)

Then you can apply:
```bash
-af "volume=1.2"
```
AFTER all `loudnorm` processing.

This keeps all files consistent relative to each other.

### Batch extraction

Extract MP3 from all videos in a folder:
```bash
for f in *.mp4; do ffmpeg -i "$f" -vn -acodec libmp3lame -b:a 128k "${f%.mp4}.mp3"; done
```