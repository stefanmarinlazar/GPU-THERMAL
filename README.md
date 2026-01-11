This script is designed for nvidia rtx carrds to ofer a more advanced gpu thermal control on linux system
it is using a python script to change the speed of the fans and a sh script to integrate the temperature loging in the system 
It can be instaled as a service with  systemctl
It is build using gemini and tested as a service on my system 
Thermal control is left on auto till 55 celsius 
Between 55 and 65 celsius temperature is controled by pushing the fans progresively to maximum using nvml
Over 65 the power available to the card is reduced until the temp lowers drops below 65 

Disclamer this is a PERSONAL experiment created to acomodate my card 5070 on a ubuntu system that was overheating it on auto behaviour 
or reducing the power available to early and generating issues 
!!!! Use at ur own risk !!!! 
