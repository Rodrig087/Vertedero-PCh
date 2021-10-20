
_EnviarTramaRS485:
	LNK	#2

;rs485.c,19 :: 		void EnviarTramaRS485(unsigned char puertoUART, unsigned char *cabecera, unsigned char *payload){
;rs485.c,31 :: 		ptrnumDatos = (unsigned char *) & numDatos;
	PUSH	W10
	ADD	W14, #0, W2
; ptrnumDatos start address is: 6 (W3)
	MOV	W2, W3
;rs485.c,34 :: 		direccion = cabecera[0];
; direccion start address is: 8 (W4)
	MOV.B	[W11], W4
;rs485.c,35 :: 		funcion = cabecera[1];
	ADD	W11, #1, W0
; funcion start address is: 10 (W5)
	MOV.B	[W0], W5
;rs485.c,36 :: 		subfuncion = cabecera[2];
	ADD	W11, #2, W0
; subfuncion start address is: 12 (W6)
	MOV.B	[W0], W6
;rs485.c,37 :: 		lsbNumDatos = cabecera[3];
	ADD	W11, #3, W1
; lsbNumDatos start address is: 14 (W7)
	MOV.B	[W1], W7
;rs485.c,38 :: 		msbNumDatos = cabecera[4];
	ADD	W11, #4, W0
; msbNumDatos start address is: 16 (W8)
	MOV.B	[W0], W8
;rs485.c,41 :: 		*(ptrnumDatos) = lsbNumDatos;
	MOV.B	[W1], [W2]
;rs485.c,42 :: 		*(ptrnumDatos+1) = msbNumDatos;
	ADD	W3, #1, W0
; ptrnumDatos end address is: 6 (W3)
	MOV.B	W8, [W0]
;rs485.c,44 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS48594
	GOTO	L_EnviarTramaRS4850
L__EnviarTramaRS48594:
;rs485.c,45 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,46 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOV	#58, W10
	CALL	_UART1_Write
;rs485.c,47 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W4, W10
; direccion end address is: 8 (W4)
	CALL	_UART1_Write
;rs485.c,48 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W5, W10
; funcion end address is: 10 (W5)
	CALL	_UART1_Write
;rs485.c,49 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	ZE	W6, W10
; subfuncion end address is: 12 (W6)
	CALL	_UART1_Write
;rs485.c,50 :: 		UART1_Write(lsbNumDatos);                                               //Envia el LSB del numero de datos
	ZE	W7, W10
; lsbNumDatos end address is: 14 (W7)
	CALL	_UART1_Write
;rs485.c,51 :: 		UART1_Write(msbNumDatos);                                               //Envia el MSB del numero de datos
	ZE	W8, W10
; msbNumDatos end address is: 16 (W8)
	CALL	_UART1_Write
;rs485.c,52 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; iDatos end address is: 2 (W1)
L_EnviarTramaRS4851:
; iDatos start address is: 2 (W1)
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA LTU	L__EnviarTramaRS48595
	GOTO	L_EnviarTramaRS4852
L__EnviarTramaRS48595:
;rs485.c,53 :: 		UART1_Write(payload[iDatos]);
	ADD	W12, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,52 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;rs485.c,54 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaRS4851
L_EnviarTramaRS4852:
;rs485.c,55 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,56 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
;rs485.c,57 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLR	W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,58 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS4854:
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS48596
	GOTO	L_EnviarTramaRS4855
L__EnviarTramaRS48596:
	GOTO	L_EnviarTramaRS4854
L_EnviarTramaRS4855:
;rs485.c,59 :: 		MSRS485 = 0;                                                           //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,60 :: 		}
L_EnviarTramaRS4850:
;rs485.c,62 :: 		}
L_end_EnviarTramaRS485:
	POP	W10
	ULNK
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

