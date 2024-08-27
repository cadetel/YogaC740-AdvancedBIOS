@echo -on
fs0:
cd\
cd \EFI\LDiag
if exist fs0:\EFI\LOG\ShellSSDPS.LOG then
rm fs0:\EFI\LOG\ShellSSDPS.LOG -q
endif

:SSD_Test

fs0:\EFI\LDiag\LdgStorage.nsh
stall 2000000
if exist fs0:\EFI\LDiag\LdgStorage.DON then
goto Shell_ps
endif

:fail
echo ******** SSD Test Fail ********
echo ******** SSD Test Fail ********
pause -q
goto fail

:Shell_ps
echo ******** Test PASS ********
pause -q

echo UEFI shell SSD Test PASS !! > fs0:\EFI\LOG\ShellSSDPS.LOG
if not exist fs0:\EFI\LOG\ShellSSDPS.LOG then
goto Shell_ps
endif

:cp_boot_w10

if exist fs0:\EFI\Boot\bootx64.efi then
rm fs0:\EFI\Boot\bootx64.efi
endif

cp fs0:\EFI\Boot\bootx64.efi_w10 fs0:\EFI\Boot\bootx64.efi -q
if %lasterror% == 0 then
goto re_start
endif
stall 5000000
goto cp_boot_w10

:re_start
reset -w
reset -w
stall 1000000
pause -q
pause -q
