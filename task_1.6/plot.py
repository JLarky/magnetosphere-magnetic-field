#!/usr/bin/python

from matplotlib.mlab import griddata
import numpy as np
import matplotlib.pyplot as plt

def plotone(x,y,z):
    #z = np.maximum( z, 0.001); z = np.minimum( z, 10 );

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

x = data[:,0]
y = data[:,1]

print x

plt.subplot(2, 1, 1);plotone(x,y,data[:,3])
plt.title('field diff')

plt.subplot(2, 1, 2);plotone(x,y,np.log(data[:,4]))
plt.title('I = \int ds \sqrt{(1-B/Bm)}')

plt.savefig("lines.png")
