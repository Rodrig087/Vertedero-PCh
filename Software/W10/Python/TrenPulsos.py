
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

#plt.plot(sig)
plt.plot(referencia)
