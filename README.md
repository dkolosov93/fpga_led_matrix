# FPGA Driven LED Matrix
MAX1000 driving a 32x32 LED Matrix Display

Simple VHDL based project using MAX10 FPGA to drive a 32x32 LED matrix display. 
Images are converted to the appropriate format through Python scripts as mif files.
These file are instantiated by 2-port ROM blocks inside the FPGA and can hold up to 7 (32x32) frames per ROM block.
Using a state machine, those images are displayed on the LED matrix.

![Screenshot](https://github.com/dkolosov93/led_matrix/blob/main/images/pic1.jpg)


# Prerequisites
The following hardware/software was used for this project, but it is simple enough to be ported to other FPGAs with some tweaks:
- [MAX1000](https://shop.trenz-electronic.de/en/TEI0001-03-08-C8-MAX1000-IoT-Maker-Board-8KLE-8-MByte-RAM)
- MicroUSB cable
- [LED Matrix Display](https://thepihut.com/products/32x32-rgb-led-matrix-panel-6mm-pitch?variant=27739411729&currency=GBP&utm_medium=product_sync&utm_source=google&utm_content=sag_organic&utm_campaign=sag_organic&gclid=Cj0KCQjw2NyFBhDoARIsAMtHtZ4h8AMRyu3QsWzDIOZZgLt8Mgkuh4T4Zq-TJBWLvsIAP4Rvqo-6qPYaAts3EALw_wcB). Check the power supply connector as it may differ. In this setup the below power supply cabling / parts were used.
- [LED Matrix Power supply](https://www.mouser.co.uk/ProductDetail/MEAN-WELL/GS18A03-P1J?qs=9v8X2fPoQt7hYq3Z7%2Fgqlw%3D%3D)
- [2.1mm terminal block adapter](https://thepihut.com/products/female-dc-power-adapter-2-1mm-jack-to-screw-terminal-block) for connecting power supply to LED Matrix 
- Quartus Prime Lite v20.1
- Ubuntu 18.04.1 LTS
- Python v3.8.5
- Pillow

## 0_led_matrix_static
This version of the project displays one static image.
By using the [python script](https://github.com/dkolosov93/led_matrix/tree/main/0_led_matrix_static/png_to_mif%20script), it can convert any jpg,jpeg or png image into a 32x32 image and create a mif file instantiates the contents of a ROM block.

python script.py --input [input image name] --output [output mif name]

 <!--
## 1_led_matrix_animated
This version of the project can display multiple frames, in animated fashion.
GIFs are ideal for this. First it is required to split a GIF into multiple images with [python script] (a) 
Then, by running [python script2], up to 7 frames can be converted and stored in a mif file. Limitations is by internal ROM block.
Future work could store data in external memory.
-->




