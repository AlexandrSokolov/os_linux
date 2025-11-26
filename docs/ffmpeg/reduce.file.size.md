
- [Get information about media file](#get-information-about-media-file)
- [Reduce file using CRF](#reduce-file-using-crf)
- [Process multiple files in parallel in background](#process-multiple-files-in-parallel-in-background)
- [Encoder speed/efficiency with `-preset` option](#encoder-speedefficiency-with--preset-option)
- [Reduce bit rate to explicit value](#reduce-bit-rate-to-explicit-value)
- [Recommended Bitrate Ranges (H.264)](#recommended-bitrate-ranges-h264)
- [Explicit Bitrate (-b:v) vs CRF (-crf)](#explicit-bitrate--bv-vs-crf--crf)

### Get information about media file

Common Details You Can Extract
1. Duration: duration
2. Codec: codec_name
3. Resolution: width, height
4. Bitrate: bit_rate
5. Frame rate: r_frame_rate
6. Audio sample rate: sample_rate

#### Basic Command
```bash
ffprobe file.mp4
```
Output (most important data):
```
Duration: 00:01:00.63, start: 0.000000, bitrate: 8421 kb/s
Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, unknown/reserved/reserved, progressive), 1920x1020 [SAR 1:1 DAR 32:17], 8226 kb/s, 30 fps, 30 tbr, 30k tbn (default)
Stream #0:1[0x2](und): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 192 kb/s (default)
```
#### Detailed Information
```bash
ffprobe -v error -show_format -show_streams file.mp4
```
Output (most important data):
```
[STREAM]
index=0
codec_name=h264
codec_long_name=H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10
codec_type=video
codec_tag_string=avc1
codec_tag=0x31637661
width=1920
height=1020
bit_rate=8226724

[STREAM]
index=1
codec_name=aac
codec_long_name=AAC (Advanced Audio Coding)
profile=LC
codec_type=audio
codec_tag_string=mp4a
codec_tag=0x6134706d
channel_layout=stereo
bit_rate=192000
```

### Reduce file using CRF

Reduce file using CRF (Constant Rate Factor) - Better Quality Control - instead of fixed bitrate.

What it does: Controls quality, not size. `FFmpeg` adjusts bitrate dynamically based on scene complexity.
Range: 0–51 (lower = better quality, larger file)

- 18–23 - visually lossless for most content
- 28+ - lower quality, smaller file

Pros:
- Consistent visual quality across the video
- Efficient: uses more bits for complex scenes, fewer for simple ones
  Cons:
- File size is unpredictable (depends on content)

Command:
```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 28 -preset slow -c:a copy output.mp4
```
- Lower CRF - higher quality (and bigger file)
- Typical range: 18–28 (`-crf 23` - to keep a quality good, `-crf 24` - to reduce file size more)
- `-c:v libx264` - re-encode video using H.264 (you can use libx265 for HEVC)
- `-c:a copy` - copy audio stream without re-encoding
- [`-preset slow`](#encoder-speedefficiency-with--preset-option)

### Process multiple files in parallel in background

```bash
nohup parallel -j 4 ffmpeg -i {} -c:v libx264 -crf 23 -preset slow -c:a copy {.}_compressed.mp4 ::: *.mp4 > ffmpeg.log 2>&1 &
```
- `nohup ${command} > ffmpeg.log 2>&1 &` - run `${command}` in background, logs into `ffmpeg.log`
- `parallel` runs jobs in parallel
- `-j` (e.g., `-j 4` for 4 parallel jobs) - to control concurrency
- `{}` = placeholder for the input file.
- `{.}` = filename without extension.
- `::: *.mp4` = list of files to process.

Check results:
```bash
tail -f ffmpeg.log
ps aux | grep ffmpeg
```

Install, if needed:
```bash
sudo apt-get install parallel
```

### Encoder speed/efficiency with `-preset` option

This is an **encoder speed/efficiency** setting for `libx264` (or `libx265`).
It affects **encoding speed vs compression efficiency**, not quality directly.
Common presets:
- `ultrafast` → fastest, largest files
- `medium` → balanced (default)
- `slow` → smaller files, better compression, but slower

So `-preset medium` is about how long `FFmpeg` spends optimizing compression.

### Reduce bit rate to explicit value

What it does: Forces the encoder to use a constant average bitrate (e.g., 1000 kbps).
Pros:
- Predictable file size
- Useful for streaming where bandwidth is fixed
Cons:
- Wastes bits on simple scenes
- May under-allocate bits for complex scenes → worse quality


To reduce the bitrate of a video stream while keeping all other properties 
(resolution, codec, frame rate, audio, etc.), you can use `FFmpeg` with the `-b:v` option 
and copy other streams unchanged:

```bash
ffmpeg -i input.mp4 -c:v libx264 -b:v 1000k -c:a copy output.mp4
```
- `-c:v libx264` - re-encode video using H.264 (you can use libx265 for HEVC)
- `-b:v 1000k` - set video bitrate to `1000 kbps`
- `-c:a copy` - copy audio stream without re-encoding

Two-Pass Encoding for Better Quality:
```bash
ffmpeg -y -i input.mp4 -c:v libx264 -b:v 1000k -pass 1 -an -f mp4 /dev/null && \
  ffmpeg -i input.mp4 -c:v libx264 -b:v 1000k -pass 2 -c:a copy output.mp4
```

### Recommended Bitrate Ranges (H.264)

| **Resolution**  | **Bitrate Range**    |
|-----------------|----------------------|
| 480p (SD)       | 1,000 – 2,500 kbps   |
| 720p (HD)       | 2,500 – 5,000 kbps   |
| 1080p (Full HD) | 4,000 – 8,000 kbps   |
| 1440p (2K)      | 8,000 – 16,000 kbps  |
| 2160p (4K UHD)  | 20,000 – 45,000 kbps |

- Lower end = acceptable for streaming or small screens.
- Higher end = better quality for complex scenes or high motion.
- For high frame rates (60fps), add ~30–50% more bitrate.
- For HEVC (H.265), you can reduce these values by ~30–50% for similar quality.

### Explicit Bitrate (-b:v) vs CRF (-crf)

| **Aspect**            | **Explicit Bitrate (-b:v)**                           | **CRF (-crf)**                                       |
|-----------------------|-------------------------------------------------------|------------------------------------------------------|
| **Control**           | You set a fixed bitrate (e.g., `2000k`).              | You set a quality level (e.g., `-crf 23`).           |
| **File Size**         | Predictable (depends on bitrate and duration).        | Variable (depends on complexity of video).           |
| **Quality**           | Can degrade if bitrate is too low for complex scenes. | Adaptive: better quality for same size in most cases |
| **Efficiency**        | Less efficient; wastes bits on simple scenes.         | More efficient; allocates bits dynamically.          |
| **Use Case**          | When you need strict size control (e.g., streaming).  | When you want best quality for given size.           |
| **Recommended Range** | Choose bitrate based on resolution & fps.             | CRF 18–28 (lower = better quality, larger file).     |
