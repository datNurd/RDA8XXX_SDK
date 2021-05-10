#include "lvgl.h"
#include "tm.h"

LV_IMG_DECLARE(casio_watchface);
LV_IMG_DECLARE(fly_0);
LV_IMG_DECLARE(fly_1);
LV_IMG_DECLARE(fly_2);
LV_IMG_DECLARE(fly_3);
LV_IMG_DECLARE(fly_4);
LV_IMG_DECLARE(fly_5);
LV_IMG_DECLARE(fly_6);
LV_IMG_DECLARE(fly_7);
LV_IMG_DECLARE(fly_8);
LV_IMG_DECLARE(fly_9);
LV_IMG_DECLARE(num_0);
LV_IMG_DECLARE(num_1);
LV_IMG_DECLARE(num_2);
LV_IMG_DECLARE(num_3);
LV_IMG_DECLARE(num_4);
LV_IMG_DECLARE(num_5);
LV_IMG_DECLARE(num_6);
LV_IMG_DECLARE(num_7);
LV_IMG_DECLARE(num_8);
LV_IMG_DECLARE(num_9);
LV_IMG_DECLARE(num_dot);
LV_IMG_DECLARE(num_dot_none);

LV_IMG_DECLARE(num_0_small);
LV_IMG_DECLARE(num_1_small);
LV_IMG_DECLARE(num_2_small);
LV_IMG_DECLARE(num_3_small);
LV_IMG_DECLARE(num_4_small);
LV_IMG_DECLARE(num_5_small);
LV_IMG_DECLARE(num_6_small);
LV_IMG_DECLARE(num_7_small);
LV_IMG_DECLARE(num_8_small);
LV_IMG_DECLARE(num_9_small);

static lv_obj_t* lvCentral = NULL;
static lv_obj_t * lvFly = NULL;
static lv_obj_t * lvWatchface = NULL;
static lv_obj_t * lvHour_H = NULL; //高位
static lv_obj_t * lvHour_L = NULL; //低位
static lv_obj_t * lvMinute_H = NULL;
static lv_obj_t * lvMinute_L = NULL;
static lv_obj_t * lvSecond_H = NULL;
static lv_obj_t * lvSecond_L = NULL;
static lv_obj_t * lvDot = NULL;

static lv_timer_t * g_refreshTimer = NULL;
static uint8_t g_hour = 0;
static uint8_t g_minute = 0;
static uint8_t g_second = 0;

static bool casio_init_flag = false;
static int flyNum = 0;
static const lv_img_dsc_t* flyArray[10] = {&fly_0, &fly_1, &fly_2, &fly_3, &fly_4, &fly_5, &fly_6, &fly_7, &fly_8, &fly_9};
static const lv_img_dsc_t* numArray[10] = {&num_0, &num_1, &num_2, &num_3, &num_4, &num_5, &num_6, &num_7, &num_8, &num_9};
static const lv_img_dsc_t* numSmallArray[10] = {&num_0_small, &num_1_small, &num_2_small, &num_3_small, &num_4_small, &num_5_small, &num_6_small, &num_7_small, &num_8_small, &num_9_small};

static void fly()
{
    flyNum = flyNum > 9 ? 0 : flyNum;
    //Trace(3,"casio faly man:%d", flyNum);
    lv_img_set_src( lvFly, flyArray[flyNum++]);
}

static void blingbling()
{
    static int timeTick= 0;
    static int needShow = 0;
    
    if(timeTick++ % 5 == 0 && lvDot)
   {
        if(needShow)
        {
            //Trace(3,"casio show dot");
            //lv_obj_move_foreground(lvDot);
            lv_img_set_src( lvDot, &num_dot);
            needShow = 0;
         }
        else
        {
            //Trace(3,"casio hide dot");
            //lv_obj_move_background(lvDot);
            lv_img_set_src( lvDot, &num_dot_none);
            needShow = 1;
         }
    }
}

static void time()
{
    TM_SYSTEMTIME systemTime;
    TM_GetSystemTime(&systemTime);
    
    uint8_t hour = systemTime.uHour;
    uint8_t minute = systemTime.uMinute;
    uint8_t second = systemTime.uSecond;
    
    if(hour != g_hour)
    {
        g_hour = hour;
        lv_img_set_src( lvHour_H, numArray[g_hour/10]);
        lv_img_set_src( lvHour_L, numArray[g_hour%10]);
    }
    if(minute != g_minute)
    {
        g_minute = minute;
        lv_img_set_src( lvMinute_H, numArray[g_minute/10]);
        lv_img_set_src( lvMinute_L, numArray[g_minute%10]);
    }
    
    if(second != g_second)
    {
        g_second = second;
        lv_img_set_src( lvSecond_H, numSmallArray[g_second/10]);
        lv_img_set_src( lvSecond_L, numSmallArray[g_second%10]);
    }
}

static void update_time(struct _lv_timer_t * timer)
{
    time();
    blingbling();
    fly();
}

void startCasio()
{
    if(casio_init_flag)
                return;
    
    Trace(3,"startCasio");
    g_hour = 0;
    g_minute = 0;
    g_second = 0;
    
    lvCentral = lv_scr_act(); 
    lv_obj_set_size(lvCentral, 128, 128);
    lv_obj_set_pos(lvCentral,  0, 0);
    // 创建表盘
    lvWatchface = lv_img_create(lvCentral);
    lv_img_set_src( lvWatchface, &casio_watchface);
    lv_obj_set_size(lvWatchface, 128, 128);
    lv_obj_align(lvWatchface, LV_ALIGN_CENTER, 0, 0);
    // 创建飞人
    lvFly = lv_img_create(lvCentral);
    lv_obj_set_pos(lvFly, 35, 51);
    // 创建时分秒
    lvHour_H = lv_img_create(lvCentral);
    lvHour_L = lv_img_create(lvCentral);
    lvDot = lv_img_create(lvCentral);
    lvMinute_H = lv_img_create(lvCentral);
    lvMinute_L = lv_img_create(lvCentral);
    lvSecond_H = lv_img_create(lvCentral);
    lvSecond_L = lv_img_create(lvCentral);
    lv_obj_set_pos(lvHour_H, 30, 36);
    lv_obj_set_pos(lvHour_L, 44, 36);
    lv_obj_set_pos(lvDot, 58, 36);
    lv_obj_set_pos(lvMinute_H, 72, 36);
    lv_obj_set_pos(lvMinute_L, 86, 36);
    lv_obj_set_pos(lvSecond_H, 102, 47);
    lv_obj_set_pos(lvSecond_L, 108, 47);
    
    update_time(NULL);
    
    //开始周期性刷新
    g_refreshTimer = lv_timer_create(update_time, 100, NULL);
    
    casio_init_flag = true;
}

void stopCasio()
{
    if(!casio_init_flag)
                return;
    Trace(3,"stopCasio");
    lv_timer_del(g_refreshTimer);
    
    lv_obj_del(lvFly);
    lv_obj_del(lvWatchface);
    lv_obj_del(lvHour_H);
    lv_obj_del(lvHour_L);
    lv_obj_del(lvMinute_H);
    lv_obj_del(lvMinute_L);
    lv_obj_del(lvSecond_H);
    lv_obj_del(lvSecond_L);
    lv_obj_del(lvDot);
    
    lv_obj_t* central = lv_scr_act(); 
    lv_obj_clean(central);
    
    casio_init_flag = false;
}