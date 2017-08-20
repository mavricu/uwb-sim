% Generates the signal pulses with defined characteristics
% uwb_sig = uwb_sig_gen(f_p, t_p, t_w, f_sim);
function out_sig=uwb_tx_model()

  global sim_params;

  % Currently only Gaussian pulses are supported
  out_sig=zeros(1,sim_params.t_sim*sim_params.f_sim);

  % Gauss preparation - we have f_sim/t_p samples for each pulse
  s_p=-5:10/(sim_params.f_sim*sim_params.t_p):+5; % 'time' vector for Gauss
  g_p=(1/(1 *sqrt(2*pi)))*exp(-s_p.^2/2); % generate single Gauss

  if(sim_params.debug_level == 2)
    plot(s_p, g_p, '-*');
  end

  step_p=round(length(out_sig)/(sim_params.f_sim/sim_params.f_p))
  for ixx=1:step_p:length(out_sig)-step_p
    out_sig(ixx:ixx+length(g_p)-1) = g_p;
  end

%endfunction
