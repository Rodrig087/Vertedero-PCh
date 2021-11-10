#from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
from scipy.signal import correlate
from scipy.signal import butter,filtfilt, lfilter

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
#Senal de referencia:
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


sig = pulse_train(
    t=np.arange(700),              # time domain
    at=np.array([2, 12, 22, 32, 42]),  # times of pulses
    shape=rect(5)                 # shape of pulse
)

referencia = butter_bandpass_filter(sig, 39000, 41000, 400000, 5)
#referencia = butter_bandpass_filter(sig, 37500, 42500, 400000, 1)
referencia = signal.resample(referencia, 350)
referencia = referencia*1000
#******************************************************************************
    
#Ingreso de datos:
#nombreArchivo1 = input("Ingrese el nombre del primer archivo: ")
nombreArchivo1 = "C01N03_211028_02"
nombreArchivo2 = input("Ingrese el nombre del segundo archivo: ")

#Abre el archivo binario:
#rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
rutaCarpeta = "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/"
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
    
    #Normaliza las senales:
    senal1 = RemuestrearOffset(referencia, 0)
    senal2 = RemuestrearOffset(senal2, 508)
    nsamples = np.size(senal1)
    
    # Ejemplo: Put in an artificial time shift between the two datasets
    #time_shift = 18
    #senal2 = np.roll(senal2, time_shift)
    
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
    
    print("Periodo muestreo [us]: %f" % (periodoResample)) 
    print("Desfase [us]: %f" % desfaseTiempo) 
    
    #Graficar:
    plt.plot(senal1)
    plt.plot(senal2)
    #plt.phase_spectrum(senal1)
    #plt.phase_spectrum(senal2)
    plt.show()