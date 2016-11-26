function q_dot = quaternionDynamics(q_BI, omega_B)
q_dot = quaternionMultiply(q_BI, [0; omega_B]) / 2;