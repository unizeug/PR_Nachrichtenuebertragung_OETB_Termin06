%% Funktion die das Signal angepasste Filter simuliert

function [Values] = SAF(DataSamples, ClkSamples, SFSamples)

version = 1; % unsere Version
% version = 2; % Timos Version
% version = 3; % Dirks Version

if version == 1
    % clk Signal von (0..max)laufen lassen
    clk = ClkSamples-min(ClkSamples); 
    % clk Signal von (0..1) laufen lassen
    clk = clk/max(clk); 
    % clk Signal nur (0,1) Werte zuweisen
    clk(clk<0.5) = 0;
    clk(clk>=0.5) = 1;

    % Vektor erstellen, der eine 1 enthält wo ein neues Bit anfängt
    BitStart = clk(1:end) - [0 clk(1:end-1)];
    
    % entstandene negative Werte löschen
    BitStart(BitStart<0) = 0;
    BitStart(1) = 0;
    
   

    
    % Faltung des Datensignals mit dem ansich invertiertem SFF
    invSF = fliplr(SFSamples);
    sum(SFSamples + invSF);
    
    nullen = conv(DataSamples, invSF(1,:)); % 'same' schmeißt nur den mittleren Teil raus, der
    einsen = conv(DataSamples, invSF(2,:)); % so lang ist wie DataSamples uns ClkSamples
    sig = einsen-nullen;
    
    % Abtastung und Entscheidung des SAF-Signals
    BitStartInd=find(BitStart);
    Values = zeros(1,length(BitStartInd)+1);

 % Letzten Abtastpunkt hinzufügen: Letzter index + den abstand zweier BitStarts
    BitStart( max(BitStartInd) + (BitStartInd(end) - BitStartInd(end-1)) ) = 1;
    BitStartInd = find(BitStart==1);
    
    for i = 1:length(BitStartInd)
        if sig(BitStartInd(i)) >= 0
            Values(i) = 1;
        else
            Values(i) = 0;
        end
    end
 


end
