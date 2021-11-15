
from scipy.signal import butter,filtfilt, lfilter
import matplotlib.pyplot as plt
import numpy as np


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
#filtrado = butter_bandpass_filter(filtrado, 37500, 42500, 400000, 2)

#referencia = signal.resample(referencia, 350)
referencia = referencia*1000

#******************************************************************************
#Senal sinusoidal:
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

fs = 200000
hz_50 = sin_wave(A=1, f=40000, fs=200000, phi=0, t=0.000025)
plt.plot(hz_50)
#******************************************************************************

#plt.plot(sig)
#plt.plot(referencia)

