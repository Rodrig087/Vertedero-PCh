import matplotlib.pyplot as plt
import numpy as np
import math
import time
import os
import errno

Vtrama = []
Dtrama = []

TOF = 2.467 / 1000  #TOF en us
Temp = np.linspace(0, 100, 10)  #Inicio, final, numero de puntos

#Calcula la velocidad del sonido:
for i in range(0, (len(Temp))):
    Vs = 331.45 * math.sqrt(1 + (Temp[i] / 273))
    Vtrama.append(Vs)

#Calcula la distancia:
for i in range(0, (len(Temp))):
    Dst = TOF * 500 * Vtrama[i]
    Dtrama.append(Dst)

VariacionVel = Dtrama[len(Temp) - 1] - Dtrama[0]
print(str(VariacionVel))

#Grafica los resultados:
fig = plt.figure()
ax1 = fig.add_subplot(211)
plt.plot(Temp, Vtrama)
plt.setp(ax1.get_xticklabels(), visible=False)
plt.title('Velocidad del sonido')
plt.ylabel('m/seg')

ax2 = plt.subplot(212, sharex=ax1)
plt.plot(Temp, Dtrama)
plt.title('Distancia')
plt.ylabel('mm')
plt.xlabel('Temperatura [oC]')

plt.show()
