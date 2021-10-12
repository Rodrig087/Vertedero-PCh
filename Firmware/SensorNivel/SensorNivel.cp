#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Vertedero PCh/Vertedero-PCh/Firmware/SensorNivel/SensorNivel.c"
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/vertedero pch/vertedero-pch/firmware/librerias/rs485.c"
#line 13 "c:/users/milto/milton/rsa/git/proyecto chanlud/vertedero pch/vertedero-pch/firmware/librerias/rs485.c"
extern sfr sbit MSRS485;
extern sfr sbit MSRS485_Direction;




void EnviarTramaRS485(unsigned short puertoUART, unsigned char *cabecera, unsigned char *payload){

 unsigned short direccion;
 unsigned short funcion;
 unsigned short subfuncion;
 unsigned short numDatos;
 unsigned short iDatos;

 direccion = cabecera[0];
 funcion = cabecera[1];
 subfuncion = cabecera[2];
 numDatos = cabecera[3];

 if (puertoUART == 1){
 MSRS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(funcion);
 UART1_Write(subfuncion);
 UART1_Write(numDatos);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART1_Write(payload[iDatos]);
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 UART1_Write(0x00);
 while(UART1_Tx_Idle()==0);
 MSRS485 = 0;
 }

}
#line 34 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Vertedero PCh/Vertedero-PCh/Firmware/SensorNivel/SensorNivel.c"
const float h[]=
{
0,
8.655082858474001e-04,
0.003740336116716,
0.008801023059201,
0.015858487391720,
0.024356432913204,
0.033436118860918,
0.042058476113843,
0.049163467317092,
0.053839086446614,
0.055470000000000,
0.053839086446614,
0.049163467317092,
0.042058476113843,
0.033436118860918,
0.024356432913204,
0.015858487391720,
0.008801023059201,
0.003740336116716,
8.655082858474001e-04,
0
};


sbit MSRS485 at LATB5_bit;
sbit MSRS485_Direction at TRISB5_bit;
sbit TEST at LATA4_bit;
sbit TEST_Direction at TRISA4_bit;

unsigned int i, j, x, y;


unsigned short banRSI, banRSC;
unsigned char byteRS485;
unsigned int i_rs485;
unsigned char solicitudCabeceraRS485[5];
unsigned char solicitudPyloadRS485[15];
unsigned char respuestaPyloadRS485[15];
unsigned char tramaPruebaRS485[10]= {0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB,  3 };


unsigned short ir, ip, ipp;


unsigned int contPulsos;


const unsigned int numeroMuestras = 350;
unsigned int vectorMuestreo[numeroMuestras];
unsigned int vectorEnvolvente[numeroMuestras];
unsigned int k;
short bm;


unsigned int valorAbsoluto;


float x0=0, x1=0, x2=0, y0=0, y1=0, y2=0;
const unsigned short O = 21;
float XFIR[O];
unsigned int f;
unsigned int YY = 0;


unsigned int Mmax=0;
unsigned int Mmin=0;
unsigned int Mmed=0;
unsigned int MIndexMax;
unsigned int MIndexMin;
unsigned int maxIndex;
unsigned int i0, i1, i2, imax;
unsigned int i1a, i1b;
const short dix=20;
const float tx=5.0;
int yy0, yy1, yy2;
float yf0, yf1, yf2;
float nx, dx, tmax;


short conts;
float T2a, T2b;
const short Nsm=30;
const float T2umb = 3.0;
const float T1 = 1375.0;
float T2adj;
float T2sum,T2prom;
float T2, TOF;









void ConfiguracionPrincipal();
void ProcesarSolicitud(unsigned char, unsigned char);
int LeerDS18B20();
void GenerarPulso();
float CalcularT2();
EnviarTramaInt(unsigned char*, unsigned char*);




void main() {


 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;

 T2 = 0;
 bm = 0;

 banRSI = 0;
 banRSC = 0;
 byteRS485 = 0;
 i_rs485 = 0;
 MSRS485 = 0;

 TEST = 0;


 ip=0;








}







