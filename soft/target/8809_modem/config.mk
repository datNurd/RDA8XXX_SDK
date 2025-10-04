#
# Automatically generated file; DO NOT EDIT.
# RDA Feature Phone Configuration
#

#
# --- RDA Software Configuration ---
#

#
# Platform
#

#
# boot
#

#
# --- platform/boot ---
#
FOTA_SUPPORT	:=y

#
# chip
#

#
# --- platform/chip ---
#
CT_ASIC	:=8809
8809e2	:=n
8955	:=n
8909	:=n
CT_CHIP_DIE	:=
CT_COMPILER	:=gcc4_xcpu
fpga	:=n
CT_ASIC_CFG	:=chip

#
# drivers
#

#
# --- platform/edrv ---
#

#
# ATV
#

#
# audio
#

#
# --- platform/edrv/aud ---
#

#
# tv
#

#
# --- platform/edrv/aud/tv ---
#
AD_MODEL	:=codec_gallite
MIC_CAPLESS_MODE	:=y

#
# bluetooth
#

#
# --- platform/edrv/btd ---
#

#
# usb
#
UCTLS_SERVICE	:=y
_UTRACE_	:=y
_UMSS_	:=y
_UCDCACM_	:=y
_UVIDEO_	:=n
_URNDIS_	:=n
_UMSS_DUAL_MC_	:=n

#
# camera
#

#
# --- platform/edrv/camd ---
#
CAMERA_MODEL	:=gc6133 bf3a01_jyj_h1_baili
MJPG_SUPPORT	:=y
CAMERA_IF	:=spi

#
# fm
#

#
# --- platform/edrv/fmd ---
#
FM_MODEL	:=rdafm_8809
FM_USING_I2S	:=n
FM_USE_32K_CLK_PIN	:=0

#
# lcd
#

#
# --- platform/edrv/lcdd ---
#
LCD_MODEL	:=gc9102
LCD_IF	:=gouda
USE_SPI_LCD	:=y
__USE_LCD_FMARK__	:=n
LCD_BACKLIGHT_CHARGE_PUMP	:=n

#
# mem
#

#
# --- platform/edrv/memd ---
#
FLSH_MODEL	:=flsh_spi32m
FLSH_IF	:=spi
RAM_SIZE_FLAG	:=__32Mbit__
SYS_MEMD_EBC_CLK	:=__78MHz__
SYS_MEMD_FLSH_SPI_CLK	:=__78MHz__
SYS_MMI_CLK	:=__104MHz__

#
# FLASH layout
#
FLASH_SIZE	:=0x400000
FLASH_BOOT_OFFSET	:=0x10000
FOTA_BACKUP_AREA_START	:=0x380000
FOTA_BACKUP_AREA_SIZE	:=0x10000
SPIFFS_FLASH_START	:=0x390000
SPIFFS_FLASH_SIZE	:=0x66000
USER_DATA_BASE	:=0x3F6000
USER_DATA_SIZE	:=0x4000
CALIB_BASE	:=0x3FA000
CALIB_RF2G_BASE	:=0x3FC000
CALIB_SIZE	:=0x4000
FACT_SETTINGS_BASE	:=0x3FE000
FACT_SETTINGS_SIZE	:=0x2000

#
# pm
#

#
# --- platform/edrv/pmd ---
#
PM_MODEL	:=pmu_8809
AUD_SPK_LINE_L_R_DOUBLE	:=y
class_ab	:=n
class_d	:=n
AUD_SPK_LINE_CLASS_MODE	:=class_k

#
# rf
#

#
# --- platform/edrv/rfd ---
#
PA_MODEL	:=pasw_rda6625
pasw_rda6231	:=n
pasw_hs8292u	:=n
XCV_MODEL	:=xcv_8809
PA_VRAMP_220PF	:=y
USE_EXT_XTAL_32K	:=n

#
# sim
#
DUALSIM_MODEL	:=rda1203_gallite_CT1129
USIM_SUPPORT	:=y
NUMBER_OF_SIM	:=2
USER_SIM_ORDER	:=1 2

#
# Touch Screen
#
TSD_MODEL	:=

#
# gpio extend
#
GPIOI2C_MODEL	:=n
GPIOSPI_MODEL	:=n

#
# mcd
#
MCD_IF	:=sdmmc

#
# gpsd
#

#
# --- platform/edrv/gpsd ---
#
GPSD_MODEL	:=
GPS_DEFAULT_UART	:=0
GPS_SUPPORT	:=n

#
# service
#

#
# --- platform/service ---
#

#
# base
#

#
# --- platform/service/base ---
#
CFG_NEW_MECHANISM_TEST	:=n

#
# --- VDS Cache Related Options ---
#
REDUNDANT_DATA_REGION	:=n

#
# gprs
#
EGPRS_SUPPORT	:=n
GPRS_SUPPORT	:=y

#
# Net Support
#

#
# --- platform/service/net/ ---
#
CFW_TCPIP_SUPPORT	:=y
CFW_PPP_SUPPORT	:=y
LWIP_SUPPORT	:=y
LWIP_DEBUG_ON	:=y
LWIP_PPP_ON	:=y
LWIP_IPV4_ON	:=y
LWIP_IPV6_ON	:=y
LWIP_TEST	:=y
LWIP_MQTT_TEST	:=y
LWIP_HTTP_TEST	:=y
LWIP_COAP_TEST	:=n
LWIP_LIBWM2M_TEST	:=n
CALL_AMR_SUPPORT	:=n

#
# system
#

#
# --- platform/system ---
#

#
# calib
#

