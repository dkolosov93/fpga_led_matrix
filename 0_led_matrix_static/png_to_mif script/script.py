import sys
import os
from PIL import Image
import PIL.ImageOps    
import argparse

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--input", default="input.png",
	help="input file")
ap.add_argument("-o", "--output", default="image.mif",
	help="output mif file")
args = vars(ap.parse_args())



## header
header = """
DEPTH =  """

header_2 = """;
WIDTH = 24;
ADDRESS_RADIX = UNS;
DATA_RADIX = HEX;
CONTENT BEGIN\n"""

input_filename = args["input"]
output_filename = args["output"]
f = open(output_filename, 'w');     

f.write(header)         
f.write(str(32*32))       
f.write(header_2)       
index = 0;
#####################################



 
print(" ")
print(" ")
print("Processing: {}".format(input_filename))
im = Image.open(input_filename)


# if jpg, convert to png
if input_filename.endswith('.jpg') or input_filename.endswith('.jpeg'):
	a,b = os.path.splitext(input_filename)
	converted_png=a+'.png'
	im.save(converted_png)
	im = Image.open(converted_png)
	print("> Input image converted to png")

print("> Input image size: {}".format(im.size))            
w = im.size[0]
h = im.size[1]

## resize if needed
if w > 32 or h > 32:
	print("> Resizing Image to 32x32 ")            	
	basewidth = 32
	wpercent = (basewidth/float(im.size[0]))
	hsize = int((float(im.size[1])*float(wpercent)))
	im = im.resize((basewidth,hsize), Image.ANTIALIAS)
	im = im.resize( (32,32) )
	im = im.convert('RGB')
	#im.save("test.png")
	#im = PIL.ImageOps.invert(im)

	w = im.size[0]
	h = im.size[1]

	print("> Done resizing to {}x{}".format(w,h))         	


#write to mif file
for y in range(0, h):           
	for x in range(0, w):
		r = im.getpixel((x,y))[0]
		g = im.getpixel((x,y))[1]
		b = im.getpixel((x,y))[2]
		#print hex(r), hex(g), hex(b)
		total = r << 16 | g << 8 | b 
		hexa = hex(total).upper()
		#print hexa
        
		if (total == 0):
			hexa = "0x000000"
		f.write('%d\t:' %index)
		f.write("\t"+hexa[2:]+";\n")
		index = index + 1
f.write("END;")


print(" ")
print("[INFO] Writing to file: "+ output_filename)
print("[INFO] Total size: {} Bytes".format(index))
print("[INFO] Done");


