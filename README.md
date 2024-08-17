# real_rob_calibration_project
This repo contains my implementation of the project #4 of probabilistic robotics, titled: "Calibration of a real robot". 

Task description:
Calibrate the kinematic parameters and the sensor pose of a front-tractor tricycle-like robot.

INPUTS: 1) A file containing the encoder ticks of all encoders in the system:
	   -absolute on the steer axis;
 	   -incremental on the steering wheel.
        
        2) The 2D poses of the sensor w.r.t. an external tracking system.
        
OUTPUTS: 1) The 2D pose of the sensor w.r.t. the mobile platform.
         2) The kinenemaic parameters: Ksteer, Ktraction, SteerOffset, Baseline.
         
For simplicity, being the pose of the mobile platform available, the problem was split into two subproblems. The sensor data has been discarded at first to prioritise model testing and kinematic parameters calibration.        
