##################################################################################
# LdgPlanar.NSH - EFI Shell Script for LDIAG Planar Test
#
# Usage: LdgPlanar.NSH [LogPath]
#
# where  LogPath - Destination folder where Test Log/Result file shall be created
#                  ROOT folder shall be used as Default if not specified
#
#  Output:
#        TESTER.LOG      - Test Log
#        LdgPlanar.DON   - Test Result Flag for PASS case
#        LdgPlanar.ERR   - Test Result Flag for FAIL case
#
# History:
#        2015-02-21 S.Ikeda  Initial
#        2015-02-22 S.Ikeda  Added date/time info into *.ERR/*.DON file
#        2015-06-18 S.Ikeda  Updated for Unattended USB port test support with 
#                            UEFI Diagnostics V2.8.1
###################################################################################
echo -off

########################## 
# SETUP
##########################
set -v LDGINI  config.ini
set -v LDGCONF LdgPlanar281.cfg
set -v FLGNAME LdgPlanar
set -v LOGPATH .\

if not %1 == "" then
    set -v LOGPATH %1
endif 

if exist %LOGPATH%%FLGNAME%.ERR then 
     del %LOGPATH%%FLGNAME%.ERR
endif

if exist %LOGPATH%%FLGNAME%.DON then 
     del %LOGPATH%%FLGNAME%.DON
endif

############################################################
# WORKAROUND - COPY REFERENCED FILES TO ROOT FOLDER on fs0:
############################################################
copy %LDGINI%   fs0:\
copy %LDGCONF%  fs0:\

##########################
# START
##########################
date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo "Running LdgPlanar.NSH -- Dated 2015-06-18 Rev.0" 
echo "Running LdgPlanar.NSH -- Dated 2015-06-18 Rev.0" >>a %LOGPATH%TESTER.LOG

lenovoapp.efi -ini %LDGINI% -conf %LDGCONF%

if not %lasterror% == 0 then 
    set -v RSLT %lasterror%
    echo .
    echo LdgPlanar.NSH:LDIAG Planar Test Failed!! (RC = %lasterror%)
    echo LdgPlanar.NSH:LDIAG Planar Test Failed!! (RC = %lasterror%)>>a %LOGPATH%TESTER.LOG
    echo LdgPlanar.NSH:LDIAG Planar Test Failed!! (RC = %lasterror%) >a %LOGPATH%%FLGNAME%.ERR
    date >>a %LOGPATH%%FLGNAME%.ERR
    time >>a %LOGPATH%%FLGNAME%.ERR
    echo .
else
    set -v RSLT %lasterror%
    echo .
    echo LdgPlanar.NSH:LDIAG Planar Test Passed!! (RC = 0)
    echo LdgPlanar.NSH:LDIAG Planar Test Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
    echo LdgPlanar.NSH:LDIAG Planar Test Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
    date >>a %LOGPATH%%FLGNAME%.DON
    time >>a %LOGPATH%%FLGNAME%.DON
    echo .
endif

date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo .
echo LdgPlanar.NSH Completed.
echo LdgPlanar.NSH Completed. >>a %LOGPATH%TESTER.LOG
echo .

:EXIT
exit /b %RSLT%

