
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
	BRA Z	L__EnviarTramaRS48586
	GOTO	L_EnviarTramaRS4850
L__EnviarTramaRS48586:
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
	BRA LTU	L__EnviarTramaRS48587
	GOTO	L_EnviarTramaRS4852
L__EnviarTramaRS48587:
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
	BRA Z	L__EnviarTramaRS48588
	GOTO	L_EnviarTramaRS4855
L__EnviarTramaRS48588:
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

;SensorNivel.c,142 :: 		void main() {
;SensorNivel.c,145 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;SensorNivel.c,149 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,150 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;SensorNivel.c,151 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;SensorNivel.c,152 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;SensorNivel.c,154 :: 		T2 = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,155 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,157 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,158 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,159 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,160 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,161 :: 		MSRS485 = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;SensorNivel.c,163 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,166 :: 		ip=0;
	MOV	#lo_addr(_ip), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,175 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;SensorNivel.c,183 :: 		void ConfiguracionPrincipal(){
;SensorNivel.c,186 :: 		CLKDIVbits.PLLPRE = 0;                                                     //PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,187 :: 		PLLFBD = 38;                                                               //PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
	MOV	#38, W0
	MOV	WREG, PLLFBD
;SensorNivel.c,188 :: 		CLKDIVbits.PLLPOST = 0;                                                    //PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,191 :: 		AD1PCFGL = 0xFFFD;                                                         //Configura el puerto AN1 como entrada analogica y todas las demas como digitales
	MOV	#65533, W0
	MOV	WREG, AD1PCFGL
;SensorNivel.c,192 :: 		TRISA1_bit = 1;                                                            //Establece el pin RA1 como entrada
	BSET	TRISA1_bit, BitPos(TRISA1_bit+0)
;SensorNivel.c,193 :: 		TRISB = 0xFF40;                                                            //TRISB = 11111111 01000000
	MOV	#65344, W0
	MOV	WREG, TRISB
;SensorNivel.c,194 :: 		MSRS485_Direction = 0;                                                     //MSRS485 out
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;SensorNivel.c,195 :: 		TEST_Direction = 0;                                                        //Test out
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;SensorNivel.c,197 :: 		AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
	BCLR	AD1CON1, #10
;SensorNivel.c,198 :: 		AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
	MOV	AD1CON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON1bits
;SensorNivel.c,199 :: 		AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea múltiples canales individualmente en secuencia
	BCLR	AD1CON1, #3
;SensorNivel.c,200 :: 		AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
	BCLR	AD1CON1, #13
;SensorNivel.c,201 :: 		AD1CON1.ASAM = 1;                                                          //Muestreo automatico
	BSET	AD1CON1, #2
;SensorNivel.c,202 :: 		AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#31, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,203 :: 		AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
	MOV	AD1CON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,204 :: 		AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
	MOV	AD1CON2bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,205 :: 		AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
	BCLR	AD1CON2, #10
;SensorNivel.c,206 :: 		AD1CON2.BUFM = 0;                                                          //Bit de selección del modo de relleno del búfer, 0 -> Siempre comienza a llenar el buffer desde el principio
	BCLR	AD1CON2, #1
;SensorNivel.c,207 :: 		AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la selección de entrada de canal para la muestra A
	BCLR	AD1CON2, #0
;SensorNivel.c,208 :: 		AD1CON3.ADRC = 0;                                                          //Selecciona el reloj de conversion del ADC derivado del reloj del sistema
	BCLR	AD1CON3, #15
;SensorNivel.c,209 :: 		AD1CON3bits.ADCS = 0x02;                                                   //Configura el periodo del reloj del ADC fijando el valor de los bits ADCS segun la formula: TAD = TCY*(ADCS+1) = 75ns  -> ADCS = 2
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
;SensorNivel.c,210 :: 		AD1CON3bits.SAMC = 0x02;                                                   //Auto Sample Time bits, 2 -> 2*TAD (minimo periodo de muestreo para 10 bits)
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CON3bits
;SensorNivel.c,211 :: 		AD1CHS0.CH0NB = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #15
;SensorNivel.c,212 :: 		AD1CHS0bits.CH0SB = 0x01;                                                  //Channel 0 positive input is AN1
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CHS0bits
;SensorNivel.c,213 :: 		AD1CHS0.CH0NA = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #7
;SensorNivel.c,214 :: 		AD1CHS0bits.CH0SA = 0x01;                                                  //Channel 0 positive input is AN1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CHS0bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,215 :: 		AD1CHS123 = 0;                                                             //AD1CHS123: ADC1 INPUT CHANNEL 1, 2, 3 SELECT REGISTER
	CLR	AD1CHS123
;SensorNivel.c,216 :: 		AD1CSSL = 0x00;                                                            //Se salta todos los puertos ANx para los escaneos de entrada
	CLR	AD1CSSL
;SensorNivel.c,217 :: 		AD1CON1.ADON = 1;                                                          //Enciende el modulo ADC
	BSET	AD1CON1, #15
;SensorNivel.c,220 :: 		T1CON = 0x8000;                                                            //Habilita el TMR1, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T1CON
;SensorNivel.c,221 :: 		IEC0.T1IE = 1;                                                             //Habilita la interrupcion por desborde de TMR1
	BSET	IEC0, #3
;SensorNivel.c,222 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,223 :: 		PR1 = 200;                                                                 //Genera una interrupcion cada 5us (Fs=200KHz)
	MOV	#200, W0
	MOV	WREG, PR1
;SensorNivel.c,224 :: 		T1CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T1CON, #15
;SensorNivel.c,227 :: 		T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T2CON
;SensorNivel.c,228 :: 		IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
	BSET	IEC0, #7
;SensorNivel.c,229 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,230 :: 		PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
	MOV	#500, W0
	MOV	WREG, PR2
;SensorNivel.c,231 :: 		T2CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T2CON, #15
;SensorNivel.c,234 :: 		RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
	MOV.B	#6, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,235 :: 		RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR3bits
;SensorNivel.c,236 :: 		IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
	BSET	IEC0, #11
;SensorNivel.c,237 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,238 :: 		UART1_Init(19200);                                                          //Inicializa el modulo UART a 9600 bps
	MOV	#19200, W10
	MOV	#0, W11
	CALL	_UART1_Init
;SensorNivel.c,241 :: 		IPC0bits.T1IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#24576, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;SensorNivel.c,242 :: 		IPC1bits.T2IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
	MOV	IPC1bits, W1
	MOV	#28672, W0
	IOR	W1, W0, W0
	MOV	WREG, IPC1bits
;SensorNivel.c,243 :: 		IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;SensorNivel.c,245 :: 		Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#21, W8
	MOV	#22619, W7
L_ConfiguracionPrincipal6:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal6
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal6
;SensorNivel.c,247 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_ProcesarSolicitud:
	LNK	#6

;SensorNivel.c,250 :: 		void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){
;SensorNivel.c,260 :: 		ptrDatoInt = (unsigned short *) & datoInt;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #0, W0
; ptrDatoInt start address is: 8 (W4)
	MOV	W0, W4
;SensorNivel.c,264 :: 		funcionRS485 = cabeceraSolicitud[1];
	ADD	W10, #1, W0
; funcionRS485 start address is: 2 (W1)
	MOV.B	[W0], W1
;SensorNivel.c,265 :: 		subFuncionRS485 = cabeceraSolicitud[2];
	ADD	W10, #2, W0
; subFuncionRS485 start address is: 0 (W0)
	MOV.B	[W0], W0
;SensorNivel.c,270 :: 		switch (funcionRS485){
	GOTO	L_ProcesarSolicitud8
; ptrDatoInt end address is: 8 (W4)
; funcionRS485 end address is: 2 (W1)
; subFuncionRS485 end address is: 0 (W0)
;SensorNivel.c,271 :: 		case 1:
L_ProcesarSolicitud10:
;SensorNivel.c,273 :: 		CalcularT2();
	CALL	_CalcularT2
;SensorNivel.c,274 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,275 :: 		case 2:
L_ProcesarSolicitud11:
;SensorNivel.c,278 :: 		switch (subFuncionRS485){
; subFuncionRS485 start address is: 0 (W0)
; ptrDatoInt start address is: 8 (W4)
	GOTO	L_ProcesarSolicitud12
; subFuncionRS485 end address is: 0 (W0)
;SensorNivel.c,279 :: 		case 1:
L_ProcesarSolicitud14:
;SensorNivel.c,282 :: 		respuestaPyloadRS485[0] = *(ptrDatoInt);                    //Llena la trama del payload de respuesra con los valores asociados al puntero
	MOV.B	[W4], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,283 :: 		respuestaPyloadRS485[1] = *(ptrDatoInt+1);
	ADD	W4, #1, W0
; ptrDatoInt end address is: 8 (W4)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,284 :: 		cabeceraSolicitud[3] = 2;                                   //Actualiza el numero de datos de la cabecera
	ADD	W10, #3, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,285 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,286 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,287 :: 		case 2:
L_ProcesarSolicitud15:
;SensorNivel.c,290 :: 		respuestaPyloadRS485[0] = *(ptrDatoInt);
; ptrDatoInt start address is: 8 (W4)
	MOV.B	[W4], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,291 :: 		respuestaPyloadRS485[1] = *(ptrDatoInt+1);
	ADD	W4, #1, W0
; ptrDatoInt end address is: 8 (W4)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,292 :: 		cabeceraSolicitud[3] = 2;
	ADD	W10, #3, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,293 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,294 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,295 :: 		case 3:
L_ProcesarSolicitud16:
;SensorNivel.c,298 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,299 :: 		case 4:
L_ProcesarSolicitud17:
;SensorNivel.c,302 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,303 :: 		}
L_ProcesarSolicitud12:
; subFuncionRS485 start address is: 0 (W0)
; ptrDatoInt start address is: 8 (W4)
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitud93
	GOTO	L_ProcesarSolicitud14
L__ProcesarSolicitud93:
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud94
	GOTO	L_ProcesarSolicitud15
L__ProcesarSolicitud94:
; ptrDatoInt end address is: 8 (W4)
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud95
	GOTO	L_ProcesarSolicitud16
L__ProcesarSolicitud95:
	CP.B	W0, #4
	BRA NZ	L__ProcesarSolicitud96
	GOTO	L_ProcesarSolicitud17
L__ProcesarSolicitud96:
; subFuncionRS485 end address is: 0 (W0)
L_ProcesarSolicitud13:
;SensorNivel.c,304 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,305 :: 		case 4:
L_ProcesarSolicitud18:
;SensorNivel.c,307 :: 		cabeceraSolicitud[3] = 10;
	ADD	W10, #3, W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;SensorNivel.c,308 :: 		EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
	MOV	#lo_addr(_tramaPruebaRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,309 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,310 :: 		}
L_ProcesarSolicitud8:
; subFuncionRS485 start address is: 0 (W0)
; funcionRS485 start address is: 2 (W1)
; ptrDatoInt start address is: 8 (W4)
	CP.B	W1, #1
	BRA NZ	L__ProcesarSolicitud97
	GOTO	L_ProcesarSolicitud10
L__ProcesarSolicitud97:
	CP.B	W1, #2
	BRA NZ	L__ProcesarSolicitud98
	GOTO	L_ProcesarSolicitud11
L__ProcesarSolicitud98:
; ptrDatoInt end address is: 8 (W4)
; subFuncionRS485 end address is: 0 (W0)
	CP.B	W1, #4
	BRA NZ	L__ProcesarSolicitud99
	GOTO	L_ProcesarSolicitud18
L__ProcesarSolicitud99:
; funcionRS485 end address is: 2 (W1)
L_ProcesarSolicitud9:
;SensorNivel.c,313 :: 		}
L_end_ProcesarSolicitud:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _ProcesarSolicitud

_LeerDS18B20:

;SensorNivel.c,317 :: 		int LeerDS18B20(){
;SensorNivel.c,321 :: 		TEST = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,324 :: 		Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,325 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,326 :: 		Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
	MOV.B	#68, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,327 :: 		Delay_ms(750);
	MOV	#153, W8
	MOV	#38577, W7
L_LeerDS18B2019:
	DEC	W7
	BRA NZ	L_LeerDS18B2019
	DEC	W8
	BRA NZ	L_LeerDS18B2019
	NOP
	NOP
;SensorNivel.c,328 :: 		Ow_Reset(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,329 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,330 :: 		Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
	MOV.B	#190, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,331 :: 		Delay_us(100);
	MOV	#1333, W7
L_LeerDS18B2021:
	DEC	W7
	BRA NZ	L_LeerDS18B2021
	NOP
;SensorNivel.c,332 :: 		temp = Ow_Read(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
; temp start address is: 10 (W5)
	ZE	W0, W5
;SensorNivel.c,333 :: 		temp = (Ow_Read(&PORTA, 0) << 8) + temp;
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
	ZE	W0, W0
	SL	W0, #8, W0
	ADD	W0, W5, W0
; temp end address is: 10 (W5)
;SensorNivel.c,335 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,339 :: 		return temperaturaCrudo;
;SensorNivel.c,341 :: 		}
;SensorNivel.c,339 :: 		return temperaturaCrudo;
;SensorNivel.c,341 :: 		}
L_end_LeerDS18B20:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _LeerDS18B20

_GenerarPulso:
	LNK	#12

;SensorNivel.c,345 :: 		void GenerarPulso(){
;SensorNivel.c,347 :: 		TEST = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,350 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,351 :: 		contPulsos = 0;                                                                 //Limpia la variable del contador de pulsos
	CLR	W0
	MOV	W0, _contPulsos
;SensorNivel.c,352 :: 		RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,353 :: 		T1CON.TON = 0;                                                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,354 :: 		TMR2 = 0;                                                                  //Encera el TMR2
	CLR	TMR2
;SensorNivel.c,355 :: 		T2CON.TON = 1;                                                             //Enciende el TMR2
	BSET	T2CON, #15
;SensorNivel.c,356 :: 		i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la señal muestreada
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,357 :: 		while(bm!=1);                                                              //Espera hasta que haya terminado de enviar y recibir todas las muestras
L_GenerarPulso23:
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__GenerarPulso102
	GOTO	L_GenerarPulso24
L__GenerarPulso102:
	GOTO	L_GenerarPulso23
L_GenerarPulso24:
;SensorNivel.c,360 :: 		if (bm==1){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__GenerarPulso103
	GOTO	L_GenerarPulso25
L__GenerarPulso103:
;SensorNivel.c,363 :: 		Mmed = 508;                                                           //Medido con el osciloscopio: Vmean = 1.64V => 508.4adc
	MOV	#508, W0
	MOV	W0, _Mmed
;SensorNivel.c,365 :: 		for (k=0;k<numeroMuestras;k++){
	CLR	W0
	MOV	W0, _k
L_GenerarPulso26:
	MOV	_k, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__GenerarPulso104
	GOTO	L_GenerarPulso27
L__GenerarPulso104:
;SensorNivel.c,368 :: 		valorAbsoluto = vectorMuestreo[k]-Mmed;
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestreo), W0
	ADD	W0, W1, W3
	MOV	[W3], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_valorAbsoluto), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,369 :: 		if (vectorMuestreo[k]<Mmed){
	MOV	[W3], W1
	MOV	#lo_addr(_Mmed), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso105
	GOTO	L_GenerarPulso29
L__GenerarPulso105:
;SensorNivel.c,370 :: 		valorAbsoluto = (vectorMuestreo[k]+((Mmed-vectorMuestreo[k])*2))-(Mmed);
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestreo), W0
	ADD	W0, W1, W1
	MOV	_Mmed, W0
	SUB	W0, [W1], W0
	SL	W0, #1, W0
	ADD	W0, [W1], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_valorAbsoluto), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,371 :: 		}
L_GenerarPulso29:
;SensorNivel.c,375 :: 		for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];
	MOV	#20, W0
	MOV	W0, _f
