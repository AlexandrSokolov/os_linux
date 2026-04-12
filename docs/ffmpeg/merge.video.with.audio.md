
Handle all files pairs, where:
- video file has `.mp4` extension
- audio file with the same name exists and has `m4a` extension
- save result `_merged` suffix:

```bash
$ for v in *.mp4; do a="${v%.mp4}.m4a"; [ -f "$a" ] && ffmpeg -i "$v" -i "$a" -c copy -map 0:v:0 -map 1:a:0 "${v%.mp4}_merged.mp4"; done
```