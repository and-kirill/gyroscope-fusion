% Measurement linearization test
checkDirectionMeasurementLinearization;
checkGyroMeasurementLinearization;

% State extrapolation test
testLinearExtrapolation;
checkLinearExtrapolation; % Non-simulink version of previous test

% Direction measurement test
testDirectionCorrector;

% Gyroscope emasurement tests
testGyroSynchronous;
checkGyroSynchronous; % Non-simulink version of previous test

% Test for loading data from workspace
runGyroFusion;