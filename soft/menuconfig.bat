@echo off
REM ========================================================================
REM RDA8955 MenuConfig Script - Portable Version
REM ========================================================================
REM This script launches the menuconfig interface for RDA8955 projects
REM in a portable, Git-friendly way
REM 
REM PREREQUISITES:
REM   1. CSDTK42 installed (any location)
REM   2. Run CSDTK42\env_set.bat once (as administrator)
REM   3. GPRS_CSDTK42_PATH environment variable should be set
REM
REM USAGE:
REM   menuconfig.bat [target]
REM   
REM PARAMETERS:
REM   target  - Target configuration (e.g., 8955_modem, 8809_modem)
REM             Default: 8955_modem if not specified
REM   
REM EXAMPLES:
REM   menuconfig.bat           - Configure 8955_modem (default)
REM   menuconfig.bat 8955_modem - Configure 8955_modem explicitly
REM   menuconfig.bat 8809_modem - Configure 8809_modem
REM   menuconfig.bat help      - Show this help message
REM ========================================================================

echo ######  RDA8955 MENUCONFIG START  ########

REM ========================================================================
REM PARAMETER PROCESSING
REM ========================================================================

set TARGET=%1
if "%TARGET%"=="" set TARGET=8955_modem
if "%TARGET%"=="help" goto usage_help

echo Target Configuration: %TARGET%
echo.

REM ========================================================================
REM ENVIRONMENT VALIDATION
REM ========================================================================

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
REM DYNAMIC PATH CONFIGURATION  
REM ========================================================================

REM Use current directory as base (portable across different project locations)
set SOFT_WORKDIR=%cd:\=/%

REM Setup environment paths relative to current directory
set PATH=%cd%\env\utils;%cd%\env\win32;%PATH%

REM Validate project structure
if not exist "%cd%\env\win32\mconf.exe" (
    echo.
    echo ERROR: MenuConfig executable not found
    echo Expected: %cd%\env\win32\mconf.exe
    echo Please run this script from the 'soft' directory of RDA8955 project
    echo.
    pause
    exit /b 1
)

if not exist "%cd%\env\menuconfig.sh" (
    echo.
    echo ERROR: MenuConfig shell script not found
    echo Expected: %cd%\env\menuconfig.sh
    echo Please run this script from the 'soft' directory of RDA8955 project
    echo.
    pause
    exit /b 1
)

REM ========================================================================
REM TARGET VALIDATION
REM ========================================================================

REM Check if target configuration exists
if not exist "%cd%\target\%TARGET%\target.config" (
    echo.
    echo ERROR: Target configuration not found
    echo Expected: %cd%\target\%TARGET%\target.config
    echo Available targets:
    if exist "%cd%\target" (
        for /d %%i in ("%cd%\target\*") do (
            if exist "%%i\target.config" echo   - %%~ni
        )
    )
    echo.
    pause
    exit /b 1
)

echo Target Config: target\%TARGET%\target.config
echo Working Directory: %SOFT_WORKDIR%
echo.

REM ========================================================================
REM MENUCONFIG LAUNCH
REM ========================================================================

echo [%time%] Initializing CSDTK environment...
call "%USER_CSDTK%\CSDTKvars.bat" || goto menuconfig_error

echo [%time%] Launching MenuConfig for %TARGET%...
echo.

REM Launch the menuconfig script with the specified target
bash env/menuconfig.sh %TARGET%

if errorlevel 1 goto menuconfig_error

echo.
echo [%time%] MenuConfig completed successfully
goto menuconfig_complete

REM ========================================================================
REM ERROR HANDLING
REM ========================================================================

:menuconfig_error
echo.
echo ========================
echo ***** MENUCONFIG FAILED *****
echo ========================
echo Error occurred at: %time%
echo Target: %TARGET%
echo Check the output above for details
echo.
pause
exit /b 1

:usage_help
echo.
echo ========================================================================
echo RDA8955 MenuConfig Script - Usage Information
echo ========================================================================
echo.
echo USAGE:
echo   %~nx0 [target]
echo.
echo PARAMETERS:
echo   target  - Target configuration to configure
echo             Default: 8955_modem if not specified
echo.
echo EXAMPLES:
echo   %~nx0           - Configure 8955_modem (default)
echo   %~nx0 8955_modem - Configure 8955_modem explicitly  
echo   %~nx0 8809_modem - Configure 8809_modem
echo   %~nx0 help      - Show this help message
echo.
echo AVAILABLE TARGETS:
if exist "%cd%\target" (
    for /d %%i in ("%cd%\target\*") do (
        if exist "%%i\target.config" echo   - %%~ni
    )
) else (
    echo   (No target directory found - please run from 'soft' directory)
)
echo.
echo SETUP REQUIREMENTS:
echo   1. Install CSDTK42 toolkit
echo   2. Run CSDTK42\env_set.bat (as administrator, one time only)
echo   3. Run this script from the 'soft' directory of your project
echo.
echo WHAT IS MENUCONFIG:
echo   MenuConfig is a configuration interface that allows you to:
echo   - Enable/disable features for your target
echo   - Configure hardware settings
echo   - Set build options
echo   - Customize your firmware build
echo.
echo ========================================================================
goto menuconfig_complete

:menuconfig_complete
echo.
echo ######  RDA8955 MENUCONFIG COMPLETE  ########