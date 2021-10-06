
_EnviarTramaRS485:

;rs485.c,19 :: 		void EnviarTramaRS485(unsigned short puertoUART, unsigned char *cabecera, unsigned char *payload){
;rs485.c,27 :: 		direccion = cabecera[0];
	PUSH	W10
; direccion start address is: 2 (W1)
	MOV.B	[W11], W1
;rs485.c,28 :: 		funcion = cabecera[1];
	ADD	W11, #1, W0
; funcion start address is: 4 (W2)
	MOV.B	[W0], W2
;rs485.c,29 :: 		subfuncion = cabecera[2];
	ADD	W11, #2, W0
; subfuncion start address is: 6 (W3)
	MOV.B	[W0], W3
;rs485.c,30 :: 		numDatos = cabecera[3];
	ADD	W11, #3, W0
; numDatos start address is: 0 (W0)
	MOV.B	[W0], W0
;rs485.c,32 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS485125
	GOTO	L_EnviarTramaRS4850
L__EnviarTramaRS485125:
;rs485.c,33 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,34 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOV	#58, W10
	CALL	_UART1_Write
;rs485.c,35 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W1, W10
; direccion end address is: 2 (W1)
	CALL	_UART1_Write
;rs485.c,36 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W2, W10
; funcion end address is: 4 (W2)
	CALL	_UART1_Write
;rs485.c,37 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	ZE	W3, W10
; subfuncion end address is: 6 (W3)
	CALL	_UART1_Write
;rs485.c,38 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W0, W10
	CALL	_UART1_Write
;rs485.c,39 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; numDatos end address is: 0 (W0)
; iDatos end address is: 2 (W1)
	MOV.B	W0, W2
L_EnviarTramaRS4851:
; iDatos start address is: 2 (W1)
; numDatos start address is: 4 (W2)
	CP.B	W1, W2
	BRA LTU	L__EnviarTramaRS485126
	GOTO	L_EnviarTramaRS4852
L__EnviarTramaRS485126:
;rs485.c,40 :: 		UART1_Write(payload[iDatos]);
	ZE	W1, W0
	ADD	W12, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,39 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC.B	W1
;rs485.c,41 :: 		}
; numDatos end address is: 4 (W2)
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaRS4851
L_EnviarTramaRS4852:
;rs485.c,42 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,43 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
;rs485.c,44 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLR	W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,45 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS4854:
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485127
	GOTO	L_EnviarTramaRS4855
L__EnviarTramaRS485127:
	GOTO	L_EnviarTramaRS4854
L_EnviarTramaRS4855:
;rs485.c,46 :: 		MSRS485 = 0;                                                           //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,47 :: 		}
L_EnviarTramaRS4850:
;rs485.c,49 :: 		}
L_end_EnviarTramaRS485:
	POP	W10
	RETURN
