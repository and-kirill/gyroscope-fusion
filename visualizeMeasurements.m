function [] = visualizeMeasurements(data, data_name)
figure('Name', sprintf('%s measurements'));

plot(data.time, data.signals.values(:, 1), 'r--');
hold on;
plot(data.time, data.signals.values(:, 2), 'g--');
plot(data.time, data.signals.values(:, 3), 'b--');
grid on;
legend('x', 'y', 'z');
