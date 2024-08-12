@echo off
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set h=%time:~0,2%
set m=%time:~3,2%
set s=%time:~6,2%
IF "%h:~0,1%"==" " set h=0%TIME:~1,1%

set f=%yyyy%.%mm%.%dd%_%h%.%m%.%s%_Bestellung_LB_ZH.xlsb
copy .\A3-Bestellhilfe_LB_ZH\A3-Bestellhilfe_LB_ZH_Vorlage.xlsb "%f%" > NUL
start "C:\Programme\Microsoft Office\OFFICE11\excel.exe" "%f%"
