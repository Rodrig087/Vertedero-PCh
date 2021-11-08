//Compilar:
//gcc LeerDS18.c -o leerds18 -lbcm2835 -lwiringPi 

/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/09/23
Observaciones:
Funcion 1: Inicio de medicion.
Funcion 2: Lectura de datos.
		Subfuncion 2: Leer temperatura
Funcion 3: Escritura de datos.
Funcion 4: Test comunicacion
       
-------------------------------------------------------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>


//Declaracion de constantes
#define P0 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define LEDTEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 100
#define FreqSPI 200000

#define RED   "\x1B[31m"
#define RESET "\x1B[0m"

//Declaracion de variables
unsigned short i;
unsigned int x;

unsigned short idPet;
unsigned short funcionPet;
unsigned short subFuncionPet;
unsigned short numDatosPet;

unsigned short idResp;
unsigned short funcionResp;
unsigned short subFuncionResp;
unsigned short numDatosResp;

unsigned char payloadPet[255];
unsigned char payloadResp[255];

unsigned int sumEnviado;
unsigned int sumRecibido;

int rawTemp;
unsigned int temperaturaInt;
float temperaturaFloat, temperaturaResultado;
unsigned char *ptrRawTemp, *ptrTemperaturaResultado;
short signoTemp;


//Declaracion de funciones
int ConfiguracionPrincipal();
void RecibirRespuesta();														//C:0xA0    F:0xF0
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload); //C:0xA1    F:0xF1														//C:0xA4	F:0xF4

void ImprimirInformacion();
void Salir();						


int main() {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	
	idPet = 0;
	funcionPet = 0;
	subFuncionPet = 0;
	numDatosPet = 0;
	idResp = 0;
	funcionPet = 0;
	subFuncionResp = 0;
	numDatosResp = 0;
		
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Datos de prueba:
	idPet = 3;
	funcionPet = 2;
	subFuncionPet = 4;
	numDatosPet = 0;
	
	//Sumatorias de control:
	sumEnviado = 0;
	sumRecibido = 0;
	
	//Variables para convertir la temperatura:
	rawTemp = 0;
	temperaturaInt = 0;
	temperaturaFloat = 0;
	temperaturaResultado = 0;
	ptrRawTemp = (unsigned char *) & rawTemp;
	ptrTemperaturaResultado = (unsigned char *) & temperaturaResultado;
	signoTemp = 0;
	
	EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
	
	while(1){}
	//Salir();	

}

//**************************************************************************************************************************************
//Configuracion:

int ConfiguracionPrincipal(){
	
    //Configuracion libreria bcm2835:
	if (!bcm2835_init()){
		printf("bcm2835_init fallo. Ejecuto el programa como root?\n");
		return 1;
    }
    if (!bcm2835_spi_begin()){
		printf("bcm2835_spi_begin fallo. Ejecuto el programa como root?\n");
		return 1;
    }

    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE3);
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_256);					//Clock divider RPi 3		
	bcm2835_spi_set_speed_hz(FreqSPI);
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
		
	//Configuracion libreria WiringPi:
    wiringPiSetup();
    pinMode(P0, INPUT);
	pinMode(MCLR, OUTPUT);
	pinMode(LEDTEST, OUTPUT);
	wiringPiISR (P0, INT_EDGE_RISING, RecibirRespuesta);
	
	//Enciende el pin LEDTEST:
	digitalWrite (LEDTEST, HIGH);
		
}
//**************************************************************************************************************************************

//Imprimir en pantalla los datos relevantes
void ImprimirInformacion(){
	
	//Imprime la solicitud:
	printf("\nTrama enviada:");
	printf("\n Cabecera: %d %d %d %d", idPet, funcionPet, subFuncionPet, numDatosPet);
	
	
	//Imprime la respuesta:
	printf("\nTrama recibida:");
	printf("\n Cabecera: %d %d %d %d", idResp, funcionResp, subFuncionResp, numDatosResp);
	printf("\n Payload: ");
	for (i=0;i<numDatosResp;i++){
        printf("%#02X ", payloadResp[i]);
    }
	
	if (subFuncionPet==2){
		//Lee el valor crudo del sensor:
		//Calculo de la temperatura cruda:
		*(ptrRawTemp) = payloadResp[0];
		*(ptrRawTemp+1) = payloadResp[1];
		printf("\n Temperatura raw: %d", rawTemp);
		//Verifica si la temperatura es negativa:
		if(rawTemp & 0x8000) {                       
		  signoTemp = -1;                              
		  rawTemp = ~rawTemp + 1;                   // Change temperature value to positive form
		} else {
		  signoTemp = 1; 
		}
		//Calculo de la parte entera de la temperatura:
		temperaturaInt = (rawTemp >> 4) * signoTemp;
		printf("\n Temperatura int: %d", temperaturaInt);
		//Calculo de la parte decimal de la temperatura:
		temperaturaFloat = ((rawTemp & 0x000F) * 625)/10000.0;
		printf("\n Temperatura decimal: %f", temperaturaFloat);
		//Sumatoria total:
		temperaturaResultado = temperaturaInt + temperaturaFloat;
		printf("\n Temperatura: %f", temperaturaResultado);
	} 

	if (subFuncionPet==4){
		//Lee el valor float del sensor:
		*(ptrTemperaturaResultado) = payloadResp[0];
		*(ptrTemperaturaResultado+1) = payloadResp[1];
		*(ptrTemperaturaResultado+2) = payloadResp[2];
		*(ptrTemperaturaResultado+3) = payloadResp[3];
		printf("\n Temperatura: %f", temperaturaResultado);		
	}
	
	Salir();
	
}

//**************************************************************************************************************************************
//Comunicacion RPi-dsPIC:

//C:0xA0    F:0xF0
void RecibirRespuesta(){
	
	bcm2835_delayMicroseconds(200);
	
	//Recupera la cabecera: [id, funcion, subfuncion, #Datos]:
	bcm2835_spi_transfer(0xA0);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	idResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	funcionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	subFuncionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	numDatosResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
		
	//Recupera el payload:
	for (i=0;i<numDatosResp;i++){
        payloadResp[i] = bcm2835_spi_transfer(0x01);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF0);	
	//bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	delay(25); //**Este retardo es muy importante**
	
	//sumatoria de control:
	for (i=0;i<numDatosResp;i++){
        sumRecibido = sumRecibido + payloadResp[i];
    }
	
	//Imprime la respuesta:
	printf("\n>Respuesta recibida\n");
			
	//Apaga el LEDTEST:
	digitalWrite (LEDTEST, LOW);
	
	//Imprime la informacion de solicitud y respuesta:
	ImprimirInformacion();
	
	Salir();

	
}

//C:0xA1	F:0xF1
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload){
	
	//sumatoria de control:
	for (i=0;i<numDatos;i++){
        sumEnviado = sumEnviado + payload[i];
    }
	
	bcm2835_delayMicroseconds(200);
	
	//Envia la cabecera: [id, funcion, subfuncion, #Datos]:
	bcm2835_spi_transfer(0xA1);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(id);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(funcion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(subFuncion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(numDatos);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Envia el payload:
	for (i=0;i<numDatos;i++){
        bcm2835_spi_transfer(payload[i]);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
		
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF1);	
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Imprime la solicitud:
	printf("\n>Solicitud enviada");
	
	//Enciende el LEDTEST:
	digitalWrite (LEDTEST, HIGH);
	
}

//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Procesos locales:

void Salir(){
	
	bcm2835_spi_end();
	bcm2835_close();
	printf("\nAdios...\n");
	exit (-1);
}


//**************************************************************************************************************************************





