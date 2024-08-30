% Function to compute the true trajectory given a sequence of deltas
function trajectory = computeTrue(x)
    n = size(x,2);
    current_T = v2t(zeros(1,3));
    trajectory = zeros(3,n);
    
    for i = 1:n
      delta = x(1:3, i)';
      current_T *= v2t(delta);
      trajectory(:,i) = t2v(current_T)';
    endfor
endfunction