;SensorNivel.c,143 :: 		void main() {
;SensorNivel.c,146 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;SensorNivel.c,150 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,151 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;SensorNivel.c,152 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;SensorNivel.c,153 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;SensorNivel.c,156 :: 		T2 = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,157 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,158 :: 		TOF = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _TOF
	MOV	W1, _TOF+2
;SensorNivel.c,159 :: 		temperaturaRaw = 0;
	CLR	W0
	MOV	W0, _temperaturaRaw
;SensorNivel.c,161 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,162 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,163 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,164 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,165 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,166 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,167 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;SensorNivel.c,168 :: 		ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrNumDatosRS485
;SensorNivel.c,169 :: 		MSRS485 = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;SensorNivel.c,174 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,176 :: 		ip=0;
	MOV	#lo_addr(_ip), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,185 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;SensorNivel.c,193 :: 		void ConfiguracionPrincipal(){
;SensorNivel.c,196 :: 		CLKDIVbits.PLLPRE = 0;                                                     //PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,197 :: 		PLLFBD = 38;                                                               //PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
	MOV	#38, W0
	MOV	WREG, PLLFBD
;SensorNivel.c,198 :: 		CLKDIVbits.PLLPOST = 0;                                                    //PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,201 :: 		AD1PCFGL = 0xFFFD;                                                         //Configura el puerto AN1 como entrada analogica y todas las demas como digitales
	MOV	#65533, W0
	MOV	WREG, AD1PCFGL
;SensorNivel.c,202 :: 		TRISA1_bit = 1;                                                            //Establece el pin RA1 como entrada
	BSET	TRISA1_bit, BitPos(TRISA1_bit+0)
;SensorNivel.c,203 :: 		TRISB = 0xFF40;                                                            //TRISB = 11111111 01000000
	MOV	#65344, W0
	MOV	WREG, TRISB
;SensorNivel.c,204 :: 		MSRS485_Direction = 0;                                                     //MSRS485 out
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;SensorNivel.c,205 :: 		TEST_Direction = 0;                                                        //Test out
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;SensorNivel.c,207 :: 		AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
	BCLR	AD1CON1, #10
;SensorNivel.c,208 :: 		AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
	MOV	AD1CON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON1bits
;SensorNivel.c,209 :: 		AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea múltiples canales individualmente en secuencia
	BCLR	AD1CON1, #3
;SensorNivel.c,210 :: 		AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
	BCLR	AD1CON1, #13
;SensorNivel.c,211 :: 		AD1CON1.ASAM = 1;                                                          //Muestreo automatico
	BSET	AD1CON1, #2
;SensorNivel.c,212 :: 		AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#31, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,213 :: 		AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
	MOV	AD1CON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,214 :: 		AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
	MOV	AD1CON2bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,215 :: 		AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
	BCLR	AD1CON2, #10
;SensorNivel.c,216 :: 		AD1CON2.BUFM = 0;                                                          //Bit de selección del modo de relleno del búfer, 0 -> Siempre comienza a llenar el buffer desde el principio
	BCLR	AD1CON2, #1
;SensorNivel.c,217 :: 		AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la selección de entrada de canal para la muestra A
	BCLR	AD1CON2, #0
;SensorNivel.c,218 :: 		AD1CON3.ADRC = 0;                                                          //Selecciona el reloj de conversion del ADC derivado del reloj del sistema
	BCLR	AD1CON3, #15
;SensorNivel.c,219 :: 		AD1CON3bits.ADCS = 0x02;                                                   //Configura el periodo del reloj del ADC fijando el valor de los bits ADCS segun la formula: TAD = TCY*(ADCS+1) = 75ns  -> ADCS = 2
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
;SensorNivel.c,220 :: 		AD1CON3bits.SAMC = 0x02;                                                   //Auto Sample Time bits, 2 -> 2*TAD (minimo periodo de muestreo para 10 bits)
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CON3bits
;SensorNivel.c,221 :: 		AD1CHS0.CH0NB = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #15
;SensorNivel.c,222 :: 		AD1CHS0bits.CH0SB = 0x01;                                                  //Channel 0 positive input is AN1
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CHS0bits
;SensorNivel.c,223 :: 		AD1CHS0.CH0NA = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #7
;SensorNivel.c,224 :: 		AD1CHS0bits.CH0SA = 0x01;                                                  //Channel 0 positive input is AN1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CHS0bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,225 :: 		AD1CHS123 = 0;                                                             //AD1CHS123: ADC1 INPUT CHANNEL 1, 2, 3 SELECT REGISTER
	CLR	AD1CHS123
;SensorNivel.c,226 :: 		AD1CSSL = 0x00;                                                            //Se salta todos los puertos ANx para los escaneos de entrada
	CLR	AD1CSSL
;SensorNivel.c,227 :: 		AD1CON1.ADON = 1;                                                          //Enciende el modulo ADC
	BSET	AD1CON1, #15
;SensorNivel.c,230 :: 		T1CON = 0x8000;                                                            //Habilita el TMR1, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T1CON
;SensorNivel.c,231 :: 		IEC0.T1IE = 1;                                                             //Habilita la interrupcion por desborde de TMR1
	BSET	IEC0, #3
;SensorNivel.c,232 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,233 :: 		PR1 = 200;                                                                 //Genera una interrupcion cada 5us (Fs=200KHz)
	MOV	#200, W0
	MOV	WREG, PR1
;SensorNivel.c,234 :: 		T1CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T1CON, #15
;SensorNivel.c,237 :: 		T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T2CON
;SensorNivel.c,238 :: 		IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
	BSET	IEC0, #7
;SensorNivel.c,239 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,240 :: 		PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
	MOV	#500, W0
	MOV	WREG, PR2
;SensorNivel.c,241 :: 		T2CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T2CON, #15
;SensorNivel.c,244 :: 		RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
	MOV.B	#6, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,245 :: 		RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR3bits
;SensorNivel.c,246 :: 		IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
	BSET	IEC0, #11
;SensorNivel.c,247 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,248 :: 		UART1_Init(19200);                                                          //Inicializa el modulo UART a 9600 bps
	MOV	#19200, W10
	MOV	#0, W11
	CALL	_UART1_Init
;SensorNivel.c,251 :: 		IPC0bits.T1IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#24576, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;SensorNivel.c,252 :: 		IPC1bits.T2IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
	MOV	IPC1bits, W1
	MOV	#28672, W0
	IOR	W1, W0, W0
	MOV	WREG, IPC1bits
;SensorNivel.c,253 :: 		IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;SensorNivel.c,255 :: 		Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#21, W8
	MOV	#22619, W7
L_ConfiguracionPrincipal6:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal6
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal6
;SensorNivel.c,257 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_ProcesarSolicitud:
	LNK	#8

;SensorNivel.c,262 :: 		void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){
;SensorNivel.c,272 :: 		ptrNumDatosResp = (unsigned char *) & numDatosResp;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #2, W0
; ptrNumDatosResp start address is: 18 (W9)
	MOV	W0, W9
;SensorNivel.c,273 :: 		ptrDatoInt = (unsigned char *) & datoInt;
	ADD	W14, #0, W0
; ptrDatoInt start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,274 :: 		ptrDatoFloat = (unsigned char *) & datoFloat;
	ADD	W14, #4, W0
; ptrDatoFloat start address is: 6 (W3)
	MOV	W0, W3
;SensorNivel.c,277 :: 		funcionSolicitud = cabeceraSolicitud[1];
	ADD	W10, #1, W0
; funcionSolicitud start address is: 2 (W1)
	MOV.B	[W0], W1
;SensorNivel.c,278 :: 		subFuncionSolicitud = cabeceraSolicitud[2];
	ADD	W10, #2, W0
; subFuncionSolicitud start address is: 0 (W0)
	MOV.B	[W0], W0
;SensorNivel.c,282 :: 		switch (funcionSolicitud){
	GOTO	L_ProcesarSolicitud8
; ptrNumDatosResp end address is: 18 (W9)
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
; funcionSolicitud end address is: 2 (W1)
; subFuncionSolicitud end address is: 0 (W0)
;SensorNivel.c,283 :: 		case 1:
L_ProcesarSolicitud10:
;SensorNivel.c,285 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,286 :: 		TOF = CalcularTOF();
	CALL	_CalcularTOF
	MOV	W0, _TOF
	MOV	W1, _TOF+2
;SensorNivel.c,287 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,288 :: 		case 2:
L_ProcesarSolicitud11:
;SensorNivel.c,291 :: 		switch (subFuncionRS485){
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	GOTO	L_ProcesarSolicitud12
;SensorNivel.c,292 :: 		case 1:
L_ProcesarSolicitud14:
;SensorNivel.c,295 :: 		datoInt = temperaturaRaw;
	MOV	_temperaturaRaw, W0
	MOV	W0, [W14+0]
;SensorNivel.c,296 :: 		datoFloat = TOF;
	MOV	_TOF, W0
	MOV	_TOF+2, W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;SensorNivel.c,297 :: 		respuestaPyloadRS485[0] = *(ptrDatoFloat);
	MOV.B	[W3], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,298 :: 		respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
	ADD	W3, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,299 :: 		respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
	ADD	W3, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+2), W0
	MOV.B	W1, [W0]
;SensorNivel.c,300 :: 		respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
	ADD	W3, #3, W0
; ptrDatoFloat end address is: 6 (W3)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+3), W0
	MOV.B	W1, [W0]
;SensorNivel.c,301 :: 		respuestaPyloadRS485[4] = *(ptrDatoInt);
	MOV.B	[W2], W1
	MOV	#lo_addr(_respuestaPyloadRS485+4), W0
	MOV.B	W1, [W0]
;SensorNivel.c,302 :: 		respuestaPyloadRS485[5] = *(ptrDatoInt+1);
	ADD	W2, #1, W0
; ptrDatoInt end address is: 4 (W2)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+5), W0
	MOV.B	W1, [W0]
