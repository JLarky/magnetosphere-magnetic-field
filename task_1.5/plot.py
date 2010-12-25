#!/usr/bin/python

#from scipy.interpolate import griddata
from matplotlib.mlab import griddata
from numpy import *
from numpy.random import uniform, seed
import numpy as np
import matplotlib.pyplot as plt
from numpy.random import uniform, seed
import numpy.ma as ma


def plotone(x,y,z):
    z = np.maximum( z, 0.001 )
    z = np.minimum( z, 40 )

    xi = linspace(0,360,100)
    yi = linspace(-90,90,100)
#zi = griddata((x, y), z, (xi[None,:], yi[:,None]), method='cubic')
    zi = griddata(x, y, z, xi, yi)

    print zi
    
    if True:
        CS = plt.contour(xi,yi,zi,15,linewidths=0.5,colors='k')
        CS = plt.contourf(xi,yi,zi,15,cmap=plt.cm.jet)
        plt.xlim(0,360)
        plt.ylim(-90,90)
        plt.colorbar() # draw colorbar
    #plt.scatter(x,y,marker='o',c='b',s=5)
    else:
        v = 100
    #plt.imshow(zi,vmin=-v,vmax=v)
        plt.imshow(zi, vmin=0)
        plt.colorbar() # draw colorbar


plt.figure(num=None, figsize=(12, 10), dpi=90, facecolor='w', edgecolor='k') 

data = genfromtxt("data.dat")

x = data[:,2]
y = data[:,1]

plt.subplot(3, 2, 1)
z = data[:,3]
plotone(x,y,z)
plt.title('80-250KEV_PRTN(0_DG)')

plt.subplot(3, 2, 2)
z = data[:,4]
plotone(x,y,z)
plt.title('250-800KEV_PRTN(0_DG)')

plt.subplot(3, 2, 3)
z = data[:,5]
plotone(x,y,z)
plt.title('800-2500KEV_PRTN(0_DG)')

plt.subplot(3, 2, 4)
z = data[:,6]
plotone(x,y,z)
plt.title('>2500KEV_PRTN(0_DG)')

plt.subplot(3, 2, 5)
z = data[:,7]
plotone(x,y,z)
plt.title('>100KEV_ELEC(0_DG)')

plt.subplot(3, 2, 6)
z = data[:,8]
plotone(x,y,z)
plt.title('>300KEV_ELEC(0_DG)')


plt.savefig("energies.png")
#plt.show()
