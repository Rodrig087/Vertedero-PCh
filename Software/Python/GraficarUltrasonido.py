#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
import time
import os
#import errno

#Variables:
sizeTramaShort = 702
sizeTramaInt = 350
tramaDatosInt = []
#Ingreso de datos:
#nombreArchivo = input("Ingrese el nombre del archivo: ")

#Abre el archivo binario:
path = "/home/rsa/Resultados/C01N03_us.dat"
f = open(path, "rb")
tramaDatosShort = np.fromfile(f, np.int8, sizeTramaShort)

print("Graficando... ") 

#*****************************************************************************
#Obtiene los bytes de temperatura de la trama:
temperaturaLSB = tramaDatosShort[sizeTramaShort - 2]
temperaturaMSB = tramaDatosShort[sizeTramaShort - 1]
temperaturaRaw = ((temperaturaMSB << 8) & 0xFF00) + ((temperaturaLSB) & 0xFF)
#Verifica si la temperatura es negativa:
if (temperaturaRaw & 0x8000):
    signoTemp = -1
    temperaturaRaw = ~temperaturaRaw + 1
else:
    signoTemp = 1
#Calcula la parte entera de la temperatura:
temperaturaInt = (temperaturaRaw >> 4) * signoTemp
#Calcula la parte decimal de la temperatura:
temperaturaFloat = ((temperaturaRaw & 0x000F) * 625) / 10000.0
#Calcula la temperatura:
temperaturaSensor = temperaturaInt + temperaturaFloat
#Imprime los valores de temperatura:
#print("   Temperatura LSB: " + hex(temperaturaLSB))
#print("   Temperatura MSB: " + hex(temperaturaMSB))
#print("   Temperatura Raw: " + str(temperaturaRaw))
print("   Temperatura sensor: " + str(temperaturaSensor))
#*****************************************************************************

#*****************************************************************************
#Convierte el vector de datos tipo short en un vector de tipo int
for i in range(0, sizeTramaInt - 1):
    datoIntLSB = ((tramaDatosShort[i * 2] << 8) & 0xFF00)
    datoIntMSB = ((tramaDatosShort[1 + (i * 2)]) & 0xFF)
    datoInt = datoIntLSB + datoIntMSB
    tramaDatosInt.append(datoInt)

datoPrueba = tramaDatosInt[184]

#print("   DatoInt LSB: " + hex(datoPrueba))

plt.plot(tramaDatosInt)
plt.show()