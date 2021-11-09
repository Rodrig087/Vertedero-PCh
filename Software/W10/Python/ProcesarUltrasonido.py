#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import hilbert,butter,filtfilt,find_peaks
from scipy.interpolate import lagrange
from scipy import signal

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
tramaDatosInt = []

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
        
def butter_lowpass_filter(data, cutoff, fs, order):
    nyq = 0.5 * fs  # Nyquist Frequency
    normal_cutoff = cutoff / nyq
    # Get the filter coefficients 
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = filtfilt(b, a, data)
    return y

def DetectarEnvolvente(senal):
    #print("Filtrando...")
    npSignal = np.array(senal)
    analytic_signal = hilbert(npSignal)
    amplitude_envelope = np.abs(analytic_signal) 
    envolepe = butter_lowpass_filter(amplitude_envelope, 5547, 200000, 2)
    #plt.plot(npSignal, label='signal')
    #plt.plot(envolepe, label='envelope')
    #plt.plot(peaks, envolepe[peaks], "x")
    #plt.show()
    return envolepe

def InterpolarSenal(senal):
    npSignal = np.array(senal)
    y0 = np.max(npSignal)
    x0 = list(npSignal).index(y0)
    x1 = x0-dix
    x2 = x0+dix
    y1 = npSignal[x1]
    y2 = npSignal[x2]
    xp = [x1,x0,x2]
    yp = [y1,y0,y2]
    
    f = lagrange(xp,yp)
    x_new = np.arange(0, 700,2.5)
    
    #plt.plot(x_new,f(x_new))
    #plt.plot(xp, yp, "x")
    #plt.show()
    return f(x_new)
    
def CalcularPico(data):   
    #funcion find_peaks de scipy:
    #peaks, _ = find_peaks(data, prominence=1) 
    #peaks, _ = find_peaks(data, height=0)
    #print(peaks)
    #Calcula el valor maximo y su indice:
    npSignal = np.array(data)
    y0 = np.max(npSignal)
    x0 = list(npSignal).index(y0)
    x1 = x0-dix
    x2 = x0+dix
    y1 = npSignal[x1]
    y2 = npSignal[x2]
    print(x0)
    #print(y0)
    nx = (y1-y2)/(2*(y1-(2*y0)+y2))                             
    dx = nx*dix
    tmax = x0
    peak = tmax+dx
    T2 = peak * periodoResample
    print(peak)
    print(T2)
    #print(y0)
    #print(y1)
    #print(y2)
        

#Ingreso de datos:
nombreArchivo = input("Ingrese el nombre del archivo: ")

#Abre el archivo binario:
rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
path = rutaCarpeta + str(nombreArchivo) + ".dat"

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

#plt.plot(tramaDatosInt)
#plt.show()

#Procesamiento de la señal:
#banProcesar =  input("Desea extraer el evento? s/n: ")
banProcesar = 's'
if (banProcesar=='s'):
    print('Procesando...')
    offsetSenal = RemuestrearOffset(tramaDatosInt)
    envolventeSenal = DetectarEnvolvente(offsetSenal)
    CalcularPico(envolventeSenal)
    interp = InterpolarSenal(envolventeSenal)
    #Graficar:
    plt.plot(offsetSenal)
    plt.plot(envolventeSenal)
    #plt.plot(interp)
    #plt.plot(peaks, envolepe[peaks], "x")
    plt.show()