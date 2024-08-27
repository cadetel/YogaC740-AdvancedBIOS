##################################################################################
# LdgStorage.NSH - EFI Shell Script for LDIAG Run-In Test
#
# Usage: LdgStorage.NSH [LogPath]
#
# where  LogPath - Destination folder where Test Log/Result file shall be created
#                  ROOT folder shall be used as Default if not specified
#
#  Output:
#        TESTER.LOG       - Test Log
#        LdgStorage.DON   - Test Result Flag for PASS case
#        LdgStorage.ERR   - Test Result Flag for FAIL case
#
# History:
#        2015-02-21 S.Ikeda  Initial
#        2015-02-22 S.Ikeda  Added date/time info into *.ERR/*.DON file
#        2015-06-18 S.Ikeda  Updated for NVMe SSD Test Support with UEFI Diag V2.8.1
#                            Modified to terminate test and exit script on error case
###################################################################################
echo -off

########################## 
# SETUP
##########################
set -v LDGINI  config.ini
set -v LDGCONFNVME LdgStorageNVMe.cfg
set -v LDGCONFSATA LdgStorageSATA.cfg
set -v FLGNAME LdgStorage
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
##@SI20150618-START-
#copy %LDGCONF%  fs0:\
copy %LDGCONFNVME%  fs0:\
copy %LDGCONFSATA%  fs0:\
##@SI20150618-END-

##########################
# START
##########################
date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo "Running LdgStorage.NSH -- Dated 2015-06-18 Rev.1" 
echo "Running LdgStorage.NSH -- Dated 2015-06-18 Rev.1" >>a %LOGPATH%TESTER.LOG

##@SI20150618-START-
:NVME
    map >a map.log
    FINDSTRG.EFI NVME map.log
    if %lasterror% == 0 then
        # no NVMe SSD installed
        goto NVME_END
    endif

    echo "Starting Storage Test for NVMe SSD ..." 
    echo "Starting Storage Test for NVMe SSD ..." >>a %LOGPATH%TESTER.LOG
    lenovoapp.efi -ini %LDGINI% -conf %LDGCONFNVME%

    if not %lasterror% == 0 then 
        set -v RSLT %lasterror%
        echo .
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Failed!! (RC = %lasterror%)
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .    
        ##@SI20150618a
        goto TEST_END
    else
        set -v RSLT %lasterror%
        echo .
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Passed!! (RC = 0)
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgStorage.NSH:LDIAG Storage Test for NVMe SSD Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif

:NVME_END

:SATA
    map >a map.log
    FINDSTRG.EFI SATA map.log
    if %lasterror% == 0 then
        # no SATA Storage installed
        goto SATA_END
    endif

    echo "Starting Storage Test for SATA Storage ..." 
    echo "Starting Storage Test for SATA Storage ..." >>a %LOGPATH%TESTER.LOG
    lenovoapp.efi -ini %LDGINI% -conf %LDGCONFSATA%

    if not %lasterror% == 0 then 
        set -v RSLT %lasterror%
        echo .
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Failed!! (RC = %lasterror%)
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .   
        ##@SI20150618a
        goto TEST_END
    else
        set -v RSLT %lasterror%
        echo .
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Passed!! (RC = 0)
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgStorage.NSH:LDIAG Storage Test for SATA Storage Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif

:SATA_END
##@SI20150618-END-

##@SI20150618a
:TEST_END

date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo .
echo LdgStorage.NSH Completed.
echo LdgStorage.NSH Completed. >>a %LOGPATH%TESTER.LOG
echo .

:EXIT
exit /b %RSLT%

