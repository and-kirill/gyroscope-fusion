function q_dot = poissonRHS(~, q_BI, omega_B, omega_offset_I)
omega_B_true = omega_B - rotateI2B(omega_offset_I, q_BI);
q_dot = quaternionDynamics(q_BI, omega_B_true);
end