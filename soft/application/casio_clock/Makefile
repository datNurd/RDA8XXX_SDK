## ----------------------------------------------------------- ##
## Don't touch the next line unless you know what you're doing.##
## ----------------------------------------------------------- ##
include ${SOFT_WORKDIR}/env/compilation/compilevars.mk

# Name of the module
LOCAL_NAME := application/casio_clock

# list all modules APIs that are neccessary to compile this module
LOCAL_API_DEPENDS := \
	platform \
	${PLATFORM_SERVICE}

# include folder
LOCAL_ADD_INCLUDE := $(PLATFORM_SERVICE)/include \
	$(PLATFORM_SERVICE)/lvgl_800 \
	$(PLATFORM_SERVICE)/lvgl_800/core \
	$(PLATFORM_SERVICE)/lvgl_800/draw \
	$(PLATFORM_SERVICE)/lvgl_800/extra \
	$(PLATFORM_SERVICE)/lvgl_800/font \
	$(PLATFORM_SERVICE)/lvgl_800/hal \
	$(PLATFORM_SERVICE)/lvgl_800/misc \
	$(PLATFORM_SERVICE)/lvgl_800/widgets 
	

# list all the modules that need to be compiled prior to using this module
LOCAL_MODULE_DEPENDS := \

# This is a top-level module
IS_TOP_LEVEL := no

## ------------------------------------ ##
## 	Add your custom flags here          ##
## ------------------------------------ ##

LOCAL_EXPORT_FLAG += 

## ------------------------------------- ##
##	List all your sources here           ##
## ------------------------------------- ##
C_SRC := ${notdir ${wildcard src/*.c}}


## ------------------------------------- ##
##  Do Not touch below this line         ##
## ------------------------------------- ##
include ${SOFT_WORKDIR}/env/compilation/compilerules.mk
