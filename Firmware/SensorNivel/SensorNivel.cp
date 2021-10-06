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
#line 36 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Vertedero PCh/Vertedero-PCh/Firmware/SensorNivel/SensorNivel.c"
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


const short Psize = 6;
const short Rsize = 6;
const short Hdr = 0x3A;
const short End = 0x0D;
unsigned char Ptcn[Psize];
unsigned char Rspt[Rsize];
unsigned short ir, ip, ipp;
unsigned short BanP, BanT;
unsigned short Fcn;
unsigned int DatoPtcn;
unsigned short Dato;
unsigned int Altura;
unsigned int Nivel;
float FNivel, FCaudal;
unsigned int TemperaturaInt, Caudal, ITOF;
int Kadj;
unsigned char *chTemp, *chCaudal, *chNivel,
*chKadj, *chTOF, *chAltura;
float FDReal;
unsigned int IT2prom;
unsigned char *chT2prom;
float doub;
float *iptr;
short num;


float vSonido;


unsigned int contp;


const unsigned int nm = 350;
unsigned int M[nm];
unsigned int k;
short bm;


unsigned int value = 0;
unsigned int aux_value = 0;


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
const short Nsm=3;
const float T2umb = 3.0;
const float T1 = 1375.0;
float T2adj;
float T2sum,T2prom;
float T2, TOF, Dst;
unsigned int IDst;
unsigned char *chIDst;
long TT2;
unsigned char *chTT2;
unsigned int distanciaEstimada;
unsigned int Vdistancia[10];


unsigned int ME1=0, ME2=0, ME3=0;
unsigned short Mb2=0, Mb3=0;
unsigned short Mc1=0, Mc2=0, Mc3=0;
unsigned short mi=0, vi=0;
const short nd = 10;




void ConfiguracionPrincipal();
void ProcesarSolicitud(unsigned char, unsigned char);
int LeerDS18B20();
float LeerTemperatura();
float CalcularVelocidadSonido();
void GenerarPulso();
int CalcularModa(int);
int CalcularDistancia();
void AproximarDistancia();




void main() {


 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;
 distanciaEstimada = 0;
 T2 = 0;
 bm = 0;

 banRSI = 0;
 banRSC = 0;
 byteRS485 = 0;
 i_rs485 = 0;
 MSRS485 = 0;

 TEST = 0;

 T2adj = 460.0;
 Kadj = 0;
 Altura = 275;

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

 AproximarDistancia();

 break;
 case 2:


 switch (subFuncionRS485){
 case 1:

 datoInt = distanciaEstimada;
 respuestaPyloadRS485[0] = *(ptrDatoInt);
 respuestaPyloadRS485[1] = *(ptrDatoInt+1);
 cabeceraSolicitud[3] = 2;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 2:

 datoInt= LeerDS18B20();
 respuestaPyloadRS485[0] = *(ptrDatoInt);
 respuestaPyloadRS485[1] = *(ptrDatoInt+1);
 cabeceraSolicitud[3] = 2;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 3:

 datoInt = Altura;
 respuestaPyloadRS485[0] = *(ptrDatoInt);
 respuestaPyloadRS485[1] = *(ptrDatoInt+1);
 cabeceraSolicitud[3] = 2;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 4:


 datoFloat = LeerTemperatura();
 respuestaPyloadRS485[0] = *(ptrDatoFloat);
 respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
 respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
 respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
 cabeceraSolicitud[3] = 4;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 case 5:

 datoShort = Kadj;
 respuestaPyloadRS485[0] = datoShort;
 cabeceraSolicitud[3] = 1;
 EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
 break;
 }
 case 3:


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



float LeerTemperatura(){

 unsigned int temperaturaCrudo, temperaturaInt;
 float temperaturaDec, temperaturaResultado;


 Ow_Reset(&PORTA, 0);
 Ow_Write(&PORTA, 0, 0xCC);
 Ow_Write(&PORTA, 0, 0x44);
 Delay_us(120);
 Ow_Reset(&PORTA, 0);
 Ow_Write(&PORTA, 0, 0xCC);
 Ow_Write(&PORTA, 0, 0xBE);
 Delay_ms(400);
 temperaturaCrudo = Ow_Read(&PORTA, 0);
 temperaturaCrudo = (Ow_Read(&PORTA, 0) << 8) + temperaturaCrudo;



 temperaturaInt = temperaturaCrudo >> 4;

 temperaturaDec = ((temperaturaCrudo & 0x000F) * 625)/10000.0;

 temperaturaResultado = temperaturaInt + temperaturaDec;

 return temperaturaResultado;

}



float CalcularVelocidadSonido(){

 float temperatura_Float, vSonido;
 temperatura_Float = LeerTemperatura();
 vSonido = 331.45 * sqrt(1+(temperatura_Float/273));
 return vSonido;

}



void GenerarPulso(){

 TEST = 1;


 bm = 0;
 contp = 0;
 RB2_bit = 0;
 T1CON.TON = 0;
 TMR2 = 0;
 T2CON.TON = 1;
 i = 0;
 while(bm!=1);


 if (bm==1){





 Mmed = 508;


 for (k=0;k<nm;k++){


 value = M[k]-Mmed;
 if (M[k]<Mmed){
 value = (M[k]+((Mmed-M[k])*2))-(Mmed);
 }



 for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];

 XFIR[0] = (float)(value);

 y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];

 YY = (unsigned int)(y0);
 M[k] = YY;

 }

 bm = 2;

 }


 if (bm==2){

 yy1 = Vector_Max(M, nm, &maxIndex);
 i1b = maxIndex;
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

 nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));
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



int CalcularDistancia(){

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


 vSonido = CalcularVelocidadSonido();

 TOF = (T1+T2prom-T2adj)/1.0e6;

 Dst = (vSonido*TOF/2.0) * 1000.0;
 doub = modf(Dst, &iptr);
 if (doub>=0.5){
 Dst=ceil(Dst);
 }else{
 Dst=floor(Dst);
 }

 return Dst;

}


void AproximarDistancia(){



 for (vi=0;vi<nd;vi++){
 Vdistancia[vi] = CalcularDistancia();
 }

 distanciaEstimada = CalcularModa(Vdistancia);
 distanciaEstimada = distanciaEstimada + Kadj;



}






void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
 SAMP_bit = 0;
 while (!AD1CON1bits.DONE);
 if (i<nm){
 M[i] = ADC1BUF0;
 i++;
 } else {
 bm = 1;
 T1CON.TON = 0;
 }
 T1IF_bit = 0;
}


void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{

 if (contp<10){
 RB2_bit = ~RB2_bit;
 }else {
 RB2_bit = 0;
 if (contp==110){
 T2CON.TON = 0;
 TMR1 = 0;
 T1CON.TON = 1;

 }
 }
 contp++;
 T2IF_bit = 0;
#line 685 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Vertedero PCh/Vertedero-PCh/Firmware/SensorNivel/SensorNivel.c"
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
