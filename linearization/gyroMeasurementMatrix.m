function H = gyroMeasurementMatrix(q_BI, omega_hat_I_skew)
%#codegen
At = quaternion2dcm(q_BI)';
H = [2 * omega_hat_I_skew, At, zeros(3)];