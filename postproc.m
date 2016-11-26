%% Visualize angular velocity
figure('Name', 'Body frame angular velocity estmiate');
hold on;
colors = 'rgb';
for i = 1:3
    plot( ...
        omega_B_async.time, ...
        omega_B_async.data(:, i) * 180 / pi, ...
        sprintf('%s-', colors(i)) ...
        );
end
grid on;
legend('\omega_B^x', '\omega_B^y', '\omega_B^z');
xlabel('Time, sec');
ylabel('Estimated angular velocity, deg/s')

% Angular velocity drift
figure('Name', 'Gyroscope drift estmiate');
hold on;
colors = 'rgb';
for i = 1:3
    plot( ...
        omega_bias_I_async.time, ...
        omega_bias_I_async.data(:, i) * 180 / pi, ...
        sprintf('%s-', colors(i)) ...
        );
end
grid on;
legend('\omega_I^x', '\omega_I^y', '\omega_I^z');
xlabel('Time, sec');
ylabel('Estimated angular velocity drift, deg/s')

% Calculate Euler angles from quaternion
[r, p, y] = quat2angle(q_BI_async.data, 'yzx');
euler = [r, p, y] * 180 / pi;

% Visualize Euler angles
figure('Name', 'Orientation estmiate');
hold on;
colors = 'rgb';
for i = 1:3
    plot(q_BI_async.time, euler(:, i), sprintf('%s-', colors(i)));
end
grid on;
legend('Yaw', 'Pitch', 'Roll');
xlabel('Time, sec');
ylabel('Estimated Euler angles, deg');