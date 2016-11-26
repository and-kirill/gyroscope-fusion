function meas = loadMeasurements(source_name, axes_sequence)
load(sprintf('%s.dat', source_name));
data = eval(source_name);
meas.time = data(:, 1);

data_vec = data(:, 2:4);

meas.signals.values = zeros(size(data_vec));
for i = 1:3
    signum = sign(axes_sequence(i));
    id = abs(axes_sequence(i));
    meas.signals.values(:, i) = signum * data_vec(:, id);
end
