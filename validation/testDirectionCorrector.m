clear;
t_sim = 5000;
t_step = 0.1;
%% Initial conditions: start with random quaternion and angular rate
omega_B = rand([3, 1]);
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

%% Define random seeds
seed_start = 123456;
horizontal_direction_seeds = [0, 1, 2] + seed_start;
vertical_direction_seeds = [3, 4, 5] + seed_start;

%% Run simulink model for Kalman predictor
model_name = 'kalman_direction_updater';
load_system(model_name);
sim(model_name);
close_system(model_name, 0);

%% Visualize data
n = size(q_true_out.data, 1);
d_phi = zeros(1, n);
dq = zeros(4, n);
for i = 1:n
    dq (:, i) = quaternionMultiply(q_true_out.data(i, :)', [q_BI_out.data(i, 1); -q_BI_out.data(i, 2:4)']);
    d_phi(i) = asin(norm(dq(2:4, i)));
end
t_series = q_true_out.time;
colors = 'krgb';
figure('Name', 'Direction measurement test, quaternion deviation');
hold on;
title('Quaternion deviation, component-wise');
ylabel('Quaternion deviation components [ijk]');
xlabel('Time, sec');
for i = 2:4
    plot(t_series, dq(i, :), colors(i));
end
grid on;

figure('Name', 'Direction measurement test, body orientation error');
title('Total angular deviation');
plot(t_series, d_phi * 180 / pi);
xlabel('Time, sec');
ylabel('Absolute angular deviation, deg');
grid on;