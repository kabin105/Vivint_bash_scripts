#!/bin/bash
source params.sh # Include the parameters

path=$(pwd) # file path in your local computer where TestLogs directory will be created

######## YOU MAY WANT TO CHANGE THESE VARIABLES #########
file_name="HDRAM" # If each file name will be like: HDRAM1.tar.gz, HDRAM2.tar.gz, etc.
log_folder_name="Tars" # All the files will be saved in the folder with this name

# This asks user if it shoould continue or abort
echo "If you continue, you will lose [TestLog] folder in [$path] (if you already have it) and all of its contents. If you wish to continue, enter [y]. Otherwise, enter any keys to abort."
read continue

# If user entered "y" abort the program
if [[ "$continue" != "y" ]]; then
  exit 1
fi

path_log_folder=$path/$log_folder_name # This is where log files are saved
rm -r $path_log_folder # Make sure you already do not have a folder that has the same name
mkdir $path_log_folder # Make a new directory where you want to put your tar files

for ((j = 1; j <= "${#IP_last_digits[@]}"; j++)); do
  IP=$IP_COMMON"${IP_last_digits[i-1]}" # Complete IP for each camera
  
  echo "Camera ${CAMERA_LABEL[i-1]} ($IP)"

  ssh root@$IP "
    cd /mnt/sdcard0
    rm -r TestLog
    mkdir TestLog
    scp /mnt/sdcard0/* /mnt/sdcard0/TestLog
    rm HDRAM${CAMERA_LABEL[i-1]}.tar.gz
    tar cvzf HDRAM${CAMERA_LABEL[i-1]}.tar.gz /mnt/sdcard0/TestLog
  "
  
  scp root@$IP:/mnt/sdcard0/HDRAM${CAMERA_LABEL[i-1]}.tar.gz $path_log_folder
  
  echo "" # New line to separate info from next camera's info
done

