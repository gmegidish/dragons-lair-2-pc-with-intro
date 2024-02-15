import os
import re
import sys
import argparse
import glob
import struct
from PIL import Image
from PIL import GifImagePlugin

output = open("video.bin", "wb")

files = glob.glob("raw-frames/*.raw")
files.sort()

f = open(files[0], "rb")
f.seek(-1024, 2)
pal = f.read(1024)

pal666 = ""
for i in range(256):
	pal666 += chr(pal[i*4+2] >> 2)
	pal666 += chr(pal[i*4+1] >> 2)
	pal666 += chr(pal[i*4+0] >> 2)

output.write(pal666.encode())

for file in files:

	f = open(file, "rb")
	raw = f.read(320*256)

	plane0 = bytearray()
	plane1 = bytearray()
	plane2 = bytearray()
	plane3 = bytearray()

	# we're skipping the first 8 lines, and ignoring the last 8 lines
	offset = 8*320 
	sz = 320*240//4
	for i in range(sz):
		plane0.append(raw[offset+0])
		plane1.append(raw[offset+1])
		plane2.append(raw[offset+2])
		plane3.append(raw[offset+3])
		offset += 4

	assert len(plane0) == 19200
	output.write(plane0)
	output.write(plane1)
	output.write(plane2)
	output.write(plane3)

