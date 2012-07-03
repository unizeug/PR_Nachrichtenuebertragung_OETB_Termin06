%Simulativer Kanal:
function [Values,Noise]=Simulierter_Kanal(OutputData,KanalParameter,FilterParameter,DEBUGParameter)

% regroup for line-wise transmission
X = DataM2ParallelM(OutputData,KanalParameter.BitGroupLength,KanalParameter.t_bitP,KanalParameter.SampleRate);
% Noise parameters
noiseStd = 4.2*(KanalParameter.NoiseFactor*4/255-2); %fit to -6db Noise @ ETT 
% Samples per Bit (Outputbit)
fT=KanalParameter.SampleRate;
SpB=fT*KanalParameter.t_bitP*1e-6;
C=[];
% several rounds of transmission
for i=1:size(X,1)
    % A and B are the oscilloscope channels     
    % ParallelBox Output:
    A.Values=kron(mod(X(i,:),2),ones(1,SpB)*5);
    B.Values=kron(floor(X(i,:)/8),ones(1,SpB)*5);   
    % ETT stuff:
    A.Values=A.Values/5;
    Noise=noiseStd*(randn(1,numel(A.Values)));
    A.Values=(A.Values*2-1)+Noise;
    A.Values(A.Values>15)=15;A.Values(A.Values<-15)=-15; % ETT clipping
    
    A.Time=(cumsum(ones(1,numel(A.Values)))-1)*fT;
    B.Time=(cumsum(ones(1,numel(B.Values)))-1)*fT;
    C=[C FilterPico(A,B,FilterParameter)];    
end
Values=C;
% Noise measurement
Noise=noiseStd*(randn(1,11700));
Noise(Noise>15)=15;Noise(Noise<-15)=-15; % clipping by ETT