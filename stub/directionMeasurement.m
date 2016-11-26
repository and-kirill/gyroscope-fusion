function meas_vector_B = directionMeasurement(ref_vector_I, q_BI)
ref_vector_B = rotateI2B(ref_vector_I, q_BI);
meas_vector_B = ref_vector_B + randn([3, 1]) * 0.1;
meas_vector_B = meas_vector_B / norm(meas_vector_B);