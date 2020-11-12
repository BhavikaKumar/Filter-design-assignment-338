f_samp = 260e3;

%Band Edge speifications
fs1 = 53.1e3;
fp1 = 49.1e3;
fp2 = 77.1e3;
fs2 = 73.1e3;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

Wn = [(fs1+fp1)/2 (fs2+fp2)/2]*2/f_samp;        %average value of the two paramters
N_min = ceil((A-8) / (2.285*0.031*pi)) + 1;       %empirical formula for N_min

%Window length for Kaiser Window calcuted by hit and trial to best fit the
%specifications
n=N_min + 15;

%Ideal bandstop impulse response of length "n"

bs_ideal =  ideal_lp(pi,n) -ideal_lp(0.575*pi,n) + ideal_lp(0.395*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandStop = bs_ideal .* kaiser_win;
fvtool(FIR_BandStop);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
plot(f,abs(H))
hold on;
%line specifications to determine the boundaries of the signal
h = line([49100,49100],[0, 1.5])
set(h, 'color', 'r')
h = line([53100,53100],[0, 1.5])
set(h, 'color', 'r')
h = line([73100,73100],[0, 1.5])
set(h, 'color', 'r')
h = line([77100,77100],[0, 1.5])
set(h, 'color', 'r')
k = line([0,150000],[1.15,1.15])
set(k, 'color', 'g')
k = line([0,150000],[0.85,0.85])
set(k, 'color', 'g')
k = line([0,150000],[0.15,0.15])
set(k, 'color', 'g')
grid