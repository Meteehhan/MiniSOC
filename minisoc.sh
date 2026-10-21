#!/bin/bash


# Terminal Colors
 RED='\033[0;31m'
 YELLOW='\033[1;33m'
 GREEN='\033[0;32m'
 CYAN='\033[0;36m'
 RESET='\033[0m'

printf "%s\n" "────────────────────────────────────────────────"
printf "                ${CYAN}MiniSOC v1.0${RESET}\n"
printf "             ${CYAN}Security Log Analyzer${RESET}\n"
printf "%s\n" "────────────────────────────────────────────────"
printf "\n"

incident_ip="192.168.56.20"

first_seen=$(grep "Failed password.*$incident_ip" logs/auth.log | head -n 1 | awk '{print $1}')
last_seen=$(grep "Failed password.*$incident_ip" logs/auth.log | tail -n 1 | awk '{print $1}')
username=$(grep "Failed password.*$incident_ip" logs/auth.log | head -n 1 | awk '{print $9}')
attempts=$(grep "Failed password.*$incident_ip" logs/auth.log | wc -l)

if [ "$attempts" -gt 10 ]
then
    incident_severity="HIGH"
elif [ "$attempts" -gt 5 ]
then
    incident_severity="MEDIUM"
else
    incident_severity="LOW"
fi

printf "\n"
printf '%b\n' "${CYAN}[ INCIDENT ]${RESET}"
printf "\n"
printf "IP          : %s\n" "$incident_ip"
printf "Service     : SSH\n"
printf "Username    : %s\n" "$username"
printf "First Seen  : %s\n" "$first_seen"
printf "Last Seen   : %s\n" "$last_seen"
printf "Attempts    : %s\n" "$attempts"
printf "Severity    : %s\n" "$incident_severity"



grep "Failed password" logs/auth.log | cut -d' ' -f11 | sort | uniq -c | while read count ip

  do

    if [ "$count" -gt 10 ]

    then

          severity="HIGH"

          elif  [ "$count" -gt 5 ]
          then
             severity="MEDIUM"
          else
              severity="LOW"

                 fi


               alert_key="$ip|failed_login|$count|$severity"
                if grep -Fxq "$alert_key" seen_alerts.log
                then
                    :
                  else


                   timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                    echo "[$timestamp]  [$severity] ALERT: $ip has $count failed login attempts" | tee -a alerts.log
                    echo "$alert_key" >> seen_alerts.log

                     fi

done

printf "\n"
printf "${CYAN}[ DETECTION ]${RESET}\n"
printf "\n"

         grep "Invalid user" logs/auth.log | while read line

do

            user=$(echo "$line" | awk '{print $6}')
            ip=$(echo  "$line" | awk '{print $8}')

            alert_key="$ip|invalid_user|$user"
             if grep -Fxq "$alert_key" seen_alerts.log
             then
                  : 
               else
                    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                    echo "[$timestamp] [MEDIUM] ALERT: Invalid user '$user' from IP $ip" | tee -a alerts.log
                    echo "$alert_key" >> seen_alerts.log
             fi

         done

            printf "\n"
            printf '%b\n' "${CYAN}[ CORRELATION ENGINE ]${RESET}"
            printf "\n"




   for ip in $(cut -d'|' -f1 seen_alerts.log | sort -u)
   do 
                   detection_count=$(awk -F'|' -v ip="$ip" '$1 == ip {print $2}' seen_alerts.log | sort -u | wc -l)

                   if [ "$detection_count" -gt 1 ]
                   then
                  

                             correlation_key="$ip|multi_detection"

                             if grep -Fxq "$correlation_key" seen_correlations.log
                             then 
                                 echo "DUPLICATE - correlation already exists"
                             else
                                 timestamp=$(date "+%Y-%m-%d %H:%M:%S")
                                 echo "[$timestamp] [HIGH] CORRELATION: $ip triggered multiple detection types" | tee -a alerts.log
                                 echo "$correlation_key" >> seen_correlations.log
                          
                             fi 
                    
                           fi
             
                           done 

high=$(grep "\[HIGH\]" alerts.log | wc -l)
    medium=$(grep "\[MEDIUM\]" alerts.log | wc -l)
   low=$(grep "\[LOW\]" alerts.log | wc -l)


                failed_logins=$(grep -i "Failed password" logs/auth.log | wc -l)
                invalid_users=$(grep -i "Invalid user" logs/auth.log | wc -l)
                correlations=$(wc -l < seen_correlations.log)

printf "\n"
printf '%b\n' "${CYAN}[ SUMMARY ]${RESET}"
printf "\n"
printf "  %-20s : %s\n" "Failed Login" "$failed_logins"
printf "  %-20s : %s\n" "Invalid User" "$invalid_users"
printf "  %-20s : %s\n" "Correlations" "$correlations"

printf "\n"
printf '%b\n' "${CYAN}[ SEVERITY ]${RESET}"
printf "\n"
printf "  %-20s : ${RED}${high}${RESET}\n" "HIGH Alerts"
printf "  %-20s : ${YELLOW}${medium}${RESET}\n" "MEDIUM Alerts"
printf "  %-20s : ${GREEN}${low}${RESET}\n" "LOW Alerts"

printf "\n"
printf '%b\n' "${CYAN}[ SYSTEM STATUS ]${RESET}"
printf "\n"
printf "  %-20s : ${GREEN}ACTIVE${RESET}\n" "Deduplication"
printf "  %-20s : ${GREEN}ACTIVE${RESET}\n" "Correlation Engine"

printf "\n"
printf "%s\n" "────────────────────────────────────────────────"
printf "                  ${CYAN}[HAN:SEC]${RESET}\n"
printf "%s\n" "────────────────────────────────────────────────"








