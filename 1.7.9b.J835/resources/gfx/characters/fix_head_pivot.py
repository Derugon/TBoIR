import os
import xml.etree.ElementTree as ET
import glob

# this is great
# but still, make a backup of all the anm2 files before you run it
player_head_pos = (0, -5)
player_head_size = (32, 32)
player_head_pivot = (16, 28)
for f in glob.glob('*.anm2'):
    tree = ET.parse(f)
    root = tree.getroot()
    for anim in root.iter('Animation'):
        if anim.attrib['Name'][:4] == 'Head':
            for frame in anim.findall('*/LayerAnimation/Frame'):
                pos = (int(float(frame.attrib['XPosition'])),
                       int(float(frame.attrib['YPosition'])))
                pivot = (int(float(frame.attrib['XPivot'])),
                         int(float(frame.attrib['YPivot'])))
                size = (int(frame.attrib['Width']),
                        int(frame.attrib['Height']))
                new_pivot = (player_head_pivot[0] + (size[0] - player_head_size[0]) // 2,
                             player_head_pivot[1] + (size[1] - player_head_size[1]) // 2)
                new_pos = (pos[0] + new_pivot[0] - pivot[0],
                           pos[1] + new_pivot[1] - pivot[1])
                frame.attrib['XPivot'] = str(new_pivot[0])
                frame.attrib['YPivot'] = str(new_pivot[1])
                frame.attrib['XPosition'] = str(new_pos[0])
                frame.attrib['YPosition'] = str(new_pos[1])
    tree.write(f)
