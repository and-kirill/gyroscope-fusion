%% Generate data for robot software inputs:
% As soon as we operate with synchronous data prcessing, signal generatio
% moemnts are all the same
t_series = gyro_meas_out.omega_I.time + 144000000;
n_samples = length(t_series);
% Gyroscope measurements are represented as millidegrees per second instead
% of radians per second
rps2mdps = 1000 * 180 / pi;

%% Output string for JSON output file
event_template = ...
    ['{', ...
     '"linear_acceleration": [%4.6f, %4.6f, %4.6f], ', ...
     '"angular_velocity": [%4.6f, %4.6f, %4.6f], ', ...
     '"ts": %4.6f, "w": "add_imu", ', ...
     '"orientation": [%4.6f, %4.6f, %4.6f, %4.6f], ', ...
     '"expected_phase_vector": ', ...
     '[%4.6f, %4.6f, %4.6f, ', ...
     '%4.6f, %4.6f, %4.6f, ', ...
     '%4.6f, %4.6f, %4.6f]', ...
     '}\n' ...
     ];
acc_data = acc_meas_out.measured_vector_B.data * 1e3;
mag_data = magnetometer_meas_out.measured_vector_B.data * 1e3;
gyr_data = gyro_meas_out.omega_I.data * rps2mdps;
output = '';
out_file = 'synthetic_input.ldj';

fid = fopen(out_file,'w');

for i = 1:n_samples
    rho = [q_BI_out.data(i, 2:4), omega_B_out.data(i, :), omega_I_bias_out.data(i, :)];
    s = sprintf(event_template, ...
        acc_data(i, :), ...
        gyr_data(i, :), ...
        t_series(i), ...
        mag_data(i, :), 0.0, ...
        rho ...
        );
    fprintf(fid, '%s', s);
end
fclose(fid);
% %% Clear temorary variables
clear out_file, fid, s, event_template, gyr_data, acc_data, mag_data;

