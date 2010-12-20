#!/usr/bin/python

#from scipy.interpolate import griddata
from matplotlib.mlab import griddata
from numpy import *
from numpy.random import uniform, seed
import numpy as np
import matplotlib.pyplot as plt
from numpy.random import uniform, seed
import numpy.ma as ma


data = genfromtxt("data.dat")

x = data[:,2]
y = data[:,1]
z = data[:,3]

xi = linspace(0,360,100)
yi = linspace(-90,90,100)
#zi = griddata((x, y), z, (xi[None,:], yi[:,None]), method='cubic')
zi = griddata(x, y, z, xi, yi)

CS = plt.contour(xi,yi,zi,15,linewidths=0.5,colors='k')
CS = plt.contourf(xi,yi,zi,15,cmap=plt.cm.jet)
plt.colorbar() # draw colorbar
#plt.scatter(x,y,marker='o',c='b',s=5)
plt.show()
