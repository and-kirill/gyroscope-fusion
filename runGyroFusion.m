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
ref_B_I = [1; 0; 0];
magnetometer_noise_power = [1; 1; 1] * 1e-4;
R_magnetometer = diag(magnetometer_noise_power) / t_step;

%% Define vertical direction measurements parameter
gravity_I = [0; -1; 0];
acc_noise_power = [1; 1; 1] * 1e-4;
R_acc = diag(acc_noise_power) / t_step;

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
magnetometer_seeds = [0, 1, 2] + seed_start;
acc_seeds = [3, 4, 5] + seed_start;
gyro_seeds = [6, 7, 8] + seed_start;

%% Run simulink model for Kalman predictor
model_name = 'gyro_synthetic_data';
load_system(model_name);
sim(model_name);
close_system(model_name, 0);

%% Initialize input data with synthetic ones
gyro_data.time = omega_I_meas.omega_I.time;
gyro_data.signals.values = omega_I_meas.omega_I.data;

acc_data.time = acc_B_meas.measured_vector_B.time;
acc_data.signals.values = acc_B_meas.measured_vector_B.data;

magnetometer_data.time = magnetic_B_meas.measured_vector_B.time;
magnetometer_data.signals.values = magnetic_B_meas.measured_vector_B.data;

%% Open simulink model
model_name = 'gyro_fusion';
load_system(model_name);
sim(model_name);
close_system(model_name);

%% Visualize data
% Angular velocity
figure;
hold on;
colors = 'rgb';
for i = 1:3
    plot(omega_B_true_out.time, omega_B_true_out.data(:, i), sprintf('%s--', colors(i)));
    plot(omega_B_async.time, omega_B_async.data(:, i), sprintf('%s-', colors(i)));
end
grid on;
