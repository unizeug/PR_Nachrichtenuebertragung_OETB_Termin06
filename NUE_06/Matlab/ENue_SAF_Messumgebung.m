%% Initialisiere Matlab
addpath('K');
addpath('SFF');
addpath('SAF');
clc; close all; clear;
load('SimpleSample.mat')

%% Verlaufseinstellungen
SAF=1;          % Wenn 0, dann kein SAF
Simulation=1;   % Wenn 0, dann keine Simulation

Noisemessung=15;
if Simulation ==1
    Noisewert = [128,230,250,290,350,400,420,430,440,450,460, 470,480, 490,500]; % Simulation
else
    Noisewert = [0,3,7,10,12,15,17,20,30,40,50,60,90,100,128]; % Messung
end


%% 
BER_gemessen_SFFNr_1 = ones(1,Noisemessung);
BER_gemessen_SFFNr_2 = ones(1,Noisemessung);
BER_gemessen_SFFNr_3 = ones(1,Noisemessung);

SNR_gemessen_SFFNr_1 = ones(1,Noisemessung);
SNR_gemessen_SFFNr_2 = ones(1,Noisemessung);
SNR_gemessen_SFFNr_3 = ones(1,Noisemessung);


%% Datensignal
for datenrunden =1:1
    disp('###############################################################')
    if datenrunden == 1
        a=round(rand(1,1000));
        disp('a=rand')
    end
    if datenrunden == 2
        a = ones(1, 1000);
        disp('a=ones')
    end
    if datenrunden == 3
        a = zeros(1,1000);
        disp('a=zeros')
    end

    Data=a;
    for SFFNr=1:3
        disp('--------------------------------------------------------------')
%         SFFNr
        % Kanalcodierung
        if SAF==1
            % SF0 stellt die Sendeform fuer eine 0 dar. Bsp: jede 0 soll durch 
            % [0 1 0] ersetzt werden. Dann muss SF=[0 1 0] sein.
            % SF1 stellt die Sendeform fuer eine 1 dar.
            if SFFNr == 1
                SF0=            [-1, 1, -1];
                SF1=            [ 1,-1,  1];
            end

            if SFFNr == 2
                SF0=            [-1,-1, 1];
                SF1=            [ 1,-1,-1];
            end

            if SFFNr == 3
                SF0=            [-1, 1, -1, 1];
                SF1=            [ 1, 1, -1,-1];
            end
            Data=SFF(a,SF0,SF1);    %Fuehrt die Sendeformung durch. Data wird auf den Kanal gegeben.
        end

        xcorr(SF0,SF1)/length(SF0);
        
        for NoiseFactor=1:Noisemessung
            %% Kanal- und Filtereinstellungen
%             disp('Aktueller NoiseFactor:');
%             round(270/Noismessung*(NoiseFactor-1))
            
            KanalParameter.NoiseFactor=Noisewert(NoiseFactor); % Werte von 0 bis 255
            
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

    %         Y

            %mittelwert = sum(Noise)/length(Noise); %mittelwert des rauschens
            mittelwert = mean(Noise);
            %Varianz = (sum((Noise-mittelwert).^2))/(length(Noise)) %varianz des rauschens
            Varianz = var(Noise);

            %bestimmt die falsch uebertragenen Bits
            Z = Y - a; 
            anzahl_fehler = length(find(Z~=0));

            BER_gemessen = anzahl_fehler/length(a);
            BER_errechnet = 0.5 * erfc(Amplitude/(sqrt(8*Varianz)));

            SNR_gemessen = 10*log10(Amplitude/Varianz);
            
            if SFFNr == 1
                BER_gemessen_SFFNr_1(NoiseFactor) = BER_gemessen;
                SNR_gemessen_SFFNr_1(NoiseFactor) = SNR_gemessen;
            end
            
            if SFFNr == 2
                BER_gemessen_SFFNr_2(NoiseFactor) = BER_gemessen;
                SNR_gemessen_SFFNr_2(NoiseFactor) = SNR_gemessen;
            end
            
            if SFFNr == 3
                BER_gemessen_SFFNr_3(NoiseFactor) = BER_gemessen;
                SNR_gemessen_SFFNr_3(NoiseFactor) = SNR_gemessen;
            end
            
            
        end
    end
end


%% Plotten

figure(601);
hold on
    plot(SNR_gemessen_SFFNr_1,BER_gemessen_SFFNr_1);
    plot(SNR_gemessen_SFFNr_2,BER_gemessen_SFFNr_2,'r');
    plot(SNR_gemessen_SFFNr_3,BER_gemessen_SFFNr_3,'c');
hold off
legend('Roh = -1','roh = -1/3','roh = 0')
title(['Wasserfallkurve linear']);
xlabel('SNR [dB]');
ylabel('BER');
grid();


BER_gemessen_SFFNr_1_log = 10*log10(BER_gemessen_SFFNr_1);
BER_gemessen_SFFNr_2_log = 10*log10(BER_gemessen_SFFNr_2);
BER_gemessen_SFFNr_3_log = 10*log10(BER_gemessen_SFFNr_3);

figure(602);
hold on
    semilogy(SNR_gemessen_SFFNr_1,BER_gemessen_SFFNr_1_log);
    semilogy(SNR_gemessen_SFFNr_2,BER_gemessen_SFFNr_2_log,'r');
    semilogy(SNR_gemessen_SFFNr_3,BER_gemessen_SFFNr_3_log,'c');
hold off
legend('Roh = -1','roh = -1/3','roh = 0')
title(['Wasserfallkurve logarithmisch']);
xlabel('SNR [dB]');
ylabel('BER [dB]');
grid();

%% Save

savefile = ['../Messdaten/Simulation',datestr(clock, 'HHMMSS')];
save(savefile,'SNR_gemessen_SFFNr_1','BER_gemessen_SFFNr_1','SNR_gemessen_SFFNr_2','BER_gemessen_SFFNr_2','SNR_gemessen_SFFNr_3','BER_gemessen_SFFNr_3') 