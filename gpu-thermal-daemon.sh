#!/bin/bash

# Configuration
GPU_ID=0
TARGET=65
MIN_POWER=175 
MAX_POWER=250
CURRENT_PL=$MAX_POWER
PYTHON_SCRIPT="/usr/local/bin/fan.py"
nvidia-smi -pm 1
FAN_IS_MANUAL=false

while true; do
  # Get Temperature
  RAW_TEMP=$(/usr/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i $GPU_ID 2>/dev/null)
  TEMP=$(echo "$RAW_TEMP" | tr -cd '0-9')
    
  if [[ -n "$TEMP" ]]; then
    
    # We use this to trigger the python script only when needed
    ACTION="none"

    # --- 1. FAN LOGIC ---
    if [ "$TEMP" -ge 65 ]; then
        FAN_SPEED=100
        MODE=1
        FAN_IS_MANUAL=true
        ACTION="manual"
    elif [ "$TEMP" -ge 55 ]; then
        FAN_SPEED=$(( 50 + (TEMP - 55) * 2 ))
        MODE=1
        FAN_IS_MANUAL=true
        ACTION="manual"
    elif [ "$FAN_IS_MANUAL" = true ]; then
        # This only runs if we were in manual and temp just dropped below 55
        MODE=0
        FAN_IS_MANUAL=false
        ACTION="set_auto"
    else
        # Already in auto and temp is low, do nothing
        MODE=0
        ACTION="none"
    fi
    # <--- This 'fi' was missing in your code!

    # --- 2. APPLY FAN CONTROL ---
    if [ "$ACTION" = "manual" ]; then
        echo "DEBUG: Temp $TEMP°C - Scaling Fans to $FAN_SPEED% (Manual)"
        python3 "$PYTHON_SCRIPT" "$FAN_SPEED" 1 &
    elif [ "$ACTION" = "set_auto" ]; then
        echo "DEBUG: Temp $TEMP°C - Returning to AUTO (Once)"
        python3 "$PYTHON_SCRIPT" 0 0 0 &
    fi

    # --- 3. POWER LOGIC ---
    if [ "$TEMP" -gt "$TARGET" ]; then
      if [ "$CURRENT_PL" -gt "$MIN_POWER" ]; then
        CURRENT_PL=$((CURRENT_PL - 10))
        nvidia-smi -i $GPU_ID -pl $CURRENT_PL > /dev/null
      fi
    elif [ "$TEMP" -lt "$TARGET" ] && [ "$CURRENT_PL" -lt "$MAX_POWER" ]; then
      CURRENT_PL=$((CURRENT_PL + 10))
      [ "$CURRENT_PL" -gt "$MAX_POWER" ] && CURRENT_PL=$MAX_POWER
      nvidia-smi -i $GPU_ID -pl $CURRENT_PL > /dev/null
    fi
  fi

  sleep 3
done
