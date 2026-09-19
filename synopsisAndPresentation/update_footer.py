import zipfile
import xml.etree.ElementTree as ET
import os

DOCX_PATH = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/neeraj sharhroz (1).docx'
TEMP_PATH = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/neeraj sharhroz (1)_temp.docx'

w_ns = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
r_ns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
ET.register_namespace('w', w_ns)
ET.register_namespace('r', r_ns)

# 1. Read the original docx
zin = zipfile.ZipFile(DOCX_PATH, 'r')
file_contents = {}
for item in zin.infolist():
    file_contents[item.filename] = zin.read(item.filename)
zin.close()

# 2. Update word/footer1.xml (Section 0 footer: Preliminary pages - lowerRoman)
footer1_xml = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:p>
    <w:pPr>
      <w:jc w:val="right"/>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="20"/>
        <w:szCs w:val="20"/>
      </w:rPr>
    </w:pPr>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="20"/>
        <w:szCs w:val="20"/>
      </w:rPr>
      <w:fldChar w:fldCharType="begin"/>
      <w:instrText xml:space="preserve">PAGE</w:instrText>
      <w:fldChar w:fldCharType="separate"/>
      <w:fldChar w:fldCharType="end"/>
    </w:r>
  </w:p>
</w:ftr>"""

file_contents['word/footer1.xml'] = footer1_xml.encode('utf-8')

# 3. Update word/document.xml (Set fmt="lowerRoman" for Section 0, remove titlePg and set fmt="decimal" for Section 1)
doc_xml = file_contents['word/document.xml'].decode('utf-8')
tree = ET.fromstring(doc_xml)

sectPrs = tree.findall(f'.//{{{w_ns}}}sectPr')
print(f"Found {len(sectPrs)} sectPr elements in document.xml")

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
    print("Section 0: Set pgNumType fmt='lowerRoman', start='1'")

    # Section 1 (Main text onwards from Introduction)
    s1 = sectPrs[1]
    # Remove titlePg from Section 1 so page 1 of Introduction displays the page number
    titlePg1 = s1.find(f'{{{w_ns}}}titlePg')
    if titlePg1 is not None:
        s1.remove(titlePg1)
        print("Section 1: Removed titlePg so Introduction page 1 displays page number")

    pgNumType1 = s1.find(f'{{{w_ns}}}pgNumType')
    if pgNumType1 is not None:
        pgNumType1.set(f'{{{w_ns}}}fmt', 'decimal')
        pgNumType1.set(f'{{{w_ns}}}start', '1')
    else:
        pgNumType1 = ET.SubElement(s1, f'{{{w_ns}}}pgNumType')
        pgNumType1.set(f'{{{w_ns}}}fmt', 'decimal')
        pgNumType1.set(f'{{{w_ns}}}start', '1')
    print("Section 1: Set pgNumType fmt='decimal', start='1'")

# Serialize back
file_contents['word/document.xml'] = ET.tostring(tree, encoding='utf-8')

# 4. Write to temp file first, then overwrite original
zout = zipfile.ZipFile(TEMP_PATH, 'w', compression=zipfile.ZIP_DEFLATED)
for fname, data in file_contents.items():
    zout.writestr(fname, data)
zout.close()

# Replace original with temp
if os.path.exists(TEMP_PATH):
    os.replace(TEMP_PATH, DOCX_PATH)
    print("Successfully updated footer and page numbering in 'neeraj sharhroz (1).docx'!")
