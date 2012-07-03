% Wandelt eine Matrix (mxn) beliebiger Länge in eine Ausgabematrix durch zeilenweises
% Umbrechen. Außerdem wird ein Taktsignal auf dem 4. Kanal hinzugefügt,
% sofern keine Daten für den 4. Kanal übermittelt wurden.
% Ein Takt ist durch eine [1 0] gekennzeichnet. Dabei wird 
% der Takt so angepasst, dass er seinen 1 zu 0 Wechsel genau in der Hälfte 
% eines Datenbits hat.
function DataM = Vec2DataM(KanalMatrix,BitBlockLength,optional_fTIdx)
% @ KanalMatrix    - (mxn) Matrix, die je Zeile die auszugebenden Bits je Kanal 
%                    beinhaltet 1 und -1 
% @ BitBlockLength - (1x1) Anzahl an Bits, die nicht getrennt werden sollen
% @ optional_fTIdx - (1x1) OPTIONAL gibt einen Index für die Abtastrate an
% @ DataM - (axb) DatenMatrix, die die Zeilenweise Ausgabe beinhaltet
%% Auswertung
tbit=20e-6; %s/bit 50e-6
N=128000;   %S/Line
if exist('optional_fTIdx')
    fTIdx=optional_fTIdx;
else
    fTIdx=4; % 5 für tbit=50e-6 
end

fT=(50e6*2^(-fTIdx));

MaxBitsPerLine=N/fT/tbit;
LineStuffingFactor = 0.75;
if size(KanalMatrix,1)<4
    MaxDataBitsPerLine=floor(MaxBitsPerLine/2*LineStuffingFactor)-mod(floor(MaxBitsPerLine/2*LineStuffingFactor),BitBlockLength);
else
    MaxDataBitsPerLine=floor(MaxBitsPerLine*LineStuffingFactor)-mod(floor(MaxBitsPerLine*LineStuffingFactor),BitBlockLength);
end

% KanalMatrix zu Vektor wandeln:
Data=zeros(1,size(KanalMatrix,2));
for i=1:size(KanalMatrix,1)
    Data=Data+KanalMatrix(i,:)*2^(i-1);
end
% ZeroPadding anfügen
ZerroPadding=MaxDataBitsPerLine-mod(numel(Data),MaxDataBitsPerLine);

%Data bipolar {-1,1} muss zu {0,1} geändert werden
Data(find(Data==-1))=0;
Data=[Data zeros(1,ZerroPadding)];
DataMatrix=reshape(Data',MaxDataBitsPerLine,[])';

% Takt hinzufügen, sofern Kanal 4 noch frei ist
Clk=0;
if size(KanalMatrix,1)<4
    DataBitMatrix=kron(DataMatrix,[1 1]); % DataMatrix für Takt anpassen
    Clk=mod(cumsum(ones(size(DataBitMatrix,1),size(DataBitMatrix,2)/BitBlockLength),2),2);
    % Takt an Signalformung anpassen
    Clk=kron(Clk,ones(1,BitBlockLength));
    Clk(end,(end+1-ZerroPadding*2):end)=0;
end

DataM=DataBitMatrix+8*Clk;
