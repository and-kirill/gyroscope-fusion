clear;
N = 10000;
disturbance_factor = 10;
errs = zeros(1, N);

out_file = 'direction_measurement_test.txt';
% The following data should be written:
% - quaternion estimate              (4)
% - reference direction unit vector  (3)
% - quaternion disturbance, vector   (3)
% - expected measurement disturbance (3)
% Total 13 elements
test_data = zeros(N, 13);

for i = 1:N
    
    %% Generate and normalize quaternion
    q_hat = rand([4, 1]);
    q_hat = q_hat / norm(q_hat);
    
    %% Generate random reference vector
    r_ref_I = rand([3, 1]);
    r_ref_I = r_ref_I / norm(r_ref_I);
    
    %% Generate and normalize disturbance
    dq_vec = rand([3, 1]) / disturbance_factor;
    dq = [sqrt(1 - norm(dq_vec)^2); dq_vec];
    
    %% Derive true vector
    q_true = quaternionMultiply(dq, q_hat);
    r_B_true = rotateI2B(r_ref_I, q_true);
    
    
    %% Generate estimateinear solutions
    r_B_hat = rotateI2B(r_ref_I, q_hat);
    
    %% Generate measurement matrix
    r_ref_I_skew = vector2antiSkewSymOperator(r_ref_I);
    H = directionMeasurementMatrix(r_ref_I_skew, q_hat);
    
    
    %% Compare linear vs. nonl
    dz_true = r_B_true - r_B_hat;
    dz_lin = H * [dq(2:4); rand(6, 1)];
    errs(i) = norm(dz_true - dz_lin) / norm(dz_true);
    %% Save test vector
    test_data(i, :) = [q_hat', r_ref_I', dq(2:4)', dz_lin'];
    
end
dlmwrite(out_file, test_data);

display(sprintf( ...
    'Relative error with respect to disturbance magnitude: %2.2f (%2.2f)',...
    mean(errs), ...
    disturbance_factor ...
));
figure('Name', 'Direction measurement linearization error distribution');
hist(errs, N / 100);
title('Relative error distribution');