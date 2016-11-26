function P = covariancePredictor(q_BI, dt, P)
%% Linearized dynamics:
F = eye(9);
F(1:3, :) = F(1:3, :) + dt * quaternionLinearizedDynamics(q_BI);

%% Model noise
q_noise = 0.1;
% Note, that yaw maneuver intensity is much hihger:
omega_B_noise = [4, 4, 4];
% Gyro drift evolves much slower than angular velocity
omega_bias_I_noise = 0.0001;

Q = diag([ ...
    ones(1, 3) * q_noise^2 * dt^2 / 2, ... Quternion evolution noise
    omega_B_noise.^2 * dt, ... Angular velocity evolution noise covariance
    ones(1, 3) * omega_bias_I_noise^2 * dt ... Gyro drift noise covariance
    ]);

%% Summary of dynamics and noisr
P = F * P * F' + Q;
end

