#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
from scipy.signal import correlate


#import time
#import os
#import errno

#Constantes:
sizeTramaShort = 702
sizeTramaInt = 350
periodoMuestreo = 5

#Variables:
factorResample = 2
periodoResample = periodoMuestreo/factorResample
dix = 25*factorResample
senal1 = []
senal2 = []

#Funciones:
def RemuestrearOffset(arrayMuestras):
    #Convierte el array a formato np:
    npMuestras = np.array(arrayMuestras)
    resampleMuestras = signal.resample(npMuestras, len(npMuestras) * factorResample)
    #Calcula la media:
    #meanMuestras = np.mean(resampleMuestras)
    meanMuestras = 508 #Medido con el osciloscopio
    #print(meanMuestras)
    #Realiza el offset de la señal:
    resampleMuestras = resampleMuestras - meanMuestras
    #Calcula el valora absoluto de la señal:
    #abMuestras = abs(npMuestras)
    return resampleMuestras
        
    
#Ingreso de datos:
nombreArchivo1 = input("Ingrese el nombre del primer archivo: ")
nombreArchivo2 = input("Ingrese el nombre del segundo archivo: ")

#Abre el archivo binario:
rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
path1 = rutaCarpeta + str(nombreArchivo1) + ".dat"
path2 = rutaCarpeta + str(nombreArchivo2) + ".dat"

#*****************************************************************************
#Abre y convierte el primer archivo:
f = open(path1, "rb")
tramaDatosShort = np.fromfile(f, np.int8, sizeTramaShort)
f.close()
#Convierte el vector de datos tipo short en un vector de tipo int
for i in range(0, sizeTramaInt - 1):
    datoIntLSB = tramaDatosShort[i * 2] 
    datoIntMSB = tramaDatosShort[(i * 2)+1]
    datoInt = ((datoIntMSB << 8) & 0xFF00) + ((datoIntLSB) & 0xFF)
    senal1.append(datoInt)
#*****************************************************************************
#Abre y convierte el segundo archivo:
f = open(path2, "rb")
tramaDatosShort = np.fromfile(f, np.int8, sizeTramaShort)
f.close()
#Convierte el vector de datos tipo short en un vector de tipo int
for i in range(0, sizeTramaInt - 1):
    datoIntLSB = tramaDatosShort[i * 2] 
    datoIntMSB = tramaDatosShort[(i * 2)+1]
    datoInt = ((datoIntMSB << 8) & 0xFF00) + ((datoIntLSB) & 0xFF)
    senal2.append(datoInt)
#*****************************************************************************



#Procesamiento de la señal:
#banProcesar =  input("Desea extraer el evento? s/n: ")
banProcesar = 's'
if (banProcesar=='s'):
    print('Procesando...')
    #offsetSenal = RemuestrearOffset(tramaDatosInt)
    
    #Calcula la correlacion cruzada:
    nsamples = np.size(senal1)
    # Find cross-correlation
    xcorr = correlate(senal1, senal2)
    # delta time array to match xcorr
    dt = np.arange(1-nsamples, nsamples)
    recovered_time_shift = dt[xcorr.argmax()]
    print("Recovered time shift: %d" % recovered_time_shift)    
    
    #Graficar:
    plt.plot(senal1)
    plt.plot(senal2)
    plt.show()