#
# --- platform/system/calib ---
#
CES_DISPLAY	:=n

#
# mdi
#

#
# --- platform/system/mdi ---
#
MEDIA_RM_SUPPORT	:=n
VIDEO_PLAYER_SUPPORT	:=n
SOUND_RECORDER_SUPPORT	:=y
VIDEO_RECORDER_SUPPORT	:=n
MEDIA_MIDI_SUPPORT	:=n

#
# Custom Setup
#
CT_PROTOSTACK_IN_RAM	:=y
EXPORT_BOARD_INFO	:=y
EXPORT_BOARD_FLAGS	:=PM_MODEL FM_MODEL

#
# Lower Power Options
#

#
# Application
#

#
# --- Application ---
#

#
# Communication
#

#
# --- application/communication ---
#

#
# Features
#

#
# Call
#

#
# --- application/coolmmi/mmi/calls ---
#

#
# --- application/coolmmi/mmi/callmanagement ---
#

#
# Messages
#

#
# --- application/coolmmi/mmi/messages ---
#
PHONE_SMS_ENTRY_COUNT	:=100
SIM_SMS_ENTRY_COUNT	:=255
CM_SMS_MAX_MSG_NUM	:=100
MAX_INDEX_MAP_LENGTH	:=100
CB_SUPPORT	:=y

#
# Phonebook
#

#
# --- application/coolmmi/mmi/phonebook ---
#
PHONE_PHB_ENTRY_COUNT	:=100
MAX_PHB_PHONE_ENTRY	:=100

#
# Profiles & Settings
#

#
# --- application/coolmmi/mmi/profiles ---
#

#
# --- application/coolmmi/mmi/setting ---
#

#
# ---FM Record Codec---
#

#
# Idlescreen
#

#
# --- application/coolmmi/mmi/idlescreen ---
#

#
# Watch
#

#
# --- Watch Options ---
#

#
# Multimedia
#

#
# Radio
#

#
# Audio
#

#
# --- application/coolmmi/mmi_csdapp/audioplayer ---
#
MULTI_MEDIA_AMR_SUPPORT	:=y
MMI_SUPPORT_MAGIC_SOUND	:=n

#
# Video
#
MEDIA_H264_SUPPORT	:=n
MEDIA_VOCVID_SUPPORT	:=y

#
# Camera
#

#
# --- application/coolmmi/mmi_csdapp/camera ---
#
CAM_MD_SUPPORT	:=n

#
# SoundRecorder
#

#
# --- application/coolmmi/mmi/soundrecorder ---
#

#
# ATV
#

#
# --- application/coolmmi/mmi_csdapp/analogtv ---
#
ANALOG_TV_SUPPORT	:=n

#
# FileManagement
#

#
# --- application/coolmmi/mmi_csdapp/filemgr ---
#

#
# Wap & MMS
#

#
# --- GPRS Options ---
#

#
# Bluetooth
#

#
# --- application/coolmmi/mmi/bluetooth ---
#

#
# USB
#

#
# --- application/coolmmi/mmi/usb ---
#

#
# Organizer
#

#
# --- application/coolmmi/mmi/organizer ---
#

#
# EngineerMode
#

#
# --- application/coolmmi/mmi_csdapp/engineermode ---
#

#
# Resource
#

#
# --- application/target_res ---
#

#
# Language
#

#
# --- languages support ---
#

#
# Inputmethod
#

#
# --- Inputmethod ---
#

#
# Fonts
#

#
# --- Fonts and Others---
#
CT_ERES	:=qqvga_3232
qvga_3264	:=n
qcif_3264	:=n
128_128	:=n
160_128_3216	:=n
220_176_3232	:=n
320_240_6432	:=n
240_240	:=n
TARGET_MEM_ULC_3216	:=y

#
# Compress
#

#
# --- Compress Options ---
#
CT_COMPRESS_CODE_SECTION	:=n
CT_COMPRESS_PREMAIN	:=n

#
# Display
#

#
# SIM
#

#
# --- SIM Options ---
#
MMI_SUPPORT_SENDKEY2	:=n

#
# diag && BBAT
#

#
# --- application/diag ---
#
SUPPORT_SPRD_BBAT	:=n

#
# Device
#

#
# Sensor
#
MMI_SUPPORT_GSENSOR	:=n

#
# Key
#

#
# Default Setup
#

#
# --- Default Options ---
#

#
# AT
#
CT_MODEM	:=1
AT_DEFAULT_UART	:=2
AT_SECOND_UART_SUPPORT	:=y
AT_SECOND_UART	:=1
_USE_AT_OC_GPIO_	:=2
AT_USB_MODEM_NO_MMMI	:=y
AT_CMUX_SUPPORT	:=y
AT_CAMERA_SUPPORT	:=y
AT_SOUND_RECORDER_SUPPORT	:=y
GCF_TTS_MODEL	:=n
AT_HTTP_SUPPORT	:=y
AT_COAP_SUPPORT	:=n
AT_LWM2M_SUPPORT	:=n
AT_FOTA_SUPPORT	:=y
DEFAULT_SIM_SLOT	:=0

#
# Debug
#

#
# --- Debug Options ---
#
WITHOUT_WERROR	:=y

#
# --- Register Debug Options ---
#
SPI_REG_DEBUG	:=y
I2C_REG_DEBUG	:=n

#
# --- Profile Options ---
#

#
# --- Trace Options ---
#
WAP_NO_TRACE	:=y
STACK_NO_PRINTF	:=n

#
# Default
#
CT_ROMULATOR	:=n
USE_KCONFIG	:=y
