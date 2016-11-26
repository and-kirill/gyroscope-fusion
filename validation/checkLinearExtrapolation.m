% Non-simulink version of extrapolation validation
clear;
t_sim = 30;
t_step = 0.001;
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
t_series = 0:t_step:t_sim;
q_BI_lin = zeros(4, length(t_series));
q_BI_lin(:, 1) = q_init;
for i = 2:length(t_series)
    q_BI = q_BI_lin(:, i - 1);
    q_BI_lin(:, i) = ...
        quaternionPredictor(q_BI, t_step, omega_B, omega_bias_I);
end
%% Visualize difference
figure('Name', 'Compare Kalman linearized dynamics with true trajectory (non-simulink)');
hold on;
color = 'rgb';
t_series = solution_true.t_series;
for i = 1:3
    plot(t_series, q_cont_true(i + 1, :), sprintf('%s-', color(i)));
    plot(t_series, q_BI_lin(i + 1, :), sprintf('%s--', color(i)));
end
grid on;
title ('Quaternion evolution (linearized vs true)');
xlabel('Time, sec');
ylabel('Quaternion components [ijk]');
hold off;
