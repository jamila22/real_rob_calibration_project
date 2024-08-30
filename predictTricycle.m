%Function definition for predictTricycle inspired by: 
%probabilistic_robotics_2023_24/source/octave/19b_mobile_base_calibration/predictTricycle.m 

function delta_pose = predictTricycle(traction_ticks, steer_ticks, delta_tau, x)
    k_traction = x(1); 
    k_steer = x(2);
    steer_encoder_offset = x(3);
    baseline = x(4);

    traction_linear_offset = k_traction * traction_ticks;
    steering_angle =  k_steer * steer_ticks * 2 * pi + steer_encoder_offset;
    back_wheels_displacement = traction_linear_offset * cos(steering_angle);

    dth = traction_linear_offset * sin(steering_angle) / baseline;
    drho = back_wheels_displacement;

    %S = [0.00000, 0.00833, 0.00000, -0.16667, 0.00000, 1.00000];
    S =  [1, 0, -1/6, 0, 1/120, 0, -1/5040, 0];
    S = fliplr(S);
    %C = [0.00139, 0.00000, -0.04167, 0.00000, 0.50000, 0.00000];
    C = [0, -1/2, 0, 1/24, 0, -1/720, 0, 1/40320];
    C = fliplr(C);
    dx = drho * polyval(S, dth);
    dy = drho * polyval(C, dth);
    %delta_time_ref = mean(delta_tau);  % or median(delta_time_values)
    % Normalize delta_time by the reference time step
    %scaled_delta_time = delta_tau / delta_time_ref;

    % Scale the displacements by the normalized time step
    %dx = dx * scaled_delta_time;
    %dy = dy * scaled_delta_time;
    %dth = dth * scaled_delta_time;


    delta_pose = [dx; dy; dth];
endfunction
