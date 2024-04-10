@ECHO OFF
REM 
REM
REM  Maven3 initial .bat sets local & global settings
REM
REM

:BEGIN
	REM set M3_REPO=

	set M3_GLOBAL=
	set M3_USER=

	set M3_GLOBAL=%M2_HOME%/conf/settings.xml	
	set M3_USER=%M2_DATA%/eric/settings.xml
	
  	if "%1" == "" goto USAGE
	
	
:RUN_M3

	cls

REM	call mvn.bat -gs %M3_GLOBAL% -s %M3_USER% -DHOME=C: %1 %2 %3 %4 %5 %6

	call mvn.cmd -gs %M3_GLOBAL% -s %M3_USER% -DHOME=C: %1 %2 %3 %4 %5 %6 %7 %8 %9

	goto end

:USAGE

	echo.
	echo.
	echo Usage: m3 [maven options]
	echo.
	echo.
	
	goto END

:END


