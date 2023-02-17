all: dl2intro.com

NASM=nasm

clean:
	rm -f dl2intro.com

video-to-raw:
	# temp, just so I don't forget
	ffmpeg -i DragonsLair2Intro.gif -filter_complex "[0:v]split[x][z];[z]palettegen[y];[x]fifo[x];[x][y]paletteuse" raw-frames/%04d.raw

dl2intro.com: dl2intro.asm
	$(NASM) -f bin -o $@ $<

run: dl2intro.com
	open -a dosbox-x --args "$(PWD)/$<" -exit
