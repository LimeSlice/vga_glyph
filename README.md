# VGA Glyphs

This is a Quartus Prime project meant for an Altera Cyclone V FPGA board, tested with a Cyclone V 5CSEMA5F31C6. This project demonstrates how to display VGA glyphs stored in a VGA ROM based on information read from the block RAM of a processor, for example to change x and y coordinates of sprites.

If you simulate this program you should see the animation of a Mario character walking across the screen, then stopping and standing until ``reset``.

### Generating Glyphs ![Mario animation](https://raw.githubusercontent.com/LimeSlice/vga_glyph/main/glyphs/mario.gif)

See "glyphs" folder for my glyphs. I used [Piskel](https://piskelapp.com) in order to process a Mario sprite sheet that I found online. Piskel allows you to create your own glyphs by drawing, or import sprite sheets and size them to create multiple sprites at the same time. You can then use the export tool to export it into a C file (Export -> Others -> Download C file).

This however downloads the colors in a ``uint32_t`` format. This unfortunately doesn't match the RGB format that I desire. So I wrote a script (also found in the "glyphs" folder) that will rewrite the C file into a "glyphs.hex" file, where each line of the file is a single pixel. See file for further instructions of how to get this to work.


### VGA Verilog Structure

// TODO -- add image


### Cyclone V 5CSEMA5F31C6 pinouts

// TODO
