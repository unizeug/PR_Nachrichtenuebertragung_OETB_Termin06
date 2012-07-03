%% Funktion die das Signal angepasste Filter simuliert

function [Values] = SAF(DataSamples, ClkSamples, SFSamples)

version = 1; % meine Version
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
    sig1 = conv(DataSamples, invSF(1,:), 'same'); % 'same' schmeißt nur den mittleren Teil raus, der
    sig2 = conv(DataSamples, invSF(2,:), 'same'); % so lang ist wie DataSamples uns ClkSamples
    sig = sig1-sig2;
    
    % Abtastung und Entscheidung des SAF-Signals
    edges=find(BitStart==1);
    Values = zeros(1,length(edges)+1);

    for i = 1:length(edges)
        if sig(edges(i)) >= 0
            Values(i) = 1;
        else
            Values(i) = 0;
        end
    end

%     if sig(edges(length(edges))+(edges(length(edges))-edges(length(edges)-1))) >= 0
%         Values(length(edges)+1) = 1;
%     else
%         Values(length(edges)+1) = 0;
%     end 

end



if version == 2
    normierteClk = ClkSamples - min(ClkSamples);
    normierteClk = normierteClk / max(normierteClk);
    normierteClk(find(normierteClk<0.5))=0;
    normierteClk(find(normierteClk>=0.5))=1;
    %normierteClk = norm(ClkSamples);
    
    clk = diff(normierteClk);
    
    
    invSF = fliplr(SFSamples);
    sig1 = conv(DataSamples, SFSamples(1,:));
    sig2 = conv(DataSamples, SFSamples(2,:));
    sig = sig1-sig2;
    %AbtastZeitpunkte
    %HINWEIS: letzter Abtastzeitpunkt wird aus den vorherigen geschaetzt

    % Abtastung und Entscheidung des SAF-Signals
    edges=find(clk==1);
    Values = zeros(1,length(edges)+1);

    for i = 1:length(edges)
        if sig(edges(i)) >= 0
            Values(i) = 1;
        else
            Values(i) = 0;
        end
    end

    if sig(edges(length(edges))+(edges(length(edges))-edges(length(edges)-1))) >= 0
        Values(length(edges)+1) = 1;
    else
        Values(length(edges)+1) = 0;
    end 
end

if version == 3


%     plot(SFSamples(1,:))

    %% Digitalisierung der CLK

    % kleinster Wert soll null sein
    ClkSamples = ( ClkSamples - min(ClkSamples) );

    % größter verbliebender Wert soll 1 sein
    ClkSamples = ClkSamples / max(ClkSamples);

    % Entscheider
    ClkSamples(ClkSamples <  0.5) = 0;
    ClkSamples(ClkSamples >= 0.5) = 1;


    % % die folgende routine würde das erste Bit ausgelassen wenn die Aufnahme der
    % % Messwerte bei einer fallenden Flanke startet
    %
    % if ClkSamples(end) == 1 && ClkSamples(end-1) == 0
    %     display('Möööööööööp')
    % end
    
    clk = diff(ClkSamples);
    % Vektor erstellen, der eine 1 enthält wo ein neues Bit anfängt
    BitStart = ClkSamples(1:end) - [0 ClkSamples(1:end-1)];

%     sum(BitStart(1:200)-clk(1:200))
%     length(clk)
%     length(BitStart)
%     length(DataSamples)
    
    % entstandene negative Werte löschen
    BitStart(BitStart<0) = 0;
    BitStart(1) = 0;

    
    invSF = fliplr(SFSamples);
    sig1 = conv(DataSamples, invSF(1,:), 'same'); % 'same' schmeißt nur den mittleren Teil raus, der
    sig2 = conv(DataSamples, invSF(2,:), 'same'); % so lang ist wie DataSamples uns ClkSamples
    sig = sig1-sig2;


    %AbtastZeitpunkte
    %HINWEIS: letzter Abtastzeitpunkt wird aus den vorherigen geschaetzt

    % Abtastung und Entscheidung des SAF-Signals

    [val max_ind] = max(BitStart);
    Abgetastet = [DataSamples(max_ind) DataSamples(end)];
    Abgetastet(Abgetastet < 0.5) = 0;
    Abgetastet(Abgetastet >=0.5) = 1;

    Values=  Abgetastet;

end



end