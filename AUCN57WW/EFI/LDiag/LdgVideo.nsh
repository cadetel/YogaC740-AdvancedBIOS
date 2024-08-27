##################################################################################
# LdgVideo.NSH - EFI Shell Script for LDIAG Video Test
#
# Usage: LdgVideo.NSH [LogPath]
#
# where  LogPath - Destination folder where Test Log/Result file shall be created
#                  ROOT folder shall be used as Default if not specified
#
#  Output:
#        TESTER.LOG     - Test Log
#        LdgVideo.DON   - Test Result Flag for PASS case
#        LdgVideo.ERR   - Test Result Flag for FAIL case
#
# History:
#        2015-02-21 S.Ikeda  Initial
#        2015-02-22 S.Ikeda  Added date/time info into *.ERR/*.DON file
###################################################################################
echo -off

########################## 
# SETUP
##########################
set -v LDGINI  config.ini
set -v LDGCONF LdgVideo.cfg
set -v FLGNAME LdgVideo
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
echo "Running LdgVideo.NSH -- Dated 2015-02-22 Rev.2" 
echo "Running LdgVideo.NSH -- Dated 2015-02-22 Rev.2" >>a %LOGPATH%TESTER.LOG

lenovoapp.efi -ini %LDGINI% -conf %LDGCONF%

if not %lasterror% == 0 then 
    set -v RSLT %lasterror%
    echo .
    echo LdgVideo.NSH:LDIAG Video Test Failed!! (RC = %lasterror%)
    echo LdgVideo.NSH:LDIAG Video Test Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
    echo LdgVideo.NSH:LDIAG Video Test Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
    date >>a %LOGPATH%%FLGNAME%.ERR
    time >>a %LOGPATH%%FLGNAME%.ERR
    echo .
else
    set -v RSLT %lasterror%
    echo .
    echo LdgVideo.NSH:LDIAG Video Test Passed!! (RC = 0)
    echo LdgVideo.NSH:LDIAG Video Test Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
    echo LdgVideo.NSH:LDIAG Video Test Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
    date >>a %LOGPATH%%FLGNAME%.DON
    time >>a %LOGPATH%%FLGNAME%.DON
    echo .
endif

date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo .
echo LdgVideo.NSH Completed.
echo LdgVideo.NSH Completed. >>a %LOGPATH%TESTER.LOG
echo .

:EXIT
exit /b %RSLT%

