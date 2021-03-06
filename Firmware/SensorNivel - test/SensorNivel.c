/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 22/03/018
Configuracion: dsPIC P33FJ32MC202, XT=8MHz, PLL=80MHz
Observaciones:
1. Firmware para probar el funcionamiento del sensor:
   - Generacion de pulsos
   - Recepcion de se?al ultrasonica
   - Comunicacion RS485


Descripcion:
Funcion1: Inicio de medicion, Payload[TiempoSeg]??
           Subfuncion1: Calcula el TOF y lee el sensor de temperatura.
                   Subfuncion2: Captura la senal ultrasonica y lee el sensor de temperatura.
Funcion2: Lectura de datos:
           Subfuncion1: Payload[t2Prom(4bytes) + tempRaw(2bytes)]
           Subfuncion2: vectorMuestras[700bytes]
           Subfuncion3: vectorEnvolvente[700bytes]

Funcion4: Test comunicacion:
           Subfuncion2: Test RS485
---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////
#include <RS485.c>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Credenciales:
#define IDNODO 2                                                                //Idendtificador del nodo

//Declaracion de pines:
sbit MSRS485 at LATB5_bit;                                                     //Definicion del pin MS RS485
sbit MSRS485_Direction at TRISB5_bit;
sbit LED1 at LATA4_bit;                                                         //Definicion del pin LED1
sbit LED1_Direction at TRISA4_bit;
sbit LED2 at LATB4_bit;                                                         //Definicion del pin LED2
sbit LED2_Direction at TRISB4_bit;
//Subindices:
unsigned int i, j, x, y;

//Variables para la comunicacion RS485:
unsigned char banRSI, banRSC;                                                  //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485;
unsigned int i_rs485;                                                           //Subindice
unsigned char solicitudCabeceraRS485[5];                                        //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char solicitudPyloadRS485[15];                                         //Vector para almacenar el pyload de la trama RS485 recibida
unsigned char respuestaPyloadRS485[15];                                         //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char direccionRS485, funcionRS485, subFuncionRS485;
unsigned int numDatosRS485;
unsigned char *ptrNumDatosRS485;
unsigned char tramaPruebaRS485[10]= {0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, IDNODO};   //Trama de 10 elementos para probar la comunicacion RS485
unsigned char contTMR3;                                                         //Contador para implementar el timeout
unsigned char contPulsosTMR3;

//Variables para la peticion y respuesta de datos:
unsigned char ir, ip, ipp;                             //Subindices para las tramas de peticion y respuesta

//Variables para la generacion de pulsos de exitacion del transductor ultrasonico
unsigned int contPulsos;

//Variables para el almacenamiento de la senal muestreada:
const unsigned int numeroMuestras = 350;
unsigned int vectorMuestras[350];
//unsigned char outputPyloadRS485[400];
unsigned int k;
char bm;

//Variables para la deteccion de la Envolvente de la senal
unsigned int valorAbsoluto;

//Variables para el filtrado de la senal
float x0=0, x1=0, x2=0, y0=0, y1=0, y2=0;
const unsigned char O = 21;
float XFIR[O];
unsigned int f;
unsigned int YY = 0;

//Variables para determinar el tiempo de maximo de la funcion
unsigned int Mmax=0;
unsigned int Mmin=0;
unsigned int Mmed=0;
unsigned int MIndexMax;
unsigned int MIndexMin;
unsigned int maxIndex;
unsigned int i0, i1, i2, imax;
unsigned int i1a, i1b;
const char dix=20;                                     //Intervalo de interpolacion
const float tx=5.0;                                     //Periodo de muestreo
int yy0, yy1, yy2;
float yf0, yf1, yf2;
float nx, dx, tmax;

//Variables para calcular la Distancia
char conts;
float T2a, T2b;
const char Nsm=30;                                     //Numero maximo de secuencias de medicion (3)
const float T2umb = 3.0;                                //Umbral para precision (3us)
float T1 = 1375.0;                                //T0+T1. Altura minima de instalacion = 250 mm
float T2adj;                                            //Variable para la calibracion de T2
float T2sum,T2prom;
float T2, TOF;
unsigned int temperaturaRaw;

