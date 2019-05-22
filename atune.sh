#!/bin/bash
if [ -f '/proc/user_beancounters' ]
   then
   if [[ $(free -m | awk 'NR==4 { print $2 }') == 0 ]] || [[ "$host_type" == 'gd' ]]
      then
          version='40'
          ramCount=`awk 'match($0,/vmguar/) {print $4}' /proc/user_beancounters`
      else
          version='45'
          ramCount=`awk 'match($0,/oomguar/) {print $4}' /proc/user_beancounters`
   fi
   ramBase=-16 && for ((;ramCount>1;ramBase++)); do ramCount=$((ramCount/2)); done
else
   ramBase=$(free -g | awk 'NR==2 { print $2 }')
fi
num_processors=$(cat /proc/cpuinfo | grep processor | wc -l)
echo -e "StartServers $ramBase \nMaxSpareServers $(($ramBase*2 + 1)) \nServerLimit $(( 50 + (($ramBase**2)*10) + (($ramBase-2)*10) )) \nMaxClients $(( 50 + (($ramBase**2)*10) + (($ramBase-2)*10) )) \nMaxRequestsPerChild $(( 2048 + ($ramBase*256) ))"
