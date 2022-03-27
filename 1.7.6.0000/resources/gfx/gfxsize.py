import os, os.path
import sys
import re
from PIL import Image
import xml.etree.ElementTree as ET
import math

def next_power_2(v):
    return math.pow(2, math.ceil(math.log(v) / math.log(2)))

maxlayers = (0, '')
maxanimlayers = (0, '')
maxframes = (0, '')
maxanims = (0, '')
maxevents = (0, '')

for path, dirs, files, in os.walk('.'):
    for f in filter(lambda fn: fn.endswith('.anm2'), files):
        print('Parse %s' % f)
        tree = ET.parse(path + '/' + f)
        root = tree.getroot()
        layers = root.findall('.//Layer')
        anims = root.findall('.//Animation')
        for a in anims:
            num_frames = int(a.attrib['FrameNum'])
            if num_frames > maxframes[0]:
                maxframes = (num_frames, f)
            num_layers = len(a.findall('.//LayerAnimation'))
            if num_layers > maxanimlayers[0]:
                maxanimlayers = (num_layers, f)
        if len(anims) > maxanims[0]:
            maxanims = (len(anims), f)
        if len(layers) > maxlayers[0]:
            maxlayers = (len(layers), f)
        events = root.findall('.//Event')
        if len(events) > maxevents[0]:
            maxevents = (len(events), f)

num_files = 0
num_pixels = 0
for path, dirs, files in os.walk('.'):
    for f in filter(lambda fn: fn.endswith('.png'), files):
        if f.startswith('%'): continue
        png = Image.open(path + '/' + f)
        num_files += 1
        w = next_power_2(png.size[0])
        h = next_power_2(png.size[1])
        num_pixels += w * h
        print('Image %s: %d kilobytes' % (f, w * h * 4 / 1024))

num_bytes = num_pixels * 4
print(num_files, "images")
print(num_pixels, "pixels")
print(num_bytes / 1000000, "megabytes")
print()
print(maxlayers, "max. layers per anm2")
print(maxanimlayers, "max. anim layers per animation")
print(maxframes, "max. frames per animation")
print(maxanims, "max. animations per anm2")
print(maxevents, "max. events per anm2")
