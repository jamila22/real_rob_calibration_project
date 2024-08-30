1;

% Load data from .mat files
load('delta_t_pose.mat'); % Contains [delta_x_t(:), delta_y_t(:), delta_th_t(:)];
load('delta_m_pose.mat'); % Contains [delta_x_t(:), delta_y_t(:), delta_th_t(:)];
load('final_ticks.mat'); % Contains [delta_ticks, abs_ticks(1:end-1)];
%load('delta_time.mat');

observed_deltas = delta_t_pose_array'; %tracker deltas 
%observed_deltas = delta_t_pose_array'; %model deltas, uncomment for tricycle only
ticks = final_ticks';
%delta_tau = delta_tau';
Z = [ticks; observed_deltas];

%initial_params = [[0.0106141, 0.1,  0 , 1.4, 0 ,0 ,0]'; %uncomment for tricycle only
initial_params = [0.0106141, 0.1,  0 , 1.4, 1.5 ,0 ,0]';

%Compute true trajectory
true_trajectory = computeTrue(observed_deltas);

% Compute initial guess trajectory
initial_trajectory = computeTrajectory(initial_params, Z);

% Run the optimisation
num_iterations = 10; % Number of optimisation iterations
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

disp('Optimised parameters:');
disp(params);
