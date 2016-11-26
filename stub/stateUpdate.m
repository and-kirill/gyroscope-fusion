function [q_BI, omega_B, omega_I_bias] = stateUpdate(delta_x, q_BI_in, omega_B_in, omega_I_bias_in)
% Increment quaternion by small rotation
dq = [1; delta_x(1:3)];
dq = dq / norm(dq);
q_BI = quaternionMultiply(dq, q_BI_in);
% Increment angular velocities:
omega_B = omega_B_in + delta_x(4:6);
omega_I_bias = omega_I_bias_in + delta_x(7:9);