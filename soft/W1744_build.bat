@echo off
REM ========================================================================
REM RDA8955 W1744 Build Script - Portable Version
REM ========================================================================
REM This script builds RDA8955 W1744 projects in a portable, Git-friendly way
REM 
REM PREREQUISITES:
REM   1. CSDTK42 installed (any location)
REM   2. Run CSDTK42\env_set.bat once (as administrator)
REM   3. GPRS_CSDTK42_PATH environment variable should be set
REM
REM USAGE:
REM   W1744_build.bat [option] [target]
REM   
REM OPTIONS:
REM   bl      - Build bootloader only
REM   app     - Build application only  
REM   all     - Build complete project
REM   lvgl    - Build LVGL module
REM   lvpng   - Build LVPNG module
REM   merge   - Merge application and bootloader
REM   clean   - Clean build outputs
REM   help    - Show this help message
REM
REM TARGETS:
REM   8955_modem  - RDA8955 modem target (default)
REM   8809_modem  - RDA8809 modem target
REM   (if no target specified, defaults to 8955_modem)
REM ========================================================================

echo ######  RDA8955 W1744 BUILD START  ########
set startTime=%time%

REM ========================================================================
REM ENVIRONMENT VALIDATION
REM ========================================================================

set option=%1
if "%option%"=="" goto usage_help
if "%option%"=="help" goto usage_help

REM Check for CSDTK42 environment variable (set by env_set.bat)
set USER_CSDTK=%GPRS_CSDTK42_PATH%
if "%USER_CSDTK%"=="" (
    echo.
    echo ERROR: GPRS_CSDTK42_PATH environment variable not set
    echo Please run CSDTK42\env_set.bat first as administrator
    echo This sets up the required CSDTK42 environment paths
    echo.
    pause
    exit /b 1
)

REM Validate CSDTK installation
if not exist "%USER_CSDTK%\CSDTKvars.bat" (
    echo.
    echo ERROR: CSDTKvars.bat not found at %USER_CSDTK%
    echo Please check your CSDTK42 installation
    echo Expected: %USER_CSDTK%\CSDTKvars.bat
    echo.
    pause
    exit /b 1
)

echo CSDTK42 Path: %USER_CSDTK%

REM ========================================================================
REM TARGET PARAMETER CONFIGURATION
REM ========================================================================

REM Handle optional CT_TARGET parameter (defaults to 8955_modem)
set CT_TARGET_PARAM=%2
if "%CT_TARGET_PARAM%"=="" set CT_TARGET_PARAM=8955_modem
echo Using target: %CT_TARGET_PARAM%
echo.

REM ========================================================================
REM DYNAMIC PATH CONFIGURATION  
REM ========================================================================

REM Use current directory as base (portable across different project locations)
set SOFT_WORKDIR=%cd:\=/%
set BL_WORKDIR=%cd:\=/%/toolpool/blfota

REM Setup environment paths relative to current directory
set PATH=%cd:\=/%/env/utils;%cd:\=/%/env/win32;%PATH%

REM Validate project structure
if not exist "%cd:\=/%/env/utils" (
    echo ERROR: Project env\utils directory not found
    echo Please run this script from the 'soft' directory of RDA8955 project
    pause
    exit /b 1
)

REM ========================================================================
REM BUILD PERFORMANCE SETUP
REM ========================================================================

REM Use all available processors for optimal build performance
if not defined NUMBER_OF_PROCESSORS set NUMBER_OF_PROCESSORS=4
echo Using %NUMBER_OF_PROCESSORS% processors for parallel build
echo.

REM ========================================================================
REM MAIN OPERATION DISPATCH
REM ========================================================================

if /i "%option%"=="bl" (
    call:build_BL
) else if /i "%option%"=="all" (
    call:build_ALL  
) else if /i "%option%"=="app" (
    call:build_APP
) else if /i "%option%"=="lvgl" (
    call:build_LVGL
) else if /i "%option%"=="lvpng" (
    call:build_LVPNG
) else if /i "%option%"=="merge" (
    call:merge_APP
) else if /i "%option%"=="clean" (
    call:clean_build
) else (
    echo ERROR: Unknown option '%option%'
    goto usage_help
)

