import numpy as np
import matplotlib.pyplot as plt
import scipy 
import re 
import matplotlib

f = open("dataset.txt")

lines = f.read().splitlines()

c = 0

x_m = []
y_m = []
th_m = []
x_t = []
y_t = []
th_t = []
tau = []
abs_ticks = []
inc_ticks = []

for l in lines:
	c += 1
	if(c < 9):
		continue
	tokens = l.split(":")
	
	tracker_pose = tokens[-1].strip()
	tpose_comp = tracker_pose.split(" ")
	x_t.append(float(tpose_comp[0]))
	y_t.append(float(tpose_comp[1]))
	th_t.append(float(tpose_comp[2]))
	
	model_pose = tokens[-2].strip()
	model_pose = re.sub(r"\s+", 'z', model_pose)
	mpose_comp = model_pose.split("z")
	x_m.append(float(mpose_comp[0]))
	y_m.append(float(mpose_comp[1]))
	th_m.append(float(mpose_comp[2]))
	
	ticks = tokens[-3].strip()
	ticks_comp = ticks.split(" ")
	abs_ticks.append(float(ticks_comp[0]))
	inc_ticks.append(float(ticks_comp[1]))
	
	time = tokens[-4].strip()
	time_comp = time.split(" ")
	tau.append(float(time_comp[0]))
	
xt_np = np.asarray(x_t)
yt_np =	np.asarray(y_t)
tht_np = np.asarray(th_t)	
xm_np = np.asarray(x_m)
ym_np =	np.asarray(y_m)
thm_np = np.asarray(th_m)	
abs_ticks_np = np.asarray(abs_ticks)
inc_ticks_np = np.asarray(inc_ticks)
tau_np = np.asarray(tau)

n=len(xt_np)
 
t_pose_array = np.zeros((n,3)) 
t_pose_array[:,0] = xt_np
t_pose_array[:,1] = yt_np
t_pose_array[:,2] = tht_np

m_pose_array = np.zeros((n,3)) 
m_pose_array[:,0] = xm_np
m_pose_array[:,1] = ym_np
m_pose_array[:,2] = thm_np

ticks_array = np.zeros((n,2))
ticks_array[:,0] = abs_ticks_np
ticks_array[:,1] = inc_ticks_np

scipy.io.savemat("t_pose.mat", {"xt_np": xt_np,"yt_np": yt_np,"tht_np": tht_np})
scipy.io.savemat("m_pose.mat", {"x_np": xm_np,"y_np": ym_np,"tht_np": thm_np})
scipy.io.savemat("ticks.mat", {"abs_ticks_np": abs_ticks_np,"inc_ticks_np": inc_ticks_np})
scipy.io.savemat("time.mat", {"tau_np": tau_np})

fig = plt.figure()
colors = matplotlib.cm.rainbow(np.linspace(1, 0, n))

ax = fig.add_subplot(121)
ax.scatter(xm_np, ym_np, c=colors)
ax2 = fig.add_subplot(122)
ax2.scatter(xt_np, yt_np, c=colors)
ax2.axis("equal")
plt.show()
