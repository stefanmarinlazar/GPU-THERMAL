This script is designed to ofer a more advanced gpu thermal control on linux system
it is build using gemini suport and has the folowing logic 
thermal control is left on auto till 55 celsius 
between 55 and 65 celsius temperature is cojntroled by pushing the fans progresively to maximum using nvml
over 65 the power available to the card is reduced until the temp lowers below 65 

Disclamer this is a PERSONAL experiment use at ur own risk 