void ConfiguracionPrincipal(){


 CLKDIVbits.PLLPRE = 0;
 PLLFBD = 38;
 CLKDIVbits.PLLPOST = 0;


 AD1PCFGL = 0xFFFD;
 TRISA1_bit = 1;
 TRISB = 0xFF40;
 MSRS485_Direction = 0;
 TEST_Direction = 0;

 AD1CON1.AD12B = 0;
 AD1CON1bits.FORM = 0x00;
 AD1CON1.SIMSAM = 0;
 AD1CON1.ADSIDL = 0;
 AD1CON1.ASAM = 1;
 AD1CON1bits.SSRC = 0x00;
 AD1CON2bits.VCFG = 0;
 AD1CON2bits.CHPS = 0;
 AD1CON2.CSCNA = 0;
 AD1CON2.BUFM = 0;
 AD1CON2.ALTS = 0x00;
 AD1CON3.ADRC = 0;
 AD1CON3bits.ADCS = 0x02;
 AD1CON3bits.SAMC = 0x02;
 AD1CHS0.CH0NB = 0;
 AD1CHS0bits.CH0SB = 0x01;
 AD1CHS0.CH0NA = 0;
 AD1CHS0bits.CH0SA = 0x01;
 AD1CHS123 = 0;
 AD1CSSL = 0x00;
 AD1CON1.ADON = 1;


 T1CON = 0x8000;
 IEC0.T1IE = 1;
 T1IF_bit = 0;
 PR1 = 200;
 T1CON.TON = 0;


 T2CON = 0x8000;
 IEC0.T2IE = 1;
 T2IF_bit = 0;
 PR2 = 500;
 T2CON.TON = 0;


 RPINR18bits.U1RXR = 0x06;
 RPOR3bits.RP7R = 0x03;
 IEC0.U1RXIE = 1;
 U1RXIF_bit = 0;
 UART1_Init(19200);


 IPC0bits.T1IP = 0x06;
 IPC1bits.T2IP = 0x07;
 IPC2bits.U1RXIP = 0x05;

 Delay_ms(100);

}


void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){


 unsigned short funcionRS485, subFuncionRS485, numDatosRS485;
 unsigned short datoShort;
 unsigned int datoInt;
 float datoFloat;
 unsigned short *ptrDatoInt, *ptrDatoFloat;


 ptrDatoInt = (unsigned short *) & datoInt;
 ptrDatoFloat = (unsigned short *) & datoFloat;


 funcionRS485 = cabeceraSolicitud[1];
 subFuncionRS485 = cabeceraSolicitud[2];
 numDatosRS485 = cabeceraSolicitud[3];



 switch (funcionRS485){
 case 1:

 CalcularT2();
 break;
 case 2:


 switch (subFuncionRS485){
 case 1:


 respuestaPyloadRS485[0] = *(ptrDatoInt);
 respuestaPyloadRS485[1] = *(ptrDatoInt+1);
 cabeceraSolicitud[3] = 2;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 2:


 respuestaPyloadRS485[0] = *(ptrDatoInt);
 respuestaPyloadRS485[1] = *(ptrDatoInt+1);
 cabeceraSolicitud[3] = 2;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 3:


 break;
 case 4:


 break;
 }
 break;
 case 4:

 cabeceraSolicitud[3] = 10;
 EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
 break;
 }


}



int LeerDS18B20(){

 unsigned int temperaturaCrudo;
 unsigned temp;
 TEST = 1;


 Ow_Reset(&PORTA, 0);
 Ow_Write(&PORTA, 0, 0xCC);
 Ow_Write(&PORTA, 0, 0x44);
 Delay_ms(750);
 Ow_Reset(&PORTA, 0);
 Ow_Write(&PORTA, 0, 0xCC);
 Ow_Write(&PORTA, 0, 0xBE);
 Delay_us(100);
 temp = Ow_Read(&PORTA, 0);
 temp = (Ow_Read(&PORTA, 0) << 8) + temp;

 TEST = 0;

 temperaturaCrudo = temp;

 return temperaturaCrudo;

}



