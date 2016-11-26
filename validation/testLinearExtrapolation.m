clear;
t_sim = 30;
t_step = 0.01;
%% Initial conditions: start with random quaternion and angular rate
omega_B = rand([3, 1]);
omega_bias_I = rand([3, 1]);
q_init = rand([4, 1]);
% Normalize quaternion to one
q_init = q_init / norm(q_init);

%% Generate true phase trajectory
solution_true = genTruePhaseTrajectory( ...
    q_init, omega_B, omega_bias_I, t_step, t_sim ...
    );
q_cont_true = solution_true.q_series;

%% Run simulink model for Kalman predictor
model_name = 'kalman_predictor';
load_system(model_name);
sim(model_name);
close_system(model_name, 0);

%% Visualize difference
figure('Name', 'Compare Kalman linearized dynamics with true trajectory');
hold on;
color = 'rgb';
t_series = solution_true.t_series;
for i = 1:3
    plot(t_series, q_cont_true(i + 1, :), sprintf('%s-', color(i)));
    plot(q_lin_predicted.time, q_lin_predicted.data(:, i), sprintf('%s--', color(i)));
end
grid on;
title ('Quaternion evolution (linearized vs true)');
xlabel('Time, sec');
ylabel('Quaternion components [ijk]');
hold off;