; end of _EnviarTramaRS485

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;SensorNivel.c,181 :: 		void main() {
;SensorNivel.c,184 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;SensorNivel.c,188 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,189 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;SensorNivel.c,190 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;SensorNivel.c,191 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;SensorNivel.c,192 :: 		distanciaEstimada = 0;
	CLR	W0
	MOV	W0, _distanciaEstimada
;SensorNivel.c,193 :: 		T2 = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,194 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,196 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,197 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,198 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,199 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,200 :: 		MSRS485 = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;SensorNivel.c,202 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,204 :: 		T2adj = 460.0;                                                             //Factor de calibracion de T2: Con Temp=20 y Vsnd=343.2, reduce la medida 1mm por cada 3 unidades que se aumente a este factor
	MOV	#0, W0
	MOV	#17382, W1
	MOV	W0, _T2adj
	MOV	W1, _T2adj+2
;SensorNivel.c,205 :: 		Kadj = 0;                                                                  //Fija la constante de ajuste en 0
	CLR	W0
	MOV	W0, _Kadj
;SensorNivel.c,206 :: 		Altura = 275;                                                              //Fija la altura de instalacion del sensor en 275mm
	MOV	#275, W0
	MOV	W0, _Altura
;SensorNivel.c,208 :: 		ip=0;
	MOV	#lo_addr(_ip), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,217 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;SensorNivel.c,225 :: 		void ConfiguracionPrincipal(){
;SensorNivel.c,228 :: 		CLKDIVbits.PLLPRE = 0;                                                     //PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,229 :: 		PLLFBD = 38;                                                               //PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
	MOV	#38, W0
	MOV	WREG, PLLFBD
;SensorNivel.c,230 :: 		CLKDIVbits.PLLPOST = 0;                                                    //PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,233 :: 		AD1PCFGL = 0xFFFD;                                                         //Configura el puerto AN1 como entrada analogica y todas las demas como digitales
	MOV	#65533, W0
	MOV	WREG, AD1PCFGL
;SensorNivel.c,234 :: 		TRISA1_bit = 1;                                                            //Establece el pin RA1 como entrada
	BSET	TRISA1_bit, BitPos(TRISA1_bit+0)
;SensorNivel.c,235 :: 		TRISB = 0xFF40;                                                            //TRISB = 11111111 01000000
	MOV	#65344, W0
	MOV	WREG, TRISB
;SensorNivel.c,236 :: 		MSRS485_Direction = 0;                                                     //MSRS485 out
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;SensorNivel.c,237 :: 		TEST_Direction = 0;                                                        //Test out
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;SensorNivel.c,239 :: 		AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
	BCLR	AD1CON1, #10
;SensorNivel.c,240 :: 		AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
	MOV	AD1CON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON1bits
;SensorNivel.c,241 :: 		AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea múltiples canales individualmente en secuencia
	BCLR	AD1CON1, #3
;SensorNivel.c,242 :: 		AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
	BCLR	AD1CON1, #13
;SensorNivel.c,243 :: 		AD1CON1.ASAM = 1;                                                          //Muestreo automatico
	BSET	AD1CON1, #2
;SensorNivel.c,244 :: 		AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#31, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,245 :: 		AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
	MOV	AD1CON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,246 :: 		AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
	MOV	AD1CON2bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,247 :: 		AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
	BCLR	AD1CON2, #10
;SensorNivel.c,248 :: 		AD1CON2.BUFM = 0;                                                          //Bit de selección del modo de relleno del búfer, 0 -> Siempre comienza a llenar el buffer desde el principio
	BCLR	AD1CON2, #1
;SensorNivel.c,249 :: 		AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la selección de entrada de canal para la muestra A
	BCLR	AD1CON2, #0
;SensorNivel.c,250 :: 		AD1CON3.ADRC = 0;                                                          //Selecciona el reloj de conversion del ADC derivado del reloj del sistema
	BCLR	AD1CON3, #15
;SensorNivel.c,251 :: 		AD1CON3bits.ADCS = 0x02;                                                   //Configura el periodo del reloj del ADC fijando el valor de los bits ADCS segun la formula: TAD = TCY*(ADCS+1) = 75ns  -> ADCS = 2
	MOV.B	#2, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#255, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CON3bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,252 :: 		AD1CON3bits.SAMC = 0x02;                                                   //Auto Sample Time bits, 2 -> 2*TAD (minimo periodo de muestreo para 10 bits)
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CON3bits
;SensorNivel.c,253 :: 		AD1CHS0.CH0NB = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #15
;SensorNivel.c,254 :: 		AD1CHS0bits.CH0SB = 0x01;                                                  //Channel 0 positive input is AN1
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CHS0bits
;SensorNivel.c,255 :: 		AD1CHS0.CH0NA = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #7
;SensorNivel.c,256 :: 		AD1CHS0bits.CH0SA = 0x01;                                                  //Channel 0 positive input is AN1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CHS0bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,257 :: 		AD1CHS123 = 0;                                                             //AD1CHS123: ADC1 INPUT CHANNEL 1, 2, 3 SELECT REGISTER
	CLR	AD1CHS123
;SensorNivel.c,258 :: 		AD1CSSL = 0x00;                                                            //Se salta todos los puertos ANx para los escaneos de entrada
	CLR	AD1CSSL
;SensorNivel.c,259 :: 		AD1CON1.ADON = 1;                                                          //Enciende el modulo ADC
	BSET	AD1CON1, #15
;SensorNivel.c,262 :: 		T1CON = 0x8000;                                                            //Habilita el TMR1, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T1CON
;SensorNivel.c,263 :: 		IEC0.T1IE = 1;                                                             //Habilita la interrupcion por desborde de TMR1
	BSET	IEC0, #3
;SensorNivel.c,264 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,265 :: 		PR1 = 200;                                                                 //Genera una interrupcion cada 5us (Fs=200KHz)
	MOV	#200, W0
	MOV	WREG, PR1
;SensorNivel.c,266 :: 		T1CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T1CON, #15
;SensorNivel.c,269 :: 		T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T2CON
;SensorNivel.c,270 :: 		IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
	BSET	IEC0, #7
;SensorNivel.c,271 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,272 :: 		PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
	MOV	#500, W0
	MOV	WREG, PR2
;SensorNivel.c,273 :: 		T2CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T2CON, #15
;SensorNivel.c,276 :: 		RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
	MOV.B	#6, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,277 :: 		RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR3bits
;SensorNivel.c,278 :: 		IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
	BSET	IEC0, #11
;SensorNivel.c,279 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,280 :: 		UART1_Init(19200);                                                          //Inicializa el modulo UART a 9600 bps
	MOV	#19200, W10
	MOV	#0, W11
	CALL	_UART1_Init
;SensorNivel.c,283 :: 		IPC0bits.T1IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#24576, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;SensorNivel.c,284 :: 		IPC1bits.T2IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
	MOV	IPC1bits, W1
	MOV	#28672, W0
	IOR	W1, W0, W0
	MOV	WREG, IPC1bits
;SensorNivel.c,285 :: 		IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;SensorNivel.c,287 :: 		Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#21, W8
	MOV	#22619, W7
L_ConfiguracionPrincipal6:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal6
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal6
;SensorNivel.c,289 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_ProcesarSolicitud:
	LNK	#6

;SensorNivel.c,292 :: 		void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){
;SensorNivel.c,302 :: 		ptrDatoInt = (unsigned short *) & datoInt;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #0, W0
; ptrDatoInt start address is: 12 (W6)
	MOV	W0, W6
;SensorNivel.c,303 :: 		ptrDatoFloat = (unsigned short *) & datoFloat;
	ADD	W14, #2, W0
; ptrDatoFloat start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,306 :: 		funcionRS485 = cabeceraSolicitud[1];
	ADD	W10, #1, W0
; funcionRS485 start address is: 2 (W1)
	MOV.B	[W0], W1
;SensorNivel.c,307 :: 		subFuncionRS485 = cabeceraSolicitud[2];
	ADD	W10, #2, W0
; subFuncionRS485 start address is: 0 (W0)
	MOV.B	[W0], W0
;SensorNivel.c,312 :: 		switch (funcionRS485){
	GOTO	L_ProcesarSolicitud8
; ptrDatoInt end address is: 12 (W6)
; ptrDatoFloat end address is: 4 (W2)
; funcionRS485 end address is: 2 (W1)
; subFuncionRS485 end address is: 0 (W0)
;SensorNivel.c,313 :: 		case 1:
L_ProcesarSolicitud10:
;SensorNivel.c,315 :: 		AproximarDistancia();                                                 //Realiza una secuencia de calculo de la distancia
	CALL	_AproximarDistancia
;SensorNivel.c,317 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,318 :: 		case 2:
L_ProcesarSolicitud11:
;SensorNivel.c,321 :: 		switch (subFuncionRS485){
; subFuncionRS485 start address is: 0 (W0)
; ptrDatoFloat start address is: 4 (W2)
; ptrDatoInt start address is: 12 (W6)
	GOTO	L_ProcesarSolicitud12
; ptrDatoFloat end address is: 4 (W2)
; subFuncionRS485 end address is: 0 (W0)
;SensorNivel.c,322 :: 		case 1:
L_ProcesarSolicitud14:
;SensorNivel.c,324 :: 		datoInt = distanciaEstimada;
	MOV	_distanciaEstimada, W0
	MOV	W0, [W14+0]
;SensorNivel.c,325 :: 		respuestaPyloadRS485[0] = *(ptrDatoInt);                    //Llena la trama del payload de respuesra con los valores asociados al puntero
	MOV.B	[W6], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,326 :: 		respuestaPyloadRS485[1] = *(ptrDatoInt+1);
	ADD	W6, #1, W0
; ptrDatoInt end address is: 12 (W6)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,327 :: 		cabeceraSolicitud[3] = 2;                                   //Actualiza el numero de datos de la cabecera
	ADD	W10, #3, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,328 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,329 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,330 :: 		case 2:
L_ProcesarSolicitud15:
;SensorNivel.c,332 :: 		datoInt= LeerDS18B20();
; ptrDatoInt start address is: 12 (W6)
	CALL	_LeerDS18B20
	MOV	W0, [W14+0]
;SensorNivel.c,333 :: 		respuestaPyloadRS485[0] = *(ptrDatoInt);
	MOV.B	[W6], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,334 :: 		respuestaPyloadRS485[1] = *(ptrDatoInt+1);
	ADD	W6, #1, W0
; ptrDatoInt end address is: 12 (W6)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,335 :: 		cabeceraSolicitud[3] = 2;
	ADD	W10, #3, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,336 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,337 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,338 :: 		case 3:
L_ProcesarSolicitud16:
;SensorNivel.c,340 :: 		datoInt = Altura;
; ptrDatoInt start address is: 12 (W6)
	MOV	_Altura, W0
	MOV	W0, [W14+0]
;SensorNivel.c,341 :: 		respuestaPyloadRS485[0] = *(ptrDatoInt);
	MOV.B	[W6], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,342 :: 		respuestaPyloadRS485[1] = *(ptrDatoInt+1);
	ADD	W6, #1, W0
; ptrDatoInt end address is: 12 (W6)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,343 :: 		cabeceraSolicitud[3] = 2;
	ADD	W10, #3, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,344 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,345 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,346 :: 		case 4:
L_ProcesarSolicitud17:
;SensorNivel.c,349 :: 		datoFloat = LeerTemperatura();
; ptrDatoFloat start address is: 4 (W2)
	PUSH	W2
	PUSH	W10
	CALL	_LeerTemperatura
	POP	W10
	POP	W2
	MOV	W0, [W14+2]
	MOV	W1, [W14+4]
;SensorNivel.c,350 :: 		respuestaPyloadRS485[0] = *(ptrDatoFloat);
	MOV.B	[W2], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,351 :: 		respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,352 :: 		respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+2), W0
	MOV.B	W1, [W0]
;SensorNivel.c,353 :: 		respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
	ADD	W2, #3, W0
; ptrDatoFloat end address is: 4 (W2)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+3), W0
	MOV.B	W1, [W0]
;SensorNivel.c,354 :: 		cabeceraSolicitud[3] = 4;
	ADD	W10, #3, W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;SensorNivel.c,355 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,356 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,357 :: 		case 5:
L_ProcesarSolicitud18:
;SensorNivel.c,360 :: 		respuestaPyloadRS485[0] = datoShort;
	MOV	#lo_addr(_respuestaPyloadRS485), W1
	MOV	#lo_addr(_Kadj), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,361 :: 		cabeceraSolicitud[3] = 1;
	ADD	W10, #3, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,362 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,363 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,364 :: 		}
L_ProcesarSolicitud12:
; subFuncionRS485 start address is: 0 (W0)
; ptrDatoFloat start address is: 4 (W2)
; ptrDatoInt start address is: 12 (W6)
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitud132
	GOTO	L_ProcesarSolicitud14
L__ProcesarSolicitud132:
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud133
	GOTO	L_ProcesarSolicitud15
L__ProcesarSolicitud133:
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud134
	GOTO	L_ProcesarSolicitud16
L__ProcesarSolicitud134:
; ptrDatoInt end address is: 12 (W6)
	CP.B	W0, #4
	BRA NZ	L__ProcesarSolicitud135
	GOTO	L_ProcesarSolicitud17
L__ProcesarSolicitud135:
; ptrDatoFloat end address is: 4 (W2)
	CP.B	W0, #5
	BRA NZ	L__ProcesarSolicitud136
	GOTO	L_ProcesarSolicitud18
L__ProcesarSolicitud136:
; subFuncionRS485 end address is: 0 (W0)
L_ProcesarSolicitud13:
;SensorNivel.c,365 :: 		case 3:
L_ProcesarSolicitud19:
;SensorNivel.c,368 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,369 :: 		case 4:
L_ProcesarSolicitud20:
;SensorNivel.c,371 :: 		cabeceraSolicitud[3] = 10;
	ADD	W10, #3, W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;SensorNivel.c,372 :: 		EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
	MOV	#lo_addr(_tramaPruebaRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,373 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,374 :: 		}
L_ProcesarSolicitud8:
; subFuncionRS485 start address is: 0 (W0)
; funcionRS485 start address is: 2 (W1)
; ptrDatoFloat start address is: 4 (W2)
; ptrDatoInt start address is: 12 (W6)
	CP.B	W1, #1
	BRA NZ	L__ProcesarSolicitud137
	GOTO	L_ProcesarSolicitud10
L__ProcesarSolicitud137:
	CP.B	W1, #2
	BRA NZ	L__ProcesarSolicitud138
	GOTO	L_ProcesarSolicitud11
L__ProcesarSolicitud138:
; ptrDatoInt end address is: 12 (W6)
; ptrDatoFloat end address is: 4 (W2)
; subFuncionRS485 end address is: 0 (W0)
	CP.B	W1, #3
	BRA NZ	L__ProcesarSolicitud139
	GOTO	L_ProcesarSolicitud19
L__ProcesarSolicitud139:
	CP.B	W1, #4
	BRA NZ	L__ProcesarSolicitud140
	GOTO	L_ProcesarSolicitud20
L__ProcesarSolicitud140:
; funcionRS485 end address is: 2 (W1)
L_ProcesarSolicitud9:
;SensorNivel.c,377 :: 		}
L_end_ProcesarSolicitud:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _ProcesarSolicitud

