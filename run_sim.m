close all
clear all
clc

% General idea to provide models from digital TX to digital RX and it should
% include coarsley models in this order (of course they preferably consist also
% of smalled submodules to model various parts in these coarse sections)
%
%          TX model               Channel model                RX model
% ----------------------------    --------------     ----------------------------
% | dig | adc | rf | antenna | -> | TX channel |  -> | antenna | rf | dac | dig |
% ----------------------------    --------------     ----------------------------

% Simulator parameters
global sim_params;
sim_params.f_sim=10e9;    % Simulation frequency in [Hz]
sim_params.t_sim=1e-6;    % Time window of simulation in [s]
sim_params.debug_level=2; % From 0 to 2

sim_params.f_dac=1e9;     % ADC sampling frequency in [Hz]
sim_params.f_p=10e6;     % Pulse frequency in [Hz]
sim_params.t_p=1e-9;      % Pulse duration in [s]

sim_params.f_adc=1e9;     % ADC sampling frequency in [Hz]

tx_sig = uwb_tx_model();

ch_sig = uwb_ch_model(tx_sig);

rx_sig = uwb_rx_model(ch_sig);



