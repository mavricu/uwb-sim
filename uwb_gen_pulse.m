% Generate pulse of type p_type of duration p_len with sampling frequency f_s
%
% p_type can be:
%   0 - normal Gaussian pulse
%   1 - 1st order Gauss derivate
%   2 - sinza
function out_pulse=uwb_gen_pulse(p_type, p_len, f_s, dbg_level)

  % Gauss preparation - we have f_sim/t_p samples for each pulse
  s_p=-5:10/(f_s*p_len):+5; % 'time' vector for Gauss
  out_pulse=(1/(1*sqrt(2*pi)))*exp(-s_p.^2/2); % generate single Gauss

  if(dbg_level == 2)
    plot(s_p, out_pulse, '-*');
  end

