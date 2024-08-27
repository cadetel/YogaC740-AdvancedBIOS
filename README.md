# ⚠️I AM NOT RESPONSIBLE IF YOU BRICK YOUR LAPTOP. DO THIS AT YOUR OWN RISK⚠️
# ONLY TRY THIS ON A `LENOVO YOGA C940-14IIL`
# Lenovo Yoga C940-14IIL Advanced Bios
## Instructions
### Step 1
Firstly, you need to verify what your Bios version is. You can do this by going into the bios and it will be stated on the Information Tab.
Alternatively you can lookup `System Information` on windows and find **Bios Version**. My bios version is "AUCN`62`WW". if the 2 numbers are above `57`, move onto step 2. If its `57` or below, move to Step 4
### Step 2
First we are going to go to disk manager and delete all partitons on a USB, make sure you backup your files before doing this.
Create a new partition for 1500MB and leave the name blank. The file system will be formatted to `FAT32`
### Step 3
Download the files from the releases and copy `Veyron.fd` onto your USB.
Shut off your Laptop and follow these steps very **carefully**:
Plug in USB, unplug pc from power.
Hold `Fn+R`, Plug power in, Press power
Continue to hold `Fn+R` for an additional 5-10 seconds.
You should have a `blank screen` for some seconds and it then should go onto a `Blue loading bar`. Wait for it to **BOOT INTO WINDOWS**
### Step 4
Boot into BIOS (F12 or Fn+F12) and enable `Bios Backflash` and click `F10` to save and exit.
Boot back into windows.
Go to disk manager and delete all partitons on a USB, make sure you backup your files before doing this.
Create a new partition for 1500MB and leave the name blank. The file system will be formatted to `FAT32` again.
This time we are going into the `AUCN57WW` folder and copying `AUCN57WW.efi`,`EFI`,`Startup.nsh` into the root of your USB.
### Step 5
Reboot your laptop and go into the boot menu (F12 or Fn+F12)
Select `EFI USB Device` and click `Esc` when it loads. P.S: you only have 3 seconds to do this.
Type `fs:0` and click enter.
Now type `Startup.nsh` and click enter.
Wait for it to reboot back into windows.
Restart into the BIOS (F2 or Fn+F12)
Finally, you will see an `Advanced` tab where you can unlock CFG and DVMT and Disable/Enable more stuff.
