@echo off
echo "######  THE START  ########"

set option=%1


set SOFT_WORKDIR=E:/RDA8955_DevEnv/RDA8955_W17.44_IDH/soft
set PATH=E:\RDA8955_DevEnv\RDA8955_W17.44_IDH\soft\env\utils;E:\RDA8955_DevEnv\RDA8955_W17.44_IDH\soft\env\win32;%PATH%
set BL_WORKDIR=E:\RDA8955_DevEnv\RDA8955_W17.44_IDH\soft\toolpool\blfota

if %option% == bl ( 
  call:build_BL
) ^
else if %option% == all ( 
  call:build_ALL
) ^
else if %option% == app ( 
  call:build_APP
) ^
else if %option% == lvgl ( 
  call:build_LVGL
) ^
else if %option% == lvpng ( 
  call:build_LVPNG
) ^
else if %option% == merge ( 
  call:merge_APP
) ^
else ( 
  echo "nothing to do" 
)

goto:eof

:build_BL
echo "build bootloader started" 
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
cd %BL_WORKDIR%
make -r -j8 CT_TARGET=8955_modem CT_USER=FAE CT_RELEAS=debug WITH_SVN=0 CT_MODEM=3 CT_PRODUCT=W1744RC1
goto:eof

:build_ALL
echo "build all started" 
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
cd %SOFT_WORKDIR%
make -r -j12 CT_TARGET=8955_modem CT_USER=FAE CT_RELEAS=debug WITH_SVN=0 CT_MODEM=3 CT_PRODUCT=W1744RC1
goto:eof

:build_LVGL
echo "build LVGL started" 
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
cd %SOFT_WORKDIR%
make -r -j12 CT_TARGET=8955_modem CT_USER=FAE CT_RELEAS=debug WITH_SVN=0 CT_MODEM=3 CT_PRODUCT=W1744RC1 CT_MODULES="platform/service/lvgl_800"
goto:eof

:build_LVPNG
echo "build LVGL started" 
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
cd %SOFT_WORKDIR%
make -r -j12 CT_TARGET=8955_modem CT_USER=FAE CT_RELEAS=debug WITH_SVN=0 CT_MODEM=3 CT_PRODUCT=W1744RC1 CT_MODULES="platform/service/lv_lib_png"
goto:eof

:build_APP
echo "build app started" 
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
cd %SOFT_WORKDIR%
make -r -j12 CT_TARGET=8955_modem CT_USER=FAE CT_RELEAS=debug WITH_SVN=0 CT_MODEM=3 CT_PRODUCT=W1744RC1 CT_MODULES="application"
goto:eof


:merge_APP
echo "merge app&bl started" 
env\utils\dual_boot_merge.py --bl hex\8955_modem_W1744RC1_debug\blfota_8955_modem_W1744RC1_debug_flash.lod --lod hex\8955_modem_W1744RC1_debug\8955_modem_W1744RC1_debug_flash.lod --output hex\8955_modem_W1744RC1_debug\factory_merge.lod
goto:eof

:END
echo "######  THE END  ########"