
### Extracting just a segment

#### With the same video and audio quality:

1. If you want a specific part (e.g., 10:05 to 12:30):
    ```bash
    ffmpeg -ss 00:10:05 -to 00:12:30 -i input.mp4 -vn -acodec copy -vcodec copy part.mp4
    ```
2. If you want duration instead of end time:
    ```bash
    ffmpeg -ss 00:10:05 -t 30 -i input.mp4 -vn -acodec copy -vcodec copy part.mp4
    ```

#### Only audio stream

Use combinations of `-ss 00:10:05 -to 00:12:30` or `-ss 00:10:05 -t 30` together with 
a parameters choice, described in [extract audio from a video](extract.audio.from.video.md)