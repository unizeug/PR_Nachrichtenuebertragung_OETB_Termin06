function [Values,Noise]=Channel(Data,KanalParameter,FilterParameter,Modus)
% @ Data - (1xq) Bitstream, der �bertragen werden soll
% @ Modus - (1x1) 0 f�r simulierter Kanal; 1 f�r echter Kanal
switch Modus
    case 0 
        [Values,Noise]=Simulierter_Kanal(Data,KanalParameter,FilterParameter);
    case 1         
        [Values,Noise]=Realer_Kanal(Data,KanalParameter,FilterParameter);
    otherwise  
        printf('Unbekannter Kanalmodus.');
end