_LeerDS18B20:

;SensorNivel.c,381 :: 		int LeerDS18B20(){
;SensorNivel.c,385 :: 		TEST = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,388 :: 		Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,389 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,390 :: 		Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
	MOV.B	#68, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,391 :: 		Delay_ms(750);
	MOV	#153, W8
	MOV	#38577, W7
L_LeerDS18B2021:
	DEC	W7
	BRA NZ	L_LeerDS18B2021
	DEC	W8
	BRA NZ	L_LeerDS18B2021
	NOP
	NOP
;SensorNivel.c,392 :: 		Ow_Reset(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,393 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,394 :: 		Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
	MOV.B	#190, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,395 :: 		Delay_us(100);
	MOV	#1333, W7
L_LeerDS18B2023:
	DEC	W7
	BRA NZ	L_LeerDS18B2023
	NOP
;SensorNivel.c,396 :: 		temp = Ow_Read(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
; temp start address is: 10 (W5)
	ZE	W0, W5
;SensorNivel.c,397 :: 		temp = (Ow_Read(&PORTA, 0) << 8) + temp;
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
	ZE	W0, W0
	SL	W0, #8, W0
	ADD	W0, W5, W0
; temp end address is: 10 (W5)
;SensorNivel.c,399 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,403 :: 		return temperaturaCrudo;
;SensorNivel.c,405 :: 		}
;SensorNivel.c,403 :: 		return temperaturaCrudo;
;SensorNivel.c,405 :: 		}
L_end_LeerDS18B20:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _LeerDS18B20

_LeerTemperatura:
	LNK	#4

;SensorNivel.c,409 :: 		float LeerTemperatura(){
;SensorNivel.c,415 :: 		Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,416 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,417 :: 		Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
	MOV.B	#68, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,418 :: 		Delay_us(120);
	MOV	#1600, W7
L_LeerTemperatura25:
	DEC	W7
	BRA NZ	L_LeerTemperatura25
;SensorNivel.c,419 :: 		Ow_Reset(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,420 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,421 :: 		Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
	MOV.B	#190, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,422 :: 		Delay_ms(400);
	MOV	#82, W8
	MOV	#24943, W7
L_LeerTemperatura27:
	DEC	W7
	BRA NZ	L_LeerTemperatura27
	DEC	W8
	BRA NZ	L_LeerTemperatura27
	NOP
;SensorNivel.c,423 :: 		temperaturaCrudo = Ow_Read(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
; temperaturaCrudo start address is: 10 (W5)
	ZE	W0, W5
;SensorNivel.c,424 :: 		temperaturaCrudo = (Ow_Read(&PORTA, 0) << 8) + temperaturaCrudo;
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
	ZE	W0, W0
	SL	W0, #8, W0
	ADD	W0, W5, W1
; temperaturaCrudo end address is: 10 (W5)
;SensorNivel.c,428 :: 		temperaturaInt = temperaturaCrudo >> 4;
	LSR	W1, #4, W0
; temperaturaInt start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,430 :: 		temperaturaDec = ((temperaturaCrudo & 0x000F) * 625)/10000.0;
	AND	W1, #15, W1
	MOV	#625, W0
	MUL.UU	W1, W0, W0
	PUSH	W2
	CLR	W1
	CALL	__Long2Float
	MOV	#16384, W2
	MOV	#17948, W3
	CALL	__Div_FP
	POP	W2
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;SensorNivel.c,432 :: 		temperaturaResultado = temperaturaInt + temperaturaDec;                    //Expresa la temperatura en punto flotante
	MOV	W2, W0
	CLR	W1
	CALL	__Long2Float
; temperaturaInt end address is: 4 (W2)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
;SensorNivel.c,434 :: 		return  temperaturaResultado;
;SensorNivel.c,436 :: 		}
;SensorNivel.c,434 :: 		return  temperaturaResultado;
;SensorNivel.c,436 :: 		}
L_end_LeerTemperatura:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _LeerTemperatura

_CalcularVelocidadSonido:

;SensorNivel.c,440 :: 		float CalcularVelocidadSonido(){
;SensorNivel.c,443 :: 		temperatura_Float = LeerTemperatura();
	PUSH	W10
	PUSH	W11
	CALL	_LeerTemperatura
;SensorNivel.c,444 :: 		vSonido = 331.45 * sqrt(1+(temperatura_Float/273));
	MOV	#32768, W2
	MOV	#17288, W3
	CALL	__Div_FP
	MOV	#0, W2
	MOV	#16256, W3
	CALL	__AddSub_FP
	MOV.D	W0, W10
	CALL	_sqrt
	MOV	#47514, W2
	MOV	#17317, W3
	CALL	__Mul_FP
;SensorNivel.c,445 :: 		return vSonido;
;SensorNivel.c,447 :: 		}
;SensorNivel.c,445 :: 		return vSonido;
;SensorNivel.c,447 :: 		}
L_end_CalcularVelocidadSonido:
	POP	W11
	POP	W10
	RETURN
; end of _CalcularVelocidadSonido

_GenerarPulso:
	LNK	#12

;SensorNivel.c,451 :: 		void GenerarPulso(){
;SensorNivel.c,453 :: 		TEST = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,456 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,457 :: 		contp = 0;                                                                 //Limpia la variable del contador de pulsos
	CLR	W0
	MOV	W0, _contp
;SensorNivel.c,458 :: 		RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,459 :: 		T1CON.TON = 0;                                                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,460 :: 		TMR2 = 0;                                                                  //Encera el TMR2
	CLR	TMR2
;SensorNivel.c,461 :: 		T2CON.TON = 1;                                                             //Enciende el TMR2
	BSET	T2CON, #15
;SensorNivel.c,462 :: 		i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la señal muestreada
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,463 :: 		while(bm!=1);                                                              //Espera hasta que haya terminado de enviar y recibir todas las muestras
L_GenerarPulso29:
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__GenerarPulso145
	GOTO	L_GenerarPulso30
L__GenerarPulso145:
	GOTO	L_GenerarPulso29
L_GenerarPulso30:
;SensorNivel.c,466 :: 		if (bm==1){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__GenerarPulso146
	GOTO	L_GenerarPulso31
L__GenerarPulso146:
;SensorNivel.c,472 :: 		Mmed = 508;                                                           //Medido con el osciloscopio: Vmean = 1.64V => 508.4adc
	MOV	#508, W0
	MOV	W0, _Mmed
;SensorNivel.c,475 :: 		for (k=0;k<nm;k++){
	CLR	W0
	MOV	W0, _k
L_GenerarPulso32:
	MOV	_k, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__GenerarPulso147
	GOTO	L_GenerarPulso33
L__GenerarPulso147:
;SensorNivel.c,478 :: 		value = M[k]-Mmed;
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W3
	MOV	[W3], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_value), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,479 :: 		if (M[k]<Mmed){
	MOV	[W3], W1
	MOV	#lo_addr(_Mmed), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso148
	GOTO	L_GenerarPulso35
L__GenerarPulso148:
;SensorNivel.c,480 :: 		value = (M[k]+((Mmed-M[k])*2))-(Mmed);
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W1
	MOV	_Mmed, W0
	SUB	W0, [W1], W0
	SL	W0, #1, W0
	ADD	W0, [W1], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_value), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,481 :: 		}
L_GenerarPulso35:
;SensorNivel.c,485 :: 		for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];
	MOV	#20, W0
	MOV	W0, _f
L_GenerarPulso36:
	MOV	_f, W0
	CP	W0, #0
	BRA NZ	L__GenerarPulso149
	GOTO	L_GenerarPulso37
L__GenerarPulso149:
	MOV	_f, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_XFIR), W0
	ADD	W0, W1, W2
	MOV	_f, W0
	DEC	W0
	SL	W0, #2, W1
	MOV	#lo_addr(_XFIR), W0
	ADD	W0, W1, W0
	MOV	[W0++], [W2++]
	MOV	[W0--], [W2--]
	MOV	#1, W1
	MOV	#lo_addr(_f), W0
	SUBR	W1, [W0], [W0]
	GOTO	L_GenerarPulso36
