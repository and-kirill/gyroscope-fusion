function F = quaternionLinearizedDynamics(q_BI)
% Calculate linearized quaternion dynamics for gyroscope Kalman filter.
% $\delta \dot{x}$ = F\delta x. Matrix F to be derived here.
% Constant angular velocity model with gyroscope bias is assumed. The state
% vector is the following: rho = [q, omega_B, omega_I_bias], where
% q -- quaternion vector part, omega_B -- body-frame angular rate,
% omega_I_bias -- gyroscope bias.
% The result matrix represents quaternion increment only, where
% dq = F * rho, and quaternion incremental equation is q = dq * q, where
% quaternion multiplication is assumed.

A = quaternion2dcm(q_BI);
F = [zeros(3), A' / 2, - eye(3) / 2];