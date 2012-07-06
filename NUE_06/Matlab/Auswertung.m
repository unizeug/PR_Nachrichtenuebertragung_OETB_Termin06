% Auswertung
clc;clear;close all;

Bilder_abspeichern = 0;

load('../Messdaten/messwerte111857');

figure(601);
hold on
    plot(SNR_gemessen_SFFNr_1,BER_gemessen_SFFNr_1);
    plot(SNR_gemessen_SFFNr_2,BER_gemessen_SFFNr_2,'r');
    plot(SNR_gemessen_SFFNr_3,BER_gemessen_SFFNr_3,'c');
hold off
legend('Roh = -1','roh = -1/3','roh = 0')
title(['Wasserfallkurve gemessen linear']);
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
title(['Wasserfallkurve gemessen logarithmisch']);
xlabel('SNR [dB]');
ylabel('BER [dB]');
grid();


if Bilder_abspeichern == 1

    figure(601);
        name=['../Bilder/aufgabe2/Wasserfallkurve_gemessen_linear.pdf'];
        print('-painters','-dpdf','-r600',name)
    figure(602);
        name=['../Bilder/aufgabe2/Wasserfallkurve_gemessen_logarithmisch.pdf'];
        print('-painters','-dpdf','-r600',name)
end