# Bash Scripts for Checking Log Files
By using these bash scripts in this repo, you do not have to ssh into individual devices to check the logs. If you have any questions or suggestions, please feel free to contact Hyunook Kim at kabin105@gmail.com or hyunook.kim@vivint.com

## HDRAM Log Checking Set-up
Please follow this instruction to set up automated log checking for HDRAM loading test.

**1. Add Camera Info in ```params.sh```**

Let's say you have three cameras to check whose IP addresses are 10.1.24.1, 10.1.24.2, and 10.1.24.3 whose labels are 1, 3, and 5 respectively.

1.1) Set the variable ```IP_COMMON``` as the common part of the IP addresses, which is "10.1.24." in our case.
```
IP_COMMON="10.1.24."
```

1.2) Assign unique parts of IPs to the variable of list ```IP_last_digits```.
```
IP_last_digits=(
  '1' '2' '3'
)
```

1.3) Assign the labels for the cameras to the variable of list ```CAMERA_LABEL```.
```
CAMERA_LABEL=(
  '1' '3' '5'
)
```

1.4) Set the name of the output csv file. The log data will be written to the csv file of this name and formated such that you can simply copy and paste the block of data to the excel sheet.
```
CSV_Filename="hdram_log.csv"
```

1.5) Make sure to save your changes before closing the file.


**2. Generate SSH Keys**

This step generates ssh keys for the cameras.

2.1) In terminal, cd into this repo, ```Vivint_bash_scripts```.

2.2) run ```ssh_keygen.sh```. Make sure that you are in this repo because of relative file path issues in the script.


**3. Copy ```zdata_compile.sh``` to Each Camera**

```zdata_compile.sh``` file is provided in this repo.

3.1) Run ```copy_zdata.sh```. Again, make sure you are still in Vivint_bash_scripts repo.

3.2) Now the ```zdata_compile.sh``` file should be copied into each camera and made executable. You can verify this by randomly ssh into a few cameras and see if  ```zdata_compile.sh``` exists in ```/mnt/sdcard0/```. 


**4. Check Clock Name**

This step is necessary because the names of clock may vary depending on the software version. For example, I had gclk_sd1, gclk_sd2, and gclk_sd3 for one version, but for another version they were gclk_sdxc, gclk_sdio, and gclk_sd.

4.1) SSH into any camera, run ```zdata_compile.sh```, and check the clock mames.

4.2) You may need to modify ```scan_high_dram.sh``` in lines 5, 6, 7, 31, 32, 33, 41, 42, 43, 61, 62, 63, 66, 67, 68, 71, 72, 73, 111, and 116 according to the clock names.


## HDRAM Daily Log Checking

Once the setup is done, you can simply run ```scan_high_dram.sh``` to get all the log data, which will be saved and formatted as a .csv file. Again, make sure you are still in Vivint_bash_scripts repo.

Then, open the .csv file and copy the data into the spread sheet report. A sample formatting of the spreadsheet will be provided in this repo.

## Compress Log Files 

You can compress and save the log files once the test is completed in case you want to access them later. 

1) By default, it will make a new directory called "Tars" where tar files will be generated. You can customize the folder name and the file names in ```create_tar.sh```. Note that it will overwrite the old files.

2) In terminal, cd into the ```Vivint_bash_scripts``` repo and run ```create_tar.sh```.

3) Move or save the generated folder with tar files before they get overwritten.


## Other files
```version_check.sh``` checks the firmware version of each camera

```scan_error_coati.sh``` checks the SD card errors. More detailed instrcutions about this to be written later.


