function y = rotateB2I(x_B, q_BI)
% Rotate vector from  fixed reference frame to ECI if q represents body
% orientation in ECI reference frame
%#codegen
qWave = [q_BI(1), -q_BI(2:4)']';
xQuaternion = [0, x_B']';
resultQuaternion = quaternionMultiply(q_BI, quaternionMultiply(xQuaternion, qWave));
y = resultQuaternion(2:4, 1);