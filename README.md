# LED Matrix
MAX1000 driving a 32x32 LED Matrix Display

Simple project using MAX10 FPGA to drive a 32x32 LED matrix display. 
Images are converted to the appropriate format through Python scripts as mif files.
These file are instantiated by 2-port ROM blocks inside the FPGA and can hold up to 64 (32x32) frames per block.
Using a state machine, those images are display on the LED matrix.

