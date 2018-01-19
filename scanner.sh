#!/bin/bash

#Rakshasha OSCP 2017

if [ -z "$1" ]
 then 
   echo "Please supply a target as an argument.  Usage:  ./<scriptname> <ip>"
   exit
fi
echo "This scan does not conduct any NSE scans."
echo "This scan does not guarantee anything."
echo "This scan is meant to scan a full range slower than normal"
echo "camoflaging the scan signature to fool some HIPS/HIDS."
echo "This scan is meant to be supplemental to your normal scan techniques."
echo "If this is a lab machine or VM, you should revert it after this scan."
echo " ... "
echo "Scaning the following IP, here is a preview: " 
nmap --top-ports 25 --open $1
echo "Threshold scan status:"
start=1
end=500
for value in {1..65536}
do
 if [[ $start -eq 65000 ]];
  then
   end=65535 
 fi 

  #echo "Scanning between port " $start " and port  " $end

  if [[ $start -lt 500 ]]
   then
    echo -ne "[#          ]  5%  \r"
  #These are toooootally random percentages by the way.
  fi
  if [[ $start -gt 501 ]]
   then
    echo -ne "[#          ] 11%  \r"
  fi
  if [[ $start -gt 2001 ]]
   then
    echo -ne "[##         ] 20%  \r"
  fi
  if [[ $start -gt 9999 ]]
   then
    echo -ne "[###        ] 30%  \r"
  fi
  if [[ $start -gt 30000 ]]
   then
    echo -ne "[###        ] 40%  \r"
  fi
  if [[ $start -gt 60000 ]]
   then
    echo -ne "[#####     ]  49%  \r"
  fi
  #These nmap values are VERY flexible for you, adjust as necessary.
  nmap -vv --max-rtt-timeout 500ms --scan-delay 4ms --max-retries 1 -vv -sS --open -p $start-$end $1 >> $1.txt

  sleep 1

   if [[ $start -eq 1 ]];
   then 
     start=0
   fi

   start=$((start+500))
   end=$((end+500))
 
   if [[ $end -ge 65536 ]];
    then
     break 
   fi 

#echo cat scan_results | grep open

done

sleep 2
echo -ne "[######    ]  60% Scanning UDP \r"
nmap -sU --top-ports 150 --open $1 >> $1_udp.txt
echo -ne "[########  ]  80% Service ID   \r"
cat $1.txt | grep open | grep -v "Discovered" | cut -d "/" -f1 > tcp.txt;echo "TCP:" >> $1_final.txt;cat tcp.txt|while read line; do nmap -p $line -sV 10.11.1.72 | grep open >> $1_final.txt; done
echo "UDP:" >> $1_final.txt
echo -ne "[##########]  92% almost done..\r"
sleep 2
cat $1_udp.txt | grep open >> $1_final.txt
rm $1.txt
mv $1_final.txt $1.txt
rm tcp.txt $1_udp.txt
echo -ne "[##########]  100% Done!...\n"
cat $1_final.txt