L_GenerarPulso37:
;SensorNivel.c,487 :: 		XFIR[0] = (float)(value);
	MOV	_value, W0
	CLR	W1
	CALL	__Long2Float
	MOV	W0, _XFIR
	MOV	W1, _XFIR+2
;SensorNivel.c,489 :: 		y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];
	CLR	W0
	CLR	W1
	MOV	W0, _y0
	MOV	W1, _y0+2
	CLR	W0
	MOV	W0, _f
L_GenerarPulso39:
	MOV	_f, W0
	CP	W0, #21
	BRA LTU	L__GenerarPulso150
	GOTO	L_GenerarPulso40
L__GenerarPulso150:
	MOV	_f, W0
	SL	W0, #2, W2
	MOV	#lo_addr(_h), W0
	ADD	W0, W2, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV	[W1++], W3
	MOV	[W1--], W4
	MOV	#lo_addr(_XFIR), W0
	ADD	W0, W2, W2
	MOV.D	[W2], W0
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Mul_FP
	MOV	_y0, W2
	MOV	_y0+2, W3
	CALL	__AddSub_FP
	MOV	W0, _y0
	MOV	W1, _y0+2
	MOV	#1, W1
	MOV	#lo_addr(_f), W0
	ADD	W1, [W0], [W0]
	GOTO	L_GenerarPulso39
L_GenerarPulso40:
;SensorNivel.c,491 :: 		YY = (unsigned int)(y0);                                          //Reconstrucción de la señal: y en 10 bits.
	MOV	_y0, W0
	MOV	_y0+2, W1
	CALL	__Float2Longint
	MOV	W0, _YY
