/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/09/09
Configuracion: dsPIC P33FJ32MC202, XT=8MHz, PLL=80MHz
Observaciones:
1. Rediseño del firmware del sensor de nivel elaborado para el proyecto de tesis elaborado el 17/01/13
2. En esta version el calculo del caudal se hace en la Raspberry Pi.


Descripcion:
Funcion1: Inicio de medicion, Payload[TiempoSeg]??
Funcion2: Lectura de datos:
           Subfuncion1: Nivel[mm]
           Subfuncion2: Temperatura[grados]
           Subfuncion3: AlturaInstalacion[mm]
           Subfuncion4: Cte_T2adj[Float]
           Subfuncion5: Cte_Kadj
Funcion3: Escritura de datos:
           Subfuncion1: AlturaInstalacion, Payload[mm]
           Subfuncion2: Cte_T2adj, Payload[Float]
           Subfuncion3:. Cte_Kadj, Payload
Funcion4: Test comunicacion:
           Subfuncion2: Test RS485
---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////
#include <RS485.c>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Credenciales:
#define IDNODO 3                                                                //Idendtificador del nodo

//Funcion de transferencia h(n) filtro FIR (Fs=200KHz, Fc=5547Hz) Ventana Hamming
const float h[]=
{
0,                        //h(0)
8.655082858474001e-04,    //h(1)
0.003740336116716,        //h(2)
0.008801023059201,        //h(3)
0.015858487391720,        //h(4)
0.024356432913204,        //h(5)
0.033436118860918,        //h(6)
0.042058476113843,        //h(7)
0.049163467317092,        //h(8)
0.053839086446614,        //h(9)
0.055470000000000,        //h(10)
0.053839086446614,        //h(11)
0.049163467317092,        //h(12)
0.042058476113843,        //h(13)
0.033436118860918,        //h(14)
0.024356432913204,        //h(15)
0.015858487391720,        //h(16)
0.008801023059201,        //h(17)
0.003740336116716,        //h(18)
8.655082858474001e-04,    //h(19)
0                         //h(20)
};

//Declaracion de pines:
sbit MSRS485 at LATB5_bit;                                                     //Definicion del pin MS RS485
sbit MSRS485_Direction at TRISB5_bit;
sbit TEST at LATA4_bit;                                                         //Definicion del pin MS RS485
sbit TEST_Direction at TRISA4_bit;
//Subindices:
unsigned int i, j, x, y;

//Variables para la comunicacion RS485:
unsigned short banRSI, banRSC;                                                  //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485;
unsigned int i_rs485;                                                           //Subindice
unsigned char solicitudCabeceraRS485[5];                                        //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char solicitudPyloadRS485[15];                                         //Vector para almacenar el pyload de la trama RS485 recibida
unsigned char respuestaPyloadRS485[15];                                         //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char tramaPruebaRS485[10]= {0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, IDNODO};   //Trama de 10 elementos para probar la comunicacion RS485
//Variables para la peticion y respuesta de datos:
//unsigned int Id;                                        //Identificador de esclavo
const short Psize = 6;                                  //Constante de longitud de trama de Peticion
const short Rsize = 6;                                  //Constante de longitud de trama de Respuesta
const short Hdr = 0x3A;                                 //Constante de delimitador de inicio de trama (0x3A)
const short End = 0x0D;                                 //Constante de delimitador de final de trama (0x0D)
unsigned char Ptcn[Psize];                              //Trama de peticion
unsigned char Rspt[Rsize];                              //Trama de respuesta
unsigned short ir, ip, ipp;                             //Subindices para las tramas de peticion y respuesta
unsigned short BanP, BanT;                              //Bandera de peticion de datos
unsigned short Fcn;                                     //Variable para el tipo de funcion
unsigned int DatoPtcn;                                  //Variable para el Dato de la peticion
unsigned short Dato;                                    //Variable para almacenar los datos que recibe por Uart
unsigned int Altura;                                    //Variable para almacenar la Altura de instalacion del sensor
unsigned int Nivel;
float FNivel, FCaudal;                                  //Variables para almacenar el Nivel y el Caudal en punto flotante
unsigned int TemperaturaInt, Caudal, ITOF;                 //Variables para almacenar la Temperatura, Caudal, TOF en entero sin signo
int Kadj;                                               //Variable de factor de calibracion
unsigned char *chTemp, *chCaudal, *chNivel,
*chKadj, *chTOF, *chAltura;                             //Variables tipo puntero para la Temperatura, Caudal, Nivel, factor de calibracion, TOF
float FDReal;                                           //Variable para almacenar la distancia real para la calibracion
unsigned int IT2prom;
unsigned char *chT2prom;
float doub;
float *iptr;
short num;                                              //Variable para realizar pruebas

