#!/bin/sh
# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-bluetooth-bluetoothctl

bluetooth_print() {
    bluetoothctl | grep --line-buffered 'Device\|#' | while read -r REPLY; do
        if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then

			if bluetoothctl show | grep -q "Powered: yes"; then
				printf '%%{F#F0C674}󰂯%%{F-}'
			else 
				echo "%{F#F0C674}󰂲"
				exit 0
			fi

			devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
			counter=0

            for device in $devices_paired; do
                device_info=$(bluetoothctl info "$device")

                if echo "$device_info" | grep -q "Connected: yes"; then
                    device_output=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)
                    device_battery_percent=$(echo "$device_info" | grep "Battery Percentage" | awk -F'[()]' '{print $2}')

                    if [ -n "$device_battery_percent" ]; then
                        if [ "$device_battery_percent" -gt 98 ]; then
                        	device_battery_icon="󰁹"
                        elif [ "$device_battery_percent" -gt 90 ]; then
                            device_battery_icon="󰂂"
                        elif [ "$device_battery_percent" -gt 80 ]; then
                            device_battery_icon="󰂁"
                        elif [ "$device_battery_percent" -gt 70 ]; then
                            device_battery_icon="󰂀"
                        elif [ "$device_battery_percent" -gt 60 ]; then
                            device_battery_icon="󰁿"
                        elif [ "$device_battery_percent" -gt 50 ]; then
                            device_battery_icon="󰁾"
                        elif [ "$device_battery_percent" -gt 40 ]; then
                            device_battery_icon="󰁽"
                        elif [ "$device_battery_percent" -gt 30 ]; then
                            device_battery_icon="󰁼"
                        elif [ "$device_battery_percent" -gt 20 ]; then
                            device_battery_icon="󰁻"
                        elif [ "$device_battery_percent" -gt 10 ]; then
                            device_battery_icon="󰁺"
                        else
                            device_battery_icon="󰂃"
                        fi

                        device_output="%{F#F0C674}$device_battery_icon%{F-} $device_output"
                    fi

                    if [ $counter -gt 0 ]; then
                        printf ", %s" "$device_output"
                    else
                        printf " %s" "$device_output"
                    fi

                    counter=$((counter + 1))
                fi
            done

            printf '\n'
        else
            echo "bt service disabled"
        fi
    done
}

bluetooth_connect() {
	devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
	echo "$devices_paired" | while read -r line; do
		bluetoothctl connect "$line" >> /dev/null
	done
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        bluetooth_connect
    else
        devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    --connect)
		bluetooth_connect
    	;;
    *)
        bluetooth_print
        ;;
esac