L_GenerarPulso30:
	MOV	_f, W0
	CP	W0, #0
	BRA NZ	L__GenerarPulso106
	GOTO	L_GenerarPulso31
L__GenerarPulso106:
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
	GOTO	L_GenerarPulso30
L_GenerarPulso31:
;SensorNivel.c,377 :: 		XFIR[0] = (float)(valorAbsoluto);
	MOV	_valorAbsoluto, W0
	CLR	W1
	CALL	__Long2Float
	MOV	W0, _XFIR
	MOV	W1, _XFIR+2
;SensorNivel.c,379 :: 		y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];
	CLR	W0
	CLR	W1
	MOV	W0, _y0
	MOV	W1, _y0+2
	CLR	W0
	MOV	W0, _f
L_GenerarPulso33:
	MOV	_f, W0
	CP	W0, #21
	BRA LTU	L__GenerarPulso107
	GOTO	L_GenerarPulso34
L__GenerarPulso107:
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
	GOTO	L_GenerarPulso33
L_GenerarPulso34:
;SensorNivel.c,381 :: 		YY = (unsigned int)(y0);                                          //Reconstrucción de la señal: y en 10 bits.
	MOV	_y0, W0
	MOV	_y0+2, W1
	CALL	__Float2Longint
	MOV	W0, _YY
