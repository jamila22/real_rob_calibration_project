% Function definition for oneRound

function [x, chi_s] = oneRound(x, Z)
    H = zeros(7, 7);
    b = zeros(7, 1);
    chi_s = 0;
    %threshold = 0.1;
  
    for i = 1:size(Z,2)
    
    	[e, J, gamma] = finalerrorAndJacobian(x, Z(:, i));
    	chi = e' * e;
    	chi_s += chi;
    
    	omega =  eye(3);
    	%omega(1,1) *= 0.1; 
    	%omega(2,2) *= 0.3;
    	%omega(3,3) *= 1;    
  
           
    	H += J_norm' * gamma * omega * J_norm;
    	factor = eye(7);
    	%factor(1,1) = 0
    	damp_H = H + factor;
    	b += J_norm' * gamma * omega * e;
    endfor
    
  % Solve for dx and update 
  dx = -damp_H \ b;
  
  if any(isnan(dx)) || any(isinf(dx))
      error('Computed dx contains NaN or Inf values.');
  endif
  
  x(1:4) += dx(1:4);
  x(5:7) = t2v(v2t(x(5:7)) * v2t(dx(5:7)'));
endfunction
