%% SAF
function [Values] = SAF(DataSamples,ClkSamples,SFSamples)
% @ DataSamples - (1xn) abgetastete Spannungswerte von Kanal A
% @ ClkSamples  - (1xn) abgetastete Spannungswerte von Kanal B
% @ SFSamples   - (2xp) Abtastwerte der SF fuer eine 0.
%                       Zeile 1 steht fuer die Samples von SF0 und
%                       Zeile 2 enthaelt die Samples fuer SF1
% @ Values      - (1xn) Bitfolge, die vom SAF ermittelt wurde


%SF0 = SFSamples(0);
%SF1 = SFSamples(1);

%[maxsignal,indmax]=max(ClkSamples);
%[minsignal,indmin]=min(ClkSamples);
%difference = maxsignal-minsignal;
%normierteClk=(ClkSamples-minsignal)./difference; 
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