//Variables para procesar las peticiones
unsigned char banderaPeticion;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud);
void GenerarTramaPrueba(unsigned int numDatosPrueba, unsigned char *cabeceraPrueba);
unsigned int LeerDS18B20();
void ProbarMuestreo();
void CapturarMuestras();
void ProcesarMuestras();
//float CalcularTOF();
void EnviarTramaInt(unsigned char* cabecera, unsigned int temperatura);
void ProbarEnvioTrama();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     //Inicio de configuracion:
     ConfiguracionPrincipal();

     //Inicializacion de variables:
     //Subindices:
     i = 0;
     j = 0;
     x = 0;
     y = 0;

     //Calculos:
     T2 = 0;
     bm = 0;
     TOF = 0;
     temperaturaRaw = 0;
     //Comunicacion RS485:
     banRSI = 0;
     banRSC = 0;
     byteRS485 = 0;
     i_rs485 = 0;
     funcionRS485 = 0;
     subFuncionRS485 = 0;
     numDatosRS485 = 0;
     ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
     MSRS485 = 0;
     contTMR3 = 0;
     contPulsosTMR3 = 0;

     //Peticion:
     banderaPeticion = 0;

     //Puertos:
     LED1 = 1;
     LED2 = 0;

     ip=0;

     //Prueba
     while(1){
          
          if (banderaPeticion==1){
          
             ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
          
          }
          
          //Test de funcionamiento del transductor:
          //CapturarMuestras();
          //Delay_ms(500);

          
     }
     //Fin prueba

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){

     //Configuracion del PLL para generar un FOSC de 80MHz  a partir de un oscilador externo de 8MHz:
     CLKDIVbits.PLLPRE = 0;                                                     //PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
     PLLFBD = 38;                                                               //PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
     CLKDIVbits.PLLPOST = 0;                                                    //PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz

     //Configuracion de puertos:
     AD1PCFGL = 0xFFFD;                                                         //Configura el puerto AN1 como entrada analogica y todas las demas como digitales
     TRISA1_bit = 1;                                                            //Establece el pin RA1 como entrada
     TRISB = 0xFF40;                                                            //TRISB = 11111111 01000000
     MSRS485_Direction = 0;                                                     //MSRS485 out
     LED1_Direction = 0;                                                        //LED1 out
     LED2_Direction = 0;                                                        //LED2 out
     //Configuracion del ADC:
     AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
     AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
     AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea multiples canales individualmente en secuencia
     AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
     AD1CON1.ASAM = 1;                                                          //Muestreo automatico
     AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
     AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
     AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
     AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
     AD1CON2.BUFM = 0;                                                          //Bit de seleccion del modo de relleno del bufer, 0 -> Siempre comienza a llenar el buffer desde el principio
     AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la seleccion de entrada de canal para la muestra A
     AD1CON3.ADRC = 0;                                                          //Selecciona el reloj de conversion del ADC derivado del reloj del sistema
     AD1CON3bits.ADCS = 0x02;                                                   //Configura el periodo del reloj del ADC fijando el valor de los bits ADCS segun la formula: TAD = TCY*(ADCS+1) = 75ns  -> ADCS = 2
     AD1CON3bits.SAMC = 0x02;                                                   //Auto Sample Time bits, 2 -> 2*TAD (minimo periodo de muestreo para 10 bits)
     AD1CHS0.CH0NB = 0;                                                         //Channel 0 negative input is VREF-
     AD1CHS0bits.CH0SB = 0x01;                                                  //Channel 0 positive input is AN1
     AD1CHS0.CH0NA = 0;                                                         //Channel 0 negative input is VREF-
     AD1CHS0bits.CH0SA = 0x01;                                                  //Channel 0 positive input is AN1
     AD1CHS123 = 0;                                                             //AD1CHS123: ADC1 INPUT CHANNEL 1, 2, 3 SELECT REGISTER
     AD1CSSL = 0x00;                                                            //Se salta todos los puertos ANx para los escaneos de entrada
     AD1CON1.ADON = 1;                                                          //Enciende el modulo ADC

     //Configuracion del TMR1:
     T1CON = 0x8000;                                                            //Habilita el TMR1, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
     IEC0.T1IE = 1;                                                             //Habilita la interrupcion por desborde de TMR1
     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion
     PR1 = 200;                                                                 //Genera una interrupcion cada 5us (Fs=200KHz)
     T1CON.TON = 0;                                                             //Apaga la interrupcion

     //Configuracion del TMR2:
     T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
     IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
     T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
     PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
     T2CON.TON = 0;                                                             //Apaga la interrupcion

     //Configuracion del TMR3:
     T3CON = 0x8030;                                                            //Habilita el TMR3
     IEC0.T3IE = 1;                                                             //Habilita la interrupcion por desborde de TMR3
     T3IF_bit = 0;                                                              //Limpia la bandera de interrupcion
     PR3 = 46875;                                                               //Genera una interrupcion cada 300ms
     T3CON.TON = 1;                                                             //Apaga la interrupcion
     
     //Configuracion UART:
     RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
     RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
     IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
     UART1_Init(19200);                                                         //Inicializa el modulo UART a 9600 bps

     //Nivel de prioridad de las interrupciones (+alta -> +prioridad):
     IPC0bits.T1IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
     IPC1bits.T2IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
     IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX

     Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios

}


