This script is designed for nvidia rtx carrds to ofer a more advanced gpu thermal control on linux system
it is using a python script and nvml
Scope is change the speed of the fans proportional to gpu temp and after fans are at 100 throthle down the power available to  tyhe card   
It can be instaled as a service with  systemctl( i provided the unit file for easy configuration)
It is build using gemini and tested as a service on my system 
Thermal control is left on auto till 55 celsius 

Between 55 and 65 celsius temperature is controled by pushing the fans progresively to maximum using nvml
Over 65 the power available to the card is reduced until the temp lowers drops below 65 

u can easely modify the temnperature limits editing the sh file 
to install as a service use the folowing steps 
copy the sh and py file in usr/local/bin
copy the service file in /etc/systemctl/system
execute 
systemctl daemon-reload
systemctl start gpu-thermal-service 
u can monitor it's activity by runing 
journalctl -u gpu-thermal.service -f
if u wanna test the behaviour i recomend installing gpu-burn and runing that in a side window while the script is runing 

Disclamer this is a PERSONAL experiment created to acomodate my card 5070 on a ubuntu system that was overheating it on auto behaviour 
or reducing the power available to early and generating issues 
!!!! Use at ur own risk !!!! 
