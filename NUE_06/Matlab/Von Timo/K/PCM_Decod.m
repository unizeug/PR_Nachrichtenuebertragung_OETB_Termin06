% Gibt auf dem grünen Kanal einen Takt aus, auf dem grï¿½nen das
% Rahmensynchronisationssignal und auf dem blauen ein 8-bit Codewort,
% das über den PCM-Decoder auf dem ETT einen Spannungswert einstellt.
function PCM_Decod(Val)
% @ Val - Ausgabewert. {0 bis 255}

DATA=[0 str2num(dec2bin(Val,8)')' str2num(dec2bin(Val,8)')']
FS=[1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
Clk=kron(ones(1,17),[1 0])

NoiseOut=[8*Clk+4*kron(FS,[1 1])+2*kron(DATA,[1 1])];
ParallelOUT(NoiseOut,20);