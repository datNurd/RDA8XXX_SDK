/*
 * @File  app_main.c
 * @Brief An example of SDK's mini system
 * 
 * @Author: Neucrack 
 * @Date: 2017-11-11 16:45:17 
 * @Last Modified by: Neucrack
 * @Last Modified time: 2017-11-11 18:24:56
 */

#include "stdio.h"
#include "stdint.h"
#include "stdbool.h"
#include "cos.h"
#include "event.h"
#include "dm.h"
#include "sxs_io.h"
#include "csw.h"
//#include "mci_lcd.h"
#include "hal_gpio.h"
#include "lcdd_m.h"
#include "imgs_m.h"
//#include "pics.h"
#include "lvgl.h"
#include "lv_png.h"
//#include "imgsp_jpeg_dec.h"
#include "anlog.h"
#include "casio.h"

#define AppMain_TASK_STACK_SIZE    (1024*8)
#define AppMain_TASK_PRIORITY      (COS_MMI_TASKS_PRIORITY_BASE + 1) //220-250 is assigned to MMI part.
#define MMI_FLASHTASK_PRIORITY     (COS_MMI_TASKS_PRIORITY_BASE + 10)
HANDLE otherTaskHandle = NULL;
HANDLE mainTaskHandle  = NULL;

#define LV_HOR_RES_MAX (128)
#define LV_VER_RES_MAX (128)

#define LV_DISP_BUF_SIZE (LV_VER_RES_MAX*LV_HOR_RES_MAX)

#ifdef __VDS_QUICK_FLUSH__
extern VOID VDS_CacheTaskEntry(void *pData);
UINT32 g_htstVdsTask = 0;
#endif
extern void Trace(UINT16 nIndex, PCSTR fmt, ...);

/**********************
 *  STATIC PROTOTYPES
 **********************/
static void my_disp_flush(lv_disp_drv_t * disp, const lv_area_t * area, lv_color_t * color_p);
static bool my_touchpad_read(struct _lv_indev_drv_t * indev_drv, lv_indev_data_t * data);


void lv_log_print(const char *buf)
{
	Trace(1,"LVGL: %s ", buf);
}
//void lvgl_task_tick()
//{
//    lv_tick_inc(1);
//    COS_StartCallbackTimer(mainTaskHandle,1,lvgl_task_tick,NULL);
//}

void Init_LVGL()
{
    lv_log_register_print_cb(lv_log_print);
    
    lv_init();
    
    static lv_disp_draw_buf_t draw_buf_dsc_1;
    static lv_color_t buf_1[LV_DISP_BUF_SIZE];                          /*A buffer for 10 rows*/
    lv_disp_draw_buf_init(&draw_buf_dsc_1, buf_1, NULL, LV_DISP_BUF_SIZE);   /*Initialize the display buffer*/
    Trace(3,"buf_1:%x ", buf_1);
    
   static lv_disp_drv_t disp_drv;               /*Descriptor of a display driver*/
   lv_disp_drv_init(&disp_drv);          /*Basic initialization*/
   disp_drv.hor_res = LV_HOR_RES_MAX;
   disp_drv.ver_res = LV_VER_RES_MAX;
   disp_drv.flush_cb = my_disp_flush;    /*Set your driver function*/
   disp_drv.draw_buf = &draw_buf_dsc_1;          /*Assign the buffer to the display*/
   lv_disp_drv_register(&disp_drv);      /*Finally register the driver*/
    
   //COS_StartCallbackTimer(mainTaskHandle,1,lvgl_task_tick,NULL);
    
    //buf1  = (lv_color_t*)COS_Malloc(LV_HOR_RES_MAX*20*sizeof(lv_color_t), COS_MMI_HEAP);
    //buf2  = (lv_color_t*)COS_Malloc(LV_HOR_RES_MAX*20*sizeof(lv_color_t), COS_MMI_HEAP);
    //Trace(3,"buf1:%x , buf2:%x", buf1, buf2);
    //lv_disp_draw_buf_init(&disp_buf, buf1, NULL, LV_HOR_RES_MAX * LV_VER_RES_MAX);    /*Initialize the display buffer*/


    /*************************
     * Input device interface
     *************************/
    /*Add a touchpad in the example*/
   //lv_indev_drv_t indev_drv;                  /*Descriptor of a input device driver*/
   //lv_indev_drv_init(&indev_drv);             /*Basic initialization*/
   //indev_drv.type = LV_INDEV_TYPE_POINTER;    /*Touch pad is a pointer-like device*/
   //indev_drv.read_cb = my_touchpad_read;      /*Set your driver function*/
   //lv_indev_drv_register(&indev_drv);         /*Finally register the driver*/
}
void Init_lcd()
{
    LCDD_SCREEN_INFO_T lcdScreenInfo;
    UINT32 background = 0xffff;
    lcdd_Open();
    lcdd_GetScreenInfo(&lcdScreenInfo);
    lcdd_SetStandbyMode(FALSE);
    lcdd_SetBrightness(7);
    
    LCDD_ROI_T roi;
    roi.x = 0;
    roi.y = 0;
    roi.width = lcdScreenInfo.width;
    roi.height = lcdScreenInfo.height;
    lcdd_FillRect16(&roi, background);
}