//*****************************************************************************************************************************************
//Funcion para la obtener la temperatura del sensor DS18B20
void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){

     //Variables:
     unsigned char funcionSolicitud, subFuncionSolicitud;
     unsigned char datoShort;
     unsigned int datoInt, numDatosResp;
     float datoFloat;
     unsigned char *ptrDatoInt, *ptrDatoFloat, *ptrNumDatosResp;

     //Asignacion de punteros:
     ptrNumDatosResp = (unsigned char *) & numDatosResp;
     ptrDatoInt = (unsigned char *) & datoInt;
     ptrDatoFloat = (unsigned char *) & datoFloat;

     //Recupera la funcion y la subfuncion:
     funcionSolicitud = cabeceraSolicitud[1];
     subFuncionSolicitud = cabeceraSolicitud[2];

     switch (funcionSolicitud){
          case 1:
               switch (subFuncionSolicitud){
                    case 1:
                         //Realiza una medicion de temperatura y TOF:
                         temperaturaRaw = LeerDS18B20();
                         //TOF = CalcularTOF();
                         break;
                    case 2:
                         //Realiza una medicion de temperatura y captura la senal ultrasonica
                         temperaturaRaw = LeerDS18B20();
                         CapturarMuestras();
                         break;
                    case 3:
                         //Prueba el ADC:
                         temperaturaRaw = LeerDS18B20();
                         ProbarMuestreo();
                         break;
                         
                    case 4:
                         //Prueba que este bien el llenado de la trama:
                         temperaturaRaw = LeerDS18B20();
                         ProbarEnvioTrama();
                         break;
                    default:
                         //Realiza una medicion de temperatura y TOF:
                         temperaturaRaw = LeerDS18B20();
                         //TOF = CalcularTOF();
                         break;
               }
               break;
          case 2:
               //T2CON.TON = 0; //**prueba
               //Solicitud de lectura de datos:
               switch (subFuncionSolicitud){
                    case 1:
                         //Lectura de la distancia [mm-int]
                         //Llena la trama del payload de respuesra con los valores asociados al puntero:
                         datoInt = temperaturaRaw;
                         datoFloat = TOF;
                         respuestaPyloadRS485[0] = *(ptrDatoFloat);
                         respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
                         respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
                         respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
                         respuestaPyloadRS485[4] = *(ptrDatoInt);
                         respuestaPyloadRS485[5] = *(ptrDatoInt+1);
                         //Actualiza el numero de datos de payload:
                         numDatosResp = 6;
                         cabeceraSolicitud[3] = *(ptrNumDatosResp);
                         cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
                    case 2:
                         //Recupera el vector de muestras y la temperatura:
                         //Actualiza el numero de payload:
                         numDatosResp = 702;
                         cabeceraSolicitud[3] = *(ptrNumDatosResp);
                         cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
                         EnviarTramaInt(cabeceraSolicitud, temperaturaRaw);
                         break;
               }
               break;
          case 4:
               //Test de comunicacion RS485:
               switch (subFuncionSolicitud){
                    case 2:
                         //Test trama corta:
                         //Actualiza el numero de payload:
                         numDatosResp = 10;
                         cabeceraSolicitud[3] = *(ptrNumDatosResp);
                         cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
                         EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
                         break;
                    case 3:
                         //Test trama larga:
                         //Actualiza el numero de payload:
                         numDatosResp = 512;
                         cabeceraSolicitud[3] = *(ptrNumDatosResp);
                         cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
                         GenerarTramaPrueba(numDatosResp, cabeceraSolicitud);
                         break;
               }
               break;
     }

     banderaPeticion = 0;

}


