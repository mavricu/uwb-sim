%function uwb_pulse_analysis()

f_s=50e9;
p_len=[0.3:0.3:3.3]*10e-9; % Pulse lengths
p_type=[ 0, 1, 2 ];    % Gauss, 1st Gauss derivate, Sine

%% Put it always to longest vector
gauss_p=zeros(length(p_len), round(p_len(end)*2*f_s)); % *2 is used in uwb_gen_pulse for pulse window
gauss_f=zeros(length(p_len), round(p_len(end)*2*f_s)); % *2 is used in uwb_gen_pulse for pulse window
t_p=(-length(gauss_p)/2:+length(gauss_p)/2-1)./f_s;
leg_str=[];
for ixx=1:length(p_len)-1
  o_p=uwb_gen_pulse(0, p_len(ixx), f_s);
  %% Stick it to gauss_p structure (in the middle)
  gauss_p(ixx,end/2-length(o_p)/2+1:end/2+length(o_p)/2)=o_p;

  leg_str=[leg_str; num2str(p_len(ixx), '%0.2e')];

  gauss_f(ixx, :)=20*log10(abs(fft(gauss_p(ixx, :))));
end

figure();
plot(t_p, gauss_p');
legend(leg_str);

figure();
plot(t_p, gauss_f');
legend(leg_str);

%endfunction
