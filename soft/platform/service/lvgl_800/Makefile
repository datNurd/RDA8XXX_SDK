
## ----------------------------------------------------------- ##
## Don't touch the next line unless you know what you're doing.##
## ----------------------------------------------------------- ##
include ${SOFT_WORKDIR}/env/compilation/compilevars.mk

# Name of the module
LOCAL_NAME := ${PLATFORM_SERVICE}/lvgl_800

# list all modules APIs that are necessary to compile this module
LOCAL_API_DEPENDS := \
	platform \
	platform/chip/hal \
	platform/base/common \
	platform/chip/defs \
	${PLATFORM_SYSTEM}/stack \
	${PLATFORM_SERVICE}

# list all the modules that need to be compiled prior to using this module
LOCAL_MODULE_DEPENDS := 

## ------------------------------------ ##
## 	Add your custom flags here          ##
## ------------------------------------ ##

LOCAL_EXPORT_FLAG += 

## ------------------------------------- ##
##	List all your sources here           ##
## ------------------------------------- ##

# Core source files
C_SRC += core/src/lv_disp.c
C_SRC += core/src/lv_event.c
C_SRC += core/src/lv_group.c
C_SRC += core/src/lv_indev_scroll.c
C_SRC += core/src/lv_indev.c
C_SRC += core/src/lv_obj_class.c
C_SRC += core/src/lv_obj_draw.c
C_SRC += core/src/lv_obj_pos.c
C_SRC += core/src/lv_obj_scroll.c
C_SRC += core/src/lv_obj_style.c
C_SRC += core/src/lv_obj_tree.c
C_SRC += core/src/lv_obj.c
C_SRC += core/src/lv_refr.c
C_SRC += core/src/lv_theme.c

# Draw source files
C_SRC += draw/src/lv_draw_arc.c
C_SRC += draw/src/lv_draw_blend.c
C_SRC += draw/src/lv_draw_img.c
C_SRC += draw/src/lv_draw_label.c
C_SRC += draw/src/lv_draw_line.c
C_SRC += draw/src/lv_draw_mask.c
C_SRC += draw/src/lv_draw_rect.c
C_SRC += draw/src/lv_draw_triangle.c
C_SRC += draw/src/lv_img_buf.c
C_SRC += draw/src/lv_img_cache.c
C_SRC += draw/src/lv_img_decoder.c

# Extra source files
C_SRC += extra/src/lv_calendar_header_arrow.c
C_SRC += extra/src/lv_calendar_header_dropdown.c
C_SRC += extra/src/lv_calendar.c
C_SRC += extra/src/lv_colorwheel.c
C_SRC += extra/src/lv_extra.c
C_SRC += extra/src/lv_flex.c
C_SRC += extra/src/lv_grid.c
C_SRC += extra/src/lv_imgbtn.c
C_SRC += extra/src/lv_keyboard.c
C_SRC += extra/src/lv_led.c
C_SRC += extra/src/lv_list.c
C_SRC += extra/src/lv_msgbox.c
C_SRC += extra/src/lv_spinbox.c
C_SRC += extra/src/lv_spinner.c
C_SRC += extra/src/lv_tabview.c
C_SRC += extra/src/lv_theme_basic.c
C_SRC += extra/src/lv_theme_default.c
C_SRC += extra/src/lv_tileview.c
C_SRC += extra/src/lv_win.c

# Font source files
C_SRC += font/src/lv_font_dejavu_16_persian_hebrew.c
C_SRC += font/src/lv_font_fmt_txt.c
C_SRC += font/src/lv_font_loader.c
C_SRC += font/src/lv_font_montserrat_8.c
C_SRC += font/src/lv_font_montserrat_10.c
C_SRC += font/src/lv_font_montserrat_12_subpx.c
C_SRC += font/src/lv_font_montserrat_12.c
C_SRC += font/src/lv_font_montserrat_14.c
C_SRC += font/src/lv_font_montserrat_16.c
C_SRC += font/src/lv_font_montserrat_18.c
C_SRC += font/src/lv_font_montserrat_20.c
C_SRC += font/src/lv_font_montserrat_22.c
C_SRC += font/src/lv_font_montserrat_24.c
C_SRC += font/src/lv_font_montserrat_26.c
C_SRC += font/src/lv_font_montserrat_28_compressed.c
C_SRC += font/src/lv_font_montserrat_28.c
C_SRC += font/src/lv_font_montserrat_30.c
C_SRC += font/src/lv_font_montserrat_32.c
C_SRC += font/src/lv_font_montserrat_34.c
C_SRC += font/src/lv_font_montserrat_36.c
C_SRC += font/src/lv_font_montserrat_38.c
C_SRC += font/src/lv_font_montserrat_40.c
C_SRC += font/src/lv_font_montserrat_42.c
C_SRC += font/src/lv_font_montserrat_44.c
C_SRC += font/src/lv_font_montserrat_46.c
C_SRC += font/src/lv_font_montserrat_48.c
C_SRC += font/src/lv_font_simsun_16_cjk.c
C_SRC += font/src/lv_font_unscii_8.c
C_SRC += font/src/lv_font_unscii_16.c
C_SRC += font/src/lv_font.c

# HAL source files
C_SRC += hal/src/lv_hal_disp.c
C_SRC += hal/src/lv_hal_indev.c
C_SRC += hal/src/lv_hal_tick.c

# Misc source files
C_SRC += misc/src/lv_anim.c
C_SRC += misc/src/lv_area.c
C_SRC += misc/src/lv_async.c
C_SRC += misc/src/lv_bidi.c
C_SRC += misc/src/lv_color.c
C_SRC += misc/src/lv_fs.c

# Widget source files
C_SRC += widgets/src/lv_arc.c
C_SRC += widgets/src/lv_bar.c
C_SRC += widgets/src/lv_btn.c
C_SRC += widgets/src/lv_btnmatrix.c
C_SRC += widgets/src/lv_canvas.c
C_SRC += widgets/src/lv_chart.c
C_SRC += widgets/src/lv_checkbox.c
C_SRC += widgets/src/lv_dropdown.c
C_SRC += widgets/src/lv_img.c
C_SRC += widgets/src/lv_label.c
C_SRC += widgets/src/lv_line.c
C_SRC += widgets/src/lv_meter.c
C_SRC += widgets/src/lv_roller.c
C_SRC += widgets/src/lv_slider.c
C_SRC += widgets/src/lv_switch.c
C_SRC += widgets/src/lv_table.c
C_SRC += widgets/src/lv_textarea.c

## ------------------------------------- ##
##  Do Not touch below this line         ##
## ------------------------------------- ##
include ${SOFT_WORKDIR}/env/compilation/compilerules.mk