//*****************************************************************************************************************************************
// Funcion para generar una trama de prueba:
void GenerarTramaPrueba(unsigned int numDatosPrueba, unsigned char *cabeceraPrueba){

     unsigned int contadorMuestras = 0;
     unsigned char outputPyloadRS485[515];

     //Llena la trama de respuesta con los datos del payload:
     for (j=0;j<numDatosPrueba;j++){
         outputPyloadRS485[j] = contadorMuestras;
         contadorMuestras++;
         if (contadorMuestras>255) {
           contadorMuestras = 0;
         }
     }

     EnviarTramaRS485(1, cabeceraPrueba, outputPyloadRS485);

}


//*****************************************************************************************************************************************
//Funcion para la obtener una lectura cruda del sensor DS18B20
unsigned int LeerDS18B20(){

     unsigned int temperaturaCrudo;
     unsigned temp;
     LED1 = 1;

     //----Lectura del sensor----
     Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
     Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
     Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
     Delay_ms(750);
     Ow_Reset(&PORTA, 0);
     Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
     Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
     Delay_us(100);
     temp = Ow_Read(&PORTA, 0);
     temp = (Ow_Read(&PORTA, 0) << 8) + temp;

     LED1 = 0;

     temperaturaCrudo = temp;

     return temperaturaCrudo;

}

//*****************************************************************************************************************************************
//Funcion para capturar la senal ultrasonica
void ProbarEnvioTrama(){

     LED1 = 1;
     
     i = 0;
     while (i<numeroMuestras){
        vectorMuestras[j] = 500;                                           //Almacena el valor actual de la conversion del ADC en el vectorMuestras
        i++;                                                                    //Aumenta en 1 el subindice del vector de Muestras
     }
     
     LED1 = 0;
     delay_ms(200);
     LED1 = 1;
     delay_ms(200);
     LED1 = 0;
     
}

//*****************************************************************************************************************************************
//Funcion para capturar la senal ultrasonica
void ProbarMuestreo(){

     LED1 = 1;

     TMR1 = 0;                                                                  //Encera el TMR1
     T1CON.TON = 1;                                                             //Enciende el TMR1
     bm = 0;
     i = 0;
     while(bm!=1);

     LED1 = 0;

}


//*****************************************************************************************************************************************
//Funcion para capturar la senal ultrasonica
void CapturarMuestras(){

     LED1 = 1;

     // Generacion de pulsos y captura de la senal de retorno:
     bm = 0;
     contPulsos = 0;                                                            //Limpia la variable del contador de pulsos
     RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
     T1CON.TON = 0;                                                             //Apaga el TMR1
     TMR2 = 0;                                                                  //Encera el TMR2
     T2CON.TON = 1;                                                             //Enciende el TMR2
     i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la senal muestreada
     while(bm!=1);

     LED1 = 0;

}

