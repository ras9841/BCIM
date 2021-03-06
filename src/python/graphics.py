"""
Figure generators
"""
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def plot_msd(msd):
  """
  Plots msd for each species given.
  Plots in the current figure.
  
  Parameters
  ----------
  msd - a matrix with the first column corresponding to the time of the measurement
      and the following columns with the msd at those times for each species
  """
  lines = ['x', '+']
  for i in range(1,len(msd[1,:])):
    labels = [ 'Cancerous', 'Healthy' ]
    # Line
    plt.plot(msd[:,0], msd[:,i], lines[i%2], label=labels[i%2] )
    # Current axes
    ax = plt.gcf().gca()
    # Linear fit
    slope,intercept=np.polyfit(msd[:,0],msd[:,i], 1)
    slope = int(slope*100)/100
    # Put fit on graph
    plt.text(0.05, 0.4-i*0.05,\
      'Sp. {0}: {1}'.format(i,slope),\
      transform = ax.transAxes,fontsize=18)
  # Titles
  plt.gca().set_title('Mean Square Displacement')
  plt.xlabel('Time')
  plt.ylabel('MSD')
  plt.legend(loc=2, fontsize=22)


def plot_config(parts, params):
  """
  Plots positions in 3d figure
  """
  colors = ['r', 'b', 'c', 'm']
  ax = plt.gca()
  ax.view_init(elev=15,azim=30)
  cl = []
  xpos, ypos, zpos = [], [], []
  for part in parts:
    cl.append( colors[part.sp-1] )
    xpos.append(part.x[0])
    ypos.append(part.x[1])
    zpos.append(part.x[2])

  ax.scatter(xpos,ypos,zpos,c=cl, s=70, lw=0)
  plot_bounds(params, plt.gca())
  ax.set_xlim3d(-params["size"], params["size"])
  ax.set_ylim3d(-params["size"], params["size"])
  ax.set_zlim3d(-params["size"], params["size"])

def plot_bounds(params, axes):
  """ plotBounds : Dict Axes -> True
  Draws a sphere with a radius of the system size
  """
  u = np.linspace(0, 2*np.pi, 100)
  v = np.linspace(0, np.pi, 100)

  x = params["size"]*np.outer(np.cos(u), np.sin(v))
  y = params["size"]*np.outer(np.sin(u), np.sin(v))
  z = params["size"]*np.outer(np.ones(np.size(u)), np.cos(v))
  axes.plot_surface(x, y, z, rstride=4, cstride=4, color='b', alpha = 0.05,\
    linewidth=0)

def plot_cluster_hist(hist, params, color='r'):
  plt.bar(range(len(hist)) , hist, color=color)
  plt.title('Cluster Sizes')
  plt.xlabel('Size of Cluster (Cells)')
  plt.ylabel('Number of Clusters')
  plt.xlim(0,len(hist))

def plot_counts(t, counts, params):
  s0 = []
  s1 = []
  s2 = []
  for time in range(len(counts[0])):
    s0.append(counts[0][time] + counts[1][time])
    s1.append(counts[0][time])
    s2.append(counts[1][time])
  plt.plot(t, s0, '--k', label='Total')
  plt.plot(t, s1, 'r', label='Healthy')
  plt.plot(t, s2, 'b', label='Cancerous')
  plt.title('Cell Counts')
  plt.legend(loc=2)
  
