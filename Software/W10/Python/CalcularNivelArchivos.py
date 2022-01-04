import os
from datetime import datetime



# ///////////////////////////////// Archivos //////////////////////////////////

pathDirectorioArchivos = 'D:\Proyecto Chanlud/Analisis/Vertederos/C01V03/Binarios/'

# /////////////////////////////////////////////////////////////////////////////



# ////////////////////////////////// Metodos //////////////////////////////////


# **********************************************************************
# ********************* Programa Principal *****************************
# **********************************************************************
def programaPrincipal ():
    
    global pathDriveID 
    global objLogFile
    global service
             
    # Fecha actual
    fechaActual = datetime.now()
    fechaFormato = fechaActual.strftime('%Y-%m-%d') 
    print(fechaActual)
    print(fechaFormato)
        
    #Lista los archivos del directorio a subir
    listaArchivos = os.listdir(pathDirectorioArchivos)
    listaArchivosOrdenada = sorted(listaArchivos)    
    print(listaArchivosOrdenada)
    
    #Extrae la hora y fecha de los archivos:
    nombreArchivoBinario = listaArchivosOrdenada[0]
    print(nombreArchivoBinario[7:20])
    fechaHora = nombreArchivoBinario[7:18]
    fecha_dt = datetime.strptime(fechaHora, '%y%m%d-%H%M')
    print(fecha_dt)
    
            
# **********************************************************************
# ******************* Fin Programa Principal ***************************
# ********************************************************************** 

# /////////////////////////////////////////////////////////////////////////////



# ///////////////////////////////// Principal /////////////////////////////////

if __name__ == '__main__':
    programaPrincipal ()
    
     
# /////////////////////////////////////////////////////////////////////////////
