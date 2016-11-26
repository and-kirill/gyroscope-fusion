function q_out = quaternionPredictor(q_BI, dt, omega_B, omega_I_bias)
% Discrete time quaternion predictor
F = quaternionLinearizedDynamics(q_BI);
dq_vec = F * [q_BI(2:4); omega_B; omega_I_bias] * dt;
dq = [1; dq_vec];
dq = dq / norm(dq);
q_out = quaternionMultiply(dq, q_BI);