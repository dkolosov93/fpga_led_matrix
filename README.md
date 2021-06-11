# LED Matrix
MAX1000 driving a 32x32 LED Matrix Display

Simple project using MAX10 FPGA to drive a 32x32 LED matrix display. 
Images are converted to the appropriate format through Python scripts as mif files.
These file are instantiated by 2-port ROM blocks inside the FPGA and can hold up to 64 (32x32) frames per block.
Using a state machine, those images are display on the LED matrix.


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


