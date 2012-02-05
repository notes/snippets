import xml.dom.minidom as x
dom = x.parse("file.xml")
for n in dom.documentElement.childNodes:
  if n.nodeType == n.NODE_ELEMENT:
    if n.hasChildNodes():
      for nn in n.childNodes:
        ...
    else:
      print("empty node")

