%% Generate pulse of type p_type of duration p_len with sampling frequency f_s
%%
%% p_type can be:
%%   0 - normal Gaussian pulse
%%   1 - 1st order Gauss derivate
%%   2 - 2nd order Gauss derivate
%%   3 - sinus
function out_pulse=uwb_gen_pulse(p_type, p_len, f_s)

  p_window=2*p_len; % Pulse window double the pulse length

  %% Be sure to always center it around 0
  s_p=[[0:-2/(p_window*f_s):-1],[0+2/(p_window*f_s):2/(p_window*f_s):+1-2/(p_window*f_s)]];
  s_p=sort(s_p);


  if(p_type == 0)
    %% Gaussian functions parameters:
    %% mu always equals 0 (no shift around 0)
    %% variance (sigma^2) depends on the pulse length 
    sigma=0.2;
    out_pulse=(1/(sigma*sqrt(2*pi))).*exp(-s_p.^2/(sigma^2*2)); % generate single Gauss
  end

  % Always normalize to 1
  out_pulse = out_pulse .* (1./max(abs(out_pulse)));