goto build_complete

REM ========================================================================
REM BUILD FUNCTIONS
REM ========================================================================

:build_BL
echo.
echo [%time%] Building bootloader...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%BL_WORKDIR%" || goto build_error
make -r -j%NUMBER_OF_PROCESSORS% CT_TARGET=%CT_TARGET_PARAM% CT_USER=FAE CT_RELEASE=debug WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=W1744RC1
if errorlevel 1 goto build_error
echo [%time%] Bootloader build completed successfully
cd "%SOFT_WORKDIR%"
goto:eof

:build_ALL
echo.
echo [%time%] Building complete project...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%SOFT_WORKDIR%" || goto build_error
make -r -j%NUMBER_OF_PROCESSORS% CT_TARGET=%CT_TARGET_PARAM% CT_USER=FAE CT_RELEASE=debug WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=W1744RC1
if errorlevel 1 goto build_error
echo [%time%] Complete project build completed successfully
goto:eof

:build_LVGL
echo.
echo [%time%] Building LVGL module...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%SOFT_WORKDIR%" || goto build_error
make -r -j%NUMBER_OF_PROCESSORS% CT_TARGET=%CT_TARGET_PARAM% CT_USER=FAE CT_RELEASE=debug WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=W1744RC1 CT_MODULES="platform/service/lvgl_800"
if errorlevel 1 goto build_error
echo [%time%] LVGL module build completed successfully
goto:eof

:build_LVPNG
echo.
echo [%time%] Building LVPNG module...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%SOFT_WORKDIR%" || goto build_error
make -r -j%NUMBER_OF_PROCESSORS% CT_TARGET=%CT_TARGET_PARAM% CT_USER=FAE CT_RELEASE=debug WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=W1744RC1 CT_MODULES="platform/service/lv_lib_png"
if errorlevel 1 goto build_error
echo [%time%] LVPNG module build completed successfully
goto:eof

:build_APP
echo.
echo [%time%] Building application...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%SOFT_WORKDIR%" || goto build_error
make -r -j%NUMBER_OF_PROCESSORS% CT_TARGET=%CT_TARGET_PARAM% CT_USER=FAE CT_RELEASE=debug WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=W1744RC1 CT_MODULES="application"
if errorlevel 1 goto build_error
echo [%time%] Application build completed successfully
goto:eof

:merge_APP
echo.
echo [%time%] Merging application and bootloader...
call "%USER_CSDTK%\CSDTKvars.bat" || goto build_error
cd "%SOFT_WORKDIR%" || goto build_error
if not exist "hex\%CT_TARGET_PARAM%_W1744RC1_debug\blfota_%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod" (
    echo ERROR: Bootloader file not found. Please build bootloader first.
    echo Expected: hex\%CT_TARGET_PARAM%_W1744RC1_debug\blfota_%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod
    goto build_error
)
if not exist "hex\%CT_TARGET_PARAM%_W1744RC1_debug\%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod" (
    echo ERROR: Application file not found. Please build application first.
    echo Expected: hex\%CT_TARGET_PARAM%_W1744RC1_debug\%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod
    goto build_error
)
python env\utils\dual_boot_merge.py --bl hex\%CT_TARGET_PARAM%_W1744RC1_debug\blfota_%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod --lod hex\%CT_TARGET_PARAM%_W1744RC1_debug\%CT_TARGET_PARAM%_W1744RC1_debug_flash.lod --output hex\%CT_TARGET_PARAM%_W1744RC1_debug\factory_merge.lod
if errorlevel 1 goto build_error
echo [%time%] Merge completed successfully
echo Output: hex\%CT_TARGET_PARAM%_W1744RC1_debug\factory_merge.lod
goto:eof

:clean_build
echo.
echo [%time%] Cleaning build outputs...
if exist "build" (
    echo Removing build directory...
    rd /s /q "build" 2>nul
)
if exist "hex" (
    echo Removing hex directory...
    rd /s /q "hex" 2>nul
)
echo [%time%] Clean completed successfully
goto:eof

REM ========================================================================
REM UTILITY FUNCTIONS
REM ========================================================================

