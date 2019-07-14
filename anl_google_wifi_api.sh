#!/bin/bash
#title           :AnilPrz Google WiFi API Report
#description     :This script logs Google WiFi Diagnostic Report and stores active ( or with defined name ) device into spreadsheet Format
#author          :Anil Prajapati
#date            :2019-06-05
#version         :1
#usage           :bash gitpush.sh ( use CRON to keep logging )
#dependency      :HTTPIE library, Google WiFi, Linux (only tested with Ubuntu 18),
#notes           :This is a personal script to make my life easier.
#bash_version    :4.1.5
#==============================================================================

#"CURL" was not working for me that's why not using this below command and using HTTPIE instead
#curl http://192.168.86.1/api/v1/diagnostic-report -o "$filename"

if ! which http >/dev/null; then
     echo "" 
     echo "Command 'http' not found, but can be installed with"
     echo ""
     echo "sudo apt install httpie"
     echo ""
fi

echo 
echo "Generating report and download from Google Wifi Diagnostics . . . "
echo 
http --download http://192.168.86.1/api/v1/diagnostic-report --output google_diagnotic.dump

echo 
echo "Download completed."
echo
echo "Processing data . . . "
echo 

file="google_diagnotic.dump"
save="google.report.csv"
exist=0

declare -A station
station[station_id]=""
station[mdns_name]=""
station[connected]=""
station[ip_addresses]=""
station[dhcp_hostname]=""
station[last_seen_seconds_since_epoch]=""
station[wireless_interface]=""
station[oui]=""

while IFS= read -r line
do
    if [[ $line == *"station_info"* ]];
    then
        exist=1
        continue
    fi

    if [[ $exist == 1 && $reset == 0 ]];
    then
        exist=1
        if [[ $line == *"dhcp_hostname"* && $line == *"\"\""* ]];
        then
            # all data of this associate array is JUNK - reset is required
            # and will perform in next loop
            reset=1
            continue
        else
            for i in "${!station[@]}"
            do
                if [[ $line == *"$i"* ]];
                then
                    value=$(sed 's/.*'$i':\(.*\)/\1/' <<< $line)
                    station[$i]=$(echo -e $value)
                    continue 1
                fi
            done
        fi
    fi

    if [[ $line == *"guest"* ]];
    then
        if [[ $reset == 0 ]];
        then
            line_text=""
            for i in "${!station[@]}"
            do
                if [[ ${station[station_id]} == "" ]];
                then
                    break
                fi

                if [ -z "$line_text" ]
                then
                     line_text="${station[$i]},"
                else
                    line_text="$line_text${station[$i]},"
                fi
            done

            echo $line_text >> $save
            line_text=""
        fi
        reset=0
        station[station_id]=""
        station[mdns_name]=""
        station[connected]=""
        station[ip_addresses]=""
        station[dhcp_hostname]=""
        station[last_seen_seconds_since_epoch]=""
        station[wireless_interface]=""
        station[oui]=""
        continue
    fi

    # End Reporting Loop
    if [[ $line == *"port_forwardings"* ]];
    then
        break
    fi

done < "$file"

echo
echo "Successfully exported Google wifi Diagnotics to CSV Formated file"
echo 
echo "Thank you for using. Namaste !!!"
echo

exit 0
