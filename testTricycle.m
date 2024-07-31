% Parameters x = [k_traction, k_steer, steer_encoder_offset, baseline]
x = [10^-2, 1, 0, 5*10^-1];

% Test cases for traction_ticks and steer_ticks
test_cases = [
  10, 90;
  20, 90;
  30, 90;
  40, 90;
  0, 90;
  1, 90;
  1, 90;
  1, 90;
  1, 90;
  1, 0
];

% Run the model for each test case and print the results
for i = 1:size(test_cases, 1)
  traction_ticks = test_cases(i, 1);
  steer_ticks = test_cases(i, 2);
  fprintf('Test Case %d: Traction Ticks = %d, Steer Ticks = %d\n', i, traction_ticks, steer_ticks);
  delta_pose = predictTricycle(traction_ticks, steer_ticks, x);
  fprintf('Delta Pose: [dx = %.4f, dy = %.4f, dth = %.4f]\n', delta_pose(1), delta_pose(2), delta_pose(3));
  fprintf('---------------------------------------\n');
end

