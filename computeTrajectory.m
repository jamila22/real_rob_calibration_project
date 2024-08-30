% Function to compute trajectory given kin. params. and measurements
function trajectory = computeTrajectory(params, Z)
	n = size(Z, 2);
	deltas = zeros(3, n);
	
	%x_s = params(5);
	%y_s = params(6);
	%theta_s = params(7);	
	%pose_s = [x_s; y_s; theta_s]; % Sensor pose
        %T_pose_s = v2t(pose_s);
        %T_pose = T_pose_s;
        
    for i = 1:n
    	delta_pose = predictTricyclesensor(Z(1, i), Z(2, i), Z(6,i), params);
    	%T_delta_pose_tri = v2t(delta_pose_tri);
    	%T_delta_pose = v2t(delta_pose);
    	%T_pose *= T_delta_pose;
    	deltas(:, i) = delta_pose;
    	
    endfor
    trajectory = computeTrue(deltas);
endfunction