;SensorNivel.c,492 :: 		M[k] = YY;
	MOV	_k, W1
	SL	W1, #1, W2
	MOV	#lo_addr(_M), W1
	ADD	W1, W2, W1
	MOV	W0, [W1]
;SensorNivel.c,475 :: 		for (k=0;k<nm;k++){
	MOV	#1, W1
	MOV	#lo_addr(_k), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,494 :: 		}
	GOTO	L_GenerarPulso32
L_GenerarPulso33:
;SensorNivel.c,496 :: 		bm = 2;                                                               //Cambia el estado de la bandera bm para dar paso al cálculo del pmax y TOF
	MOV	#lo_addr(_bm), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,498 :: 		}
L_GenerarPulso31:
;SensorNivel.c,501 :: 		if (bm==2){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__GenerarPulso151
	GOTO	L_GenerarPulso42
L__GenerarPulso151:
;SensorNivel.c,503 :: 		yy1 = Vector_Max(M, nm, &maxIndex);                                    //Encuentra el valor maximo del vector R
	MOV	#lo_addr(_maxIndex), W0
	PUSH	W0
	MOV	#350, W0
	PUSH	W0
	MOV	#lo_addr(_M), W0
	PUSH	W0
	CALL	_Vector_Max
	SUB	#6, W15
	MOV	W0, _yy1
;SensorNivel.c,504 :: 		i1b = maxIndex;                                                        //Asigna el subindice del valor maximo a la variable i1a
	MOV	_maxIndex, W0
	MOV	W0, _i1b
;SensorNivel.c,505 :: 		i1a = 0;
	CLR	W0
	MOV	W0, _i1a
;SensorNivel.c,507 :: 		while (M[i1a]<yy1){
L_GenerarPulso43:
	MOV	_i1a, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W0
	MOV	[W0], W1
	MOV	#lo_addr(_yy1), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso152
	GOTO	L_GenerarPulso44
L__GenerarPulso152:
;SensorNivel.c,508 :: 		i1a++;
	MOV	#1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,509 :: 		}
	GOTO	L_GenerarPulso43
L_GenerarPulso44:
;SensorNivel.c,511 :: 		i1 = i1a+((i1b-i1a)/2);
	MOV	_i1b, W1
	MOV	#lo_addr(_i1a), W0
	SUB	W1, [W0], W0
	LSR	W0, #1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], W1
	MOV	W1, _i1
;SensorNivel.c,512 :: 		i0 = i1 - dix;
	SUB	W1, #20, W0
	MOV	W0, _i0
;SensorNivel.c,513 :: 		i2 = i1 + dix;
	ADD	W1, #20, W3
	MOV	W3, _i2
;SensorNivel.c,515 :: 		yy0 = M[i0];
	SL	W0, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W0
	MOV	[W0], W2
	MOV	W2, _yy0
;SensorNivel.c,516 :: 		yy2 = M[i2];
	SL	W3, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W0
	MOV	[W0], W0
	MOV	W0, [W14+0]
	MOV	W0, _yy2
;SensorNivel.c,518 :: 		yf0 = (float)(yy0);
	MOV	W2, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
	MOV	W0, _yf0
	MOV	W1, _yf0+2
;SensorNivel.c,519 :: 		yf1 = (float)(yy1);
	MOV	_yy1, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	W0, _yf1
	MOV	W1, _yf1+2
;SensorNivel.c,520 :: 		yf2 = (float)(yy2);
	MOV	[W14+0], W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	PUSH.D	W0
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	MOV	W0, _yf2
	MOV	W1, _yf2+2
	POP.D	W0
;SensorNivel.c,522 :: 		nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));                              //Factor de ajuste determinado por interpolacion parabolica
	MOV	[W14+8], W0
	MOV	[W14+10], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Sub_FP
	POP.D	W2
	MOV	[W14+4], W2
	MOV	[W14+6], W3
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	#0, W0
	MOV	#16384, W1
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	_yf0, W0
	MOV	_yf0+2, W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Sub_FP
	POP.D	W2
	MOV	_yf2, W2
	MOV	_yf2+2, W3
	CALL	__AddSub_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Div_FP
	POP.D	W2
	MOV	W0, _nx
	MOV	W1, _nx+2
;SensorNivel.c,523 :: 		dx = nx*dix*tx;
	MOV	#0, W2
	MOV	#16800, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _dx
	MOV	W1, _dx+2
;SensorNivel.c,524 :: 		tmax = i1*tx;
	MOV	_i1, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _tmax
	MOV	W1, _tmax+2
;SensorNivel.c,526 :: 		T2 = tmax+dx;
	MOV	_dx, W2
	MOV	_dx+2, W3
	CALL	__AddSub_FP
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,528 :: 		}
L_GenerarPulso42:
;SensorNivel.c,530 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,532 :: 		}
L_end_GenerarPulso:
	ULNK
	RETURN
; end of _GenerarPulso

_CalcularModa:

;SensorNivel.c,534 :: 		int CalcularModa(int VRpt[nd]){
;SensorNivel.c,536 :: 		ME1=0;
	CLR	W0
	MOV	W0, _ME1
;SensorNivel.c,537 :: 		ME2=0;
	CLR	W0
	MOV	W0, _ME2
;SensorNivel.c,538 :: 		ME3=0;
	CLR	W0
	MOV	W0, _ME3
;SensorNivel.c,539 :: 		Mb2=0;
	MOV	#lo_addr(_Mb2), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,540 :: 		Mb3=0;
	MOV	#lo_addr(_Mb3), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,541 :: 		Mc1=0;
	MOV	#lo_addr(_Mc1), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,542 :: 		Mc2=0;
	MOV	#lo_addr(_Mc2), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,543 :: 		Mc3=0;
	MOV	#lo_addr(_Mc3), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,545 :: 		ME1=VRpt[0];
	MOV	[W10], W0
	MOV	W0, _ME1
;SensorNivel.c,547 :: 		for (mi=0;mi<nd;mi++){
	MOV	#lo_addr(_mi), W1
	CLR	W0
	MOV.B	W0, [W1]
L_CalcularModa45:
	MOV	#lo_addr(_mi), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L__CalcularModa154
	GOTO	L_CalcularModa46
L__CalcularModa154:
;SensorNivel.c,548 :: 		if (VRpt[mi]==ME1){
	MOV	#lo_addr(_mi), W0
	ZE	[W0], W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W1
	MOV	#lo_addr(_ME1), W0
	CP	W1, [W0]
	BRA Z	L__CalcularModa155
	GOTO	L_CalcularModa48
L__CalcularModa155:
;SensorNivel.c,549 :: 		Mc1++;
	MOV.B	#1, W1
	MOV	#lo_addr(_Mc1), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,550 :: 		}else{
	GOTO	L_CalcularModa49
L_CalcularModa48:
;SensorNivel.c,551 :: 		if (Mb2==0){
	MOV	#lo_addr(_Mb2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__CalcularModa156
	GOTO	L_CalcularModa50
L__CalcularModa156:
;SensorNivel.c,552 :: 		ME2=VRpt[mi];
	MOV	#lo_addr(_mi), W0
	ZE	[W0], W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	MOV	W0, _ME2
;SensorNivel.c,553 :: 		Mb2=1;
	MOV	#lo_addr(_Mb2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,554 :: 		}
L_CalcularModa50:
;SensorNivel.c,555 :: 		if (VRpt[mi]==ME2){
	MOV	#lo_addr(_mi), W0
	ZE	[W0], W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W1
	MOV	#lo_addr(_ME2), W0
	CP	W1, [W0]
	BRA Z	L__CalcularModa157
	GOTO	L_CalcularModa51
L__CalcularModa157:
;SensorNivel.c,556 :: 		Mc2++;
	MOV.B	#1, W1
	MOV	#lo_addr(_Mc2), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,557 :: 		}else{
	GOTO	L_CalcularModa52
L_CalcularModa51:
;SensorNivel.c,558 :: 		if (Mb3==0){
	MOV	#lo_addr(_Mb3), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__CalcularModa158
	GOTO	L_CalcularModa53
L__CalcularModa158:
;SensorNivel.c,559 :: 		ME3=VRpt[mi];
	MOV	#lo_addr(_mi), W0
	ZE	[W0], W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	MOV	W0, _ME3
;SensorNivel.c,560 :: 		Mb3=1;
	MOV	#lo_addr(_Mb3), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,561 :: 		}
L_CalcularModa53:
;SensorNivel.c,562 :: 		if (VRpt[mi]==ME3){
	MOV	#lo_addr(_mi), W0
	ZE	[W0], W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W1
	MOV	#lo_addr(_ME3), W0
	CP	W1, [W0]
	BRA Z	L__CalcularModa159
	GOTO	L_CalcularModa54
L__CalcularModa159:
;SensorNivel.c,563 :: 		Mc3++;
	MOV.B	#1, W1
	MOV	#lo_addr(_Mc3), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,564 :: 		}
L_CalcularModa54:
;SensorNivel.c,565 :: 		}
L_CalcularModa52:
;SensorNivel.c,566 :: 		}
L_CalcularModa49:
;SensorNivel.c,547 :: 		for (mi=0;mi<nd;mi++){
	MOV.B	#1, W1
	MOV	#lo_addr(_mi), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,568 :: 		}
	GOTO	L_CalcularModa45
L_CalcularModa46:
;SensorNivel.c,570 :: 		if ((Mc1>Mc2)&&(Mc1>Mc3)){
	MOV	#lo_addr(_Mc1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc2), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa160
	GOTO	L__CalcularModa106
L__CalcularModa160:
	MOV	#lo_addr(_Mc1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc3), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa161
	GOTO	L__CalcularModa105
L__CalcularModa161:
L__CalcularModa104:
;SensorNivel.c,571 :: 		return ME1;
	MOV	_ME1, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,570 :: 		if ((Mc1>Mc2)&&(Mc1>Mc3)){
L__CalcularModa106:
L__CalcularModa105:
;SensorNivel.c,573 :: 		if ((Mc2>Mc1)&&(Mc2>Mc3)){
	MOV	#lo_addr(_Mc2), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc1), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa162
	GOTO	L__CalcularModa108
L__CalcularModa162:
	MOV	#lo_addr(_Mc2), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc3), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa163
	GOTO	L__CalcularModa107
L__CalcularModa163:
L__CalcularModa103:
;SensorNivel.c,574 :: 		return ME2;
	MOV	_ME2, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,573 :: 		if ((Mc2>Mc1)&&(Mc2>Mc3)){
L__CalcularModa108:
L__CalcularModa107:
;SensorNivel.c,576 :: 		if ((Mc3>Mc1)&&(Mc3>Mc2)){
	MOV	#lo_addr(_Mc3), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc1), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa164
	GOTO	L__CalcularModa110
L__CalcularModa164:
	MOV	#lo_addr(_Mc3), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc2), W0
	CP.B	W1, [W0]
	BRA GTU	L__CalcularModa165
	GOTO	L__CalcularModa109
L__CalcularModa165:
L__CalcularModa102:
;SensorNivel.c,577 :: 		return ME3;
	MOV	_ME3, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,576 :: 		if ((Mc3>Mc1)&&(Mc3>Mc2)){
L__CalcularModa110:
L__CalcularModa109:
;SensorNivel.c,579 :: 		if (Mc1==Mc2){
	MOV	#lo_addr(_Mc1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc2), W0
	CP.B	W1, [W0]
	BRA Z	L__CalcularModa166
	GOTO	L_CalcularModa64
L__CalcularModa166:
;SensorNivel.c,580 :: 		return ME1;
	MOV	_ME1, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,581 :: 		}
L_CalcularModa64:
;SensorNivel.c,582 :: 		if (Mc1==Mc3){
	MOV	#lo_addr(_Mc1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc3), W0
	CP.B	W1, [W0]
	BRA Z	L__CalcularModa167
	GOTO	L_CalcularModa65
L__CalcularModa167:
;SensorNivel.c,583 :: 		return ME1;
	MOV	_ME1, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,584 :: 		}
L_CalcularModa65:
;SensorNivel.c,585 :: 		if (Mc2==Mc3){
	MOV	#lo_addr(_Mc2), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_Mc3), W0
	CP.B	W1, [W0]
	BRA Z	L__CalcularModa168
	GOTO	L_CalcularModa66
L__CalcularModa168:
;SensorNivel.c,586 :: 		return ME2;
	MOV	_ME2, W0
	GOTO	L_end_CalcularModa
;SensorNivel.c,587 :: 		}
L_CalcularModa66:
;SensorNivel.c,589 :: 		}
L_end_CalcularModa:
	RETURN
; end of _CalcularModa

_CalcularDistancia:

;SensorNivel.c,593 :: 		int CalcularDistancia(){
;SensorNivel.c,595 :: 		conts = 0;                                                                 //Limpia el contador de secuencias
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_conts), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,596 :: 		T2sum = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,597 :: 		T2prom = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,598 :: 		T2a = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,599 :: 		T2b = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,601 :: 		while (conts<Nsm){
L_CalcularDistancia67:
	MOV	#lo_addr(_conts), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA LT	L__CalcularDistancia170
	GOTO	L_CalcularDistancia68
L__CalcularDistancia170:
;SensorNivel.c,602 :: 		GenerarPulso();                                                      //Inicia una secuencia de medicion
	CALL	_GenerarPulso
;SensorNivel.c,603 :: 		T2b = T2;
	MOV	_T2, W0
	MOV	_T2+2, W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,604 :: 		if ((T2b-T2a)<=T2umb){                                               //Verifica si el T2 actual esta dentro de un umbral pre-establecido
	MOV	_T2, W0
	MOV	_T2+2, W1
	MOV	_T2a, W2
	MOV	_T2a+2, W3
	CALL	__Sub_FP
	MOV	#0, W2
	MOV	#16448, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L__CalcularDistancia171
	INC.B	W0
L__CalcularDistancia171:
	CP0.B	W0
	BRA NZ	L__CalcularDistancia172
	GOTO	L_CalcularDistancia69
L__CalcularDistancia172:
;SensorNivel.c,605 :: 		T2sum = T2sum + T2b;                                              //Acumula la sumatoria de valores de T2 calculados por la funcion GenerarPulso()
	MOV	_T2sum, W2
	MOV	_T2sum+2, W3
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	CALL	__AddSub_FP
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,606 :: 		conts++;                                                          //Aumenta el contador de secuencias
	MOV.B	#1, W1
	MOV	#lo_addr(_conts), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,607 :: 		}
L_CalcularDistancia69:
;SensorNivel.c,608 :: 		T2a = T2b;
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,609 :: 		}
	GOTO	L_CalcularDistancia67
L_CalcularDistancia68:
;SensorNivel.c,611 :: 		T2prom = T2sum/Nsm;
	MOV	#0, W2
	MOV	#16448, W3
	MOV	_T2sum, W0
	MOV	_T2sum+2, W1
	CALL	__Div_FP
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,614 :: 		vSonido = CalcularVelocidadSonido();
	CALL	_CalcularVelocidadSonido
	MOV	W0, _vSonido
	MOV	W1, _vSonido+2
;SensorNivel.c,616 :: 		TOF = (T1+T2prom-T2adj)/1.0e6;                                             //TOF = TO + T1 + Tp - k (pag82)
	MOV	#57344, W2
	MOV	#17579, W3
	MOV	_T2prom, W0
	MOV	_T2prom+2, W1
	CALL	__AddSub_FP
	MOV	_T2adj, W2
	MOV	_T2adj+2, W3
	CALL	__Sub_FP
	MOV	#9216, W2
	MOV	#18804, W3
	CALL	__Div_FP
	MOV	W0, _TOF
	MOV	W1, _TOF+2
;SensorNivel.c,618 :: 		Dst = (vSonido*TOF/2.0) * 1000.0;
	MOV	_vSonido, W2
	MOV	_vSonido+2, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Div_FP
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Mul_FP
	MOV	W0, _Dst
	MOV	W1, _Dst+2
;SensorNivel.c,619 :: 		doub = modf(Dst, &iptr);                                                   //Ejemplo: doub = modf(6.25, &iptr) => doub = 0.25, iptr = 6.00
	MOV	#lo_addr(_iptr), W12
	MOV.D	W0, W10
	CALL	_modf
	MOV	W0, _doub
	MOV	W1, _doub+2
;SensorNivel.c,620 :: 		if (doub>=0.5){
	MOV	#0, W2
	MOV	#16128, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LT	L__CalcularDistancia173
	INC.B	W0
L__CalcularDistancia173:
	CP0.B	W0
	BRA NZ	L__CalcularDistancia174
	GOTO	L_CalcularDistancia70
L__CalcularDistancia174:
;SensorNivel.c,621 :: 		Dst=ceil(Dst);                                                          //Redondea al inmediato superior
	MOV	_Dst, W10
	MOV	_Dst+2, W11
	CALL	_ceil
	MOV	W0, _Dst
	MOV	W1, _Dst+2
;SensorNivel.c,622 :: 		}else{
	GOTO	L_CalcularDistancia71
L_CalcularDistancia70:
;SensorNivel.c,623 :: 		Dst=floor(Dst);                                                         //Redondea al inmediato inferior
	MOV	_Dst, W10
	MOV	_Dst+2, W11
	CALL	_floor
	MOV	W0, _Dst
	MOV	W1, _Dst+2
;SensorNivel.c,624 :: 		}
L_CalcularDistancia71:
;SensorNivel.c,626 :: 		return Dst;
	MOV	_Dst, W0
	MOV	_Dst+2, W1
	CALL	__Float2Longint
;SensorNivel.c,628 :: 		}
;SensorNivel.c,626 :: 		return Dst;
;SensorNivel.c,628 :: 		}
L_end_CalcularDistancia:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _CalcularDistancia

_AproximarDistancia:
	LNK	#2

;SensorNivel.c,631 :: 		void AproximarDistancia(){
;SensorNivel.c,635 :: 		for (vi=0;vi<nd;vi++){
	PUSH	W10
	MOV	#lo_addr(_vi), W1
	CLR	W0
	MOV.B	W0, [W1]
L_AproximarDistancia72:
	MOV	#lo_addr(_vi), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L__AproximarDistancia176
	GOTO	L_AproximarDistancia73
L__AproximarDistancia176:
;SensorNivel.c,636 :: 		Vdistancia[vi] = CalcularDistancia();                                  //Toma 10 lecturas de la distancia calculada y las almacena en un vector
	MOV	#lo_addr(_vi), W0
	ZE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_Vdistancia), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	CALL	_CalcularDistancia
	MOV	[W14+0], W1
	MOV	W0, [W1]
;SensorNivel.c,635 :: 		for (vi=0;vi<nd;vi++){
	MOV.B	#1, W1
	MOV	#lo_addr(_vi), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,637 :: 		}
	GOTO	L_AproximarDistancia72
L_AproximarDistancia73:
;SensorNivel.c,639 :: 		distanciaEstimada = CalcularModa(Vdistancia);                              //Calcula la Moda del vector de distancias
	MOV	#lo_addr(_Vdistancia), W10
	CALL	_CalcularModa
	MOV	W0, _distanciaEstimada
;SensorNivel.c,640 :: 		distanciaEstimada = distanciaEstimada + Kadj;                              //Ajusta el valor de la Distancia calculada segun el factor de calibracion Kadj
	MOV	#lo_addr(_Kadj), W2
	MOV	#lo_addr(_distanciaEstimada), W1
	ADD	W0, [W2], [W1]
;SensorNivel.c,644 :: 		}
L_end_AproximarDistancia:
	POP	W10
	ULNK
	RETURN
; end of _AproximarDistancia

_Timer1Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;SensorNivel.c,651 :: 		void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
;SensorNivel.c,652 :: 		SAMP_bit = 0;                                 //Limpia el bit SAMP para iniciar la conversion del ADC
	BCLR	SAMP_bit, BitPos(SAMP_bit+0)
;SensorNivel.c,653 :: 		while (!AD1CON1bits.DONE);                    //Espera hasta que se complete la conversion
L_Timer1Interrupt75:
	BTSC	AD1CON1bits, #0
	GOTO	L_Timer1Interrupt76
	GOTO	L_Timer1Interrupt75
L_Timer1Interrupt76:
;SensorNivel.c,654 :: 		if (i<nm){
	MOV	_i, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__Timer1Interrupt178
	GOTO	L_Timer1Interrupt77
L__Timer1Interrupt178:
;SensorNivel.c,655 :: 		M[i] = ADC1BUF0;                           //Almacena el valor actual de la conversion del ADC en el vector M
	MOV	_i, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_M), W0
	ADD	W0, W1, W1
	MOV	ADC1BUF0, WREG
	MOV	W0, [W1]
;SensorNivel.c,656 :: 		i++;                                       //Aumenta en 1 el subindice del vector de Muestras
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,657 :: 		} else {
	GOTO	L_Timer1Interrupt78
L_Timer1Interrupt77:
;SensorNivel.c,658 :: 		bm = 1;                                    //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la señal
	MOV	#lo_addr(_bm), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,659 :: 		T1CON.TON = 0;                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,660 :: 		}
L_Timer1Interrupt78:
;SensorNivel.c,661 :: 		T1IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,662 :: 		}
L_end_Timer1Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer1Interrupt

_Timer2Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;SensorNivel.c,665 :: 		void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{
;SensorNivel.c,667 :: 		if (contp<10){                                //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
	MOV	_contp, W0
	CP	W0, #10
	BRA LTU	L__Timer2Interrupt180
	GOTO	L_Timer2Interrupt79
L__Timer2Interrupt180:
;SensorNivel.c,668 :: 		RB2_bit = ~RB2_bit;                      //Conmuta el valor del pin RB14
	BTG	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,669 :: 		}else {
	GOTO	L_Timer2Interrupt80
L_Timer2Interrupt79:
;SensorNivel.c,670 :: 		RB2_bit = 0;                             //Pone a cero despues de enviar todos los pulsos de exitacion.
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,671 :: 		if (contp==110){
	MOV	#110, W1
	MOV	#lo_addr(_contp), W0
	CP	W1, [W0]
	BRA Z	L__Timer2Interrupt181
	GOTO	L_Timer2Interrupt81
L__Timer2Interrupt181:
;SensorNivel.c,672 :: 		T2CON.TON = 0;                       //Apaga el TMR2
	BCLR	T2CON, #15
;SensorNivel.c,673 :: 		TMR1 = 0;                            //Encera el TMR1
	CLR	TMR1
;SensorNivel.c,674 :: 		T1CON.TON = 1;                       //Enciende el TMR1
	BSET	T1CON, #15
;SensorNivel.c,676 :: 		}
L_Timer2Interrupt81:
;SensorNivel.c,677 :: 		}
L_Timer2Interrupt80:
;SensorNivel.c,678 :: 		contp++;                                      //Aumenta el contador en una unidad.
	MOV	#1, W1
	MOV	#lo_addr(_contp), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,679 :: 		T2IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,685 :: 		}
L_end_Timer2Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer2Interrupt

_UART1Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;SensorNivel.c,688 :: 		void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {
;SensorNivel.c,690 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	PUSH	W10
	PUSH	W11
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,691 :: 		byteRS485 = UART1_Read();                                                  //Lee el byte recibido
	CALL	_UART1_Read
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	W0, [W1]
;SensorNivel.c,694 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__UART1Interrupt183
	GOTO	L_UART1Interrupt82
L__UART1Interrupt183:
;SensorNivel.c,696 :: 		if (i_rs485<(solicitudCabeceraRS485[3])){
	MOV	#lo_addr(_solicitudCabeceraRS485+3), W0
	ZE	[W0], W1
	MOV	#lo_addr(_i_rs485), W0
	CP	W1, [W0]
	BRA GTU	L__UART1Interrupt184
	GOTO	L_UART1Interrupt83
L__UART1Interrupt184:
;SensorNivel.c,697 :: 		solicitudPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_solicitudPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,698 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,699 :: 		} else {
	GOTO	L_UART1Interrupt84
L_UART1Interrupt83:
;SensorNivel.c,700 :: 		banRSI = 0;                                                      //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,701 :: 		banRSC = 1;                                                      //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,702 :: 		}
L_UART1Interrupt84:
;SensorNivel.c,703 :: 		}
L_UART1Interrupt82:
;SensorNivel.c,706 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt185
	GOTO	L__UART1Interrupt116
L__UART1Interrupt185:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt186
	GOTO	L__UART1Interrupt115
L__UART1Interrupt186:
L__UART1Interrupt114:
;SensorNivel.c,707 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__UART1Interrupt187
	GOTO	L_UART1Interrupt88
L__UART1Interrupt187:
;SensorNivel.c,708 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,709 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,711 :: 		}
L_UART1Interrupt88:
;SensorNivel.c,706 :: 		if ((banRSI==0)&&(banRSC==0)){
L__UART1Interrupt116:
L__UART1Interrupt115:
;SensorNivel.c,713 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt188
	GOTO	L__UART1Interrupt119
L__UART1Interrupt188:
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt189
	GOTO	L__UART1Interrupt118
L__UART1Interrupt189:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA LTU	L__UART1Interrupt190
	GOTO	L__UART1Interrupt117
L__UART1Interrupt190:
L__UART1Interrupt113:
;SensorNivel.c,714 :: 		solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_solicitudCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,715 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,713 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
L__UART1Interrupt119:
L__UART1Interrupt118:
L__UART1Interrupt117:
;SensorNivel.c,717 :: 		if ((banRSI==1)&&(i_rs485==4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt191
	GOTO	L__UART1Interrupt123
L__UART1Interrupt191:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA Z	L__UART1Interrupt192
	GOTO	L__UART1Interrupt122
L__UART1Interrupt192:
L__UART1Interrupt112:
;SensorNivel.c,719 :: 		if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__UART1Interrupt193
	GOTO	L__UART1Interrupt121
L__UART1Interrupt193:
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt194
	GOTO	L__UART1Interrupt120
L__UART1Interrupt194:
	GOTO	L_UART1Interrupt97
L__UART1Interrupt121:
L__UART1Interrupt120:
;SensorNivel.c,720 :: 		i_rs485 = 0;                                                     //Encera el subindice para almacenar el payload
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,721 :: 		banRSI = 2;                                                      //Cambia el valor de la bandera para salir del bucle
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,722 :: 		} else {
	GOTO	L_UART1Interrupt98
L_UART1Interrupt97:
;SensorNivel.c,723 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,724 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,725 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,726 :: 		}
L_UART1Interrupt98:
;SensorNivel.c,717 :: 		if ((banRSI==1)&&(i_rs485==4)){
L__UART1Interrupt123:
L__UART1Interrupt122:
;SensorNivel.c,730 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt195
	GOTO	L_UART1Interrupt99
L__UART1Interrupt195:
;SensorNivel.c,731 :: 		Delay_ms(100);                                                        //**Ojo: Este retardo es importante para que el Concentrador tenga tiempo de recibir la respuesta
	MOV	#21, W8
	MOV	#22619, W7
L_UART1Interrupt100:
	DEC	W7
	BRA NZ	L_UART1Interrupt100
	DEC	W8
	BRA NZ	L_UART1Interrupt100
;SensorNivel.c,733 :: 		ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
	MOV	#lo_addr(_solicitudPyloadRS485), W11
	MOV	#lo_addr(_solicitudCabeceraRS485), W10
	CALL	_ProcesarSolicitud
;SensorNivel.c,735 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,736 :: 		}
L_UART1Interrupt99:
;SensorNivel.c,737 :: 		}
L_end_UART1Interrupt:
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _UART1Interrupt
