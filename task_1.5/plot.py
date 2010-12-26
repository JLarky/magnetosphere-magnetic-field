#!/usr/bin/python

from matplotlib.mlab import griddata
import numpy as np
import matplotlib.pyplot as plt

def plotone(x,y,z):
    z = np.maximum( z, 0.001); z = np.minimum( z, 40 );

    xi = np.linspace(-180,180, 200)
    yi = np.linspace(-90,90, 100)
    zi = griddata(x, y, z, xi, yi)

    CS = plt.contour(xi,yi,zi,15,linewidths=0.5,colors='k')
    CS = plt.contourf(xi,yi,zi,15,cmap=plt.cm.jet)
    plt.xlim(np.min(xi),np.max(xi))
    plt.ylim(np.min(yi),np.max(yi))
    plt.colorbar() # draw colorbar


plt.figure(num=None, figsize=(12, 10), dpi=90, facecolor='w', edgecolor='k') 

data = np.genfromtxt("data.dat")

x = data[:,2]
y = data[:,1]

plt.subplot(3, 2, 1);plotone(x,y,data[:,3])
plt.title('80-250KEV_PRTN(0_DG)')

plt.subplot(3, 2, 2);plotone(x,y,data[:,4])
plt.title('250-800KEV_PRTN(0_DG)')

plt.subplot(3, 2, 3);plotone(x,y,data[:,5])
plt.title('800-2500KEV_PRTN(0_DG)')

plt.subplot(3, 2, 4);plotone(x,y,data[:,6])
plt.title('>2500KEV_PRTN(0_DG)')

plt.subplot(3, 2, 5);plotone(x,y,data[:,7])
plt.title('>100KEV_ELEC(0_DG)')

plt.subplot(3, 2, 6);plotone(x,y,data[:,8])
plt.title('>300KEV_ELEC(0_DG)')

plt.savefig("energies.png")
