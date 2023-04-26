#!/bin/bash
source params.sh

for ((j = 1; j <= "${#IP_last_digits[@]}"; j++)); do
  IP=$IP_COMMON"${IP_last_digits[j-1]}" # Complete IP for each camera
  echo "Camera ${CAMERA_LABEL[j-1]} ($IP)" # Print which camera's info is going to be displayed
  scp ./zdata_compile.sh root@$IP:/mnt/sdcard0/ # Copy zdata_compile.sh to each camera
  ssh root@$IP "chmod +x /mnt/sdcard0/zdata_compile.sh" # Make the copied file executable
  echo "" # New line
done
