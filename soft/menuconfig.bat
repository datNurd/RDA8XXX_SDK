@echo off
call E:\RDA8955_DevEnv\CSDTK42\CSDTKvars.bat
set SOFT_WORKDIR=E:/RDA8955_DevEnv/RDA8955_W17.44_IDH/soft
set PATH=E:\RDA8955_DevEnv\RDA8955_W17.44_IDH\soft\env\utils;E:\RDA8955_DevEnv\RDA8955_W17.44_IDH\soft\env\win32;%PATH%
bash env/menuconfig.sh 8955_modem