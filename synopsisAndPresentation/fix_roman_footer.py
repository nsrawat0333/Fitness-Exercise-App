import zipfile
import xml.etree.ElementTree as ET
import os
import shutil

w_ns = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
r_ns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
ET.register_namespace('w', w_ns)
ET.register_namespace('r', r_ns)

BASE = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation'
SOURCE_DOCX = os.path.join(BASE, 'neeraj sharhroz (1)_backup.docx')
TARGET_NEW = os.path.join(BASE, 'neeraj_shahroz_final_roman.docx')

# 1. Read the original clean backup docx
zin = zipfile.ZipFile(SOURCE_DOCX, 'r')
file_contents = {}
for item in zin.infolist():
    file_contents[item.filename] = zin.read(item.filename)
zin.close()

# 2. Craft footer1.xml (Preliminary Pages: Certificate up to Introduction in centered Roman numerals)
# Using explicit 'PAGE \* roman' switch AND cached '<w:t>ii</w:t>' so it displays immediately in Word
footer1_xml = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:p>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
    </w:pPr>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="begin"/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:instrText xml:space="preserve">PAGE \\* roman</w:instrText>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="separate"/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:t>ii</w:t>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="end"/>
    </w:r>
  </w:p>
</w:ftr>"""

file_contents['word/footer1.xml'] = footer1_xml.encode('utf-8')

# 3. Craft footer2.xml (Main Content: Introduction onwards in centered Arabic numerals 1, 2, 3...)
footer2_xml = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:p>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
    </w:pPr>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="begin"/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:instrText xml:space="preserve">PAGE</w:instrText>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="separate"/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:t>1</w:t>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="24"/>
        <w:szCs w:val="24"/>
      </w:rPr>
      <w:fldChar w:fldCharType="end"/>
    </w:r>
  </w:p>
</w:ftr>"""

file_contents['word/footer2.xml'] = footer2_xml.encode('utf-8')

# 4. Update word/settings.xml to enable updateFields on document open
settings_xml = file_contents['word/settings.xml'].decode('utf-8')
if 'updateFields' not in settings_xml:
    settings_tree = ET.fromstring(settings_xml)
    upd = ET.SubElement(settings_tree, f'{{{w_ns}}}updateFields')
    upd.set(f'{{{w_ns}}}val', 'true')
    file_contents['word/settings.xml'] = ET.tostring(settings_tree, encoding='utf-8')
    print("Added updateFields=true to word/settings.xml")

# 5. Update word/document.xml for Section 0 (lowerRoman) and Section 1 (decimal, no titlePg)
doc_xml = file_contents['word/document.xml'].decode('utf-8')
tree = ET.fromstring(doc_xml)
sectPrs = tree.findall(f'.//{{{w_ns}}}sectPr')

if len(sectPrs) >= 2:
    # Section 0
    s0 = sectPrs[0]
    pgNumType0 = s0.find(f'{{{w_ns}}}pgNumType')
    if pgNumType0 is not None:
        pgNumType0.set(f'{{{w_ns}}}fmt', 'lowerRoman')
        pgNumType0.set(f'{{{w_ns}}}start', '1')
    else:
        pgNumType0 = ET.SubElement(s0, f'{{{w_ns}}}pgNumType')
        pgNumType0.set(f'{{{w_ns}}}fmt', 'lowerRoman')
        pgNumType0.set(f'{{{w_ns}}}start', '1')

    # Section 1 (Introduction onwards)
    s1 = sectPrs[1]
    titlePg1 = s1.find(f'{{{w_ns}}}titlePg')
    if titlePg1 is not None:
        s1.remove(titlePg1)
        
    pgNumType1 = s1.find(f'{{{w_ns}}}pgNumType')
    if pgNumType1 is not None:
        pgNumType1.set(f'{{{w_ns}}}fmt', 'decimal')
        pgNumType1.set(f'{{{w_ns}}}start', '1')
    else:
        pgNumType1 = ET.SubElement(s1, f'{{{w_ns}}}pgNumType')
        pgNumType1.set(f'{{{w_ns}}}fmt', 'decimal')
        pgNumType1.set(f'{{{w_ns}}}start', '1')

file_contents['word/document.xml'] = ET.tostring(tree, encoding='utf-8')

# 6. Save to TARGET_NEW (neeraj_shahroz_final_roman.docx)
zout = zipfile.ZipFile(TARGET_NEW, 'w', compression=zipfile.ZIP_DEFLATED)
for fname, data in file_contents.items():
    zout.writestr(fname, data)
zout.close()
print(f"Created: {TARGET_NEW}")

# Also copy to 'neeraj sharhroz (1).docx' and 'neerajshahroz1.docx'
for dest_name in ['neeraj sharhroz (1).docx', 'neerajshahroz1.docx', 'neerajshahroz1_centered.docx']:
    dest_path = os.path.join(BASE, dest_name)
    try:
        shutil.copy2(TARGET_NEW, dest_path)
        print(f"Updated: {dest_name}")
    except Exception as e:
        print(f"Could not update {dest_name}: {e}")