;SensorNivel.c,304 :: 		numDatosResp = 6;
	MOV	#6, W0
	MOV	W0, [W14+2]
;SensorNivel.c,305 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,306 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,307 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,308 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,309 :: 		case 2:
L_ProcesarSolicitud15:
;SensorNivel.c,312 :: 		numDatosResp = 700;
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#700, W0
	MOV	W0, [W14+2]
;SensorNivel.c,313 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,314 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,315 :: 		EnviarTramaInt(cabeceraSolicitud,vectorMuestras);
	MOV	#lo_addr(_vectorMuestras), W11
	CALL	_EnviarTramaInt
;SensorNivel.c,316 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,317 :: 		case 3:
L_ProcesarSolicitud16:
;SensorNivel.c,319 :: 		numDatosResp = 700;
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#700, W0
	MOV	W0, [W14+2]
;SensorNivel.c,320 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,321 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,322 :: 		EnviarTramaInt(cabeceraSolicitud,vectorMuestras);
	MOV	#lo_addr(_vectorMuestras), W11
	CALL	_EnviarTramaInt
;SensorNivel.c,323 :: 		break;
	GOTO	L_ProcesarSolicitud13
;SensorNivel.c,324 :: 		}
L_ProcesarSolicitud12:
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitud101
	GOTO	L_ProcesarSolicitud14
L__ProcesarSolicitud101:
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud102
	GOTO	L_ProcesarSolicitud15
L__ProcesarSolicitud102:
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud103
	GOTO	L_ProcesarSolicitud16
L__ProcesarSolicitud103:
; ptrNumDatosResp end address is: 18 (W9)
L_ProcesarSolicitud13:
;SensorNivel.c,325 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,326 :: 		case 4:
L_ProcesarSolicitud17:
;SensorNivel.c,328 :: 		switch (subFuncionSolicitud){
; subFuncionSolicitud start address is: 0 (W0)
; ptrNumDatosResp start address is: 18 (W9)
	GOTO	L_ProcesarSolicitud18
; subFuncionSolicitud end address is: 0 (W0)
;SensorNivel.c,329 :: 		case 2:
L_ProcesarSolicitud20:
;SensorNivel.c,332 :: 		numDatosResp = 10;
	MOV	#10, W0
	MOV	W0, [W14+2]
;SensorNivel.c,333 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,334 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,335 :: 		EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
	MOV	#lo_addr(_tramaPruebaRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,336 :: 		break;
	GOTO	L_ProcesarSolicitud19
;SensorNivel.c,337 :: 		case 3:
L_ProcesarSolicitud21:
;SensorNivel.c,340 :: 		numDatosResp = 512;
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#512, W0
	MOV	W0, [W14+2]
;SensorNivel.c,341 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,342 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,343 :: 		TEST = ~TEST;
	BTG	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,344 :: 		GenerarTramaPrueba(numDatosResp, cabeceraSolicitud);
	MOV	W10, W11
	MOV	[W14+2], W10
	CALL	_GenerarTramaPrueba
;SensorNivel.c,346 :: 		break;
	GOTO	L_ProcesarSolicitud19
;SensorNivel.c,347 :: 		}
L_ProcesarSolicitud18:
; subFuncionSolicitud start address is: 0 (W0)
; ptrNumDatosResp start address is: 18 (W9)
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud104
	GOTO	L_ProcesarSolicitud20