;SensorNivel.c,382 :: 		vectorEnvolvente[k] = YY;
	MOV	_k, W1
	SL	W1, #1, W2
	MOV	#lo_addr(_vectorEnvolvente), W1
	ADD	W1, W2, W1
	MOV	W0, [W1]
;SensorNivel.c,365 :: 		for (k=0;k<numeroMuestras;k++){
	MOV	#1, W1
	MOV	#lo_addr(_k), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,384 :: 		}
	GOTO	L_GenerarPulso26
L_GenerarPulso27:
;SensorNivel.c,386 :: 		bm = 2;                                                               //Cambia el estado de la bandera bm para dar paso al cálculo del pmax y TOF
	MOV	#lo_addr(_bm), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,388 :: 		}
L_GenerarPulso25:
;SensorNivel.c,391 :: 		if (bm==2){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__GenerarPulso108
	GOTO	L_GenerarPulso36
L__GenerarPulso108:
;SensorNivel.c,393 :: 		yy1 = Vector_Max(vectorEnvolvente, numeroMuestras, &maxIndex);                                    //Encuentra el valor maximo del vector R
	MOV	#lo_addr(_maxIndex), W0
	PUSH	W0
	MOV	#350, W0
	PUSH	W0
	MOV	#lo_addr(_vectorEnvolvente), W0
	PUSH	W0
	CALL	_Vector_Max
	SUB	#6, W15
	MOV	W0, _yy1
;SensorNivel.c,394 :: 		i1b = maxIndex;                                                        //Asigna el subindice del valor maximo a la variable i1a
	MOV	_maxIndex, W0
	MOV	W0, _i1b
;SensorNivel.c,395 :: 		i1a = 0;
	CLR	W0
	MOV	W0, _i1a
;SensorNivel.c,397 :: 		while (vectorEnvolvente[i1a]<yy1){
L_GenerarPulso37:
	MOV	_i1a, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorEnvolvente), W0
	ADD	W0, W1, W0
	MOV	[W0], W1
	MOV	#lo_addr(_yy1), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso109
	GOTO	L_GenerarPulso38
L__GenerarPulso109:
;SensorNivel.c,398 :: 		i1a++;
	MOV	#1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,399 :: 		}
	GOTO	L_GenerarPulso37
L_GenerarPulso38:
;SensorNivel.c,401 :: 		i1 = i1a+((i1b-i1a)/2);
	MOV	_i1b, W1
	MOV	#lo_addr(_i1a), W0
	SUB	W1, [W0], W0
	LSR	W0, #1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], W1
	MOV	W1, _i1
;SensorNivel.c,402 :: 		i0 = i1 - dix;
	SUB	W1, #20, W0
	MOV	W0, _i0
;SensorNivel.c,403 :: 		i2 = i1 + dix;
	ADD	W1, #20, W3
	MOV	W3, _i2
;SensorNivel.c,405 :: 		yy0 = vectorEnvolvente[i0];
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorEnvolvente), W0
	ADD	W0, W1, W0
	MOV	[W0], W2
	MOV	W2, _yy0
;SensorNivel.c,406 :: 		yy2 = vectorEnvolvente[i2];
	SL	W3, #1, W1
	MOV	#lo_addr(_vectorEnvolvente), W0
	ADD	W0, W1, W0
	MOV	[W0], W0
	MOV	W0, [W14+0]
	MOV	W0, _yy2
;SensorNivel.c,408 :: 		yf0 = (float)(yy0);
	MOV	W2, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
	MOV	W0, _yf0
	MOV	W1, _yf0+2
;SensorNivel.c,409 :: 		yf1 = (float)(yy1);
	MOV	_yy1, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	W0, _yf1
	MOV	W1, _yf1+2
;SensorNivel.c,410 :: 		yf2 = (float)(yy2);
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
;SensorNivel.c,412 :: 		nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));                              //Factor de ajuste determinado por interpolacion parabolica
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
;SensorNivel.c,413 :: 		dx = nx*dix*tx;
	MOV	#0, W2
	MOV	#16800, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _dx
	MOV	W1, _dx+2
