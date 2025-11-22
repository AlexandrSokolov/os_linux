
### Rotate and re-encode with High Quality

```bash
ffmpeg -i input.mp4 -vf "transpose=2" -c:v libx264 -crf 23 -preset slow -c:a copy output.mp4
```
- `-crf 23` - visually lossless quality (lower CRF - for instance 18 = better quality).
- `-preset slow` - better compression efficiency
- `-c:a copy` - keep original audio

### Transpose Values for `FFmpeg` Rotation

| Value | Rotation Description                 |
|-------|--------------------------------------|
| 0     | 90° counterclockwise + vertical flip |
| 1     | 90° clockwise                        |
| 2     | 90° counterclockwise                 |
| 3     | 90° clockwise + vertical flip        |

Rotate 180°: `-vf "transpose=2,transpose=2"`
