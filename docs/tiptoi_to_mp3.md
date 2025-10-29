
## Convert Ravensburger `tiptoi` audio files to `mp3`

1. Install `tip-toi-reveng` tool

    This tool helps to convert Ravensburger TipToi files into mp3.
    - [`tip-toi-reveng` GitHub project](https://github.com/entropia/tip-toi-reveng/tree/master)
    - [`tip-toi-reveng` available releases](https://github.com/entropia/tip-toi-reveng/releases)
    
    Download the last version of [`tttool-x.x.zip`](https://github.com/entropia/tip-toi-reveng/releases/download/1.11/tttool-1.11.zip) 
    file. In our case it is `tttool-1.11.zip`.
    
    Extract zip. You must get `tttool` binary file in the folder with extracted files:
    ```bash
    $ ls -lh
    -r-xr-xr-x 1 alex alex   380 Jan  1  1970 tttool
    ```
    
    Linux users likely want to install additional packages. On Debian or Ubuntu, run:
    ```bash
    sudo apt install libttspico-utils vorbis-tools
    ```
2. Find original `.gme` audio files

   - [tiptoi® Audiodateien](https://service.ravensburger.de/tiptoi%C2%AE/tiptoi%C2%AE_Audiodateien)
   - [Audiodateien tiptoi Bücher](https://service.ravensburger.de/tiptoi%C2%AE/tiptoi%C2%AE_Audiodateien/Audiodateien_tiptoi%C2%AE_B%C3%BCcher)
   
   For instance for this tutorial we download original `gme` audio for [_Mein Wörter-Bilderbuch Kindergarten_](https://service.ravensburger.de/tiptoi%C2%AE/tiptoi%C2%AE_Audiodateien/Audiodateien_tiptoi%C2%AE_B%C3%BCcher/tiptoi%C2%AE_Mein_W%C3%B6rter-Bilderbuch_Kindergarten_55477_und_49267)
   book. 
  
   `Mein_Woerter_Bilderbuch_Kindergarten_RL.gme` file was downloaded.

3. Extract from `.gme` file multiple `.ogg` files:

    ```bash
    ./tttool-1.11/tttool media Mein_Woerter_Bilderbuch_Kindergarten_RL.gme
    ```
    `media` - it is target folder, where all `.ogg` files get extracted. You could use any target folder name.

4. Convert `.ogg` files into `mp3`

    ```bash
    for i in *.ogg; do ffmpeg -i "$i" "${i%.*}.mp3"; done
    ```
   For very big files you might use `parallel`:
    ```bash
    parallel ffmpeg -i "{}" "{.}.mp3" ::: *.ogg
    ```
   [How can I convert audio from ogg to mp3?](https://askubuntu.com/questions/442997/how-can-i-convert-audio-from-ogg-to-mp3)

5. Move all `mp.3` files into `mp3` folder:
    ```bash
    mkdir mp3
    mv *.mp3 mp3/
    ```
6. Convert mp3 into text

    You could use [TurboScribe](https://turboscribe.ai/) **in browser incognito mode**. 
    
    Click on _Try TurboScribe for Free_ and upload the file.