;SensorNivel.c,414 :: 		tmax = i1*tx;
	MOV	_i1, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _tmax
	MOV	W1, _tmax+2
;SensorNivel.c,416 :: 		T2 = tmax+dx;
	MOV	_dx, W2
	MOV	_dx+2, W3
	CALL	__AddSub_FP
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,418 :: 		}
L_GenerarPulso36:
;SensorNivel.c,420 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,422 :: 		}
L_end_GenerarPulso:
	ULNK
	RETURN
; end of _GenerarPulso

_CalcularT2:

;SensorNivel.c,426 :: 		float CalcularT2(){
;SensorNivel.c,428 :: 		conts = 0;                                                                 //Limpia el contador de secuencias
	MOV	#lo_addr(_conts), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,429 :: 		T2sum = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,430 :: 		T2prom = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,431 :: 		T2a = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,432 :: 		T2b = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,434 :: 		while (conts<Nsm){
L_CalcularT239:
	MOV	#lo_addr(_conts), W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA LT	L__CalcularT2111
	GOTO	L_CalcularT240
L__CalcularT2111:
;SensorNivel.c,435 :: 		GenerarPulso();                                                      //Inicia una secuencia de medicion
	CALL	_GenerarPulso
;SensorNivel.c,436 :: 		T2b = T2;
	MOV	_T2, W0
	MOV	_T2+2, W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,437 :: 		if ((T2b-T2a)<=T2umb){                                               //Verifica si el T2 actual esta dentro de un umbral pre-establecido
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
	BRA GT	L__CalcularT2112
	INC.B	W0
L__CalcularT2112:
	CP0.B	W0
	BRA NZ	L__CalcularT2113
	GOTO	L_CalcularT241
L__CalcularT2113:
;SensorNivel.c,438 :: 		T2sum = T2sum + T2b;                                              //Acumula la sumatoria de valores de T2 calculados por la funcion GenerarPulso()
	MOV	_T2sum, W2
	MOV	_T2sum+2, W3
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	CALL	__AddSub_FP
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,439 :: 		conts++;                                                          //Aumenta el contador de secuencias
	MOV.B	#1, W1
	MOV	#lo_addr(_conts), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,440 :: 		}
L_CalcularT241:
;SensorNivel.c,441 :: 		T2a = T2b;
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,442 :: 		}
	GOTO	L_CalcularT239
L_CalcularT240:
;SensorNivel.c,444 :: 		T2prom = T2sum/Nsm;
	MOV	#0, W2
	MOV	#16880, W3
	MOV	_T2sum, W0
	MOV	_T2sum+2, W1
	CALL	__Div_FP
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,446 :: 		return T2prom;
;SensorNivel.c,448 :: 		}
L_end_CalcularT2:
	RETURN
