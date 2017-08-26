% Small helper file that make a relation sigma vs time for time pulse for Gaussian curve
% Plot also the pulses & the FFT of them
close all
clear all
clc

f_s=500e9;   % Simulator frequency (sim_params.f_sim)
p_thr=1e-1;  % Pulse threshold
max_sigma=5;
range_sigma=150; % -range_sigm:+range_sigma

s_p=-(range_sigma)/2:1e9*range_sigma/f_s:+(range_sigma/2)-(1/(f_s/1e9)); % sample vector

idx=1;
for ixx=max_sigma:-0.1:0.1
  sigma=ixx;
  out_pulse=(1/(sigma*sqrt(2*pi))).*exp(-s_p.^2/(sigma^2*2)); % generate single Gauss
  out_pulse = out_pulse .* (1./max(abs(out_pulse)));

  s_vec(idx)=ixx;
  p_sum(idx)=sum(out_pulse>p_thr); % Sum number of samples above threshold
  idx=idx+1;
end

% Calculate time for the pulses
figure()
t_vec=p_sum./f_s*range_sigma*1e9;
sigma_poly=polyfit(t_vec, s_vec, 1);

plot(t_vec, s_vec, '-*') 
xlabel('Pulse length [ns]');
ylabel('Sigma [n/a]');
hold on
plot([0, max(t_vec)], [ sigma_poly(1)*0+sigma_poly(2), sigma_poly(1)*max(t_vec)+sigma_poly(2) ], '-r')
legend(['calculated';'  fitted  '])
title(['Relation between Gaussian sigma and pulse time (pulse threshold=',num2str(p_thr),')']);
t=text(max(t_vec)/2, max(s_vec)/3, ['\sigma=',num2str(sigma_poly(1), '%1.3e'),' * t_p + ',num2str(sigma_poly(2), '%1.3e')], 'color', 'r');
s=t.Color;
s='r'

save('sigma_poly.mat','sigma_poly')