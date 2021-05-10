#include "lvgl.h"
#include "tm.h"

LV_IMG_DECLARE(analog_watchface);
LV_IMG_DECLARE(hour);
LV_IMG_DECLARE(minute);
LV_IMG_DECLARE(second);

static bool analog_init_flag = false;
static lv_timer_t * g_refreshTimer = NULL;
static lv_obj_t * lvWatchFace = NULL; 
static lv_obj_t * lvMinute = NULL; 
static lv_obj_t * lvHour = NULL; 
static lv_obj_t * lvSecond  = NULL; 

static uint8_t g_hour = 0;
static uint8_t g_minute = 0;
static uint8_t g_second = 0;

static void update_time(struct _lv_timer_t * timer)
{
    TM_SYSTEMTIME systemTime;
    TM_GetSystemTime(&systemTime);
    
    if(systemTime.uMinute != g_minute)
    {
        g_minute = systemTime.uMinute ;
        uint16_t angle = (systemTime.uHour % 12) * 300 + g_minute * 5;// 3600单位/12份/60分钟=每分钟时针走的刻度;
        lv_img_set_angle(lvHour, angle);
        lv_img_set_angle(lvMinute, systemTime.uMinute * 6 * 10);
    }
    
    if(systemTime.uSecond != g_second)
    {
        g_second = systemTime.uSecond;
        lv_img_set_angle(lvSecond, g_second * 6 * 10 );
    }
}

void startAnalog()
{
    if(analog_init_flag)
            return;
    
    g_hour = 0;
    g_minute = 0;
    g_second = 0;
    
    lv_obj_t* central = lv_scr_act(); 
    lv_obj_set_size(central, 128, 128);
    lv_obj_set_pos(central,  0, 0);

    lvWatchFace= lv_img_create(central);
    lv_img_set_src(lvWatchFace, &analog_watchface);
    lv_obj_set_size(lvWatchFace, 128, 128);
    lv_obj_align(lvWatchFace, LV_ALIGN_CENTER, 0, 0);

    lvHour = lv_img_create(central);
    lv_img_set_src( lvHour, &hour);
    //lv_obj_set_size(lvHour, 20, 128);
    lv_img_set_pivot(lvHour, 6, 62);
    lv_obj_align(lvHour,LV_ALIGN_CENTER, 0, -18);

    lvMinute = lv_img_create(central);
    lv_img_set_src( lvMinute, &minute);
    lv_img_set_pivot(lvMinute, 6, 62);
    //lv_obj_set_size(lvMinute, 20, 128);
    lv_obj_align(lvMinute,LV_ALIGN_CENTER, 0, -18);

    lvSecond = lv_img_create(central);
    lv_img_set_src( lvSecond, &second);
    lv_img_set_pivot(lvSecond, 6, 62);
    //lv_obj_set_size(lvSecond, 20, 128);
    lv_obj_align(lvSecond,LV_ALIGN_CENTER, 0, -18);
    
    update_time(NULL);
    
    g_refreshTimer = lv_timer_create(update_time, 100, NULL);
    
    analog_init_flag = true;
}

void stopAnalog()
{
    if(!analog_init_flag)
            return;

    lv_timer_del(g_refreshTimer);
    
    lv_obj_del(lvWatchFace);
    lv_obj_del(lvMinute);
    lv_obj_del(lvHour);
    lv_obj_del(lvSecond);
    
    lv_obj_t* central = lv_scr_act(); 
    lv_obj_clean(central);
    
    analog_init_flag = false;
}