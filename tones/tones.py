#!/usr/bin/env python3

import math
import struct
import sys

i16 = struct.Struct('<h')
i32 = struct.Struct('<l')

S = 10 # Seconds
L = (220, 264, 330, 396) # Amin7
R = (264, 330, 396, 495) # Cmaj7

def main():
  raw = b''.join(collect(sample(L), sample(R)))
  with open('tones.wav', 'wb') as f:
    for bs in wave_file(raw):
      f.write(bs)
  with open('tones.hex', 'wb') as f:
    for bs in hex_file(raw[:4*48000]):
      f.write(bs)

def sample(fs):
  for t in range(S*48000):
    yield sum(math.sin(math.tau * t/48000 * f) for f in fs)

def collect(ls, rs):
  for l, r in zip(ls, rs):
    yield i16.pack(int(l*0x800))
    yield i16.pack(int(r*0x800))

def wave_file(raw):
  # WAVE header
  yield b'RIFF'
  yield i32.pack(len(raw)+36)
  yield b'WAVE'

  # WAVE format
  yield b'fmt '
  yield i32.pack(16)
  yield i16.pack(1)      # sample format
  yield i16.pack(2)      # channels
  yield i32.pack(48000)  # sample rate
  yield i32.pack(192000) # byte rate
  yield i16.pack(4)      # bytes per sample
  yield i16.pack(16)     # bits per channel

  # WAVE data
  yield b'data'
  yield i32.pack(len(raw))
  yield raw

def hex_file(raw):
  # Eight samples per line
  for i in range(0, len(raw), 32):
    bs = bytes(hex_record(i>>2, raw[i:i+32]))
    cs = -sum(bs) & 0xff
    yield f':{bs.hex()}{cs:02x}\n'.encode()

  # End of file
  yield b':00000001FF\n'

def hex_record(addr, data):
  yield len(data)   # byte count
  yield addr >> 8   # address MSB
  yield addr & 0xff # address LSB
  yield 0           # record type
  yield from data

if __name__ == '__main__':
  sys.exit(main())
