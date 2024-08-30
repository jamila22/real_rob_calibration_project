% Define needed maximum values 
MAX_UINT32 = 4294967295;
MAX_ABS_ENCODER = 8192;
MAX_INC_ENCODER = 5000;

% Open file and read lines
fid = fopen('dataset.txt', 'r');
lines = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

lines = lines{1}; #remove outer cell

n = length(lines);

% Initialise variables
x_m = [];
y_m = [];
th_m = [];
x_t = [];
y_t = [];
th_t = [];
tau = [];
abs_ticks = [];
inc_ticks = [];

% Process each line
for i = 1:n
    l = lines{i};
    if i < 9
        continue; #ignore first 9 lines 
    end
    tokens = strsplit(l, ':');
    
    tracker_pose = strtrim(tokens{end});
    tpose_comp = str2double(strsplit(tracker_pose, ' '));
    x_t(end+1) = tpose_comp(1);
    y_t(end+1) = tpose_comp(2);
    th_t(end+1) = tpose_comp(3);
    
    model_pose = strtrim(tokens{end-1});
    mpose_comp = str2double(strsplit(model_pose, ' '));
    x_m(end+1) = mpose_comp(1);
    y_m(end+1) = mpose_comp(2);
    th_m(end+1) = mpose_comp(3);
    
    ticks = strtrim(tokens{end-2});
    ticks_comp = str2double(strsplit(ticks, ' '));
    abs_ticks(end+1) = ticks_comp(1);
    inc_ticks(end+1) = ticks_comp(2);
    
    time = strtrim(tokens{end-3});
    time_comp = str2double(strsplit(time, ' '));
    tau(end+1) = time_comp(1);
end

% Convert to matrices
n = length(x_t);
t_pose_array = [x_t(:), y_t(:), th_t(:)];
m_pose_array = [x_m(:), y_m(:), th_m(:)];
ticks_array = [abs_ticks(:), inc_ticks(:)];

% Calculate time differences
delta_tau = diff(tau)';

% Initialize delta pose arrays
delta_t_pose_array = zeros(n-1, 3);
delta_m_pose_array = zeros(n-1, 3);

% Calculate delta poses
for i = 2:n
    past_t_pose = t_pose_array(i-1, :)';
    new_t_pose = t_pose_array(i, :)';
    delta_t_pose_array(i-1, :) = t2v(inv(v2t(past_t_pose)) * v2t(new_t_pose))';
    
    past_m_pose = m_pose_array(i-1, :)';
    new_m_pose = m_pose_array(i, :)';
    delta_m_pose_array(i-1, :) = t2v(inv(v2t(past_m_pose)) * v2t(new_m_pose))';
end

% Calculate incremental ticks (traction)
delta_ticks = diff(ticks_array(:,2))';
 
% Correct for overflow
for i = 1:length(delta_ticks)
    if delta_ticks(i) < -MAX_UINT32 / 2
        delta_ticks(i) = delta_ticks(i) + MAX_UINT32 ;
    elseif delta_ticks(i) > MAX_UINT32 / 2
        delta_ticks(i) = delta_ticks(i) - MAX_UINT32 ;
    end    
end
% Correct ranges
delta_ticks = delta_ticks / MAX_INC_ENCODER ;

delta_abs_ticks = diff(ticks_array(:,1))';
 
% Correct for overflow
for i = 1:length(delta_abs_ticks)
    if delta_abs_ticks(i) < -MAX_ABS_ENCODER / 2
        delta_abs_ticks(i) = delta_abs_ticks(i) + MAX_ABS_ENCODER;
    elseif delta_abs_ticks(i) > MAX_ABS_ENCODER / 2
        delta_abs_ticks(i) = delta_abs_ticks(i) -MAX_ABS_ENCODER ;
    end
end
% Go back to absolute values
old_abs = abs_ticks(1);
new_abs = zeros(1,length(abs_ticks));

for i = 1:length(delta_abs_ticks)
	new_abs(i) = old_abs + delta_abs_ticks(i);
	old_abs = new_abs(i);
end

% Create final ticks matrix
final_ticks = [delta_ticks; new_abs(1:end-1)/MAX_ABS_ENCODER]';


% Save data to MAT-files
save('delta_t_pose.mat', 'delta_t_pose_array');
save('delta_m_pose.mat', 'delta_m_pose_array');
save('final_ticks.mat', 'final_ticks');
save('delta_time.mat', 'delta_tau');

% Print sizes of saved data
printf('Size of t_pose_array: %d x %d\n', size(t_pose_array));
printf('Size of m_pose_array: %d x %d\n', size(m_pose_array));
printf('Size of ticks_array: %d x %d\n', size(ticks_array));
printf('Size of tau: %d\n', length(tau));

printf('Size of t_pose_array: %d x %d\n', size(delta_t_pose_array));
printf('Size of m_pose_array: %d x %d\n', size(delta_m_pose_array));
printf('Size of ticks_array: %d x %d\n', size(final_ticks));
printf('Size of tau: %d\n', length(delta_tau));

% Plot model and tracker position
h = figure;
colors = linspace(1, 0, n);

subplot(1, 2, 1);
scatter(m_pose_array(:,1), m_pose_array(:,2), [], colors, 'filled');
title('Model Pose');
axis equal;

subplot(1, 2, 2);
scatter(t_pose_array(:,1), t_pose_array(:,2), [], colors, 'filled');
title('Tracker Pose');
axis equal;

waitfor(h);
