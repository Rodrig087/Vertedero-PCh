import numpy as np
from scipy import signal
from scipy.signal import correlate
import math
import os
from datetime import datetime

import matplotlib.pyplot as plt 

#Constantes:
sizeTramaShort = 702
sizeTramaInt = 350
periodoMuestreo = 5
factorResample = 10


# ////////////////////////////////// Metodos //////////////////////////////////

def RemuestrearOffset(arrayMuestras, offset, factorResample):
    #Convierte el array a formato np:
    npMuestras = np.array(arrayMuestras)
    resampleMuestras = signal.resample(npMuestras, len(npMuestras) * factorResample)
    resampleMuestras = resampleMuestras - offset
    return resampleMuestras

def ProcesarSenal(tramaDatosShort,referencia):
        
    #******************************************************************************
    #Variables:
    periodoResample = periodoMuestreo/factorResample
    senal1 = []
    senal2 = []
    #******************************************************************************
    
    #*****************************************************************************
    #Convierte el vector de datos tipo short en un vector de tipo int
    for i in range(0, sizeTramaInt - 1):
        datoIntLSB = tramaDatosShort[i * 2] 
        datoIntMSB = tramaDatosShort[(i * 2)+1]
        datoInt = ((datoIntMSB << 8) & 0xFF00) + ((datoIntLSB) & 0xFF)
        senal2.append(datoInt)
    
    #*****************************************************************************
    
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
    MLO = (1000*(Vsonido/40000)/2)
    #*****************************************************************************
    
    #*****************************************************************************
    #Procesamiento de la señal:
    #print('Procesando...')
    #Normaliza las senales:
    senal1 = RemuestrearOffset(referencia, 0, factorResample)
    senal2 = RemuestrearOffset(senal2, 517, factorResample)
    nsamples = np.size(senal1)
    #Calcula la correlacion cruzada de la senal ultrasonica con la senal de referencia:
    xcorr = correlate(senal1, senal2)
    dt = np.arange(1-nsamples, nsamples)
    recovered_time_shift = dt[xcorr.argmax()]
    #Calculo del desfase en us:
    desfaseTiempo = recovered_time_shift*-1*periodoResample
    dA = -80.5
    TOF = 1375 + desfaseTiempo + dA
    Distancia = 0.5*(TOF/1e6)*Vsonido*1000
    #Imprime las respuestas:
    # print("Desfase [num muestras]: %d" % recovered_time_shift) 
    # print("Periodo muestreo [us]: %f" % (periodoResample)) 
    # print("Temperatura [gC]: %f" % temperaturaSensor) 
    # print("Vsonido [m/seg]: %f" % Vsonido)
    # print("Desfase [us]: %f" % desfaseTiempo) 
    # print("TOF [us]: %f" % TOF) 
    #print("Distancia [mm]: %f" % Distancia) 
    return [Distancia,temperaturaSensor,MLO]
    #*****************************************************************************

# /////////////////////////////////////////////////////////////////////////////



# ///////////////////////////////// Principal /////////////////////////////////

if __name__ == '__main__':
    
    #*****************************************************************************
    #Carga la senal de referencia: 
    rutaArchivoReferencia = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/Referencia/"
    nombreArchivoReferencia = "Referencia_Btt-39-41-3.npy"
    pathArchivoReferencia = rutaArchivoReferencia + nombreArchivoReferencia
    senalReferencia = np.load(pathArchivoReferencia)
    #******************************************************************************
    
    #******************************************************************************
    #Obtiene el nombre de todos los archivos:
    #Lista los archivos del directorio a subir
    rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/C01V03/Binarios/"
    listaArchivos = os.listdir(rutaCarpeta)
    listaArchivosOrdenada = sorted(listaArchivos)    
    #print(listaArchivosOrdenada)    
    #******************************************************************************
        
    #******************************************************************************
    #Lee o crea el archivo de mediciones:
    try:
        #Lee la ultima linea del archivo de mediciones:
        archivoMediciones = open(rutaCarpeta[0:86]+"C01V03.txt","r")
        file_lines = archivoMediciones.readlines ()
        archivoMediciones.close()
        ultimaLinea = file_lines [len (file_lines) -1]
        ultimaFecha = ultimaLinea[0:19]
        ultimaFecha_dt =  datetime.strptime(ultimaFecha, '%Y-%m-%d %H:%M:%S')
        banNewFile = 0
        print(ultimaFecha_dt)
    except:
        print("El archivo no existe...")
        banNewFile = 1
    #******************************************************************************
    
    archivoMediciones = open(rutaCarpeta[0:86]+"C01V03.txt","a")
    
    x = []
    y = []
    t = []
            
    for nombreArchivo in listaArchivosOrdenada:
        #Abre el archivo binario de datos:
        pathArchivo = rutaCarpeta + nombreArchivo
        f = open(pathArchivo, "rb")
        tramaDatosShort = np.fromfile(f, np.int8, sizeTramaShort)
        f.close()
        
        #Extrae la hora y fecha de los archivos:
        fechaHora = nombreArchivo[7:18]
        fecha_dt = datetime.strptime(fechaHora, '%y%m%d-%H%M')
        #print(fecha_dt)
        
        medicion = ProcesarSenal(tramaDatosShort,senalReferencia)
        distanciaMedida = medicion[0]
        temperaturaMedida = medicion[1]
        mediaLongitudOnda = medicion[2]
                
        y.append(distanciaMedida)
        x.append(fecha_dt)
        t.append(temperaturaMedida)
        
        #print (str(fecha_dt) + "\t" + str(distanciaMedida) + "\t" + str(temperaturaMedida))
        
        #Guarda los datos nuevos:
        if (banNewFile==1):
            print("Guardado...")
            archivoMediciones.write(str(fecha_dt) + "\t" + str(distanciaMedida) + "\t" + str(temperaturaMedida) + "\t" + str(mediaLongitudOnda) + "\n")
        else:
            if (ultimaFecha_dt<fecha_dt):
                print("Guardado...")
                archivoMediciones.write(str(fecha_dt) + "\t" + str(distanciaMedida) + "\t" + str(temperaturaMedida) + "\t" + str(mediaLongitudOnda) + "\n")
    
        
    archivoMediciones.close()
    
    #Grafica los datos como una serie temporal:
    plt.plot_date(x,y,linestyle ='solid')
    #plt.plot_date(x,t,linestyle ='solid', color='r')
    plt.gcf().set_size_inches(9, 7)
    plt.show()
    
# /////////////////////////////////////////////////////////////////////////////



    
        
    
        
    
    
    
    
   
    
