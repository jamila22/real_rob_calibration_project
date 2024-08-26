% Function definition for finalerrorAndJacobian

function [e, J, gamma] = finalerrorAndJacobian(x, z)
    traction_ticks = z(1);
    steer_ticks = z(2);
    meas = z(3:5);
    delta_tau = z(6);
    x_kin = [x(1,1), x(2,1), x(3,1), x(4,1)];
    x_s = [x(5); x(6); x(7)];
    T_x_s = v2t(x_s);

    %pred_delta_tri = predictTricycle(traction_ticks, steer_ticks, x_kin)
    pred_delta_sensor = predictTricyclesensor(traction_ticks, steer_ticks, delta_tau, x);
     
    e = t2v(v2t(meas)^-1 * v2t(pred_delta_sensor));
    J = zeros(3, 7);
    u = sqrt(e' * e);
    gamma = 1 / (1+u^2)^2;
  
    for i = 1:4
        epsilon = zeros(4, 1);
        epsilon(i) = 1e-9;
        T_pred_delta_plus = T_x_s^-1 * v2t(predictTricycle(traction_ticks, steer_ticks, delta_tau, x_kin + epsilon)) * T_x_s;
        T_pred_delta_minus = T_x_s^-1 * v2t(predictTricycle(traction_ticks, steer_ticks, delta_tau, x_kin - epsilon)) * T_x_s;
        J(:, i) = (t2v((v2t(meas)^-1 * T_pred_delta_plus)) - t2v((v2t(meas)^-1 * T_pred_delta_minus))) / (2e-9);
    endfor
    
    for i = 1:3
    	epsilon = zeros(3,1);
    	epsilon(i) = 1e-9;
    	T_delta_s_plus = T_x_s * v2t(epsilon);
    	T_delta_s_minus = T_x_s * v2t(-epsilon);
    	J(:, 4+i) = (t2v(v2t(meas)^-1 * T_delta_s_plus^-1 * v2t(predictTricycle(traction_ticks, steer_ticks, delta_tau, x_kin)) * T_delta_s_plus) - t2v(v2t(meas)^-1 * T_delta_s_minus^-1 * v2t(predictTricycle(traction_ticks, steer_ticks, delta_tau, x_kin)) * T_delta_s_minus)) / (2e-9); 	
    endfor 
endfunction