static int switchFunc = 0;
void CasioOnOff()
{
    if(switchFunc%3 == 0)
    {
        lcdd_SetBrightness(0);
        stopAnalog();
        stopCasio();
    }
    else if(switchFunc%3 == 1)
    {
        lcdd_SetBrightness(7);
        stopAnalog();
        stopCasio();
        startCasio();
    }
    else if(switchFunc%3 == 2)
    {
        lcdd_SetBrightness(7);
        stopAnalog();
        stopCasio();
        startAnalog();
    }
    switchFunc++;
}

void setSysTime()
{
    TM_SetTimeZone(8);
    TM_SetTimeFormat(TM_FMT_TWENTYFOUR_TIME);
    TM_SYSTEMTIME systemTime;
    TM_GetSystemTime(&systemTime);
    
    systemTime.uHour = 7;
    systemTime.uMinute = 58;
    systemTime.uSecond = 45;
    
    TM_SetSystemTime(&systemTime);
}

bool lvgl_init_flag = false;
void LVGL_Task(void* param)
{
    setSysTime();
    Init_lcd();
    Init_LVGL();
    lv_png_init();
    lvgl_init_flag = true;
    Trace(1,"init complete");
    /*************************************
     * Run the task handler of LittlevGL
     *************************************/
    while(1) {
        /* Periodically call this function.
         * The timing is not critical but should be between 1..10 ms */
        lv_tick_inc(10);
        lv_task_handler();
        COS_Sleep(10);
    }
}
void Display_Task(void* param)
{
    Trace(3,"start Display_Task");
    while(!lvgl_init_flag)
    {
        Trace(3,"Display_Task: wait lvgl init");
        COS_Sleep(200);
    }
    Trace(3,"start display");
    
    startAnalog();
    
    while(1)
    {
        //Trace(3,"in display task");
        COS_Sleep(200);
    }
}

#define APP_ZERO_PARAM1(pEv)      \
    do {                         \
        (pEv)->nParam1 = 0;      \
    } while (0)

void ProcPowerOnInd(COS_EVENT *pEvent)
{
    switch (LOUINT16(pEvent->nParam1))
    {
    case DM_POWRN_ON_CAUSE_KEY:   // power on by press power key
    case DM_POWRN_ON_CAUSE_RESET: // reset
        break;
    case DM_POWRN_ON_CAUSE_CHARGE: // power on by charging
    case DM_POWRN_ON_CAUSE_ALARM:  // power on by alarming
    case DM_POWRN_ON_CAUSE_EXCEPTION:
    default:
        break;
    }
    APP_ZERO_PARAM1(pEvent);
}

