% Generate pulse of type p_type of duration p_len with sampling frequency f_s
%
% p_type can be:
%   0 - normal Gaussian pulse
%   1 - 1st order Gauss derivate
%   2 - 2nd order Gauss derivate
%   3 - sinus
function out_pulse=uwb_gen_pulse(p_type, p_len, f_s, dbg_level)

  max_p_len=20e-9;

  if(p_type >= 0 && p_type <= 2)
  end
  if(p_type == 3)
    s_p=-pi:(2*pi)/(f_s*p_len):+pi
  end
  
  % Gaussian functions parameters:
  % mu always equals 0 (no shift around 0)
  % variance (sigma^2) depends on the pulse length 
  s_p=-5:10/(max_p_len*2*f_s):+5-1/(max_p_len*2*f_s);
  load('sigma_poly.mat')
  sigma=p_len*1e9*sigma_poly(1) + sigma_poly(2)
  out_pulse=(1/(sigma*sqrt(2*pi))).*exp(-s_p.^2/(sigma^2*2)); % generate single Gauss
  out_pulse = out_pulse .* (1./max(abs(out_pulse)));

%  out_pulse_2=-(s_p./(1*sqrt(2*pi))).*exp(-s_p.^2/2); % 1st derivate Gauss
%  out_pulse_3=-(1-s_p.^2)./(1*sqrt(2*pi)).*exp(-s_p.^2/2); % 2nd derivate Gauss

%  if(dbg_level == 2)
%
%%    plot(s_p, out_pulse_2, '-g');
%%    plot(s_p, out_pulse_3, '-r');
%%    plot(s_p_2, out_pulse_4, '-m');
%%    plot(s_p_2, out_pulse_5, '-c');
%  end

