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
        

#******************************************************************************
#Generacion de senal de referencia: 
#Tren de pulsos filtrado pasa-banda Butterworth FC=39-41KHz Orden=3 

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
referencia1 = signal.resample(referencia1, 350)
referencia1 = referencia1*1000

print(referencia1[100])

#*****************************************************************************

#*****************************************************************************
#Guardado de la senal de referencia en un archivo binario:

rutaArchivoReferencia = "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Referencias/"
nombreArchivoReferencia = "Referencia_Btt-39-41-3.npy"
pathArchivoReferencia = rutaArchivoReferencia + nombreArchivoReferencia

#Gurda el array en el archivo:
np.save(pathArchivoReferencia,referencia1)

#*****************************************************************************

#*****************************************************************************
#Comprueba el archivo de referencia generado:

pathComprobacion = pathArchivoReferencia

#Abre carga en el array senal2 los datos del archivo:
senal2 = np.load(pathComprobacion)
#Agrega un offset para visualizar mejor el resultado:
senal2 = senal2 + 500

#Grafica las senales:
banProcesar = 's'
if (banProcesar=='s'):
         
    #Graficar:
    plt.plot(referencia1, 'r--')
    plt.plot(senal2)
    
    plt.show()
    
#*****************************************************************************