//Variable para Calcular la Velocidad del sonido
float vSonido;

//Variables para la generacion de pulsos de exitacion del transductor ultrasonico
unsigned int contp;

//Variables para el almacenamiento de la señal muestreada:
const unsigned int nm = 350;
unsigned int M[nm];
unsigned int k;
short bm;

//Variables para la deteccion de la Envolvente de la señal
unsigned int value = 0;
unsigned int aux_value = 0;

//Variables para el filtrado de la señal
float x0=0, x1=0, x2=0, y0=0, y1=0, y2=0;
const unsigned short O = 21;
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
const short dix=20;                                     //Intervalo de interpolacion
const float tx=5.0;                                     //Periodo de muestreo
int yy0, yy1, yy2;
float yf0, yf1, yf2;
float nx, dx, tmax;

//Variables para calcular la Distancia
short conts;
float T2a, T2b;
const short Nsm=3;                                      //Numero maximo de secuencias de medicion (3)
const float T2umb = 3.0;                                //Umbral para precision (3us)
const float T1 = 1375.0;                                //T0+T1. Altura minima de instalacion = 250 mm
float T2adj;                                            //Variable para la calibracion de T2
float T2sum,T2prom;
float T2, TOF, Dst;
unsigned int IDst;
unsigned char *chIDst;
long TT2;
unsigned char *chTT2;
unsigned int distanciaEstimada;
unsigned int Vdistancia[10];

//Variables para calcular la moda estadistica
unsigned int ME1=0, ME2=0, ME3=0;                       //Variables para almacenar los 3 posibles valores de una medicion de distancia
unsigned short Mb2=0, Mb3=0;                            //Banderas
unsigned short Mc1=0, Mc2=0, Mc3=0;                     //Contadores de mediciones de distancia
unsigned short mi=0, vi=0;                              //Subindices para el calculo de la Moda y la Distancia
const short nd = 10;                                    //Numero de secuencias de medicion de Distancia
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void ProcesarSolicitud(unsigned char, unsigned char);
int LeerDS18B20();
float LeerTemperatura();
float CalcularVelocidadSonido();
void GenerarPulso();
int CalcularModa(int);
int CalcularDistancia();
void AproximarDistancia();
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
     distanciaEstimada = 0;
     T2 = 0;
     bm = 0;
     //Comunicacion RS485:
     banRSI = 0;
     banRSC = 0;
     byteRS485 = 0;
     i_rs485 = 0;
     MSRS485 = 0;
     //Puertos:
     TEST = 0;

     T2adj = 460.0;                                                             //Factor de calibracion de T2: Con Temp=20 y Vsnd=343.2, reduce la medida 1mm por cada 3 unidades que se aumente a este factor
     Kadj = 0;                                                                  //Fija la constante de ajuste en 0
     Altura = 275;                                                              //Fija la altura de instalacion del sensor en 275mm

     ip=0;

     //Prueba
     //while(1){
     //         TEST = ~TEST;
     //         Delay_ms(500);
     //}
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
     TEST_Direction = 0;                                                        //Test out
     //Configuracion del ADC:
     AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
     AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
     AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea múltiples canales individualmente en secuencia
     AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
     AD1CON1.ASAM = 1;                                                          //Muestreo automatico
     AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
     AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
     AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
     AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
     AD1CON2.BUFM = 0;                                                          //Bit de selección del modo de relleno del búfer, 0 -> Siempre comienza a llenar el buffer desde el principio
     AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la selección de entrada de canal para la muestra A
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

     ////Configuracion del TMR2:
     T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
     IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
     T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
     PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
     T2CON.TON = 0;                                                             //Apaga la interrupcion

      //Configuracion UART:
     RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
     RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
     IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
     UART1_Init(19200);                                                          //Inicializa el modulo UART a 9600 bps

     //Nivel de prioridad de las interrupciones (+alta -> +prioridad):
     IPC0bits.T1IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
     IPC1bits.T2IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
     IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX

     Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************
