#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
from scipy.signal import correlate
from scipy.signal import butter,bessel,filtfilt, lfilter
import math


#import time
#import os
#import errno

#Constantes:
sizeTramaShort = 702
sizeTramaInt = 350
periodoMuestreo = 5

#Variables:
factorResample = 10
periodoResample = periodoMuestreo/factorResample
dix = 25*factorResample
senal1 = []
senal2 = []

#Funciones:
def RemuestrearOffset(arrayMuestras, offset):
    #Convierte el array a formato np:
    npMuestras = np.array(arrayMuestras)
    resampleMuestras = signal.resample(npMuestras, len(npMuestras) * factorResample)
    #Calcula la media:
    #meanMuestras = np.mean(resampleMuestras)
    #meanMuestras = 508 #Medido con el osciloscopio
    #print(meanMuestras)
    #Realiza el offset de la señal:
    resampleMuestras = resampleMuestras - offset
    #Calcula el valora absoluto de la señal:
    #abMuestras = abs(npMuestras)
    return resampleMuestras
        

#******************************************************************************
#Senal de referencia: Tren de pulsos filtrado pasa-banda
def rect(T):
    """create a centered rectangular pulse of width $T"""
    return lambda t: (-T/2 <= t) & (t < T/2)

def pulse_train(t, at, shape):
    """create a train of pulses over $t at times $at and shape $shape"""
    return np.sum(shape(t - at[:,np.newaxis]), axis=0)

def butter_lowpass_filter(data, cutoff, fs, order):
    nyq = 0.5 * fs  # Nyquist Frequency
    normal_cutoff = cutoff / nyq
    # Get the filter coefficients 
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = filtfilt(b, a, data)
    return y

def butter_bandpass(lowcut, highcut, fs, order):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def bessel_bandpass(lowcut, highcut, fs, order):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = bessel(order, [low, high], btype='band')
    return b, a

def bessel_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = bessel_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y


sig = pulse_train(
    t=np.arange(700),              # time domain
    at=np.array([2, 12, 22, 32, 42]),  # times of pulses
    shape=rect(5)                 # shape of pulse
)

#Filtrado con filtro Butterford
referencia1 = butter_bandpass_filter(sig, 39000, 41000, 400000, 3)
#referencia1 = bessel_bandpass_filter(sig, 37500, 42500, 400000, 2)
referencia1 = signal.resample(referencia1, 350)
referencia1 = referencia1*1000

#Filtrado con filtro Bessel
#referencia2 = bessel_bandpass_filter(sig, 39000, 41000, 400000, 3)
referencia2 = bessel_bandpass_filter(sig, 37500, 42500, 400000, 2)
referencia2 = signal.resample(referencia2, 350)
referencia2 = referencia2*1000

#******************************************************************************
#Senal de referencia: Onda sinusoidal
def sin_wave(A, f, fs, phi, t):
    '''
    : Params A: Amplitud
         : params F: Frecuencia de señal
         : Params FS: Frecuencia de muestreo
         : Params phi: fase
         : params t: longitud de tiempo
    '''
    # Si la longitud de la serie de tiempo es T = 1S, 
    # Frecuencia de muestreo FS = 1000 Hz, intervalo de tiempo de muestreo TS = 1/FS = 0.001S
    # Para los puntos de muestreo de la secuencia de tiempo es n = t / t ts = 1 / 0,001 = 1000, hay 1000 puntos, cada intervalo de punto es TS
    Ts = 1/fs
    n = t / Ts
    n = np.arange(n)
    y = A*np.sin(2*np.pi*f*n*Ts + phi*(np.pi/180))
    return y

referencia3 = sin_wave(A=200, f=40000, fs=200000, phi=0, t=0.00175)
#******************************************************************************
    
#Ingreso de datos:
#nombreArchivo1 = input("Ingrese el nombre del primer archivo: ")
nombreArchivo2 = input("Ingrese el nombre del segundo archivo: ")

#Abre el archivo binario:
#rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
rutaCarpeta = "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
path2 = rutaCarpeta + str(nombreArchivo2) + ".dat"

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
dTemp = -0.5
temperaturaSensor = temperaturaInt + temperaturaFloat + dTemp
Vsonido = 331.45 * math.sqrt(1 + (temperaturaSensor / 273))
#*****************************************************************************

#Procesamiento de la señal:
#banProcesar =  input("Desea extraer el evento? s/n: ")
banProcesar = 's'
if (banProcesar=='s'):
    
    print('Procesando...')
    
    #Normaliza las senales:
    senal1 = RemuestrearOffset(referencia1, 0)
    #senal2 = RemuestrearOffset(senal2, 508)
    senal2 = RemuestrearOffset(senal2, 517)
    nsamples = np.size(senal1)
    
    # Ejemplo: Put in an artificial time shift between the two datasets
    #time_shift = 313
    #senal1 = np.roll(senal1, time_shift)
    
    #Calcula la correlacion cruzada de la senal ultrasonica con la senal de referencia:
    xcorr = correlate(senal1, senal2)
    #xcorr = np.correlate([1, 2, 3], [0, 1, 0.5])
    # delta time array to match xcorr
    dt = np.arange(1-nsamples, nsamples)
    recovered_time_shift = dt[xcorr.argmax()]
    #print (xcorr[recovered_time_shift ])
    print("Recovered time shift: %d" % recovered_time_shift)    
    
    #Calculo del desfase en us:
    desfaseTiempo = recovered_time_shift*-1*periodoResample
    dA = -80.5
    TOF = 1375 + desfaseTiempo + dA
    Distancia = 0.5*(TOF/1e6)*Vsonido*1000
    
    print("Periodo muestreo [us]: %f" % (periodoResample)) 
    print("Temperatura [gc]: %f" % temperaturaSensor) 
    print("Vsonido [m/seg]: %f" % Vsonido)
    print("Desfase [us]: %f" % desfaseTiempo) 
    print("TOF [us]: %f" % TOF) 
    print("Distancia [mm]: %f" % Distancia) 
    
    #Graficar:
    plt.ylim(-250,250)
    plt.plot(senal1, 'r--')
    plt.plot(senal2)
    #plt.phase_spectrum(senal1)
    #plt.phase_spectrum(senal2)
    plt.show()