:build_error
echo.
echo ========================
echo ***** BUILD FAILED *****
echo ========================
echo Error occurred at: %time%
echo Check the build output above for details
echo.
pause
exit /b 1

:usage_help
echo.
echo ========================================================================
echo RDA8955 W1744 Build Script - Usage Information
echo ========================================================================
echo.
echo USAGE:
echo   %~nx0 [option] [target]
echo.
echo BUILD OPTIONS:
echo   bl      - Build bootloader only
echo   app     - Build application only
echo   all     - Build complete project (bootloader + application)
echo   lvgl    - Build LVGL graphics module
echo   lvpng   - Build LVPNG image module
echo   merge   - Merge application and bootloader into factory image
echo   clean   - Clean all build outputs
echo   help    - Show this help message
echo.
echo TARGET OPTIONS:
echo   8955_modem  - Build for RDA8955 modem target (default)
echo   8809_modem  - Build for RDA8809 modem target
echo   (if no target specified, defaults to 8955_modem for backward compatibility)
echo.
echo EXAMPLES:
echo   %~nx0 all              - Build complete project (8955_modem target)
echo   %~nx0 all 8955_modem   - Build complete project for RDA8955
echo   %~nx0 all 8809_modem   - Build complete project for RDA8809
echo   %~nx0 app 8809_modem   - Build application for RDA8809
echo   %~nx0 merge            - Create merged factory image (8955_modem)
echo   %~nx0 merge 8809_modem - Create merged factory image (8809_modem)
echo.
echo SETUP REQUIREMENTS:
echo   1. Install CSDTK42 toolkit
echo   2. Run CSDTK42\env_set.bat (as administrator, one time only)
echo   3. Run this script from the 'soft' directory of your project
echo.
echo ========================================================================
goto build_complete

:build_complete
set endTime=%time%

REM Calculate build duration with precision
call :calculate_duration "%startTime%" "%endTime%"

echo.
echo ========================================================================
echo Build Process Summary
echo ========================================================================
echo Start Time: %startTime%
echo End Time:   %endTime%
echo Duration:   %BUILD_DURATION%
echo Operation:  %option%
echo Status:     COMPLETED SUCCESSFULLY
echo ========================================================================

echo.
echo ######  RDA8955 W1744 BUILD COMPLETE  ########
goto:eof

REM ========================================================================
REM TIME CALCULATION FUNCTION
REM ========================================================================

:calculate_duration
REM Calculate duration between two time stamps
REM Parameters: %1 = start time, %2 = end time
REM Returns: BUILD_DURATION variable with formatted duration

set start_time=%~1
set end_time=%~2

REM Handle potential leading space in time format
if "%start_time:~0,1%"==" " set start_time=0%start_time:~1%
if "%end_time:~0,1%"==" " set end_time=0%end_time:~1%

REM Parse start time components
set /a start_h=1%start_time:~0,2%-100
set /a start_m=1%start_time:~3,2%-100
set /a start_s=1%start_time:~6,2%-100
set /a start_cs=1%start_time:~9,2%-100

REM Parse end time components
set /a end_h=1%end_time:~0,2%-100
set /a end_m=1%end_time:~3,2%-100
set /a end_s=1%end_time:~6,2%-100
set /a end_cs=1%end_time:~9,2%-100

REM Convert to total centiseconds
set /a start_total_cs=%start_h%*360000 + %start_m%*6000 + %start_s%*100 + %start_cs%
set /a end_total_cs=%end_h%*360000 + %end_m%*6000 + %end_s%*100 + %end_cs%

REM Calculate duration in centiseconds
set /a duration_cs=%end_total_cs% - %start_total_cs%

REM Handle midnight crossover (if end time is less than start time)
if %duration_cs% LSS 0 set /a duration_cs=%duration_cs% + 8640000

REM Convert to seconds with 2 decimal places
set /a duration_sec=%duration_cs% / 100
set /a duration_frac=%duration_cs% %% 100

REM Format with leading zero for fractions if needed
if %duration_frac% LSS 10 (
    set BUILD_DURATION=%duration_sec%.0%duration_frac% seconds
) else (
    set BUILD_DURATION=%duration_sec%.%duration_frac% seconds
)

goto:eof