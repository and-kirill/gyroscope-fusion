function y = rotateI2B(x_I, q_BI)
% Rotate vector from ECI to fixed reference frame if q represents body
% orientation in ECI reference frame

%#codegen
qWave = [q_BI(1), -q_BI(2:4)']';
xQuaternion = [0, x_I']';
resultQuaternion = quaternionMultiply(qWave, quaternionMultiply(xQuaternion, q_BI));
y = resultQuaternion(2:4, 1);