##################################################################################
# LdgRunIn.NSH - EFI Shell Script for LDIAG Run-In Test
#
# Usage: LdgRunIn.NSH [LogPath]
#
# where  LogPath - Destination folder where Test Log/Result file shall be created
#                  ROOT folder shall be used as Default if not specified
#
#  Output:
#        TESTER.LOG     - Test Log
#        LdgRunIn.DON   - Test Result Flag for PASS case
#        LdgRunIn.ERR   - Test Result Flag for FAIL case
#
# History:
#        2015-02-21 S.Ikeda  Initial
#        2015-02-22 S.Ikeda  Added date/time info into *.ERR/*.DON file
#        2015-03-30 S.Ikeda  Changed Storage test from LSC UEFI Diag to LNV UEFI Diag (HDTEST.EFI)
#                            to support the test on NVMe SSD 
#                            Changed test configuration file for LSC UEFI diag from LdgRunIn.cfg
#                            to LdgRunInNoStorage.cfg (w/o Storage test items)
#        2015-04-06 S.Ikeda  Updated to add FAN/Thermal Sensor Test with TPFANTST.EFI/TPTHMTST.EFI
#        2015-06-18 S.Ikeda  Updated for LSC UEFI Diagnostics V2.8.1 with below changes
#                             - CPU Test supported
#                             - NVMe SSD Test Supported
#                             - HDTEST.EFI replaced with original LSC UEFI Diag Storage Test due to instability
###################################################################################
echo -off

########################## 
# SETUP
##########################
set -v LDGINI  config.ini
##@SI20150618-START-
set -v LDGCONF LdgRunIn281.cfg
set -v LDGCONFNVME LdgStorageNVMe.cfg
set -v LDGCONFSATA LdgStorageSATA.cfg
##@SI20150618-END-
set -v FLGNAME LdgRunIn
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
##@SI20150618-START-
copy %LDGCONFNVME%  fs0:\
copy %LDGCONFSATA%  fs0:\
##@SI20150618-END-

################################
# START TEST WITH LSC UEFI DIAG
################################
date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo "Running LdgRunIn.NSH -- Dated 2015-06-18 Rev.0" 
echo "Running LdgRunIn.NSH -- Dated 2015-06-18 Rev.0" >>a %LOGPATH%TESTER.LOG

lenovoapp.efi -ini %LDGINI% -conf %LDGCONF%

if not %lasterror% == 0 then 
    set -v RSLT %lasterror%
    echo .
    echo LdgRunIn.NSH:LDIAG RunIn Test Failed!! (RC = %lasterror%)
    echo LdgRunIn.NSH:LDIAG RunIn Test Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
    echo LdgRunIn.NSH:LDIAG RunIn Test Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
    date >>a %LOGPATH%%FLGNAME%.ERR
    time >>a %LOGPATH%%FLGNAME%.ERR
    echo .    
else
    set -v RSLT %lasterror%
    echo .
    echo LdgRunIn.NSH:LDIAG RunIn Test Passed!! (RC = 0)
    echo LdgRunIn.NSH:LDIAG RunIn Test Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
    echo LdgRunIn.NSH:LDIAG RunIn Test Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
    date >>a %LOGPATH%%FLGNAME%.DON
    time >>a %LOGPATH%%FLGNAME%.DON
    echo .
endif

##@SI20150618-START-
if %RSLT% == 0 then

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
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Failed!! (RC = %lasterror%)
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .    
    else
        set -v RSLT %lasterror%
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Passed!! (RC = 0)
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for NVMe SSD Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif

:NVME_END
endif

if %RSLT% == 0 then

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
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Failed!! (RC = %lasterror%)
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .    
    else
        set -v RSLT %lasterror%
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Passed!! (RC = 0)
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Storage Test for SATA Storage Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif

:SATA_END
endif
##@SI20150618-END-

##@SI20150403-START-
if %RSLT% == 0 then
    if exist TPFANTST.LOG then 
        del TPFANTST.LOG
    endif

    echo "Starting FAN Test with TPFANTST ..." 
    echo "Starting FAN Test with TPFANTST ..." >>a %LOGPATH%TESTER.LOG
    TPFANTST.EFI

    if not %lasterror% == 0 then 
        set -v RSLT %lasterror%
        type TPFANTST.LOG >>a %LOGPATH%TESTER.LOG
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Failed!! (RC = %lasterror%)
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .    
    else
        set -v RSLT %lasterror%
        type TPFANTST.LOG >>a %LOGPATH%TESTER.LOG
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Passed!! (RC = 0)
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn FAN Test with TPFANTST Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif

endif

if %RSLT% == 0 then
    if exist TPTHMTST.LOG then 
        del TPTHMTST.LOG
    endif

    echo "Starting Thermal Sensor Test with TPTHMTST ..." 
    echo "Starting Thermal Sensor Test with TPTHMTST ..." >>a %LOGPATH%TESTER.LOG
    TPTHMTST.EFI

    if not %lasterror% == 0 then 
        set -v RSLT %lasterror%
        type TPTHMTST.LOG >>a %LOGPATH%TESTER.LOG
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Failed!! (RC = %lasterror%)
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Failed!! (RC = %lasterror%) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Failed!! (RC = %lasterror%) >a  %LOGPATH%%FLGNAME%.ERR
        date >>a %LOGPATH%%FLGNAME%.ERR
        time >>a %LOGPATH%%FLGNAME%.ERR
        del %LOGPATH%%FLGNAME%.DON
        echo .    
    else
        set -v RSLT %lasterror%
        type TPTHMTST.LOG >>a %LOGPATH%TESTER.LOG
        echo .
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Passed!! (RC = 0)
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Passed!! (RC = 0) >>a %LOGPATH%TESTER.LOG
        echo LdgRunIn.NSH:LDIAG RunIn Thermal Sensor Test with TPTHMTST Passed!! (RC = 0) >a  %LOGPATH%%FLGNAME%.DON
        date >>a %LOGPATH%%FLGNAME%.DON
        time >>a %LOGPATH%%FLGNAME%.DON
        echo .
    endif
endif
##@SI20150403-END-


date >>a %LOGPATH%TESTER.LOG
time >>a %LOGPATH%TESTER.LOG
echo .
echo LdgRunIn.NSH Completed. 
echo LdgRunIn.NSH Completed. >>a %LOGPATH%TESTER.LOG
echo .

:EXIT
exit /b %RSLT%

