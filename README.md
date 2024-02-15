# Dragon's Lair II Timewarp PC with Intro

##### Context

In August of 2022, Indie Retro News ran this post: [Dragon's Lair II Time Warp: Amiga Intro Animation redone frame by frame in Personal Paint by Hache](https://www.indieretronews.com/2022/07/dragons-lair-ii-time-warp-amiga-intro.html)

I immediately emailed Hache about it, asking if I could get the original files so we can release a new version of the DOS game with his
intro. He was very excited and sent me the .gif file.

Hache is Hernán Beroldo, artist from Argentina. And his work made this possible. You can reach Hache at hacheberoldo at gmail dot com.

You can see how it runs on my facebook page: https://www.facebook.com/GilMegidish/posts/pfbid02AdpY4naXw5XuzqZefsShzKMNmEeTSYxN3Li7UN5KwL3k4A8WvuKFmgB8wxBEUKFCl

##### Getting started

Clone this repo, run `make` to build the .com file, and `make run` to launch it with dosbox-x on your mac.

##### Technical details

The code in this current state is:

1. Works only on emulators --- it would be TOO slow to load these frames uncompressed on a real hdd
2. The conversion was done from laserdisc, on a PAL Amiga. Original video is 320x256x32 (5 bitplanes). However, PC doesn't support this, so 320x240x256 (unchained mode-x) is the best next thing.
3. I decided to write this in assembly, just cause it's fun
4. It's implemented using mode-x, unchained 4 planes, 2 pages with page flipping. Single palette for entire animation.
5. No compression, no audio, no timing at the moment. Just added 6 vsyncs between frames.

##### Links

- Indie Retro New's post: https://www.indieretronews.com/2022/07/dragons-lair-ii-time-warp-amiga-intro.html
- David Brackeen's amazing explanation and code of mode-x: http://www.brackeen.com/vga/unchain.html

