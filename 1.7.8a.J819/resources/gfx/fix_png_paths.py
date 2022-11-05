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
    for spritesheet in root.iter('Spritesheet'):
        path = spritesheet.attrib['Path']
            
        if os.path.exists(path):
            pass
            #print("found: %s" % path)
        else:
            file = os.path.basename(path.lower())
            if file in pngfiles:
                modified = True
                newpath = pngfiles[file]
                print("correct: %s -> %s" % (path, newpath))
                spritesheet.attrib['Path'] = newpath
            else:
                print("%s - not found: %s" % (f, path))
    if modified:
        print("writing %s" % f)
        tree.write(f)