L__ProcesarSolicitud104:
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud105
	GOTO	L_ProcesarSolicitud21
L__ProcesarSolicitud105:
; ptrNumDatosResp end address is: 18 (W9)
; subFuncionSolicitud end address is: 0 (W0)
L_ProcesarSolicitud19:
;SensorNivel.c,348 :: 		break;
	GOTO	L_ProcesarSolicitud9
;SensorNivel.c,349 :: 		}
L_ProcesarSolicitud8:
; subFuncionSolicitud start address is: 0 (W0)
; funcionSolicitud start address is: 2 (W1)
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	CP.B	W1, #1
	BRA NZ	L__ProcesarSolicitud106
	GOTO	L_ProcesarSolicitud10
L__ProcesarSolicitud106:
	CP.B	W1, #2
	BRA NZ	L__ProcesarSolicitud107
	GOTO	L_ProcesarSolicitud11
L__ProcesarSolicitud107:
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
	CP.B	W1, #4
	BRA NZ	L__ProcesarSolicitud108
	GOTO	L_ProcesarSolicitud17
L__ProcesarSolicitud108:
; ptrNumDatosResp end address is: 18 (W9)
; funcionSolicitud end address is: 2 (W1)
; subFuncionSolicitud end address is: 0 (W0)
L_ProcesarSolicitud9:
;SensorNivel.c,351 :: 		}
L_end_ProcesarSolicitud:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _ProcesarSolicitud

_GenerarTramaPrueba:
	LNK	#516

