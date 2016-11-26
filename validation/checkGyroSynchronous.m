clear;
t_sim = 50;
t_step = 0.001;

%% Generate true phase trajectory
omega_B_true = rand([3, 1]);
gyro_mean_bias = rand([3, 1]); % Mean drift values for gyroscope;
q_init = rand([4, 1]);
% Normalize quaternion to one
q_init = q_init / norm(q_init);
solution_true = genTruePhaseTrajectory( ...
    q_init, omega_B_true, gyro_mean_bias, t_step, t_sim ...
    );
q_cont_true = solution_true.q_series;

%% Kalman Initial conditions
q_BI = q_init;%[1; 0; 0; 0];      % Phase vector: initial quaternion
omega_B = omega_B_true;%[0; 0; 0];      % Pgase vector: initial angular velocity (body axes)
omega_I_bias = gyro_mean_bias;%[0; 0; 0]; % Phase vector: initial gyro bias
P = eye(9); % Initial covariance

t_series = solution_true.t_series;
q_BI_estimate = zeros(4, length(t_series));
q_BI_estimate(:, 1) = q_BI;
%% Run Kalman filter

for i = 2:length(t_series)
    % Kalman predictor step
    q_BI = quaternionPredictor(q_BI, t_step, omega_B, omega_I_bias);
    P = covariancePredictor(q_BI, t_step, P);
    
    % Kalman update steps:
    % 1. Gyro measurement:
    omega_I = gyroMeasurement(q_BI, omega_B_true);
    omega_I_hat = rotateB2I(omega_B, q_BI);
    delta_z = omega_I - omega_I_hat;
    
    H = gyroMeasurementMatrix(q_BI, vector2antiSkewSymOperator(omega_I_hat));
    R = eye(3);
    K = P * H' * inv(H * P * H' + R);
    delta_x = K * delta_z;
    [q_BI, omega_B, omega_I_bias] = stateUpdate(delta_x, q_BI, omega_B, omega_I_bias);
    P = (eye(9) - K * H) * P;
    
    % 2. Some 'vertical' vector measurement:
    ref_vector_I = [0; -1; 0];
    meas_vector_B = directionMeasurement(ref_vector_I, q_cont_true(:, i));
    meas_vector_B_hat = rotateI2B(ref_vector_I, q_BI);

    delta_z = meas_vector_B - meas_vector_B_hat;
    H = directionMeasurementMatrix( ...
        vector2antiSkewSymOperator(ref_vector_I), ...
        q_BI ...
        );
    
    R = eye(3) / 100;
    K = P * H' * inv(H * P * H' + R);
    delta_x = K * delta_z;
    [q_BI, omega_B, omega_I_bias] = stateUpdate(delta_x, q_BI, omega_B, omega_I_bias);
    P = (eye(9) - K * H) * P;
    % 3. Some 'horizontal' vector measurement:
    ref_vector_I = [1; 0; 0];
    meas_vector_B = directionMeasurement(ref_vector_I, q_cont_true(:, i));
    meas_vector_B_hat = rotateI2B(ref_vector_I, q_BI);

    delta_z = meas_vector_B - meas_vector_B_hat;
    H = directionMeasurementMatrix( ...
        vector2antiSkewSymOperator(ref_vector_I), ...
        q_BI ...
        );
    
    R = eye(3) / 100;
    K = P * H' * inv(H * P * H' + R);
    delta_x = K * delta_z;
    [q_BI, omega_B, omega_I_bias] = stateUpdate(delta_x, q_BI, omega_B, omega_I_bias);
    P = (eye(9) - K * H) * P;
    % Save result quaternion:
    q_BI_estimate(:, i) = q_BI;
end

%% Visualize data
n = size(q_cont_true, 2);
d_phi = zeros(1, n);
for i = 1:n
    dq = quaternionMultiply(q_cont_true(:, i), [q_BI_estimate(1, i); -q_BI_estimate(2:4, i)]);
    d_phi(i) = asin(norm(dq(2:4)));
end
t_series = solution_true.t_series;
colors = 'krgb';

figure('Name', 'Gyro measurement test (non-simulink), orientation error ');
title('Total angular deviation');
plot(t_series, d_phi * 180 / pi);
xlabel('Time, sec');
ylabel('Absolute angular deviation, deg');
grid on;