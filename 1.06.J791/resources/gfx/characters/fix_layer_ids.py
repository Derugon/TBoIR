import os
import xml.etree.ElementTree as ET
import glob

pngfiles = {}

for root, dirs, files in os.walk('.'):
    for file in files:
        if not file.endswith('.png'): continue
        f = os.path.join(root, file).lower()
        if f.startswith('.\\'):
            f = f[2:]
        file = os.path.basename(f)
        pngfiles[file] = f

for f in glob.glob('*.anm2'):
    tree = ET.parse(f)
    root = tree.getroot()
    modified = False
    ID = 0
    for layer in root.iter('Layer'):
        if int(layer.attrib['Id']) != ID:
            layer.attrib['Id'] = str(ID)
            
            modified = True
        ID += 1
    ID = 0
    for layer in root.iter('Spritesheet'):
        if int(layer.attrib['Id']) > ID:
            print('Spritesheet issue in %s!' % f)
        ID += 1
        
            
    if modified:
        print("writing %s" % f)
        tree.write(f)