void EventDispatch(COS_EVENT *pev)
{
    Trace(1, "EventDispatch get event: 0x%08x/0x%08x/0x%08x/0x%08x",
           pev->nEventId, pev->nParam1, pev->nParam2, pev->nParam3);
    
    switch (pev->nEventId)
    {
    case EV_DM_POWER_ON_IND:
        ProcPowerOnInd(pev);
        break;
    case EV_TIMER:
            break;
    case EV_KEY_DOWN:
           Trace(1,"EV_KEY_DOWN");
           CasioOnOff();
           break;
    default:
        break;
    }
}

void BAL_MmiTask(VOID *pData)
{
    Trace(1,"AppMainTask Test");
    COS_EVENT event = {0};
    
    otherTaskHandle = COS_CreateTask(LVGL_Task,
                               NULL,
                               NULL,
                               AppMain_TASK_STACK_SIZE,
                               AppMain_TASK_PRIORITY+1,
                               COS_CREATE_DEFAULT,
                               0,
                               "lvgl Task");
    
        otherTaskHandle = COS_CreateTask(Display_Task,
                               NULL,
                               NULL,
                               AppMain_TASK_STACK_SIZE,
                               AppMain_TASK_PRIORITY+2,
                               COS_CREATE_DEFAULT,
                               0,
                               "display Task");
    
   for (;;)
    {
        if (event.nParam1 != NULL)
        {
            if (COS_Free((VOID *)event.nParam1) == FALSE)
            {
                APP_ZERO_PARAM1(&event);
            }
        }
        
        COS_WaitEvent(mainTaskHandle, &event, COS_WAIT_FOREVER);
        
        EventDispatch(&event);
    }
}

BOOL SRVAPI BAL_ApplicationInit(VOID)
{
    Trace(1,"app_task_init Test");
    application_RegisterYourself();
    
    // Create a default MMI task by CSW automatically.
    // You only can change the task stack size.
    mainTaskHandle = COS_CreateTask(BAL_MmiTask,
                               NULL,
                               NULL,
                               AppMain_TASK_STACK_SIZE,
                               AppMain_TASK_PRIORITY,
                               COS_CREATE_DEFAULT,
                               0,
                               "APP Task");
    
    #ifdef __VDS_QUICK_FLUSH__
    g_htstVdsTask = COS_CreateTask(VDS_CacheTaskEntry,
                               NULL, NULL,
                               1024,
                               MMI_FLASHTASK_PRIORITY,
                               COS_CREATE_DEFAULT,
                               0,
                               "APP VDS Flush Task");
#endif
}

void my_disp_flush(lv_disp_drv_t * disp, const lv_area_t * area, lv_color_t * color_p)
{
    static uint16_t flush_pixels[LV_DISP_BUF_SIZE];
    uint32_t i = 0;
    int32_t x, y;
    for(y = area->y1; y <= area->y2; y++) {
        for(x = area->x1; x <= area->x2; x++) {
            flush_pixels[i++] = color_p->full;  /* Put a pixel to the display.*/
            color_p++;
        }
    }
    
    //flush to LCD
    LCDD_FBW_T window;
    window.fb.buffer = flush_pixels;
    //window.fb.buffer = (uint16_t*)color_p;
    window.fb.width = area->x2 - area->x1 + 1;
    window.fb.height = area->y2 - area->y1 + 1;
    window.fb.colorFormat = LCDD_COLOR_FORMAT_RGB_565;
    window.roi.x = 0;
    window.roi.y = 0;
    window.roi.width = window.fb.width;
    window.roi.height = window.fb.height;
    lcdd_Blit16(&window,area->x1,area->y1);
    
    lv_disp_flush_ready(disp);         /* Indicate you are ready with the flushing*/
}

bool my_touchpad_read(struct _lv_indev_drv_t * indev_drv, lv_indev_data_t * data)
{
    //data->state = touchpad_is_pressed() ? LV_INDEV_STATE_PR : LV_INDEV_STATE_REL;
    //if(data->state == LV_INDEV_STATE_PR) touchpad_get_xy(&data->point.x, &data->point.y);

    return false; /*Return `false` because we are not buffering and no more data to read*/
}