; end of _CalcularT2

_EnviarTramaInt:
	LNK	#702

;SensorNivel.c,452 :: 		void EnviarTramaInt(unsigned char* cabecera, unsigned char* tramaInt){
;SensorNivel.c,459 :: 		ptrValorInt = (unsigned short *) & valorInt;
	PUSH	W12
	MOV	#700, W0
	ADD	W14, W0, W0
; ptrValorInt start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,462 :: 		for (j=0;j<numeroMuestras;j++){
	CLR	W0
	MOV	W0, _j
L_EnviarTramaInt42:
; ptrValorInt start address is: 4 (W2)
; ptrValorInt end address is: 4 (W2)
	MOV	_j, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaInt115
	GOTO	L_EnviarTramaInt43
L__EnviarTramaInt115:
; ptrValorInt end address is: 4 (W2)
;SensorNivel.c,463 :: 		valorInt = tramaInt[j];
; ptrValorInt start address is: 4 (W2)
	MOV	#lo_addr(_j), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, [W14+700]
;SensorNivel.c,464 :: 		tramaShort[j*2] = *(ptrValorInt);
	MOV	_j, W0
	SL	W0, #1, W0
	ADD	W14, #0, W1
	ADD	W1, W0, W0
	MOV.B	[W2], [W0]
;SensorNivel.c,465 :: 		tramaShort[(j*2)+1] = *(ptrValorInt+1);
	MOV	_j, W0
	SL	W0, #1, W0
	INC	W0
	ADD	W1, W0, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;SensorNivel.c,462 :: 		for (j=0;j<numeroMuestras;j++){
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,466 :: 		}
; ptrValorInt end address is: 4 (W2)
	GOTO	L_EnviarTramaInt42
L_EnviarTramaInt43:
;SensorNivel.c,470 :: 		EnviarTramaRS485(1, cabecera, tramaShort);
	ADD	W14, #0, W0
	PUSH.D	W10
	MOV	W0, W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
	POP.D	W10
;SensorNivel.c,472 :: 		}
L_end_EnviarTramaInt:
	POP	W12
	ULNK
	RETURN
; end of _EnviarTramaInt

_Timer1Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;SensorNivel.c,480 :: 		void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
;SensorNivel.c,481 :: 		SAMP_bit = 0;                                 //Limpia el bit SAMP para iniciar la conversion del ADC
	BCLR	SAMP_bit, BitPos(SAMP_bit+0)
;SensorNivel.c,482 :: 		while (!AD1CON1bits.DONE);                    //Espera hasta que se complete la conversion
L_Timer1Interrupt45:
	BTSC	AD1CON1bits, #0
	GOTO	L_Timer1Interrupt46
	GOTO	L_Timer1Interrupt45
L_Timer1Interrupt46:
;SensorNivel.c,483 :: 		if (i<numeroMuestras){
	MOV	_i, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__Timer1Interrupt117
	GOTO	L_Timer1Interrupt47
L__Timer1Interrupt117:
;SensorNivel.c,484 :: 		vectorMuestreo[i] = ADC1BUF0;                           //Almacena el valor actual de la conversion del ADC en el vector M
	MOV	_i, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestreo), W0
	ADD	W0, W1, W1
	MOV	ADC1BUF0, WREG
	MOV	W0, [W1]
;SensorNivel.c,485 :: 		i++;                                       //Aumenta en 1 el subindice del vector de Muestras
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,486 :: 		} else {
	GOTO	L_Timer1Interrupt48
L_Timer1Interrupt47:
;SensorNivel.c,487 :: 		bm = 1;                                    //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la señal
	MOV	#lo_addr(_bm), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,488 :: 		T1CON.TON = 0;                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,489 :: 		}
L_Timer1Interrupt48:
;SensorNivel.c,490 :: 		T1IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,491 :: 		}
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

