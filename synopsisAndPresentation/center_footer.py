import zipfile
import os

def center_footers_in_docx(file_path):
    zin = zipfile.ZipFile(file_path, 'r')
    file_contents = {}
    for item in zin.infolist():
        file_contents[item.filename] = zin.read(item.filename)
    zin.close()

    # In footer1.xml: replace right alignment with center
    if 'word/footer1.xml' in file_contents:
        xml1 = file_contents['word/footer1.xml'].decode('utf-8')
        xml1 = xml1.replace('<w:jc w:val="right"/>', '<w:jc w:val="center"/>')
        file_contents['word/footer1.xml'] = xml1.encode('utf-8')

    # In footer2.xml: replace right alignment with center
    if 'word/footer2.xml' in file_contents:
        xml2 = file_contents['word/footer2.xml'].decode('utf-8')
        xml2 = xml2.replace('<w:jc w:val="right"/>', '<w:jc w:val="center"/>')
        file_contents['word/footer2.xml'] = xml2.encode('utf-8')

    temp_path = file_path + '.temp'
    zout = zipfile.ZipFile(temp_path, 'w', compression=zipfile.ZIP_DEFLATED)
    for fname, data in file_contents.items():
        zout.writestr(fname, data)
    zout.close()

    os.replace(temp_path, file_path)
    print(f"Successfully centered page numbers in {os.path.basename(file_path)}!")

f1 = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/neeraj sharhroz (1).docx'
f2 = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/neerajshahroz1.docx'

center_footers_in_docx(f1)
center_footers_in_docx(f2)
