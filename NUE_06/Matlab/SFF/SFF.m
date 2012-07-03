%SFF
function SFVec=SFF(Data,SF0,SF1)
% @ Data - (1xm) Datenvektor. Elemente: {0,1}
% @ SF0  - (1xp) Sendeform für eine 0. Elemente: {-1,1}
% @ SF1  - (1xp) Sendeform für eine 1. Elemente: {-1,1}
% Anmerkung: SF0 und SF1 müssen gleichlang sein
% @ SFVec - (1xq) sendegeformtes Signal. Elemente: {-1,1}

%SF0
Data0=(Data~=1);
Data0=kron(Data0,SF0);

%SF1
Data1=(Data==1);
Data1=kron(Data1,SF1);

SFVec=Data0+Data1;