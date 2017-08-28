%function uwb_pulse_analysis()

close all
clear all
clc

f_s=100e9;
%p_len=[0.1:0.3:3.0]*1e-9; % Pulse lengths
p_len=[0.125, 0.150, 0.200, 0.25, 0.5, 0.5]*1e-9; % Pulse lengths - last element is dummy and should be ignored
p_type=[ 0, 1, 2 ];    % Gauss, 1st Gauss derivate, Sine
bw_db=3.5; % dB to define BW

%% Put it always to longest vector
gauss_p=zeros(length(p_len), round(p_len(end)*2*f_s)); % *2 is used in uwb_gen_pulse for pulse window
gauss_f=zeros(length(p_len), round(p_len(end)*f_s));
gauss_3db_f=zeros(length(p_len), round(p_len(end)*f_s));
gauss_1d_p=zeros(length(p_len), round(p_len(end)*2*f_s));
gauss_1d_f=zeros(length(p_len), round(p_len(end)*f_s));
gauss_1d_3db_f=zeros(length(p_len), round(p_len(end)*f_s));
sin_p=zeros(length(p_len), round(p_len(end)*2*f_s)); % *2 is used in uwb_gen_pulse for pulse window
sin_f=zeros(length(p_len), round(p_len(end)*f_s));
sin_3db_f=zeros(length(p_len), round(p_len(end)*f_s));

% Time axis
time_x=(-length(gauss_p)/2:+length(gauss_p)/2-1)./f_s .* 1e9; % in [ns]
% Frequency axis
freq_x=[0:length(time_x)-1] .* f_s./length(time_x);
%freq_x=(freq_x-(freq_x(end/2+1)))./1e9; % in [GHz]
freq_x=freq_x(1:round(length(freq_x)/2))./1e9; % in [GHz]

leg_str=[];

for ixx=1:length(p_len)-1
  o_g=uwb_gen_pulse(0, p_len(ixx), f_s);
  o_s=uwb_gen_pulse(2, p_len(ixx), f_s);
  o_f=uwb_gen_pulse(1, p_len(ixx), f_s);

  %% Stick it to gauss_p structure (in the middle)
  gauss_p(ixx,end/2-length(o_g)/2+1:end/2+length(o_g)/2)=o_g;
  gauss_1d_p(ixx,end/2-length(o_s)/2+1:end/2+length(o_s)/2)=o_f;
  sin_p(ixx,end/2-length(o_s)/2+1:end/2+length(o_s)/2)=o_s;

  leg_str=[leg_str; num2str(p_len(ixx), '%0.2e')];

  f_tmp=20*log10(abs(fft(gauss_p(ixx, :))));
%  gauss_f(ixx, :)=fftshift(f_tmp);
  gauss_f(ixx, :)=f_tmp(1:round(length(f_tmp)/2));
  gauss_3db_f(ixx, :)=(gauss_f(ixx,:)>=(max(gauss_f(ixx,:))-bw_db)).*gauss_f(ixx,:); % 3dB BW

  f_tmp=20*log10(abs(fft(gauss_1d_p(ixx, :))));
%  gauss_1d_f(ixx, :)=fftshift(f_tmp);
  gauss_1d_f(ixx, :)=f_tmp(1:round(length(f_tmp)/2));
  gauss_1d_3db_f(ixx, :)=(gauss_1d_f(ixx,:)>=(max(gauss_1d_f(ixx,:))-bw_db)).*gauss_1d_f(ixx,:); % 3dB BW

  f_tmp=20*log10(abs(fft(sin_p(ixx, :))));

%  sin_f(ixx, :)=fftshift(f_tmp);
  sin_f(ixx, :)=f_tmp(1:round(length(f_tmp)/2));
  sin_3db_f(ixx, :)=(sin_f(ixx,:)>=(max(sin_f(ixx,:))-bw_db)).*sin_f(ixx,:); % 3dB BW
end

figure(1);
subplot(3, 3, 1)
hold on
title('Gaussian pulse');
xlabel('Time [ns]');
ylabel('Normalized amp. [n/a]');
plot(time_x, gauss_p(1:end-1, :)');
legend(leg_str);
subplot(3, 3, 2)
hold on
title('1st derivate Gaussian pulse');
xlabel('Time [ns]');
ylabel('Normalized amp. [n/a]');
plot(time_x, gauss_1d_p(1:end-1, :)');
subplot(3, 3, 3)
hold on
title('Sine pulse');
xlabel('Time [ns]');
ylabel('Normalized amp. [n/a]');
plot(time_x, sin_p(1:end-1, :)');

subplot(3, 3, 4)
hold on
title('Freq. spectrum of Gaussian pulse');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([min(freq_x) 25 -30 30]);
plot(freq_x, gauss_f(1:end-1, :)');
subplot(3, 3, 5)
hold on
title('Freq. spectrum of Gaussian 1st derivate');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([min(freq_x) 25 -30 30]);
plot(freq_x, gauss_1d_f(1:end-1, :)');
subplot(3, 3, 6)
hold on
title('Freq. spectrum of Sine pulse');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([min(freq_x) 25 -30 30]);
plot(freq_x, sin_f(1:end-1, :)');


for ixx=1:length(p_len)
   for jxx=1:length(gauss_3db_f(ixx,:))
      if(gauss_3db_f(ixx,jxx)==0)
         gauss_3db_f(ixx,jxx)=NaN;
      end
      if(gauss_1d_3db_f(ixx,jxx)==0)
         gauss_1d_3db_f(ixx,jxx)=NaN;
      end
      if(sin_3db_f(ixx,jxx)==0)
         sin_3db_f(ixx,jxx)=NaN;
      end
   end
end
subplot(3, 3, 7)
hold on
title('3dB BW of Gaussian pulse');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([0 10.5 0 25]);
plot(freq_x, gauss_3db_f(1:end-1, :)');
subplot(3, 3, 8)
hold on
title('3dB BW of Gaussian 1st derivate');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([0 10.5 0 25]);
plot(freq_x, gauss_1d_3db_f(1:end-1, :)');
subplot(3, 3, 9)
hold on
title('3dB BW of Sine pulse');
ylabel('Magnitude [dB]');
xlabel('Frequency [GHz]');
axis([0 10.5 0 25]);
plot(freq_x, sin_3db_f(1:end-1, :)');

%endfunction