//Funcion para la obtener la temperatura del sensor DS18B20
void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){

     //Variables:
     unsigned short funcionRS485, subFuncionRS485, numDatosRS485;
     unsigned short datoShort;
     unsigned int datoInt;
     float datoFloat;
     unsigned short *ptrDatoInt, *ptrDatoFloat;

     //Asignacion de punteros:
     ptrDatoInt = (unsigned short *) & datoInt;
     ptrDatoFloat = (unsigned short *) & datoFloat;
     
     //Recupera la funcion, la subfuncion y el numero de datos:
     funcionRS485 = cabeceraSolicitud[1];
     subFuncionRS485 = cabeceraSolicitud[2];
     numDatosRS485 = cabeceraSolicitud[3];

     //TEST = ~TEST;

     switch (funcionRS485){
          case 1:
               //Solicitud de medicion:
               AproximarDistancia();                                                 //Realiza una secuencia de calculo de la distancia
               //CalcularDistancia(); //**prueba
               break;
          case 2:
               //T2CON.TON = 0; //**prueba
               //Solicitud de lectura de datos:
               switch (subFuncionRS485){ 
                    case 1:
                         //Lectura de la distancia [mm-int]:
                         datoInt = distanciaEstimada;
                         respuestaPyloadRS485[0] = *(ptrDatoInt);                    //Llena la trama del payload de respuesra con los valores asociados al puntero
                         respuestaPyloadRS485[1] = *(ptrDatoInt+1);
                         cabeceraSolicitud[3] = 2;                                   //Actualiza el numero de datos de la cabecera
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
                    case 2:
                         //Lectura del sensor DS18B20 [int]:
                         datoInt= LeerDS18B20();
                         respuestaPyloadRS485[0] = *(ptrDatoInt);
                         respuestaPyloadRS485[1] = *(ptrDatoInt+1);
                         cabeceraSolicitud[3] = 2;
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
                    case 3:
                         //Lectura de altura de instalacion[int-mm]:
                         datoInt = Altura;
                         respuestaPyloadRS485[0] = *(ptrDatoInt);
                         respuestaPyloadRS485[1] = *(ptrDatoInt+1);
                         cabeceraSolicitud[3] = 2;
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
                    case 4:
                         //Lectura de la constante T2adj [float]:
                         //datoFloat = T2adj;
                         datoFloat = LeerTemperatura();
                         respuestaPyloadRS485[0] = *(ptrDatoFloat);
                         respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
                         respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
                         respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
                         cabeceraSolicitud[3] = 4;
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
                    case 5:
                         //Lectura de la constante [short-mm]:
                         datoShort = Kadj;
                         respuestaPyloadRS485[0] = datoShort;
                         cabeceraSolicitud[3] = 1;
                         EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
                         break;
               }
          case 3:
               //Solicitud de escritura de datos:

               break;
          case 4:
               //Test de comunicacion RS485:
               cabeceraSolicitud[3] = 10;
               EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
               break;
     }


}

//*****************************************************************************************************************************************
//Funcion para la obtener una lectura cruda del sensor DS18B20
int LeerDS18B20(){

     unsigned int temperaturaCrudo;
     unsigned temp;
     TEST = 1;

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

     TEST = 0;

     temperaturaCrudo = temp;

     return temperaturaCrudo;

}

//*****************************************************************************************************************************************
//Funcion para la obtener la temperatura del sensor DS18B20
float LeerTemperatura(){

     unsigned int temperaturaCrudo, temperaturaInt;
     float temperaturaDec, temperaturaResultado;
      
     //----Lectura del sensor----
     Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
     Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
     Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
     Delay_us(120);
     Ow_Reset(&PORTA, 0);
     Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
     Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
     Delay_ms(400);
     temperaturaCrudo = Ow_Read(&PORTA, 0);
     temperaturaCrudo = (Ow_Read(&PORTA, 0) << 8) + temperaturaCrudo;

     //----Conversion de datos----
     //Extrae la parte entera:
     temperaturaInt = temperaturaCrudo >> 4;
     //Extrae la parte decimal:
     temperaturaDec = ((temperaturaCrudo & 0x000F) * 625)/10000.0;
     //Suma la parte entera mas la parte decimal:
     temperaturaResultado = temperaturaInt + temperaturaDec;                    //Expresa la temperatura en punto flotante

     return  temperaturaResultado;

}

