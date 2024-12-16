#!/bin/bash

# Loud fan control script to lower speed of fan based on current
# max temperature of any cpu
#
# See README.md for details.

#set to false to suppress logs
DEBUG=false

# Make sure only root can run our script
if (( $EUID != 0 )); then
   echo "This script must be run as root:" 1>&2
   echo "sudo $0" 1>&2
   exit 1
fi


TEMPERATURE_FILE="/sys/devices/virtual/thermal/thermal_zone0/temp"
FAN_SPEED_FILE="/sys/class/hwmon/hwmon0/pwm1"
DEFAULT_FAN_SPEED=`cat ${FAN_SPEED_FILE}`
TEST_EVERY=3 #seconds
new_fan_speed_default=80
LOGGER_NAME=rp5-fan-control

#make sure after quiting script fan goes to auto control
function cleanup {
  ${DEBUG} && logger -t $LOGGER_NAME "event: quit; temp: auto"
  echo $DEFAULT_FAN_SPEED > $FAN_SPEED_FILE
}
trap cleanup EXIT

function exit_rp5_only_supported {
  ${DEBUG} && logger -t $LOGGER_NAME "event: non-rp5 $1"
  exit 2
}
if [ ! -f $TEMPERATURE_FILE ]; then
  exit_rp5_only_supported "a"
elif [ ! -f $FAN_SPEED_FILE ]; then
  exit_rp5_only_supported "b"
fi


current_max_temp=`cat ${TEMPERATURE_FILE} | cut -d: -f2 | sort -nr | head -1`
echo "fan control started. Current max temp: ${current_max_temp}"
echo "For more logs see:"
echo "sudo tail -f /var/log/syslog"

while [ true ];
do
  current_max_temp=`cat ${TEMPERATURE_FILE} | cut -d: -f2 | sort -nr | head -1`
  ${DEBUG} && logger -t $LOGGER_NAME "event: read_max; temp: ${current_max_temp}"

  new_fan_speed=0
  if (( ${current_max_temp} >= 75000 )); then
    new_fan_speed=255
  elif (( ${current_max_temp} >= 70000 )); then
    new_fan_speed=200
  elif (( ${current_max_temp} >= 68000 )); then
    new_fan_speed=130
  elif (( ${current_max_temp} >= 66000 )); then
    new_fan_speed=80 
  elif (( ${current_max_temp} >= 63000 )); then
    new_fan_speed=80
  elif (( ${current_max_temp} >= 60000 )); then
    new_fan_speed=0
  elif (( ${current_max_temp} >= 58000 )); then
    new_fan_speed=0
  elif (( ${current_max_temp} >= 55000 )); then
    new_fan_speed=0
  else
    new_fan_speed=0
  fi
  ${DEBUG} && logger -t $LOGGER_NAME "event: adjust; speed: ${new_fan_speed}"
  echo ${new_fan_speed} > ${FAN_SPEED_FILE}

  sleep ${TEST_EVERY}
done
