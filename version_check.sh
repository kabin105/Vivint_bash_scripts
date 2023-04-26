#!/bin/bash
source params.sh

for ((j = 1; j <= "${#IP_last_digits[@]}"; j++)); do
  IP=$IP_COMMON"${IP_last_digits[j-1]}"
  echo "Camera number ${CAMERA_LABEL[j-1]} ($IP)"
  echo $(ssh root@$IP "cat /etc/version") # Print the firmware version of the camera
  echo ""
done
