clear;
%% Rnadom initial quaternion
q_init = rand([4, 1]);
q_init = q_init / norm(q_init);
%% Non-maneuvering constant angular rate condition
omega_B = [0; 0; 0];
omega_bias_I = rand([3, 1]);

r_ref_I = rand([3, 1]);

%% Run Fisher matrix integration

absTol = 1e-10;
relTol = 1e-10;
t_sim = 300;

model_name = 'state_observability';
load_system(model_name);
sim(model_name);
close_system(model_name, 0);

%% Visualize
plot(rank_I.time, rank_I.data, 'b-');
hold on;
plot(rank_H.time, rank_H.data, 'r-');
legend( ...
    'Fisher matrix rank', ...
    'Measurement matrix rank' ...
    );