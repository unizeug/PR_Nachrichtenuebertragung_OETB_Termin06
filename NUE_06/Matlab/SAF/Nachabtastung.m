%% Nachabtastung
function [Values] = Nachabtastung(DataSamples,ClkSamples,Threshold,SampleDelay)
% @ DataSamples - (1xn) abgetastete Spannungswerte von Kanal A
% @ ClkSamples - (1xn) abgetastete Spannungswerte von Kanal B
% @ SF0Samples - (1xp) Abtastwerte der SF für eine 0
% @ SF1Samples - (1xp) Abtastwerte der SF für eine 1
% @ YValues_opt - (1xq) Bitfolge nach der SAF bei optimalen Abtastzeitpunkten
% @ YValues_nopt_09 - (1xq) Bitfolge nach der SAF bei nicht optimalen Abtastzeitpunkten


%AbtastZeitpunkte
C2=ClkSamples;
C2=C2-min(C2);
C2=C2/max(C2);
C2(find(C2>=0.5))=1;
C2(find(C2<0.5))=0;
ClkDiff=[diff(C2) 0];
TaktStartIdx=find(ClkDiff<(-0.5));

% Abtastung und Entscheidung des Signals
Values=DataSamples(TaktStartIdx+SampleDelay)>Threshold;
end