void GenerarPulso(){

 TEST = 1;


 bm = 0;
 contPulsos = 0;
 RB2_bit = 0;
 T1CON.TON = 0;
 TMR2 = 0;
 T2CON.TON = 1;
 i = 0;
 while(bm!=1);


 if (bm==1){


 Mmed = 508;

 for (k=0;k<numeroMuestras;k++){


 valorAbsoluto = vectorMuestreo[k]-Mmed;
 if (vectorMuestreo[k]<Mmed){
 valorAbsoluto = (vectorMuestreo[k]+((Mmed-vectorMuestreo[k])*2))-(Mmed);
 }



 for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];

 XFIR[0] = (float)(valorAbsoluto);

 y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];

 YY = (unsigned int)(y0);
 vectorEnvolvente[k] = YY;

 }

 bm = 2;

 }


 if (bm==2){

 yy1 = Vector_Max(vectorEnvolvente, numeroMuestras, &maxIndex);
 i1b = maxIndex;
 i1a = 0;

 while (vectorEnvolvente[i1a]<yy1){
 i1a++;
 }

 i1 = i1a+((i1b-i1a)/2);
 i0 = i1 - dix;
 i2 = i1 + dix;

 yy0 = vectorEnvolvente[i0];
 yy2 = vectorEnvolvente[i2];

 yf0 = (float)(yy0);
 yf1 = (float)(yy1);
 yf2 = (float)(yy2);

 nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));
 dx = nx*dix*tx;
 tmax = i1*tx;

 T2 = tmax+dx;

 }

 TEST = 0;

}



float CalcularT2(){

 conts = 0;
 T2sum = 0.0;
 T2prom = 0.0;
 T2a = 0.0;
 T2b = 0.0;

 while (conts<Nsm){
 GenerarPulso();
 T2b = T2;
 if ((T2b-T2a)<=T2umb){
 T2sum = T2sum + T2b;
 conts++;
 }
 T2a = T2b;
 }

 T2prom = T2sum/Nsm;

 return T2prom;

}



void EnviarTramaInt(unsigned char* cabecera, unsigned char* tramaInt){


 unsigned short tramaShort[numeroMuestras*2];
 unsigned int valorInt;
 unsigned short *ptrValorInt;

 ptrValorInt = (unsigned short *) & valorInt;


 for (j=0;j<numeroMuestras;j++){
 valorInt = tramaInt[j];
 tramaShort[j*2] = *(ptrValorInt);
 tramaShort[(j*2)+1] = *(ptrValorInt+1);
 }



 EnviarTramaRS485(1, cabecera, tramaShort);

}







void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
 SAMP_bit = 0;
 while (!AD1CON1bits.DONE);
 if (i<numeroMuestras){
 vectorMuestreo[i] = ADC1BUF0;
 i++;
 } else {
 bm = 1;
 T1CON.TON = 0;
 }
 T1IF_bit = 0;
}


void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{

 if (contPulsos<10){
 RB2_bit = ~RB2_bit;
 }else {
 RB2_bit = 0;
 if (contPulsos==110){
 T2CON.TON = 0;
 TMR1 = 0;
 T1CON.TON = 1;

 }
 }
 contPulsos++;
 T2IF_bit = 0;
#line 514 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Vertedero PCh/Vertedero-PCh/Firmware/SensorNivel/SensorNivel.c"
}


void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {

 U1RXIF_bit = 0;
 byteRS485 = UART1_Read();


 if (banRSI==2){

 if (i_rs485<(solicitudCabeceraRS485[3])){
 solicitudPyloadRS485[i_rs485] = byteRS485;
 i_rs485++;
 } else {
 banRSI = 0;
 banRSC = 1;
 }
 }


 if ((banRSI==0)&&(banRSC==0)){
 if (byteRS485==0x3A){
 banRSI = 1;
 i_rs485 = 0;

 }
 }
 if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
 solicitudCabeceraRS485[i_rs485] = byteRS485;
 i_rs485++;
 }
 if ((banRSI==1)&&(i_rs485==4)){

 if ((solicitudCabeceraRS485[0]== 3 )||(solicitudCabeceraRS485[0]==255)){
 i_rs485 = 0;
 banRSI = 2;
 } else {
 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;
 }
 }


 if (banRSC==1){
 Delay_ms(100);

 ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);

 banRSC = 0;
 }
}
