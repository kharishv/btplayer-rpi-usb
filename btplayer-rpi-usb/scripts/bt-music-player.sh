#!/bin/bash

MAC=""
LOCAL_DIR="/home/btplayer/Music"
USB_DIR=""

while true; do
    # 1. Ensure Bluetooth speaker is connected
    if ! bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        echo "Attempting to connect to Bluetooth speaker..."
        bluetoothctl connect "$MAC" > /dev/null 2>&1
        sleep 5
    fi

    # 2. If connected, play local folder first, then USB
    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then

        # Check and play local folder songs first
        if [ -d "$LOCAL_DIR" ] && ls "$LOCAL_DIR"/*.mp3 >/dev/null 2>&1; then
            echo "Playing from local directory: $LOCAL_DIR"
            while bluetoothctl info "$MAC" | grep -q "Connected: yes"; do
                # Check if local songs still exist, otherwise break to USB check
                local_has_songs=0
                for song in "$LOCAL_DIR"/*.mp3; do
                    [ -f "$song" ] || continue
                    local_has_songs=1
                    if ! bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
                        break 2
                    fi
                    ffplay -nodisp -autoexit -loglevel quiet "$song"
                done
                [ "$local_has_songs" -eq 1 ] && break
            done
        fi

        # Check and play USB directory songs next
        if [ -d "$USB_DIR" ] && ls "$USB_DIR"/*.mp3 >/dev/null 2>&1; then
            echo "Playing from USB directory: $USB_DIR"
            while bluetoothctl info "$MAC" | grep -q "Connected: yes"; do
                for song in "$USB_DIR"/*.mp3; do
                    [ -f "$song" ] || continue
                    if ! bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
                        break
                    fi
                    ffplay -nodisp -autoexit -loglevel quiet "$song"
                done
            done
        else
            echo "No audio files found in local folder or USB. Retrying in 10s..."
            sleep 10
        fi
    else
        echo "Speaker not connected. Retrying in 10 seconds..."
        sleep 10
    fi
done
