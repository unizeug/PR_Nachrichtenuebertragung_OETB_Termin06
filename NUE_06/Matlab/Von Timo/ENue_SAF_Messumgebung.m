%% Initialisiere Matlab
addpath('K');
addpath('SFF');
addpath('SAF');
clc;
load('SimpleSample.mat')

%% Verlaufseinstellungen
SAF=1;          % Wenn 0, dann kein SAF
Simulation=1;   % Wenn 0, dann keine Simulation

%% Datensignal
a=round(rand(1,1000))
Data=a;
% Kanalcodierung
if SAF==1
    % SF0 stellt die Sendeform fuer eine 0 dar. Bsp: jede 0 soll durch 
    % [0 1 0] ersetzt werden. Dann muss SF=[0 1 0] sein.
    % SF1 stellt die Sendeform fuer eine 1 dar.
    SF0=            [-1, 1, 1];
    SF1=            [1, -1, -1];
    Data=SFF(a,SF0,SF1);    %Fuehrt die Sendeformung durch. Data wird auf den Kanal gegeben.
end

%% Kanal- und Filtereinstellungen
KanalParameter.NoiseFactor=120; % Werte von 0 bis 255
if SAF==1
    FilterParameter.SF0=SF0;
    FilterParameter.SF1=SF1;
    FilterParameter.BitBlockLength=numel(FilterParameter.SF0);
    KanalParameter.BitGroupLength=numel(FilterParameter.SF0);
end
if Simulation==0
    [KanalParameter.ScopeHandle KanalParameter.ScopeVersion]=LoadPicoscope;    
    KanalParameter.MinimumSampleRate=KanalParameter.SamplesPerBit/KanalParameter.t_bitP*10^6; %in Hz
    if numel(KanalParameter.ScopeVersion)==numel('3204')
        KanalParameter.SampleRateIdx=floor(log2(50e6)-log2(KanalParameter.MinimumSampleRate));
        KanalParameter.SampleRate=50e6/(2^KanalParameter.SampleRateIdx);
    else
        if KanalParameter.MinimumSampleRate>=125e6
            KanalParameter.SampleRateIdx=floor(log2(500e6)-log2(KanalParameter.MinimumSampleRate));
            KanalParameter.SampleRate=500e6/2^KanalParameter.SampleRateIdx;
        else
            KanalParameter.SampleRateIdx=floor(62.5e6/KanalParameter.MinimumSampleRate+2);
            KanalParameter.SampleRate=62.5e6/(KanalParameter.SampleRateIdx-2);
        end
    end
else
    KanalParameter.SampleRate=50e6/(2^KanalParameter.SampleRateIdx);
end

%% UEbertragung
[Y,Noise]=Channel(Data,KanalParameter,FilterParameter,abs(Simulation-1));
if Simulation==0
    ClosePicoScope(KanalParameter.ScopeHandle);
end

%% Analyse

Amplitude = max(a); %betraegt hier 1

mittelwert = sum(Noise)/length(Noise); %mittelwert des rauschens
Varianz = (sum((Noise-mittelwert).^2))/(length(Noise)); %varianz des rauschens

%bestimmt die falsch uebertragenen Bits
Z = Y - a; 
anzahl_fehler = length(find(Z~=0));

BER_gemessen = anzahl_fehler/length(a)
BER_errechnet = 0.5 * erfc(Amplitude/(sqrt(8*Varianz)))

SNR_gemessen = 20*log10(Amplitude/sqrt(Varianz))