//*****************************************************************************************************************************************
//Funcion para calcular la velocidad el sonido:
float CalcularVelocidadSonido(){

     float temperatura_Float, vSonido;
     temperatura_Float = LeerTemperatura();
     vSonido = 331.45 * sqrt(1+(temperatura_Float/273));
     return vSonido;

}

//*****************************************************************************************************************************************
//Funcion para la generacion y procesamiento de la señal
void GenerarPulso(){

     TEST = 1;

     // Generacion de pulsos y captura de la señal de retorno:
     bm = 0;
     contp = 0;                                                                 //Limpia la variable del contador de pulsos
     RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
     T1CON.TON = 0;                                                             //Apaga el TMR1
     TMR2 = 0;                                                                  //Encera el TMR2
     T2CON.TON = 1;                                                             //Enciende el TMR2
     i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la señal muestreada
     while(bm!=1);                                                              //Espera hasta que haya terminado de enviar y recibir todas las muestras

     // Procesamiento de la señal capturada:
     if (bm==1){

          //Determinacion de la amplitud media de la señal:                     //**Esta parte podria revisar. Es realmente necesario considerar la parte negativa de la señal?
          //Mmax = Vector_Max(M, nm, &MIndexMax);
          //Mmin = Vector_Min(M, nm, &MIndexMin);
          //Mmed = Mmax-((Mmax-Mmin)/2);
          Mmed = 508;                                                           //Medido con el osciloscopio: Vmean = 1.64V => 508.4adc
          

          for (k=0;k<nm;k++){

              //Valor absoluto
              value = M[k]-Mmed;
              if (M[k]<Mmed){
                 value = (M[k]+((Mmed-M[k])*2))-(Mmed);
              }

              //Filtrado
              //Corrimiento continuo de la señal x[n]
              for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];
              //Adquisición de una muestra de 10 bits en, x[0]
              XFIR[0] = (float)(value);
              //Convolución continúa.
              y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];

              YY = (unsigned int)(y0);                                          //Reconstrucción de la señal: y en 10 bits.
              M[k] = YY;

          }

          bm = 2;                                                               //Cambia el estado de la bandera bm para dar paso al cálculo del pmax y TOF

      }

      // Cálculo del punto maximo y TOF
      if (bm==2){

         yy1 = Vector_Max(M, nm, &maxIndex);                                    //Encuentra el valor maximo del vector R
         i1b = maxIndex;                                                        //Asigna el subindice del valor maximo a la variable i1a
         i1a = 0;

         while (M[i1a]<yy1){
               i1a++;
         }

         i1 = i1a+((i1b-i1a)/2);
         i0 = i1 - dix;
         i2 = i1 + dix;

         yy0 = M[i0];
         yy2 = M[i2];

         yf0 = (float)(yy0);
         yf1 = (float)(yy1);
         yf2 = (float)(yy2);

         nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));                              //Factor de ajuste determinado por interpolacion parabolica
         dx = nx*dix*tx;
         tmax = i1*tx;

         T2 = tmax+dx;

      }

      TEST = 0;

}

int CalcularModa(int VRpt[nd]){

     ME1=0;
     ME2=0;
     ME3=0;
     Mb2=0;
     Mb3=0;
     Mc1=0;
     Mc2=0;
     Mc3=0;

     ME1=VRpt[0];

     for (mi=0;mi<nd;mi++){
          if (VRpt[mi]==ME1){
               Mc1++;
          }else{
               if (Mb2==0){
                    ME2=VRpt[mi];
                    Mb2=1;
               }
               if (VRpt[mi]==ME2){
                    Mc2++;
               }else{
                    if (Mb3==0){
                         ME3=VRpt[mi];
                         Mb3=1;
                    }
                    if (VRpt[mi]==ME3){
                         Mc3++;
                    }
               }
          }

     }

     if ((Mc1>Mc2)&&(Mc1>Mc3)){
          return ME1;
     }
     if ((Mc2>Mc1)&&(Mc2>Mc3)){
          return ME2;
     }
     if ((Mc3>Mc1)&&(Mc3>Mc2)){
          return ME3;
     }
     if (Mc1==Mc2){
          return ME1;
     }
     if (Mc1==Mc3){
          return ME1;
     }
     if (Mc2==Mc3){
          return ME2;
     }

}

