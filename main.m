1;

% Load data from .mat files
load('delta_m_pose.mat'); % Contains [delta_x_m(:), delta_y_m(:), delta_th_m(:)];
load('final_ticks.mat'); % Contains [delta_ticks, abs_ticks(2:end)];

observed_deltas = delta_m_pose_array';
ticks = final_ticks';
Z = [ticks; observed_deltas];

% Initial parameters [k_traction, k_steer, steer_encoder_offset, baseline]
initial_params = [0.0106141, 0.1, 0, 1.4 ]';

%Compute true trajectory
true_trajectory = computeTrue(observed_deltas);

% Compute initial guess trajectory
initial_trajectory = computeTrajectory(initial_params, Z);

% Run the optimisation
num_iterations = 15; % Number of optimization iterations
params = initial_params;
for i = 1:num_iterations
  [params, chi] = oneRound(params, Z)
endfor

% Compute optimised trajectory
optimized_trajectory = computeTrajectory(params, Z);


% Plot trajectories
figure;
hold on;
plot(true_trajectory(1, :), true_trajectory(2, :), 'g', 'DisplayName', 'Ground Truth');
plot(initial_trajectory(1, :), initial_trajectory(2, :), 'r', 'DisplayName', 'Initial Guess');
plot(optimized_trajectory(1, :), optimized_trajectory(2, :), 'b', 'DisplayName', 'Optimised');
legend show;
xlabel('X Position');
ylabel('Y Position');
title('Trajectories');
hold off;
pause;

disp('Optimized parameters:');
disp(params);


