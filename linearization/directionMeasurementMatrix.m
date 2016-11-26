function H = directionMeasurementMatrix(ref_vector_I_skew, q_BI)
%#codegen
% Measurement matrix:
A = quaternion2dcm(q_BI);
H = [-2 * A * ref_vector_I_skew, zeros(3), zeros(3)];