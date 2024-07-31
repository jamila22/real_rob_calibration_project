function delta_pose = predictTricycle(traction_ticks, steer_ticks, x)
  k_traction = x(1); 
  k_steer = x(2);
  steer_encoder_offset = x(3);
  baseline = x(4);

  traction_linear_offset = k_traction * traction_ticks;
  fprintf('traction_linear_offset = %.4f\n', traction_linear_offset);
  
  steering_angle = k_steer * steer_ticks + steer_encoder_offset;
  fprintf('steering_angle = %.4f\n', steering_angle);
  
  back_wheels_displacement = traction_linear_offset * cos(steering_angle);
  fprintf('back_wheels_displacement = %.4f\n', back_wheels_displacement);
  
  dth = traction_linear_offset * sin(steering_angle) / baseline;
  fprintf('dth = %.4f\n', dth);
  
  drho = back_wheels_displacement;
  fprintf('drho = %.4f\n', drho);

  S = [0.00000, 0.00833, 0.00000, -0.16667, 0.00000, 1.00000];
  C = [0.00139, 0.00000, -0.04167, 0.00000, 0.50000, 0.00000];

  dx = drho * polyval(S, dth);
  fprintf('dx = %.4f\n', dx);
  
  dy = drho * polyval(C, dth);
  fprintf('dy = %.4f\n', dy);

  delta_pose = [dx; dy; dth];
endfunction