/*
//*****************************************************************************************************************************************
//Funcion capturar y procesar la senal ultrasonica
void ProcesarMuestras(){

     LED1 = 1;

     // Generacion de pulsos y captura de la senal de retorno:
     bm = 0;
     contPulsos = 0;                                                            //Limpia la variable del contador de pulsos
     RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
     T1CON.TON = 0;                                                             //Apaga el TMR1
     TMR2 = 0;                                                                  //Encera el TMR2
     T2CON.TON = 1;                                                             //Enciende el TMR2
     i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la senal muestreada
     while(bm!=1);                                                              //Espera hasta que haya terminado de enviar y recibir todas las muestras

     // Procesamiento de la senal capturada:
     if (bm==1){

          //Determinacion de la amplitud media de la senal:                     //**Esta parte podria revisar. Es realmente necesario considerar la parte negativa de la senal?
          Mmed = 508;                                                           //Medido con el osciloscopio: Vmean = 1.64V => 508.4adc

          for (k=0;k<numeroMuestras;k++){

              //Valor absoluto
              valorAbsoluto = vectorMuestras[k]-Mmed;
              if (vectorMuestras[k]<Mmed){
                 valorAbsoluto = (vectorMuestras[k]+((Mmed-vectorMuestras[k])*2))-(Mmed);
              }

              //Filtrado
              //Corrimiento continuo de la senal x[n]
              for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];
              //Adquisicion de una muestra de 10 bits en, x[0]
              XFIR[0] = (float)(valorAbsoluto);
              //Convolucion continua.
              y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];

              YY = (unsigned int)(y0);                                          //Reconstruccion de la senal: y en 10 bits.
              vectorMuestras[k] = YY;

          }

          bm = 2;                                                               //Cambia el estado de la bandera bm para dar paso al calculo del pmax y TOF

      }

      // Calculo del punto maximo y TOF
      if (bm==2){

         yy1 = Vector_Max(vectorMuestras, numeroMuestras, &maxIndex);                                    //Encuentra el valor maximo del vector R
         i1b = maxIndex;                                                        //Asigna el subindice del valor maximo a la variable i1a
         i1a = 0;

         while (vectorMuestras[i1a]<yy1){
               i1a++;
         }

         i1 = i1a+((i1b-i1a)/2);
         i0 = i1 - dix;
         i2 = i1 + dix;

         yy0 = vectorMuestras[i0];
         yy2 = vectorMuestras[i2];

         yf0 = (float)(yy0);
         yf1 = (float)(yy1);
         yf2 = (float)(yy2);

         nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));                              //Factor de ajuste determinado por interpolacion parabolica
         dx = nx*dix*tx;
         tmax = i1*tx;

         T2 = tmax+dx;

      }

      LED1 = 0;

}
*/
/*
//*****************************************************************************************************************************************
//Funcion para el calculo del T2
float CalcularTOF(){

     conts = 0;                                                                 //Limpia el contador de secuencias
     T2sum = 0.0;
     T2prom = 0.0;
     T2a = 0.0;
     T2b = 0.0;

     while (conts<Nsm){
           ProcesarMuestras();                                                      //Inicia una secuencia de medicion
           T2b = T2;
           if ((T2b-T2a)<=T2umb){                                               //Verifica si el T2 actual esta dentro de un umbral pre-establecido
              T2sum = T2sum + T2b;                                              //Acumula la sumatoria de valores de T2 calculados por la funcion ProcesarMuestras()
              conts++;                                                          //Aumenta el contador de secuencias
           }
           T2a = T2b;
     }

     T2prom = T2sum/Nsm;

     return T2prom;

}
//*****************************************************************************************************************************************
*/

