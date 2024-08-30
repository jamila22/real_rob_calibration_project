% Function definition for errorAndJacobian

function [e, J] = errorAndJacobian(x, z)
    traction_ticks = z(1);
    steer_ticks = z(2);
    meas = z(3:5);

    pred_delta = predictTricycle(traction_ticks, steer_ticks, x);
    e = t2v(v2t(meas)^-1 * v2t(pred_delta));
    J = zeros(3, 4);
  
    for i = 1:4
        epsilon = zeros(4, 1);
        epsilon(i) = 1e-3;
        pred_delta_plus = predictTricycle(traction_ticks, steer_ticks, x + epsilon);
        pred_delta_minus = predictTricycle(traction_ticks, steer_ticks, x - epsilon);
        J(:, i) = (t2v((v2t(meas)^-1 * v2t(pred_delta_plus))) - t2v((v2t(meas)^-1 * v2t(pred_delta_minus)))) / (2e-3);
    endfor
endfunction

