function [T]=FilterPico(A,B,FilterParameter)
% @ A - A.Time beinhaltet die Zeitpunkte der Abtastwerte in ms; A.Values
%       beinhaltet die Spannungspegel an den Abtastzeitpunkten
% @ B - B.Time beinhaltet die Zeitpunkte der Abtastwerte in ms; B.Values
%       beinhaltet die Spannungspegel an den Abtastzeitpunkten
% @ SF0 - (1xn) SF einer 0. Elemente: {-1,1}
% @ SF1 - (1xn) SF einer 1. Elemente: {-1,1}
% @ T - (2xm) SAF gefilterte Bitfolgen einer �bertragung.
%       Die erste Zeile repr�sentiert den Bitstream bei
%       optimaler Abtastung. Die zweite Zeile repr�sentiert
%       den Bitstream bei nichtoptimaler Abtastung.

if numel(B)>0
    [AA,BB]=ClkOptimization(A.Values,B.Values);
    
    if exist('FilterParameter','var') & isstruct(FilterParameter)==1        
            %********* SAF **************
            % Mittlere Taktbreite (und damit auch Sendesymbolbreite) ermitteln:
            Clk=(BB>=2.5);
            ClkIdx=find(diff(Clk)>0);
            d=mean(diff(ClkIdx));
            % Aus SendeformSignalen Samples machen
            SF0=FilterParameter.SF0;
            SF1=FilterParameter.SF1;
            SF0Samples=kron(SF0,ones(1,round(d/numel(SF0))));
            SF1Samples=kron(SF1,ones(1,round(d/numel(SF1))));
            SFSamples=[SF0Samples;SF1Samples];
            % Mit SAF.m nachabtasten
            [T]=SAF(AA,BB,SFSamples);

    else
        %** einfache Nachabtasung ***
        %Nachabtastung(DataSamples,ClkSamples,SampleDelay)
        T=Nachabtastung(AA,BB,0,0);
    end
else
    error('No clocksamples @ channel B.')
end