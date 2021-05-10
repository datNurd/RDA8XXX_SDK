/**
 * @file lv_png.c
 *
 */

/*********************
 *      INCLUDES
 *********************/

#include "lvgl.h"
#include "lv_png.h"
#include "lodepng.h"
#include <stdlib.h>
#include <stdio.h>

/*********************
 *      DEFINES
 *********************/

/**********************
 *      TYPEDEFS
 **********************/

/**********************
 *  STATIC PROTOTYPES
 **********************/
static lv_res_t decoder_info(struct _lv_img_decoder * decoder, const void * src, lv_img_header_t * header);
static lv_res_t decoder_open(lv_img_decoder_t * dec, lv_img_decoder_dsc_t * dsc);
static void decoder_close(lv_img_decoder_t * dec, lv_img_decoder_dsc_t * dsc);
static void convert_color_depth(uint8_t * img, uint32_t px_cnt);

/**********************
 *  STATIC VARIABLES
 **********************/

/**********************
 *      MACROS
 **********************/

/**********************
 *   GLOBAL FUNCTIONS
 **********************/

/**
 * Register the PNG decoder functions in LittlevGL
 */
void lv_png_init(void)
{
    lv_img_decoder_t * dec = lv_img_decoder_create();
    lv_img_decoder_set_info_cb(dec, decoder_info);
    lv_img_decoder_set_open_cb(dec, decoder_open);
    lv_img_decoder_set_close_cb(dec, decoder_close);
    
    Trace(1, "lv_png_inited!\n");
}

/**********************
 *   STATIC FUNCTIONS
 **********************/

/**
 * Get info about a PNG image
 * @param src can be file name or pointer to a C array
 * @param header store the info here
 * @return LV_RES_OK: no error; LV_RES_INV: can't get the info
 */
static lv_res_t decoder_info(struct _lv_img_decoder * decoder, const void * src, lv_img_header_t * header)
{
    (void) decoder; /*Unused*/
     lv_img_src_t src_type = lv_img_src_get_type(src);          /*Get the source type*/

     /*If it's a PNG file...*/
     if(src_type == LV_IMG_SRC_FILE) {
        Trace(1, "error this version of lv_lib_png not support png file!\n");
     }
     /*If it's a PNG file in a  C array...*/
     else if(src_type == LV_IMG_SRC_VARIABLE) {
         const lv_img_dsc_t * img_dsc = src;
         header->always_zero = 0;
         header->cf = img_dsc->header.cf;       /*Save the color format*/
         header->w = img_dsc->header.w;         /*Save the color width*/
         header->h = img_dsc->header.h;         /*Save the color height*/
         return LV_RES_OK;
     }

     return LV_RES_INV;         /*If didn't succeeded earlier then it's an error*/
}


/**
 * Open a PNG image and return the decided image
 * @param src can be file name or pointer to a C array
 * @param style style of the image object (unused now but certain formats might use it)
 * @return pointer to the decoded image or  `LV_IMG_DECODER_OPEN_FAIL` if failed
 */
static lv_res_t decoder_open(lv_img_decoder_t * decoder, lv_img_decoder_dsc_t * dsc)
{
    (void) decoder; /*Unused*/
    uint32_t error;                 /*For the return values of PNG decoder functions*/
    uint8_t * img_data = NULL;

    /*If it's a PNG file...*/
    if(dsc->src_type == LV_IMG_SRC_FILE) {
            Trace(1, "error this version of lv_lib_png not support png file!\n");
    }
    /*If it's a PNG file in a  C array...*/
    else if(dsc->src_type == LV_IMG_SRC_VARIABLE) {
        const lv_img_dsc_t * img_dsc = dsc->src;
        uint32_t png_width;             /*No used, just required by he decoder*/
        uint32_t png_height;            /*No used, just required by he decoder*/

        /*Decode the image in ARGB8888 */
        error = lodepng_decode32(&img_data, &png_width, &png_height, img_dsc->data, img_dsc->data_size);
        if(error) {
            Trace(1, "error %u: %s\n", error, lodepng_error_text(error));
            return LV_RES_INV;
        }

        /*Convert the image to the system's color depth*/
        convert_color_depth(img_data,  png_width * png_height);

        dsc->img_data = img_data;
        return LV_RES_OK;     /*Return with its pointer*/
    }

    return LV_RES_INV;    /*If not returned earlier then it failed*/
}

/**
 * Free the allocated resources
 */
static void decoder_close(lv_img_decoder_t * decoder, lv_img_decoder_dsc_t * dsc)
{
    (void) decoder; /*Unused*/
    if(dsc->img_data) lodepng_free((uint8_t *)dsc->img_data);
}

/**
 * If the display is not in 32 bit format (ARGB888) then covert the image to the current color depth
 * @param img the ARGB888 image
 * @param px_cnt number of pixels in `img`
 */
static void convert_color_depth(uint8_t * img, uint32_t px_cnt)
{
    lv_color32_t * img_argb = (lv_color32_t*)img;
    lv_color_t c;
    uint32_t i;
    for(i = 0; i < px_cnt; i++)
    {
        c = lv_color_make(img_argb[i].ch.blue, img_argb[i].ch.green, img_argb[i].ch.red);;
        img[i*3 + 2] = img_argb[i].ch.alpha;
        img[i*3 + 1] = c.full >> 8;
        img[i*3 + 0] = c.full & 0xFF;
    }
}
