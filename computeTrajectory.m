% Function to compute trajectory given kin. params. and measurements
function trajectory = computeTrajectory(params, Z)
	n = size(Z, 2);
	trajectory = zeros(3, n);	
	pose = [0; 0; 0]; % Starting pose
    T_pose = v2t(pose);
  
    for i = 1:n
    	delta_pose = predictTricycle(Z(1, i), Z(2, i), params);
    	T_pose *= v2t(delta_pose);
    	trajectory(:, i) = t2v(T_pose);
    endfor
endfunction

