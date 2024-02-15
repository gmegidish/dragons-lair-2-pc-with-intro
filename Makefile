all: dl2intro.com

NASM=nasm

clean:
	rm -f dl2intro.com

video.bin:
	# temp, just so I don't forget
	mkdir -p raw-frames
	ffmpeg -i video/DragonsLair2Intro.gif -filter_complex "[0:v]split[x][z];[z]palettegen[y];[x]fifo[x];[x][y]paletteuse" raw-frames/%04d.raw
	python3 convert-frames-to-raw.py

dl2intro.com: dl2intro.asm video.bin
	$(NASM) -f bin -o $@ $<

run: dl2intro.com
	open -a dosbox-x --args "$(PWD)/$<" -exit
