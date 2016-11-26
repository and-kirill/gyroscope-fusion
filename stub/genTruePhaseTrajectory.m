function solution = generate_true_phase_trajectory(q_BI_init, omega_B, omega_bias_I, t_step, t_sim)
% Generate true quaternion series for given angular velocity omega_B in
% fixed axes including omega_I_bias -- bias component in intertial axes

odeOptions = odeset( ...
    'RelTol', 1e-10, ...
    'AbsTol', 1e-10 ...
    );

rhsFunction = @(t, q)poissonRHS(t, q, omega_B, omega_bias_I);

q_sol = ode45(rhsFunction, [0, t_sim], q_BI_init, odeOptions);

t_series = 0:t_step:t_sim;
q_cont_true = deval(q_sol, t_series);

solution.q_series = q_cont_true;
solution.t_series = t_series;