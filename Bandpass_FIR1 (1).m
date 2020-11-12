f_samp = 330e3;

%Band Edge specifications same as chebyshev
fs1 = 58.3e3;
fp1 = 62.3e3;
fp2 = 82.3e3;
fs2 = 86.3e3;

Wc1 = fp1*2*pi/f_samp;
Wc2  = fp2*2*pi/f_samp;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-8) / (2.285*0.024*pi))+1;           %empirical formula for N_min

%Window length for Kaiser Window such that the specifications are meet.
n=N_min+14; 

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(0.51*pi,n) - ideal_lp(0.365*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
plot(f,abs(H))
hold on;
%line specifications to determine the boundaries of the signal
h = line([58300,58300],[0, 1.5])
set(h, 'color', 'r')
h = line([62300,62300],[0, 1.5])
set(h, 'color', 'r')
h = line([82300,82300],[0, 1.5])
set(h, 'color', 'r')
h = line([86300,86300],[0, 1.5])
set(h, 'color', 'r')
k = line([0,200000],[1.15,1.15])
set(k, 'color', 'g')
k = line([0,200000],[0.85,0.85])
set(k, 'color', 'g')
k = line([0,200000],[0.15,0.15])
set(k, 'color', 'g')
grid
