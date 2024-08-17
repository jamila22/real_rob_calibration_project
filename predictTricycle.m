%Function definition for predictTricycle inspired by: 
%probabilistic_robotics_2023_24/source/octave/19b_mobile_base_calibration/predictTricycle.m 

function delta_pose = predictTricycle(traction_ticks, steer_ticks, x)
    k_traction = x(1); 
    k_steer = x(2);
    steer_encoder_offset = x(3);
    baseline = x(4);

    traction_linear_offset = k_traction * traction_ticks;
    steering_angle = 2 * pi * k_steer * steer_ticks + steer_encoder_offset;
    back_wheels_displacement = traction_linear_offset * cos(steering_angle);

    dth = traction_linear_offset * sin(steering_angle) / baseline;
    drho = back_wheels_displacement;

    S = [0.00000, 0.00833, 0.00000, -0.16667, 0.00000, 1.00000];
    C = [0.00139, 0.00000, -0.04167, 0.00000, 0.50000, 0.00000];

    dx = drho * polyval(S, dth);
    dy = drho * polyval(C, dth);

    delta_pose = [dx; dy; dth];
endfunction
