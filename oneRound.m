% Function definition for oneRound

function [x, chi] = oneRound(x, Z)
    H = zeros(4, 4);
    b = zeros(4, 1);
    chi = 0;
    threshold = 1;
  
    for i = 1:size(Z, 2)
    	[e, J] = errorAndJacobian(x, Z(:, i));
    	chi += e' * e;
    
    if chi > threshold
    	e *= sqrt(threshold/chi);
    	chi=threshold;
    endif
    
    omega = eye(3)*17;       
    H += J' * omega * J;
    damp_H = H + eye(4);
    b += J' * omega * e;
    endfor
  
  % Solve for dx and update 
  dx = -damp_H \ b
  
  if any(isnan(dx)) || any(isinf(dx))
      error('Computed dx contains NaN or Inf values.');
  endif
  
  x += dx;
endfunction