;SensorNivel.c,494 :: 		void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{
;SensorNivel.c,496 :: 		if (contPulsos<10){                                //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
	MOV	_contPulsos, W0
	CP	W0, #10
	BRA LTU	L__Timer2Interrupt119
	GOTO	L_Timer2Interrupt49
L__Timer2Interrupt119:
;SensorNivel.c,497 :: 		RB2_bit = ~RB2_bit;                      //Conmuta el valor del pin RB14
	BTG	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,498 :: 		}else {
	GOTO	L_Timer2Interrupt50
L_Timer2Interrupt49:
;SensorNivel.c,499 :: 		RB2_bit = 0;                             //Pone a cero despues de enviar todos los pulsos de exitacion.
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,500 :: 		if (contPulsos==110){
	MOV	#110, W1
	MOV	#lo_addr(_contPulsos), W0
	CP	W1, [W0]
	BRA Z	L__Timer2Interrupt120
	GOTO	L_Timer2Interrupt51
L__Timer2Interrupt120:
;SensorNivel.c,501 :: 		T2CON.TON = 0;                       //Apaga el TMR2
	BCLR	T2CON, #15
;SensorNivel.c,502 :: 		TMR1 = 0;                            //Encera el TMR1
	CLR	TMR1
;SensorNivel.c,503 :: 		T1CON.TON = 1;                       //Enciende el TMR1
	BSET	T1CON, #15
;SensorNivel.c,505 :: 		}
L_Timer2Interrupt51:
;SensorNivel.c,506 :: 		}
L_Timer2Interrupt50:
;SensorNivel.c,507 :: 		contPulsos++;                                      //Aumenta el contador en una unidad.
	MOV	#1, W1
	MOV	#lo_addr(_contPulsos), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,508 :: 		T2IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,514 :: 		}
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

;SensorNivel.c,517 :: 		void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {
;SensorNivel.c,519 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	PUSH	W10
	PUSH	W11
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,520 :: 		byteRS485 = UART1_Read();                                                  //Lee el byte recibido
	CALL	_UART1_Read
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	W0, [W1]
;SensorNivel.c,523 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__UART1Interrupt122
	GOTO	L_UART1Interrupt52
L__UART1Interrupt122:
;SensorNivel.c,525 :: 		if (i_rs485<(solicitudCabeceraRS485[3])){
	MOV	#lo_addr(_solicitudCabeceraRS485+3), W0
	ZE	[W0], W1
	MOV	#lo_addr(_i_rs485), W0
	CP	W1, [W0]
	BRA GTU	L__UART1Interrupt123
	GOTO	L_UART1Interrupt53
L__UART1Interrupt123:
;SensorNivel.c,526 :: 		solicitudPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_solicitudPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,527 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,528 :: 		} else {
	GOTO	L_UART1Interrupt54
L_UART1Interrupt53:
;SensorNivel.c,529 :: 		banRSI = 0;                                                      //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,530 :: 		banRSC = 1;                                                      //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,531 :: 		}
L_UART1Interrupt54:
;SensorNivel.c,532 :: 		}
L_UART1Interrupt52:
;SensorNivel.c,535 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt124
	GOTO	L__UART1Interrupt77
L__UART1Interrupt124:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt125
	GOTO	L__UART1Interrupt76
L__UART1Interrupt125:
L__UART1Interrupt75:
;SensorNivel.c,536 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__UART1Interrupt126
	GOTO	L_UART1Interrupt58
L__UART1Interrupt126:
;SensorNivel.c,537 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,538 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,540 :: 		}
L_UART1Interrupt58:
;SensorNivel.c,535 :: 		if ((banRSI==0)&&(banRSC==0)){
L__UART1Interrupt77:
L__UART1Interrupt76:
;SensorNivel.c,542 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt127
	GOTO	L__UART1Interrupt80
L__UART1Interrupt127:
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt128
	GOTO	L__UART1Interrupt79
L__UART1Interrupt128:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA LTU	L__UART1Interrupt129
	GOTO	L__UART1Interrupt78
L__UART1Interrupt129:
L__UART1Interrupt74:
;SensorNivel.c,543 :: 		solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_solicitudCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,544 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,542 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
L__UART1Interrupt80:
L__UART1Interrupt79:
L__UART1Interrupt78:
;SensorNivel.c,546 :: 		if ((banRSI==1)&&(i_rs485==4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt130
	GOTO	L__UART1Interrupt84
L__UART1Interrupt130:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA Z	L__UART1Interrupt131
	GOTO	L__UART1Interrupt83
L__UART1Interrupt131:
L__UART1Interrupt73:
;SensorNivel.c,548 :: 		if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__UART1Interrupt132
	GOTO	L__UART1Interrupt82
L__UART1Interrupt132:
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt133
	GOTO	L__UART1Interrupt81
L__UART1Interrupt133:
	GOTO	L_UART1Interrupt67
L__UART1Interrupt82:
L__UART1Interrupt81:
;SensorNivel.c,549 :: 		i_rs485 = 0;                                                     //Encera el subindice para almacenar el payload
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,550 :: 		banRSI = 2;                                                      //Cambia el valor de la bandera para salir del bucle
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,551 :: 		} else {
	GOTO	L_UART1Interrupt68
L_UART1Interrupt67:
;SensorNivel.c,552 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,553 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,554 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,555 :: 		}
L_UART1Interrupt68:
;SensorNivel.c,546 :: 		if ((banRSI==1)&&(i_rs485==4)){
L__UART1Interrupt84:
L__UART1Interrupt83:
;SensorNivel.c,559 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt134
	GOTO	L_UART1Interrupt69
L__UART1Interrupt134:
;SensorNivel.c,560 :: 		Delay_ms(100);                                                        //**Ojo: Este retardo es importante para que el Concentrador tenga tiempo de recibir la respuesta
	MOV	#21, W8
	MOV	#22619, W7
L_UART1Interrupt70:
	DEC	W7
	BRA NZ	L_UART1Interrupt70
	DEC	W8
	BRA NZ	L_UART1Interrupt70
;SensorNivel.c,562 :: 		ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
	MOV	#lo_addr(_solicitudPyloadRS485), W11
	MOV	#lo_addr(_solicitudCabeceraRS485), W10
	CALL	_ProcesarSolicitud
;SensorNivel.c,564 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,565 :: 		}
L_UART1Interrupt69:
;SensorNivel.c,566 :: 		}
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
