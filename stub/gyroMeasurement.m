function omega_I = gyroMeasurement(q_BI, omega_B)
omega_I_true = rotateB2I(omega_B, q_BI);
noise = randn([3, 1]) * 0.0;
omega_I = omega_I_true + noise;