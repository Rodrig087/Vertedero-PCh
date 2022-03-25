# -*- coding: utf-8 -*-
"""
Created on Wed Mar  9 21:19:23 2022

@author: milto
"""

import numpy as np
from scipy import signal
from scipy.signal import correlate
import math
import os
from datetime import datetime

import matplotlib.pyplot as plt 

# ///////////////////////////////// Principal /////////////////////////////////

if __name__ == '__main__':
    
    #******************************************************************************
    #Obtiene el nombre del archivo de mediciones de distancia:
    #Lista los archivos del directorio a subir
    rutaCarpeta = "C:/Users/milto/Milton/RSA/Proyectos/Proyecto Chanlud/Analisis/Vertederos/Datos/C01V03/"
    
    
    #******************************************************************************
    #Lee o crea el archivo de mediciones:
    try:
        #Lee la ultima linea del archivo de mediciones:
        archivoMediciones = open(rutaCarpeta+"C01V03.txt","r")
        file_lines = archivoMediciones.readlines ()
        archivoMediciones.close()
        primeraLinea = file_lines[0]
        ultimaLinea = file_lines [len (file_lines) -1]
        ultimaFecha = ultimaLinea[0:19]
        ultimaFecha_dt =  datetime.strptime(ultimaFecha, '%Y-%m-%d %H:%M:%S')
        ultimaMedicion = ultimaLinea[20:27]
        banNewFile = 0
        #print(ultimaLinea.split())
        #print(ultimaFecha_dt)
        #print(ultimaMedicion)
    except:
        print("El archivo no existe...")
        banNewFile = 1
        
    #for linea in file_lines:
    #    print(linea.split())
    #******************************************************************************
    
    #******************************************************************************
    #Calcula el nivel y el caudal:
    # hSensor = 320  #Altura de instalacion del sensor
    # hVertedero = 64 #Altura de escotadura del vertedero triangular
    # anguloVertedero = 90 #Angulo de escotadura del vertedero triangular
    
    # primeraLinea = file_lines[0]
    
    # fechaHora = primeraLinea.split()[0:2]
    # medidaDistancia = primeraLinea.split()[2]
    # #medidaDistancia = ultimaLinea.split()[2]
    
    # nivel = hSensor - hVertedero - float(medidaDistancia) #[mm]
    # nivelMetros = nivel/1000 #[m]
    # caudal = 1.32 * 1 * nivelMetros**(2.48) #Q = 1.32*tan(O/2)*h^(2.48) [m3/s]
    # caudalHora = caudal * 3600 #[m3/hora]
    # caudalDia = caudal * 86400 #[m3/dia]
    
    #print(fechaHora)
    #print(medidaDistancia)
    
    #print(" ".join(fechaHora) + " " + medidaDistancia + " " + str(nivel) + " " + str(caudalHora))
    
    #******************************************************************************
    
    #******************************************************************************
    #Calcula el nivel y el caudal:
    
    #Constantes:
    hSensor = 320  #Altura de instalacion del sensor
    hVertedero = 64 #Altura de escotadura del vertedero triangular
    anguloVertedero = 90 #Angulo de escotadura del vertedero triangular
    
    yDistancia = []
    yNivel = []
    yCaudal = []
    tiempo = []
    
    #Abre el archivo para guardar los datos procesados
    archivoDatosProcesados = open(rutaCarpeta+"C01V03_Procesado.txt","a")
    
    #Recorre todos los valores: 
    for linea in file_lines:
        
        umbralNivel = 7.7
        umbralTiempo = datetime.strptime("2021-12-20 00:00:00", '%Y-%m-%d %H:%M:%S')
        
        fechaHora = linea.split()[0:2]
        strFechaHora = "\t".join(fechaHora)
        fecha_dt = datetime.strptime(strFechaHora, '%Y-%m-%d %H:%M:%S')
        
        medidaSensor = linea.split()[2]
        MLO = linea.split()[4] #Media longitud de onda
        MLO = "4.24"
                
        nivel = hSensor - hVertedero - float(medidaSensor) #[mm]
        
        
        if (fecha_dt>umbralTiempo)and(nivel>umbralNivel):
            nivel = nivel - float(MLO)
            #nivel = nivel
        
        nivelMetros = nivel/1000 #[m]
        caudal = 1.32 * 1 * nivelMetros**(2.48) #Q = 1.32*tan(O/2)*h^(2.48) [m3/s]
        caudalLitrosHora = caudal * 3600 * 1000#[m3/hora]
        
        strNivel = str("{0:.3f}".format(nivel))
        strCaudal = str("{0:.3f}".format(caudalLitrosHora))
        
        
        
        if (abs(nivel)<7.7 and nivel>2):
            #print(" ".join(fechaHora) + " " + medidaSensor + " " + str(nivel) + " " + str(caudalLitrosHora))
            print( strFechaHora + " " + strNivel + " " + strCaudal)
            archivoDatosProcesados.write(strFechaHora + "\t" + strNivel + "\t" + strCaudal + "\n")
            
            yDistancia.append(float(medidaSensor))
            yNivel.append(nivel)
            yCaudal.append(caudalLitrosHora)
            tiempo.append(fecha_dt)
        
    archivoDatosProcesados.close()    
    #******************************************************************************
    
    #******************************************************************************
    #Grafica los resultados:
    
    plt.plot_date(tiempo,yDistancia,linestyle ='solid')
    #plt.plot_date(tiempo,yNivel,linestyle ='solid')
    #plt.plot_date(tiempo,yCaudal,linestyle ='solid')
    plt.gcf().set_size_inches(9, 7)
    plt.show()
    #******************************************************************************
    

# /////////////////////////////////////////////////////////////////////////////