//*****************************************************************************************************************************************
//Funcion para enviar la trama de datos tipo int:
//void EnviarTramaInt(unsigned char* cabecera, unsigned int* tramaInt, unsigned int temperatura){
void EnviarTramaInt(unsigned char* cabecera, unsigned int temperatura){

     //Variables:
     unsigned char tramaShort[705];
     unsigned int valorInt;
     unsigned char *ptrValorInt, *ptrTemperatura;

     //Asignacion de punteros:
     ptrValorInt = (unsigned char *) & valorInt;
     ptrTemperatura = (unsigned char *) & temperatura;

     //Convierte el vector de enteros en un vector de char:
     for (j=0;j<numeroMuestras;j++){
          valorInt = vectorMuestras[j];
          tramaShort[j*2] = *(ptrValorInt);
          tramaShort[(j*2)+1] = *(ptrValorInt+1);
     }

     //Agrega los datos de temperatura al final de la trama:
     tramaShort[700] = *(ptrTemperatura);
     tramaShort[701] = *(ptrTemperatura+1);

     //Actualiza la cabecera y envia la trama por RS485:
     EnviarTramaRS485(1, cabecera, tramaShort);

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////// Interrupciones ///////////////////////////////////////////////////////////////
//********************************************************************************************************************************************
//Interrupcion por desbordamiento del TMR1:
void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
     SAMP_bit = 0;                                                              //Limpia el bit SAMP para iniciar la conversion del ADC
     while (!AD1CON1bits.DONE);                                                 //Espera hasta que se complete la conversion
     if (i<numeroMuestras){
        vectorMuestras[i] = ADC1BUF0;                                           //Almacena el valor actual de la conversion del ADC en el vectorMuestras
        i++;                                                                    //Aumenta en 1 el subindice del vector de Muestras
     } else {
        bm = 1;                                                                 //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la senal
        T1CON.TON = 0;                                                          //Apaga el TMR1
     }
     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del TMR1
}
//********************************************************************************************************************************************
//Interrupcion por desbordamiento del TMR2:
void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{

     if (contPulsos<10){                                                        //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
          RB2_bit = ~RB2_bit;                                                   //Conmuta el valor del pin RB14
     }else {
          RB2_bit = 0;                                                          //Pone a cero despues de enviar todos los pulsos de exitacion.
          if (contPulsos==110){
              T2CON.TON = 0;                                                    //Apaga el TMR2
              TMR1 = 0;                                                         //Encera el TMR1
              T1CON.TON = 1;                                                    //Enciende el TMR1
              bm = 0;
              i = 0;
          }
     }
     contPulsos++;                                                              //Aumenta el contador en una unidad.
     T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del TMR2

}
//********************************************************************************************************************************************
//Interrupcion por desbordamiento del TMR3:
void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{

     contTMR3++;                                                                //Incrementa el contador de TMR2

     //Despues de 900ms apaga el TMR3 y vuelve a encender el UART1:
     if (contTMR3==3){
         TMR3 = 0;                                                              //Encera el TMR3
         contTMR3 = 0;
         //Limpia estas banderas para restablecer la comunicacion por RS485:
         banRSI = 0;
         banRSC = 0;
         i_rs485 = 0;
         
         //Inicio test
         LED1 = ~LED1;
         contPulsosTMR3++;
         //Fin test
         
         //Activa el UART1:
         //banderaUART = 0;
         //T3CON.TON = 0;                                                         //Apaga el TMR3
     }

     //*************************************************************************
     //Test
     if (contPulsosTMR3==10){
         T3CON.TON = 0;                                                         //Apaga el TMR3
     }
     //LED1 = ~LED1;
     //*************************************************************************

     T3IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2

}
//********************************************************************************************************************************************
//Interrupcion por recepcion de datos a travez de UART
void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {

     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
     byteRS485 = UART1_Read();                                                  //Lee el byte recibido

     //*Recupera el pyload de la trama RS485:                                   //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banRSI==2){
          //Recupera el pyload de final de trama:
          if (i_rs485<(numDatosRS485)){
               solicitudPyloadRS485[i_rs485] = byteRS485;
               i_rs485++;
          } else {
               banRSI = 0;                                                      //Limpia la bandera de inicio de trama
               banRSC = 1;                                                      //Activa la bandera de trama completa
          }
     }

     //*Recupera la cabecera de la trama RS485:                                 //Aqui deberia entrar primero cada vez que se recibe una trama nueva
     if ((banRSI==0)&&(banRSC==0)){
          if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
               banRSI = 1;
               i_rs485 = 0;
          }
     }
     if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
          solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
     }
     if ((banRSI==1)&&(i_rs485==5)){
          //Comprueba la direccion del nodo solicitado:
          if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
               //Recupera el numero de datos:
               *(ptrNumDatosRS485) = solicitudCabeceraRS485[3];
               *(ptrNumDatosRS485+1) = solicitudCabeceraRS485[4];
               i_rs485 = 0;                                                     //Encera el subindice para almacenar el payload
               banRSI = 2;                                                      //Cambia el valor de la bandera para salir del bucle
          } else {
               banRSI = 0;
               banRSC = 0;
               i_rs485 = 0;
          }
     }

     //*Realiza el procesamiento de la informacion del  pyload:                 //Aqui se realiza cualquier accion con el pyload recuperado
     if (banRSC==1){
          Delay_ms(100);                                                        //**Ojo: Este retardo es importante para que el Concentrador tenga tiempo de recibir la respuesta
          //Llama a la funcion para procesar la solicitud recibida:
          //ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
          
           banderaPeticion = 1;
          //Limpia la bandera de trama completa:
          banRSC = 0;
     }
}
//********************************************************************************************************************************************
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////