;SensorNivel.c,356 :: 		void GenerarTramaPrueba(unsigned int numDatosPrueba, unsigned char *cabeceraPrueba){
;SensorNivel.c,358 :: 		unsigned int contadorMuestras = 0;
	PUSH	W12
; contadorMuestras start address is: 4 (W2)
	CLR	W2
;SensorNivel.c,362 :: 		for (j=0;j<numDatosPrueba;j++){
	CLR	W0
	MOV	W0, _j
; contadorMuestras end address is: 4 (W2)
L_GenerarTramaPrueba22:
; contadorMuestras start address is: 4 (W2)
	MOV	#lo_addr(_j), W0
	CP	W10, [W0]
	BRA GTU	L__GenerarTramaPrueba110
	GOTO	L_GenerarTramaPrueba23
L__GenerarTramaPrueba110:
;SensorNivel.c,363 :: 		outputPyloadRS485[j] = contadorMuestras;
	ADD	W14, #0, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;SensorNivel.c,364 :: 		contadorMuestras++;
	ADD	W2, #1, W1
	MOV	W1, W2
;SensorNivel.c,365 :: 		if (contadorMuestras>255) {
	MOV	#255, W0
	CP	W1, W0
	BRA GTU	L__GenerarTramaPrueba111
	GOTO	L__GenerarTramaPrueba79
L__GenerarTramaPrueba111:
;SensorNivel.c,366 :: 		contadorMuestras = 0;
	CLR	W2
; contadorMuestras end address is: 4 (W2)
;SensorNivel.c,367 :: 		}
	GOTO	L_GenerarTramaPrueba25
L__GenerarTramaPrueba79:
;SensorNivel.c,365 :: 		if (contadorMuestras>255) {
;SensorNivel.c,367 :: 		}
L_GenerarTramaPrueba25:
;SensorNivel.c,362 :: 		for (j=0;j<numDatosPrueba;j++){
; contadorMuestras start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,368 :: 		}
; contadorMuestras end address is: 4 (W2)
	GOTO	L_GenerarTramaPrueba22
L_GenerarTramaPrueba23:
;SensorNivel.c,370 :: 		EnviarTramaRS485(1, cabeceraPrueba, outputPyloadRS485);
	ADD	W14, #0, W0
	PUSH	W10
	MOV	W0, W12
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
	POP	W10
;SensorNivel.c,374 :: 		}
L_end_GenerarTramaPrueba:
	POP	W12
	ULNK
	RETURN
; end of _GenerarTramaPrueba

_LeerDS18B20:

;SensorNivel.c,379 :: 		unsigned int LeerDS18B20(){
;SensorNivel.c,383 :: 		TEST = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,386 :: 		Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,387 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,388 :: 		Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
	MOV.B	#68, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,389 :: 		Delay_ms(750);
	MOV	#153, W8
	MOV	#38577, W7
L_LeerDS18B2026:
	DEC	W7
	BRA NZ	L_LeerDS18B2026
	DEC	W8
	BRA NZ	L_LeerDS18B2026
	NOP
	NOP
;SensorNivel.c,390 :: 		Ow_Reset(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,391 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,392 :: 		Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
	MOV.B	#190, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,393 :: 		Delay_us(100);
	MOV	#1333, W7
L_LeerDS18B2028:
	DEC	W7
	BRA NZ	L_LeerDS18B2028
	NOP
;SensorNivel.c,394 :: 		temp = Ow_Read(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
; temp start address is: 10 (W5)
	ZE	W0, W5
;SensorNivel.c,395 :: 		temp = (Ow_Read(&PORTA, 0) << 8) + temp;
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
	ZE	W0, W0
	SL	W0, #8, W0
	ADD	W0, W5, W0
; temp end address is: 10 (W5)
;SensorNivel.c,397 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,401 :: 		return temperaturaCrudo;
;SensorNivel.c,403 :: 		}
;SensorNivel.c,401 :: 		return temperaturaCrudo;
;SensorNivel.c,403 :: 		}
L_end_LeerDS18B20:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _LeerDS18B20

_GenerarPulso:
	LNK	#12

;SensorNivel.c,407 :: 		void GenerarPulso(){
;SensorNivel.c,409 :: 		TEST = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,412 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,413 :: 		contPulsos = 0;                                                            //Limpia la variable del contador de pulsos
	CLR	W0
	MOV	W0, _contPulsos
;SensorNivel.c,414 :: 		RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,415 :: 		T1CON.TON = 0;                                                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,416 :: 		TMR2 = 0;                                                                  //Encera el TMR2
	CLR	TMR2
;SensorNivel.c,417 :: 		T2CON.TON = 1;                                                             //Enciende el TMR2
	BSET	T2CON, #15
;SensorNivel.c,418 :: 		i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la señal muestreada
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,419 :: 		while(bm!=1);                                                              //Espera hasta que haya terminado de enviar y recibir todas las muestras
L_GenerarPulso30:
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__GenerarPulso114
	GOTO	L_GenerarPulso31
L__GenerarPulso114:
	GOTO	L_GenerarPulso30
L_GenerarPulso31:
;SensorNivel.c,422 :: 		if (bm==1){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__GenerarPulso115
	GOTO	L_GenerarPulso32
L__GenerarPulso115:
;SensorNivel.c,425 :: 		Mmed = 508;                                                           //Medido con el osciloscopio: Vmean = 1.64V => 508.4adc
	MOV	#508, W0
	MOV	W0, _Mmed
;SensorNivel.c,427 :: 		for (k=0;k<numeroMuestras;k++){
	CLR	W0
	MOV	W0, _k
L_GenerarPulso33:
	MOV	_k, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__GenerarPulso116
	GOTO	L_GenerarPulso34
L__GenerarPulso116:
;SensorNivel.c,430 :: 		valorAbsoluto = vectorMuestras[k]-Mmed;
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W3
	MOV	[W3], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_valorAbsoluto), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,431 :: 		if (vectorMuestras[k]<Mmed){
	MOV	[W3], W1
	MOV	#lo_addr(_Mmed), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso117
	GOTO	L_GenerarPulso36
L__GenerarPulso117:
;SensorNivel.c,432 :: 		valorAbsoluto = (vectorMuestras[k]+((Mmed-vectorMuestras[k])*2))-(Mmed);
	MOV	_k, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W1
	MOV	_Mmed, W0
	SUB	W0, [W1], W0
	SL	W0, #1, W0
	ADD	W0, [W1], W2
	MOV	#lo_addr(_Mmed), W1
	MOV	#lo_addr(_valorAbsoluto), W0
	SUB	W2, [W1], [W0]
;SensorNivel.c,433 :: 		}
L_GenerarPulso36:
;SensorNivel.c,437 :: 		for( f=O-1; f!=0; f-- ) XFIR[f]=XFIR[f-1];
	MOV	#20, W0
	MOV	W0, _f
L_GenerarPulso37:
	MOV	_f, W0
	CP	W0, #0
	BRA NZ	L__GenerarPulso118
	GOTO	L_GenerarPulso38
L__GenerarPulso118:
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
	GOTO	L_GenerarPulso37
L_GenerarPulso38:
;SensorNivel.c,439 :: 		XFIR[0] = (float)(valorAbsoluto);
	MOV	_valorAbsoluto, W0
	CLR	W1
	CALL	__Long2Float
	MOV	W0, _XFIR
	MOV	W1, _XFIR+2
;SensorNivel.c,441 :: 		y0 = 0.0; for( f=0; f<O; f++ ) y0 += h[f]*XFIR[f];
	CLR	W0
	CLR	W1
	MOV	W0, _y0
	MOV	W1, _y0+2
	CLR	W0
	MOV	W0, _f
L_GenerarPulso40:
	MOV	_f, W0
	CP	W0, #21
	BRA LTU	L__GenerarPulso119
	GOTO	L_GenerarPulso41
L__GenerarPulso119:
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
	GOTO	L_GenerarPulso40
L_GenerarPulso41:
;SensorNivel.c,443 :: 		YY = (unsigned int)(y0);                                          //Reconstrucción de la señal: y en 10 bits.
	MOV	_y0, W0
	MOV	_y0+2, W1
	CALL	__Float2Longint
	MOV	W0, _YY
;SensorNivel.c,444 :: 		vectorMuestras[k] = YY;
	MOV	_k, W1
	SL	W1, #1, W2
	MOV	#lo_addr(_vectorMuestras), W1
	ADD	W1, W2, W1
	MOV	W0, [W1]
;SensorNivel.c,427 :: 		for (k=0;k<numeroMuestras;k++){
	MOV	#1, W1
	MOV	#lo_addr(_k), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,446 :: 		}
	GOTO	L_GenerarPulso33
L_GenerarPulso34:
;SensorNivel.c,448 :: 		bm = 2;                                                               //Cambia el estado de la bandera bm para dar paso al cálculo del pmax y TOF
	MOV	#lo_addr(_bm), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,450 :: 		}
L_GenerarPulso32:
;SensorNivel.c,453 :: 		if (bm==2){
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__GenerarPulso120
	GOTO	L_GenerarPulso43
L__GenerarPulso120:
;SensorNivel.c,455 :: 		yy1 = Vector_Max(vectorMuestras, numeroMuestras, &maxIndex);                                    //Encuentra el valor maximo del vector R
	MOV	#lo_addr(_maxIndex), W0
	PUSH	W0
	MOV	#350, W0
	PUSH	W0
	MOV	#lo_addr(_vectorMuestras), W0
	PUSH	W0
	CALL	_Vector_Max
	SUB	#6, W15
	MOV	W0, _yy1
;SensorNivel.c,456 :: 		i1b = maxIndex;                                                        //Asigna el subindice del valor maximo a la variable i1a
	MOV	_maxIndex, W0
	MOV	W0, _i1b
;SensorNivel.c,457 :: 		i1a = 0;
	CLR	W0
	MOV	W0, _i1a
;SensorNivel.c,459 :: 		while (vectorMuestras[i1a]<yy1){
L_GenerarPulso44:
	MOV	_i1a, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W0
	MOV	[W0], W1
	MOV	#lo_addr(_yy1), W0
	CP	W1, [W0]
	BRA LTU	L__GenerarPulso121
	GOTO	L_GenerarPulso45
L__GenerarPulso121:
;SensorNivel.c,460 :: 		i1a++;
	MOV	#1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,461 :: 		}
	GOTO	L_GenerarPulso44
L_GenerarPulso45:
;SensorNivel.c,463 :: 		i1 = i1a+((i1b-i1a)/2);
	MOV	_i1b, W1
	MOV	#lo_addr(_i1a), W0
	SUB	W1, [W0], W0
	LSR	W0, #1, W1
	MOV	#lo_addr(_i1a), W0
	ADD	W1, [W0], W1
	MOV	W1, _i1
;SensorNivel.c,464 :: 		i0 = i1 - dix;
	SUB	W1, #20, W0
	MOV	W0, _i0
;SensorNivel.c,465 :: 		i2 = i1 + dix;
	ADD	W1, #20, W3
	MOV	W3, _i2
;SensorNivel.c,467 :: 		yy0 = vectorMuestras[i0];
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W0
	MOV	[W0], W2
	MOV	W2, _yy0
;SensorNivel.c,468 :: 		yy2 = vectorMuestras[i2];
	SL	W3, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W0
	MOV	[W0], W0
	MOV	W0, [W14+0]
	MOV	W0, _yy2
;SensorNivel.c,470 :: 		yf0 = (float)(yy0);
	MOV	W2, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
	MOV	W0, _yf0
	MOV	W1, _yf0+2
;SensorNivel.c,471 :: 		yf1 = (float)(yy1);
	MOV	_yy1, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	W0, _yf1
	MOV	W1, _yf1+2
;SensorNivel.c,472 :: 		yf2 = (float)(yy2);
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
;SensorNivel.c,474 :: 		nx = (yf0-yf2)/(2.0*(yf0-(2.0*yf1)+yf2));                              //Factor de ajuste determinado por interpolacion parabolica
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
;SensorNivel.c,475 :: 		dx = nx*dix*tx;
	MOV	#0, W2
	MOV	#16800, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _dx
	MOV	W1, _dx+2
;SensorNivel.c,476 :: 		tmax = i1*tx;
	MOV	_i1, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	W0, _tmax
	MOV	W1, _tmax+2
;SensorNivel.c,478 :: 		T2 = tmax+dx;
	MOV	_dx, W2
	MOV	_dx+2, W3
	CALL	__AddSub_FP
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,480 :: 		}
L_GenerarPulso43:
;SensorNivel.c,482 :: 		TEST = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,484 :: 		}
L_end_GenerarPulso:
	ULNK
	RETURN
; end of _GenerarPulso

_CalcularTOF:

;SensorNivel.c,488 :: 		float CalcularTOF(){
;SensorNivel.c,490 :: 		conts = 0;                                                                 //Limpia el contador de secuencias
	MOV	#lo_addr(_conts), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,491 :: 		T2sum = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,492 :: 		T2prom = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,493 :: 		T2a = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,494 :: 		T2b = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,496 :: 		while (conts<Nsm){
L_CalcularTOF46:
	MOV	#lo_addr(_conts), W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA LTU	L__CalcularTOF123
	GOTO	L_CalcularTOF47
L__CalcularTOF123:
;SensorNivel.c,497 :: 		GenerarPulso();                                                      //Inicia una secuencia de medicion
	CALL	_GenerarPulso
;SensorNivel.c,498 :: 		T2b = T2;
	MOV	_T2, W0
	MOV	_T2+2, W1
	MOV	W0, _T2b
	MOV	W1, _T2b+2
;SensorNivel.c,499 :: 		if ((T2b-T2a)<=T2umb){                                               //Verifica si el T2 actual esta dentro de un umbral pre-establecido
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
	BRA GT	L__CalcularTOF124
	INC.B	W0
L__CalcularTOF124:
	CP0.B	W0
	BRA NZ	L__CalcularTOF125
	GOTO	L_CalcularTOF48
L__CalcularTOF125:
;SensorNivel.c,500 :: 		T2sum = T2sum + T2b;                                              //Acumula la sumatoria de valores de T2 calculados por la funcion GenerarPulso()
	MOV	_T2sum, W2
	MOV	_T2sum+2, W3
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	CALL	__AddSub_FP
	MOV	W0, _T2sum
	MOV	W1, _T2sum+2
;SensorNivel.c,501 :: 		conts++;                                                          //Aumenta el contador de secuencias
	MOV.B	#1, W1
	MOV	#lo_addr(_conts), W0
	ADD.B	W1, [W0], [W0]
;SensorNivel.c,502 :: 		}
L_CalcularTOF48:
;SensorNivel.c,503 :: 		T2a = T2b;
	MOV	_T2b, W0
	MOV	_T2b+2, W1
	MOV	W0, _T2a
	MOV	W1, _T2a+2
;SensorNivel.c,504 :: 		}
	GOTO	L_CalcularTOF46
L_CalcularTOF47:
;SensorNivel.c,506 :: 		T2prom = T2sum/Nsm;
	MOV	#0, W2
	MOV	#16880, W3
	MOV	_T2sum, W0
	MOV	_T2sum+2, W1
	CALL	__Div_FP
	MOV	W0, _T2prom
	MOV	W1, _T2prom+2
;SensorNivel.c,508 :: 		return T2prom;
;SensorNivel.c,510 :: 		}
L_end_CalcularTOF:
	RETURN
; end of _CalcularTOF

_EnviarTramaInt:
	LNK	#702

;SensorNivel.c,514 :: 		void EnviarTramaInt(unsigned char* cabecera, unsigned char* tramaInt){
;SensorNivel.c,521 :: 		ptrValorInt = (unsigned char *) & valorInt;
	PUSH	W12
	MOV	#700, W0
	ADD	W14, W0, W0
; ptrValorInt start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,524 :: 		for (j=0;j<numeroMuestras;j++){
	CLR	W0
	MOV	W0, _j
L_EnviarTramaInt49:
; ptrValorInt start address is: 4 (W2)
; ptrValorInt end address is: 4 (W2)
	MOV	_j, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaInt127
	GOTO	L_EnviarTramaInt50
L__EnviarTramaInt127:
; ptrValorInt end address is: 4 (W2)
;SensorNivel.c,525 :: 		valorInt = tramaInt[j];
; ptrValorInt start address is: 4 (W2)
	MOV	#lo_addr(_j), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, [W14+700]
;SensorNivel.c,526 :: 		tramaShort[j*2] = *(ptrValorInt);
	MOV	_j, W0
	SL	W0, #1, W0
	ADD	W14, #0, W1
	ADD	W1, W0, W0
	MOV.B	[W2], [W0]
;SensorNivel.c,527 :: 		tramaShort[(j*2)+1] = *(ptrValorInt+1);
	MOV	_j, W0
	SL	W0, #1, W0
	INC	W0
	ADD	W1, W0, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;SensorNivel.c,524 :: 		for (j=0;j<numeroMuestras;j++){
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,528 :: 		}
; ptrValorInt end address is: 4 (W2)
	GOTO	L_EnviarTramaInt49
L_EnviarTramaInt50:
;SensorNivel.c,532 :: 		EnviarTramaRS485(1, cabecera, tramaShort);
	ADD	W14, #0, W0
	PUSH.D	W10
	MOV	W0, W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
	POP.D	W10
;SensorNivel.c,534 :: 		}
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

;SensorNivel.c,542 :: 		void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
;SensorNivel.c,543 :: 		SAMP_bit = 0;                                 //Limpia el bit SAMP para iniciar la conversion del ADC
	BCLR	SAMP_bit, BitPos(SAMP_bit+0)
;SensorNivel.c,544 :: 		while (!AD1CON1bits.DONE);                    //Espera hasta que se complete la conversion
L_Timer1Interrupt52:
	BTSC	AD1CON1bits, #0
	GOTO	L_Timer1Interrupt53
	GOTO	L_Timer1Interrupt52
L_Timer1Interrupt53:
;SensorNivel.c,545 :: 		if (i<numeroMuestras){
	MOV	_i, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__Timer1Interrupt129
	GOTO	L_Timer1Interrupt54
L__Timer1Interrupt129:
;SensorNivel.c,546 :: 		vectorMuestras[i] = ADC1BUF0;                           //Almacena el valor actual de la conversion del ADC en el vector M
	MOV	_i, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W1
	MOV	ADC1BUF0, WREG
	MOV	W0, [W1]
;SensorNivel.c,547 :: 		i++;                                       //Aumenta en 1 el subindice del vector de Muestras
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,548 :: 		} else {
	GOTO	L_Timer1Interrupt55
L_Timer1Interrupt54:
;SensorNivel.c,549 :: 		bm = 1;                                    //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la señal
	MOV	#lo_addr(_bm), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,550 :: 		T1CON.TON = 0;                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,551 :: 		}
L_Timer1Interrupt55:
;SensorNivel.c,552 :: 		T1IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,553 :: 		}
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

;SensorNivel.c,556 :: 		void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{
;SensorNivel.c,558 :: 		if (contPulsos<10){                                //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
	MOV	_contPulsos, W0
	CP	W0, #10
	BRA LTU	L__Timer2Interrupt131
	GOTO	L_Timer2Interrupt56
L__Timer2Interrupt131:
;SensorNivel.c,559 :: 		RB2_bit = ~RB2_bit;                      //Conmuta el valor del pin RB14
	BTG	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,560 :: 		}else {
	GOTO	L_Timer2Interrupt57
L_Timer2Interrupt56:
;SensorNivel.c,561 :: 		RB2_bit = 0;                             //Pone a cero despues de enviar todos los pulsos de exitacion.
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,562 :: 		if (contPulsos==110){
	MOV	#110, W1
	MOV	#lo_addr(_contPulsos), W0
	CP	W1, [W0]
	BRA Z	L__Timer2Interrupt132
	GOTO	L_Timer2Interrupt58
L__Timer2Interrupt132:
;SensorNivel.c,563 :: 		T2CON.TON = 0;                       //Apaga el TMR2
	BCLR	T2CON, #15
;SensorNivel.c,564 :: 		TMR1 = 0;                            //Encera el TMR1
	CLR	TMR1
;SensorNivel.c,565 :: 		T1CON.TON = 1;                       //Enciende el TMR1
	BSET	T1CON, #15
;SensorNivel.c,567 :: 		}
L_Timer2Interrupt58:
;SensorNivel.c,568 :: 		}
L_Timer2Interrupt57:
;SensorNivel.c,569 :: 		contPulsos++;                                      //Aumenta el contador en una unidad.
	MOV	#1, W1
	MOV	#lo_addr(_contPulsos), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,570 :: 		T2IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,576 :: 		}
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

;SensorNivel.c,579 :: 		void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {
;SensorNivel.c,581 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	PUSH	W10
	PUSH	W11
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,582 :: 		byteRS485 = UART1_Read();                                                  //Lee el byte recibido
	CALL	_UART1_Read
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	W0, [W1]
;SensorNivel.c,585 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__UART1Interrupt134
	GOTO	L_UART1Interrupt59
L__UART1Interrupt134:
;SensorNivel.c,587 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__UART1Interrupt135
	GOTO	L_UART1Interrupt60
L__UART1Interrupt135:
;SensorNivel.c,588 :: 		solicitudPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_solicitudPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,589 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,590 :: 		} else {
	GOTO	L_UART1Interrupt61
L_UART1Interrupt60:
;SensorNivel.c,591 :: 		banRSI = 0;                                                      //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,592 :: 		banRSC = 1;                                                      //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,593 :: 		}
L_UART1Interrupt61:
;SensorNivel.c,594 :: 		}
L_UART1Interrupt59:
;SensorNivel.c,597 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt136
	GOTO	L__UART1Interrupt85
L__UART1Interrupt136:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt137
	GOTO	L__UART1Interrupt84
L__UART1Interrupt137:
L__UART1Interrupt83:
;SensorNivel.c,598 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__UART1Interrupt138
	GOTO	L_UART1Interrupt65
L__UART1Interrupt138:
;SensorNivel.c,599 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,600 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,601 :: 		}
L_UART1Interrupt65:
;SensorNivel.c,597 :: 		if ((banRSI==0)&&(banRSC==0)){
L__UART1Interrupt85:
L__UART1Interrupt84:
;SensorNivel.c,603 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt139
	GOTO	L__UART1Interrupt88
L__UART1Interrupt139:
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt140
	GOTO	L__UART1Interrupt87
L__UART1Interrupt140:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__UART1Interrupt141
	GOTO	L__UART1Interrupt86
L__UART1Interrupt141:
L__UART1Interrupt82:
;SensorNivel.c,604 :: 		solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_solicitudCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,605 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,603 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
L__UART1Interrupt88:
L__UART1Interrupt87:
L__UART1Interrupt86:
;SensorNivel.c,607 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt142
	GOTO	L__UART1Interrupt92
L__UART1Interrupt142:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__UART1Interrupt143
	GOTO	L__UART1Interrupt91
L__UART1Interrupt143:
L__UART1Interrupt81:
;SensorNivel.c,609 :: 		if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__UART1Interrupt144
	GOTO	L__UART1Interrupt90
L__UART1Interrupt144:
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt145
	GOTO	L__UART1Interrupt89
L__UART1Interrupt145:
	GOTO	L_UART1Interrupt74
L__UART1Interrupt90:
L__UART1Interrupt89:
;SensorNivel.c,611 :: 		*(ptrNumDatosRS485) = solicitudCabeceraRS485[3];
	MOV	#lo_addr(_solicitudCabeceraRS485+3), W1
	MOV	_ptrNumDatosRS485, W0
	MOV.B	[W1], [W0]
;SensorNivel.c,612 :: 		*(ptrNumDatosRS485+1) = solicitudCabeceraRS485[4];
	MOV	_ptrNumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_solicitudCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,613 :: 		i_rs485 = 0;                                                     //Encera el subindice para almacenar el payload
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,614 :: 		banRSI = 2;                                                      //Cambia el valor de la bandera para salir del bucle
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,615 :: 		} else {
	GOTO	L_UART1Interrupt75
L_UART1Interrupt74:
;SensorNivel.c,616 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,617 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,618 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,619 :: 		}
L_UART1Interrupt75:
;SensorNivel.c,607 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__UART1Interrupt92:
L__UART1Interrupt91:
;SensorNivel.c,623 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt146
	GOTO	L_UART1Interrupt76
L__UART1Interrupt146:
;SensorNivel.c,624 :: 		Delay_ms(100);                                                        //**Ojo: Este retardo es importante para que el Concentrador tenga tiempo de recibir la respuesta
	MOV	#21, W8
	MOV	#22619, W7
L_UART1Interrupt77:
	DEC	W7
	BRA NZ	L_UART1Interrupt77
	DEC	W8
	BRA NZ	L_UART1Interrupt77
;SensorNivel.c,626 :: 		ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
	MOV	#lo_addr(_solicitudPyloadRS485), W11
	MOV	#lo_addr(_solicitudCabeceraRS485), W10
	CALL	_ProcesarSolicitud
;SensorNivel.c,628 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,629 :: 		}
L_UART1Interrupt76:
;SensorNivel.c,630 :: 		}
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
