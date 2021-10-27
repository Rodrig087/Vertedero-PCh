#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import hilbert
#import time
#import os
#import errno

#Variables:
sizeTramaShort = 702
sizeTramaInt = 350
tramaDatosInt = []

#Funciones:
def CalcularValorAbsoluto(arrayMuestras):
    #Convierte el array a formato np:
    npMuestras = np.array(arrayMuestras)
    #Calcula la media:
    meanMuestras = np.mean(npMuestras)
    #meanMuestras = 508 #Medido con el osciloscopio
    print(meanMuestras)
    #Realiza el offset de la señal:
    npMuestras = npMuestras - meanMuestras
    #Calcula el valora absoluto de la señal:
    abMuestras = abs(npMuestras)
    return abMuestras
    #plt.plot(abMuestras)
    #plt.show()

def FiltrarSenal(senal):
    print("Filtrando...")
    npSignal = np.array(senal)
    analytic_signal = hilbert(npSignal)
    #amplitude_envelope = np.abs(analytic_signal) 
    plt.plot(npSignal, label='signal')
    plt.plot(analytic_signal, label='envelope')
    plt.show()

    

#Ingreso de datos:
nombreArchivo = input("Ingrese el nombre del archivo: ")

#Abre el archivo binario:
path = str(nombreArchivo) + ".dat"
f = open(path, "rb")
tramaDatosShort = np.fromfile(f, np.int8, sizeTramaShort)

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
    datoIntLSB = tramaDatosShort[i * 2] 
    datoIntMSB = tramaDatosShort[(i * 2)+1]
    datoInt = ((datoIntMSB << 8) & 0xFF00) + ((datoIntLSB) & 0xFF)
    tramaDatosInt.append(datoInt)

# datoPrueba = tramaDatosInt[184]
# print("   DatoInt: " + hex(datoPrueba))

plt.plot(tramaDatosInt)
plt.show()

#Procesamiento de la señal:
banProcesar =  input("Desea extraer el evento? s/n: ")
if (banProcesar=='s'):
    print('Procesando...')
    arraySenal = CalcularValorAbsoluto(tramaDatosInt)
    FiltrarSenal(arraySenal)