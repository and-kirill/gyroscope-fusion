clear;
N = 100;
disturbance_factor = 100;
errs = zeros(1, N);

out_file = 'gyro_measurement_test.txt';
% The following data should be written:
% - quaternion estimate                 (4)
% - body frame angular rate estimate    (3)
% - quaternion disturbance, vector      (3)
% - body frame angular rate disturbance (3)
% - expected measurement disturbance    (3)
% Total 16 elements
test_data = zeros(N, 16);

for i = 1:N
    %% Generate some random state estimate
    q_hat = rand([4, 1]);
    q_hat = q_hat / norm(q_hat);
    omega_B_hat = rand([3, 1]);
    
    %% Generate and normalize disturbance
    dq_vec = rand([3, 1]) / disturbance_factor;
    dq = [sqrt(1 - norm(dq_vec)^2); dq_vec];
    d_omega_B = rand([3, 1]) / disturbance_factor;
    
    %% Derive true vector
    q_true = quaternionMultiply(dq, q_hat);
    omega_B_true = omega_B_hat + d_omega_B;
   
    omega_I_true = rotateB2I(omega_B_true, q_true);
    omega_I_hat = rotateB2I(omega_B_hat, q_hat);

    meas_true = omega_I_true;
    meas_hat = omega_I_hat;

    %% Check difference
    dz_true = meas_true - meas_hat;
    omega_hat_I_skew = vector2antiSkewSymOperator(omega_I_hat);
    H = gyroMeasurementMatrix(q_hat, omega_hat_I_skew);
    dz_lin = H * [dq(2:4); d_omega_B; rand(3, 1)];
    errs(i) = norm(dz_true - dz_lin) / norm(dz_true);

    %% Save test vector
    test_data(i, :) = [q_hat', omega_B_hat', dq(2:4)', d_omega_B', dz_lin'];
end

dlmwrite(out_file, test_data);

display(sprintf( ...
    'Relative error with respect to disturbance magnitude: %2.2f (%2.2f)',...
    mean(errs), ...
    disturbance_factor ...
));
figure('Name', 'Gyroscope measurement linearization error distribution');
hist(errs, N / 100);
title ('Relative error distribution');