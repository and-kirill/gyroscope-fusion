function dcm = quaternion2dcm(q_BI)
%#codegen
dcm = zeros(3);

dcm(1,1) = q_BI(1)^2 + q_BI(2)^2 - q_BI(3)^2 - q_BI(4)^2;
dcm(1,2) = 2 * (q_BI(2) * q_BI(3) + q_BI(1) * q_BI(4));
dcm(1,3) = 2 * (q_BI(2) * q_BI(4) - q_BI(1) * q_BI(3));

dcm(2,1) = 2 * (q_BI(2) * q_BI(3) - q_BI(1) * q_BI(4));
dcm(2,2) = q_BI(1)^2 - q_BI(2)^2 + q_BI(3)^2 - q_BI(4)^2;
dcm(2,3) = 2 * (q_BI(3) * q_BI(4) + q_BI(1) * q_BI(2));

dcm(3,1) = 2 * (q_BI(2) * q_BI(4) + q_BI(1) * q_BI(3));
dcm(3,2) = 2 * (q_BI(3) * q_BI(4) - q_BI(1) * q_BI(2));
dcm(3,3) = q_BI(1)^2 - q_BI(2)^2 - q_BI(3)^2 + q_BI(4)^2;
