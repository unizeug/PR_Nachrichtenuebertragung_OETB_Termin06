%Diese Funktion sucht in den ClkSamples nach variierender Taktbreite und 
% staucht zu Breite Takte durch entfernen von Samples sowohl der
% SignaleSamples als auch der ClkSamples (um sie synchron zu halten).
% Das hier ist als Bugfix für die Ausgabe der ParallelBox gedacht. Da 
% sie keinen festen Takt ausgeben kann, kann die Bitbreite um us variieren.
% Je höherfrequent die Ausgabe, desto stärker fällt diese Variation ins
% Gewicht.
function [optSigSam optClkSam]=ClkOptimization(SignalSamples, ClkSamples)
% bei hoher Abtastrate kann die steigende Flanke mit abgetastet worden
% sein. Deshalb werden die ersten Samples angepasst, damit die
% Differenzbildung beim Takt nicht schief geht.
ClkSamples(1:10) = max(ClkSamples(1:10));
%Normalization
C2=ClkSamples;
C2=C2-min(C2);
C2=C2/max(C2);
C2(find(C2>=0.5))=1;
C2(find(C2<0.5))=0;
ClkDiff=diff(C2);

in=find(abs(ClkDiff)==1);
din=diff(in);
meanDiff=mean(din);
largeDiffIdx=find(din>meanDiff*1.2);
LDI=largeDiffIdx;

NewIdx=1:numel(ClkSamples);
for i=1:numel(largeDiffIdx)
    a=in(LDI(i));
    b=in(LDI(i)+1);
    c=(din(LDI(i))-meanDiff);
    d=(floor((a+b)/2+(1:c)-c/2));
    %NewIdx=NewIdx(NewIdx~=(in(LDI(i))+in(LDI(i+1)))/2+floor((1:(din(LDI(i))-meanDiff))-(din(LDI(i))-meanDiff)/2)  );
    NewIdx=NewIdx(NewIdx<d(1) | NewIdx>d(end));
end

optSigSam=SignalSamples(NewIdx);
optClkSam=ClkSamples(NewIdx);