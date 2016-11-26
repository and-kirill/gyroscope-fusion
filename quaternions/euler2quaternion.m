function q_BI = euler2quaternion(yaw, pitch, roll)
%#codegen
% Axes: oX -- car heading, oY -- vertical axis. oZ = [oX, oY]
% Rotation sequence:
% 1. yaw,   around Y axis
% 2. pitch, around Z axis
% 3. roll,  around X axis
sang = sin([yaw, pitch, roll] / 2);
cang = cos([yaw, pitch, roll] / 2);

q_BI = [...
    cang(1) * cang(2) * cang(3) - sang(1) * sang(2) * sang(3); ...
    cang(1) * cang(2) * sang(3) + sang(1) * sang(2) * cang(3); ...
    cang(1) * sang(2) * sang(3) + sang(1) * cang(2) * cang(3); ...
    cang(1) * sang(2) * cang(3) - sang(1) * cang(2) * sang(3) ...
    ];