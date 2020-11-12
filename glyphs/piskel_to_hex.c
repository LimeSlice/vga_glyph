/**
  * piskel_to_hex.c
  * 
  * Converts outputted piskel C-array from its uint32_t output to a hex file
  * that can be loaded into ROM for VGA glyph reading in Verilog.
  *
  * Output is formatted pixel by pixel. So one line in the outputted hex file
  * will be a single RGB pixel.
  * 
  * Output appends to "glyph.hex". This can be changed below
  *
  * Pre-requisites: 
  *     (1) adjust outputted piskel C file to header file: <filename>.h
  *             Ex. "mario.c" to "mario.h"
  *     (2) remove static keyword from data array to allow reading from header
  *             Ex. "static const uint32_t mario_data[21][544]" to
  *                 "const uint32_t mario_data[21][544]"
  *     (3) adjust data array name to just be data
  *             Ex. "const uint32_t mario_data[21][544]" to
  *                 "const uint32_t data[21][544]"
  *     (4) adjust define statement FRAME_COUNT to just be FRAME_COUNT
  *             Ex. mario_FRAME_COUNT to FRAME_COUNT
  *     (5) do the same with FRAME_WIDTH and FRAME_HEIGHT
  *
  * Author: Kris Wolff
  * Last Updated: 11/10/2020
  */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* change filename to match your adjusted piskel header file (see above) */
#include "mario.h"

/* change filename if you want something else */
#define FILENAME "glyphs.hex"

static uint8_t get_red(uint32_t pixel)
{
    return pixel >> 0;
}

static uint8_t get_green(uint32_t pixel)
{
    return pixel >> 8;
}

static uint8_t get_blue(uint32_t pixel)
{
    return pixel >> 16;
}

int main(void)
{
    FILE *fptr;
    time_t now;
    int i,j;
    uint8_t r, g, b;
    
    // obtain current time
    time(&now);

    // open hex file or create new one
    // so as not to delete past files 'a' appends to the file
    fptr = fopen(FILENAME, "wa");

    if (fptr == NULL) {
        printf("\r\nERROR!\r\n\r\n");
        exit(1);
    }

    printf("\r\nIterating sprites...");

    // print stats as comments at top of glyphs
    fprintf(fptr, "// Outputted data from piskel_to_hex.c\r\n");
    fprintf(fptr, "// Glyph width: %u\r\n", FRAME_WIDTH);
    fprintf(fptr, "// Glyph height: %u\r\n", FRAME_HEIGHT);

    // iterates through each sprite
    for (i=0; i<FRAME_COUNT; i++) {
        
	// print out for separation
	fprintf(fptr, "\n\n// glyph[%u] -- added %s\r\n\n",
		i, ctime(&now));

        // iterates though every pixel of sprite
        for (j=0; j<FRAME_WIDTH*FRAME_HEIGHT; j++) {
            r = get_red(data[i][j]);
            g = get_green(data[i][j]);
            b = get_blue(data[i][j]);
            fprintf(fptr, "%02x%02x%02x\r\n", r, g, b);
        }
    }

    printf("Done!\r\n\r\n");

    fclose(fptr);

    return 0;
}
