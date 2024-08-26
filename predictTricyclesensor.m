%Function definition for predictTricycle inspired by: 
%probabilistic_robotics_2023_24/source/octave/19b_mobile_base_calibration/predictTricycle.m 

function delta_pose_sensor = predictTricyclesensor(traction_ticks, steer_ticks, delta_time , x)
    k_traction = x(1); 
    k_steer = x(2);
    steer_encoder_offset = x(3);
    baseline = x(4);
    x_s = x(5);
    y_s = x(6);
    theta_s = x(7);
    pose_s = [x_s; y_s; theta_s];

    traction_linear_offset = k_traction * traction_ticks;
    steering_angle = k_steer * steer_ticks * pi + steer_encoder_offset;
    back_wheels_displacement = traction_linear_offset * cos(steering_angle);

    dth = traction_linear_offset * sin(steering_angle) / baseline;
    drho = back_wheels_displacement;

    S =  [1, 0, -1/6, 0, 1/120, 0, -1/5040, 0];
    S = fliplr(S);
    C = [0, -1/2, 0, 1/24, 0, -1/720, 0, 1/40320];
    C = fliplr(C);
    dx = drho * polyval(S, dth);
    dy = drho * polyval(C, dth);
    
    delta_time_ref = mean(delta_time);  % or median(delta_time_values)
    % Normalize delta_time by the reference time step
    scaled_delta_time = delta_time / delta_time_ref;

    % Scale the displacements by the normalized time step
    dx = dx * scaled_delta_time;
    dy = dy * scaled_delta_time;
    dth = dth * scaled_delta_time;

    delta_pose_tri = [dx; dy; dth];
    T_delta_pose_tri = v2t(delta_pose_tri);
    T_pose_s = v2t(pose_s);
    
    delta_pose_sensor = t2v(T_pose_s^-1 * T_delta_pose_tri * T_pose_s);
endfunction
