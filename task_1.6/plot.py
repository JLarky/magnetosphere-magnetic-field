#!/usr/bin/python
# -*- coding: utf-8 -*-

from matplotlib.mlab import griddata
import numpy as np
import matplotlib.pyplot as plt

def plotone(n, x,y,z):
    xi = np.linspace(-179,180, 200)
    yi = np.linspace(-90,90, 100)
    zi = griddata(x, y, z, xi, yi)

    if n == 2:
        bins = np.exp(np.linspace(-2.2,4,10))
        CS = plt.contour(xi,yi,zi,bins,linewidths=0.5,colors='k')
        #CS = plt.contourf(xi,yi,zi,bins,cmap=plt.cm.jet)
        plt.colorbar() # draw colorbar
    else:
        CS = plt.contourf(xi,yi,zi,15,cmap=plt.cm.jet)
    plt.xlim(np.min(xi),np.max(xi))
    plt.ylim(np.min(yi),np.max(yi))


plt.figure(num=None, figsize=(15,8), dpi=90, facecolor='w', edgecolor='k') 

data = np.genfromtxt("data.dat")

x = data[:,0]
y = data[:,1]

print x

plotone(1, x,y,data[:,3])
plt.title(u'Разница поля и линии дрейфа')

z = data[:,4] 
z = np.minimum( z, 40 ); z = np.maximum( z, 0.001);
plotone(2, x,y,z)

plt.savefig("lines.png")
