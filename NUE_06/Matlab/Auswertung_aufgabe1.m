%NUE Auswertung Aufgabe 1, verrauschte Signale

%Signale laden
nf0 = load('signal_rauschen(0)');
nf128 = load('signal_rauschen(128)');
nf255 = load('signal_rauschen(255)');

figure(1);
plot(nf0.A)
xlabel('Zeitachse t');
ylabel('Amplitude');
title('\bf Signal mit Rauschen (NoiseFactor = 0)');
AXIS([0 4*10^(4) -15 15]);

figure(2);
plot(nf128.A)
xlabel('Zeitachse t');
ylabel('Amplitude');
title('\bf Signal mit Rauschen (NoiseFactor = 128)');
AXIS([0 4*10^(4) -2.5 2.5]);

figure(3);
plot(nf255.A)
xlabel('Zeitachse t');
ylabel('Amplitude');
title('\bf Signal mit Rauschen (NoiseFactor = 255)');
AXIS([0 4*10^(4) -15 15]);

