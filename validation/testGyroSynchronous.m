clear;
t_sim = 500;
t_step = 0.1;
%% Initial conditions: start with random quaternion and angular rate
omega_B = rand([3, 1]);
gyro_mean_bias = rand([3, 1]); % Mean drift values for gyroscope;
q_init = rand([4, 1]);
% Normalize quaternion to one
q_init = q_init / norm(q_init);

%% Fill model noise parameters:
q_noise = 0.1;
% Note, that yaw maneuver intensity is much hihger:
omega_B_noise = [4, 4, 4];
% Gyro drift evolves much slower than angular velocity
omega_bias_I_noise = 0.0001;

%% Define horizonal direction measurements parameter
horizontal_direction = [1; 0; 0];
horizontal_direction_noise_power = [1; 1; 1] * 1e-4;
horizontal_direction_R = diag(horizontal_direction_noise_power) / t_step;

%% Define vertical direction measurements parameter
vertical_direction = [0; -1; 0];
vertical_direction_noise_power = [1; 1; 1] * 1e-4;
vertical_direction_R = diag(vertical_direction_noise_power) / t_step;

%% Initialize variables required by the gyroscope model
acc_I = [0, -1, 0]; % Inertial axes acceleration in G's to derive gyro drift;
gyro_g_sensitivity_bias = [1, 1, 1] * 0; % acceleration sensitivity for the gyro bias;
gyro_natrual_freq = 190; % Gyroscope natrual frequency [Hz]
gyro_damping_factor = 0.707; % Gyroscope damping factor;
gyro_scale_factor = eye(3); % Gyroscope scaling factor;
gyro_noise = [1, 1, 1] * 1e-4; % Gyroscope noise power
R_gyro = diag(gyro_noise) / t_step;

%% Define random seeds
seed_start = 123456;
horizontal_direction_seeds = [0, 1, 2] + seed_start;
vertical_direction_seeds = [3, 4, 5] + seed_start;
gyro_seeds = [6, 7, 8] + seed_start;

%% Run simulink model for fixed step Kalman filter
model_name = 'kalman_gyro_synchronous';
load_system(model_name);
sim(model_name);
close_system(model_name, 0);

%% Visualize data
n = size(q_true_out.data, 1);
d_phi = zeros(1, n);
for i = 1:n
    q_BI_wave = [q_BI_out.data(i, 1); -q_BI_out.data(i, 2:4)'];
    dq = quaternionMultiply(q_true_out.data(i, :)', q_BI_wave);
    d_phi(i) = asin(norm(dq(2:4)));
end
t_series = q_true_out.time;
colors = 'krgb';

figure('Name', 'Gyro measurement test, orientation error');
title('Total angular deviation');
plot(t_series, d_phi * 180 / pi);
xlabel('Time, sec');
ylabel('Absolute angular deviation, deg');
grid on;

figure('Name', 'Gyro measurement test, angular velocity bias estimate');
hold on;
for i = 1:3
    plot(omega_I_bias_out.time, omega_I_bias_out.data(:, i), colors(i+1));
    plot( ...
        [min(t_series), max(t_series)], ...
        [gyro_mean_bias(i), gyro_mean_bias(i)], ...
        colors(i+1) ...
    );
end
title('Angular velocity bias estimate');
xlabel('Time, sec');
grid on;

figure('Name', 'Gyro measurement test, angular velocity estimate');
hold on;
title('Angular velocity estimate');
xlabel('Time, sec');
for i = 1:3
    plot(omega_B_out.time, omega_B_out.data(:, i), colors(i+1));
    plot(omega_B_true_out.time, omega_B_true_out.data(:, i), colors(i+1));
end
grid on;

save_test_data;
