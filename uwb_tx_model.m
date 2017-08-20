% TX model should model all TX specific things and give support for digital
% and analog development
function out_sig=uwb_tx_model()

  global sim_params;

  out_sig=zeros(1,sim_params.t_sim*sim_params.f_sim);

  s_p=uwb_gen_pulse(0, sim_params.t_p, sim_params.f_sim, sim_params.debug_level);
  
  step_p=round(length(out_sig)/(sim_params.f_sim/sim_params.f_p))
  for ixx=1:step_p:length(out_sig)-step_p
    out_sig(ixx:ixx+length(s_p)-1) = s_p;
  end

%endfunction
