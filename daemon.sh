#! /bin/sh

# Exit behavior
trap cleanup EXIT

cleanup() {
  echo $DEFAULT_SPEED > $FAN_CONTROL
}

WAIT_TIME=2

# Speed control
DEFAULT_SPEED=20

# Control files
FAN_CONTROL=/sys/class/hwmon/hwmon1/pwm1
TEMP_FILE=/sys/class/hwmon/hwmon2/temp1_input

while true;
do
  # Get the temperature
  current_temperature=$(cat $TEMP_FILE)

  new_speed=0

  if [ $current_temperature -ge 75000 ]; then
    new_speed=255
  elif [ $current_temperature -ge 70000 ]; then
    new_speed=200
  elif [ $current_temperature -ge 68000 ]; then
    new_speed=130
  elif [ $current_temperature -ge 66000 ]; then
    new_speed=80 
  elif [ $current_temperature -ge 63000 ]; then
    new_speed=80
  elif [ $current_temperature -ge 60000 ]; then
    new_speed=0
  elif [ $current_temperature -ge 58000 ]; then
    new_speed=0
  elif [ $current_temperature -ge 55000 ]; then
    new_speed=0
  else
    new_speed=0
  fi

  echo $new_speed > $FAN_CONTROL

  sleep $WAIT_TIME
done


