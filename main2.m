1;

% Load data from .mat files
load('delta_t_pose.mat'); % Contains [delta_x_t(:), delta_y_t(:), delta_th_t(:)];
load('final_ticks.mat'); % Contains [delta_ticks, abs_ticks(2:end)];
load('delta_time.mat');

observed_deltas = delta_t_pose_array';
ticks = final_ticks';
%delta_tau = delta_tau';
Z = [ticks; observed_deltas; delta_tau'];

% Initial parameters [k_traction, k_steer, steer_encoder_offset, baseline, x_s, y_s, theta_s]; #0.1 0.0106141 1.4 0
%initial_params = [0.0106141, -0.1, 0, 1.4, 1.5, 0, 0]';
%initial_params = [0.0106141, -0.5, 0, 1.4, -1.5, 0, 0.2]';
%initial_params = [1.1892e-02, 5.0033e-01, 6.0676e-05, 2.0219e+00, 1.9562, -0.1082, 0.3981]';
initial_params = [1.0399e-02, 4.9361e-01 2.6418e-03 2.0219e+00 1.9562e+00 -1.0820e-01 3.9810e-01]';

%Compute true trajectory
true_trajectory = computeTrue(observed_deltas);

% Compute initial guess trajectory
initial_trajectory = computeTrajectory(initial_params, Z);

% Run the optimisation
num_iterations = 19; % Number of optimisation iterations
params = initial_params;
chi_stats = zeros(1,num_iterations);

for i = 1:num_iterations
    [params, chi_s] = oneRound(params, Z);
    chi_stats(i) = chi_s;
endfor


% Create a vector for the x-axis representing the iteration numbers
iterations = 1:num_iterations;

% Plot the chi-squared errors over iterations
figure; % Create a new figure
plot(iterations, chi_stats, '-o', 'LineWidth', 2, 'MarkerSize', 6);

% Label the axes
xlabel('Iteration Number');
ylabel('Chi-Squared Error');

% Add a title to the plot
title('Chi-Squared Error vs. Iteration');

% Optionally, add grid lines to the plot
grid on;

% Display the plot
drawnow;
% Compute optimised trajectory
optimized_trajectory = computeTrajectory(params, Z);

% Plot trajectories
h = figure;
hold on;
plot(true_trajectory(1, :), true_trajectory(2, :), 'g', 'DisplayName', 'Ground Truth');
plot(initial_trajectory(1, :), initial_trajectory(2, :), 'r', 'DisplayName', 'Initial Guess');
plot(optimized_trajectory(1, :), optimized_trajectory(2, :), 'b', 'DisplayName', 'Optimised');
legend show;
xlabel('X Position');
ylabel('Y Position');
title('Trajectories');
hold off;
waitfor(h);

disp('Optimized parameters:');
disp(params);


