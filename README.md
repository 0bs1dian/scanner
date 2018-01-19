# scanner
This is basically just a simple bash script that leverages nmap and a clever breakdown of iterating through all ports, slowly, and with artificial pauses.  This has been effective as a penetration testing tool in order to fool some IDS/IPS/FW into not blacklisting the originator's IP when the threshold is met on an certain agressive types of NMAP scans.  
Originally created for OSCP pen testing labs.
