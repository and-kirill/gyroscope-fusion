clear;
t_step = 1 / 50; % 50 Hz approximate data rate

%% Specify data sources
event_source ='test_data/test_orientation.ldj';
gyro_source_name = 'add_imu_gyro';
acc_source_name = 'add_imu_acc';
magnetometer_source_name = 'add_imu_magnetometer';
%% Load data from json
command = sprintf('./test_data/event_parser.py %s', event_source);
system(command);

%% Load measured data
% Accelerometer
acc_data = loadMeasurements(acc_source_name, [2, -3, 1]);
if strcmp(magnetometer_source_name, 'add_imu_magnetometer')
    mag_sequence = [-1, -3, -2];
elseif strcmp(magnetometer_source_name, 'main_imu_magnetometer')
    mag_sequence = [ 1,  3, -2];
end

% Magnetometer
magnetometer_data = loadMeasurements(magnetometer_source_name, mag_sequence);

% Gyroscope
% Convert gyroscope units to rad/s from milli-degrees/s
gyro_data = loadMeasurements(gyro_source_name, [2, 3, -1]);
digit2dps = 1 / 1000;
digit2rps = digit2dps * pi / 180;
gyro_data.signals.values = gyro_data.signals.values * digit2rps;

% Specify reference directions
gravity_I = [0; -1; 0];


n_first = 60; % First n samples of magnetic field are averaged
magnetic_field = mean(magnetometer_data.signals.values(1:n_first, :), 1);
ref_B_I = magnetic_field / norm(magnetic_field);

% Spceicify simulation time
t_sim = max([ ...
    magnetometer_data.time; ...
    acc_data.time; ...
    gyro_data.time; ...
    ]);
% Clear temporary files
system('rm *.dat');

%% Fill model noise parameters:
% Quaternion noise parameters
q_noise = 0.1;
% Note, that yaw maneuver intensity is much hihger:
omega_B_noise = [4, 4, 4];
% Gyro drift evolves much slower than angular velocity
omega_bias_I_noise = 0.4;
% Gyroscope measurement covariance matrix
R_magnetometer = eye(3) * t_step;
R_acc = eye(3) * t_step;
R_gyro = eye(3) * t_step;

%% Run simulink model
% model_name = 'validate_magnetometer';
model_name = 'gyro_fusion';

load_system(model_name);
sim(model_name);
close_system(model_name, 0);

postproc;