//*****************************************************************************************************************************************
//Funcion para el calculo de la Distancia
int CalcularDistancia(){

     conts = 0;                                                                 //Limpia el contador de secuencias
     T2sum = 0.0;
     T2prom = 0.0;
     T2a = 0.0;
     T2b = 0.0;

     while (conts<Nsm){
           GenerarPulso();                                                      //Inicia una secuencia de medicion
           T2b = T2;
           if ((T2b-T2a)<=T2umb){                                               //Verifica si el T2 actual esta dentro de un umbral pre-establecido
              T2sum = T2sum + T2b;                                              //Acumula la sumatoria de valores de T2 calculados por la funcion GenerarPulso()
              conts++;                                                          //Aumenta el contador de secuencias
           }
           T2a = T2b;
     }

     T2prom = T2sum/Nsm;

     //Calcula la velocidad del sonido:
     vSonido = CalcularVelocidadSonido();
     //Calcula el TOF en seg:
     TOF = (T1+T2prom-T2adj)/1.0e6;                                             //TOF = TO + T1 + Tp - k (pag82)
     //Calcula la distancia en mm:
     Dst = (vSonido*TOF/2.0) * 1000.0;
     doub = modf(Dst, &iptr);                                                   //Ejemplo: doub = modf(6.25, &iptr) => doub = 0.25, iptr = 6.00
     if (doub>=0.5){
        Dst=ceil(Dst);                                                          //Redondea al inmediato superior
     }else{
        Dst=floor(Dst);                                                         //Redondea al inmediato inferior
     }

     return Dst;

}
//*****************************************************************************************************************************************
//Funcion para estimar la distancia en base a multiples mediciones
void AproximarDistancia(){

     //TEST = 1;

     for (vi=0;vi<nd;vi++){
         Vdistancia[vi] = CalcularDistancia();                                  //Toma 10 lecturas de la distancia calculada y las almacena en un vector
     }

     distanciaEstimada = CalcularModa(Vdistancia);                              //Calcula la Moda del vector de distancias
     distanciaEstimada = distanciaEstimada + Kadj;                              //Ajusta el valor de la Distancia calculada segun el factor de calibracion Kadj

     //TEST = 0;

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////// Interrupciones ///////////////////////////////////////////////////////////////
//********************************************************************************************************************************************
//Interrupcion por desbordamiento del TMR1:
void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
     SAMP_bit = 0;                                 //Limpia el bit SAMP para iniciar la conversion del ADC
     while (!AD1CON1bits.DONE);                    //Espera hasta que se complete la conversion
     if (i<nm){
        M[i] = ADC1BUF0;                           //Almacena el valor actual de la conversion del ADC en el vector M
        i++;                                       //Aumenta en 1 el subindice del vector de Muestras
     } else {
        bm = 1;                                    //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la señal
        T1CON.TON = 0;                             //Apaga el TMR1
     }
     T1IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR1
}
//********************************************************************************************************************************************
//Interrupcion por desbordamiento del TMR2:
void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{

     if (contp<10){                                //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
          RB2_bit = ~RB2_bit;                      //Conmuta el valor del pin RB14
     }else {
          RB2_bit = 0;                             //Pone a cero despues de enviar todos los pulsos de exitacion.
          if (contp==110){
              T2CON.TON = 0;                       //Apaga el TMR2
              TMR1 = 0;                            //Encera el TMR1
              T1CON.TON = 1;                       //Enciende el TMR1
              //bm=0;
          }
     }
     contp++;                                      //Aumenta el contador en una unidad.
     T2IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR2
     /*
     TEST = 0;  //*****
     RB2_bit = ~RB2_bit;
     T2IF_bit = 0;
     */
}
//********************************************************************************************************************************************
//Interrupcion por recepcion de datos a travez de UART
void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {

     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
     byteRS485 = UART1_Read();                                                  //Lee el byte recibido

     //*Recupera el pyload de la trama RS485:                                   //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banRSI==2){
          //Recupera el pyload de final de trama:
          if (i_rs485<(solicitudCabeceraRS485[3])){
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
               //TEST = 1;
          }
     }
     if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
          solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
     }
     if ((banRSI==1)&&(i_rs485==4)){
          //Comprueba la direccion del nodo solicitado:
          if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
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
          ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
          //Limpia la bandera de trama completa:
          banRSC = 0;
     }
}
//********************************************************************************************************************************************
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////