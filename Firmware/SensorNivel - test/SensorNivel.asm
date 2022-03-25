
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
	BRA Z	L__EnviarTramaRS48596
	GOTO	L_EnviarTramaRS4850
L__EnviarTramaRS48596:
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
	BRA LTU	L__EnviarTramaRS48597
	GOTO	L_EnviarTramaRS4852
L__EnviarTramaRS48597:
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
	BRA Z	L__EnviarTramaRS48598
	GOTO	L_EnviarTramaRS4855
L__EnviarTramaRS48598:
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

;SensorNivel.c,126 :: 		void main() {
;SensorNivel.c,129 :: 		ConfiguracionPrincipal();
	PUSH	W10
	PUSH	W11
	CALL	_ConfiguracionPrincipal
;SensorNivel.c,133 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,134 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;SensorNivel.c,135 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;SensorNivel.c,136 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;SensorNivel.c,139 :: 		T2 = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;SensorNivel.c,140 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,141 :: 		TOF = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _TOF
	MOV	W1, _TOF+2
;SensorNivel.c,142 :: 		temperaturaRaw = 0;
	CLR	W0
	MOV	W0, _temperaturaRaw
;SensorNivel.c,144 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,145 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,146 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,147 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,148 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,149 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,150 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;SensorNivel.c,151 :: 		ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrNumDatosRS485
;SensorNivel.c,152 :: 		MSRS485 = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;SensorNivel.c,155 :: 		banderaPeticion = 0;
	MOV	#lo_addr(_banderaPeticion), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,158 :: 		LED1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,159 :: 		LED2 = 0;
	BCLR	LATB4_bit, BitPos(LATB4_bit+0)
;SensorNivel.c,161 :: 		ip=0;
	MOV	#lo_addr(_ip), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,164 :: 		while(1){
L_main6:
;SensorNivel.c,165 :: 		if (banderaPeticion==1){
	MOV	#lo_addr(_banderaPeticion), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main100
	GOTO	L_main8
L__main100:
;SensorNivel.c,167 :: 		ProcesarSolicitud(solicitudCabeceraRS485, solicitudPyloadRS485);
	MOV	#lo_addr(_solicitudPyloadRS485), W11
	MOV	#lo_addr(_solicitudCabeceraRS485), W10
	CALL	_ProcesarSolicitud
;SensorNivel.c,169 :: 		}
L_main8:
;SensorNivel.c,171 :: 		CapturarMuestras();
	CALL	_CapturarMuestras
;SensorNivel.c,172 :: 		Delay_ms(500);
	MOV	#102, W8
	MOV	#47563, W7
L_main9:
	DEC	W7
	BRA NZ	L_main9
	DEC	W8
	BRA NZ	L_main9
	NOP
;SensorNivel.c,175 :: 		}
	GOTO	L_main6
;SensorNivel.c,178 :: 		}
L_end_main:
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;SensorNivel.c,186 :: 		void ConfiguracionPrincipal(){
;SensorNivel.c,189 :: 		CLKDIVbits.PLLPRE = 0;                                                     //PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,190 :: 		PLLFBD = 38;                                                               //PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
	MOV	#38, W0
	MOV	WREG, PLLFBD
;SensorNivel.c,191 :: 		CLKDIVbits.PLLPOST = 0;                                                    //PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,194 :: 		AD1PCFGL = 0xFFFD;                                                         //Configura el puerto AN1 como entrada analogica y todas las demas como digitales
	MOV	#65533, W0
	MOV	WREG, AD1PCFGL
;SensorNivel.c,195 :: 		TRISA1_bit = 1;                                                            //Establece el pin RA1 como entrada
	BSET	TRISA1_bit, BitPos(TRISA1_bit+0)
;SensorNivel.c,196 :: 		TRISB = 0xFF40;                                                            //TRISB = 11111111 01000000
	MOV	#65344, W0
	MOV	WREG, TRISB
;SensorNivel.c,197 :: 		MSRS485_Direction = 0;                                                     //MSRS485 out
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;SensorNivel.c,198 :: 		LED1_Direction = 0;                                                        //LED1 out
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;SensorNivel.c,199 :: 		LED2_Direction = 0;                                                        //LED2 out
	BCLR	TRISB4_bit, BitPos(TRISB4_bit+0)
;SensorNivel.c,201 :: 		AD1CON1.AD12B = 0;                                                         //Configura el ADC en modo de 10 bits
	BCLR	AD1CON1, #10
;SensorNivel.c,202 :: 		AD1CON1bits.FORM = 0x00;                                                   //Formato de la canversion: 00->(0_1023)|01->(-512_511)|02->(0_0.999)|03->(-1_0.999)
	MOV	AD1CON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON1bits
;SensorNivel.c,203 :: 		AD1CON1.SIMSAM = 0;                                                        //0 -> Muestrea multiples canales individualmente en secuencia
	BCLR	AD1CON1, #3
;SensorNivel.c,204 :: 		AD1CON1.ADSIDL = 0;                                                        //Continua con la operacion del modulo durante el modo desocupado
	BCLR	AD1CON1, #13
;SensorNivel.c,205 :: 		AD1CON1.ASAM = 1;                                                          //Muestreo automatico
	BSET	AD1CON1, #2
;SensorNivel.c,206 :: 		AD1CON1bits.SSRC = 0x00;                                                   //Conversion manual
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#31, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(AD1CON1bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,207 :: 		AD1CON2bits.VCFG = 0;                                                      //Selecciona AVDD y AVSS como fuentes de voltaje de referencia
	MOV	AD1CON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,208 :: 		AD1CON2bits.CHPS = 0;                                                      //Selecciona unicamente el canal CH0
	MOV	AD1CON2bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, AD1CON2bits
;SensorNivel.c,209 :: 		AD1CON2.CSCNA = 0;                                                         //No escanea las entradas de CH0 durante la Muestra A
	BCLR	AD1CON2, #10
;SensorNivel.c,210 :: 		AD1CON2.BUFM = 0;                                                          //Bit de seleccion del modo de relleno del bufer, 0 -> Siempre comienza a llenar el buffer desde el principio
	BCLR	AD1CON2, #1
;SensorNivel.c,211 :: 		AD1CON2.ALTS = 0x00;                                                       //Utiliza siempre la seleccion de entrada de canal para la muestra A
	BCLR	AD1CON2, #0
;SensorNivel.c,212 :: 		AD1CON3.ADRC = 0;                                                          //Selecciona el reloj de conversion del ADC derivado del reloj del sistema
	BCLR	AD1CON3, #15
;SensorNivel.c,213 :: 		AD1CON3bits.ADCS = 0x02;                                                   //Configura el periodo del reloj del ADC fijando el valor de los bits ADCS segun la formula: TAD = TCY*(ADCS+1) = 75ns  -> ADCS = 2
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
;SensorNivel.c,214 :: 		AD1CON3bits.SAMC = 0x02;                                                   //Auto Sample Time bits, 2 -> 2*TAD (minimo periodo de muestreo para 10 bits)
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CON3bits
;SensorNivel.c,215 :: 		AD1CHS0.CH0NB = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #15
;SensorNivel.c,216 :: 		AD1CHS0bits.CH0SB = 0x01;                                                  //Channel 0 positive input is AN1
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, AD1CHS0bits
;SensorNivel.c,217 :: 		AD1CHS0.CH0NA = 0;                                                         //Channel 0 negative input is VREF-
	BCLR	AD1CHS0, #7
;SensorNivel.c,218 :: 		AD1CHS0bits.CH0SA = 0x01;                                                  //Channel 0 positive input is AN1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(AD1CHS0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(AD1CHS0bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,219 :: 		AD1CHS123 = 0;                                                             //AD1CHS123: ADC1 INPUT CHANNEL 1, 2, 3 SELECT REGISTER
	CLR	AD1CHS123
;SensorNivel.c,220 :: 		AD1CSSL = 0x00;                                                            //Se salta todos los puertos ANx para los escaneos de entrada
	CLR	AD1CSSL
;SensorNivel.c,221 :: 		AD1CON1.ADON = 1;                                                          //Enciende el modulo ADC
	BSET	AD1CON1, #15
;SensorNivel.c,224 :: 		T1CON = 0x8000;                                                            //Habilita el TMR1, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T1CON
;SensorNivel.c,225 :: 		IEC0.T1IE = 1;                                                             //Habilita la interrupcion por desborde de TMR1
	BSET	IEC0, #3
;SensorNivel.c,226 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,227 :: 		PR1 = 200;                                                                 //Genera una interrupcion cada 5us (Fs=200KHz)
	MOV	#200, W0
	MOV	WREG, PR1
;SensorNivel.c,228 :: 		T1CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T1CON, #15
;SensorNivel.c,231 :: 		T2CON = 0x8000;                                                            //Habilita el TMR2, selecciona el reloj interno, desabilita el modo Gated Timer, selecciona el preescalador 1:1,
	MOV	#32768, W0
	MOV	WREG, T2CON
;SensorNivel.c,232 :: 		IEC0.T2IE = 1;                                                             //Habilita la interrupcion por desborde de TMR2
	BSET	IEC0, #7
;SensorNivel.c,233 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,234 :: 		PR2 = 500;                                                                 //Genera una interrupcion cada 12.5us
	MOV	#500, W0
	MOV	WREG, PR2
;SensorNivel.c,235 :: 		T2CON.TON = 0;                                                             //Apaga la interrupcion
	BCLR	T2CON, #15
;SensorNivel.c,238 :: 		RPINR18bits.U1RXR = 0x06;                                                  //Asisgna Rx a RP6
	MOV.B	#6, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;SensorNivel.c,239 :: 		RPOR3bits.RP7R = 0x03;                                                     //Asigna Tx a RP7
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR3bits
;SensorNivel.c,240 :: 		IEC0.U1RXIE = 1;                                                           //Habilita la interrupcion por recepcion de dato por UART
	BSET	IEC0, #11
;SensorNivel.c,241 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,242 :: 		UART1_Init(19200);                                                         //Inicializa el modulo UART a 9600 bps
	MOV	#19200, W10
	MOV	#0, W11
	CALL	_UART1_Init
;SensorNivel.c,245 :: 		IPC0bits.T1IP = 0x07;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR1
	MOV	IPC0bits, W1
	MOV	#28672, W0
	IOR	W1, W0, W0
	MOV	WREG, IPC0bits
;SensorNivel.c,246 :: 		IPC1bits.T2IP = 0x06;                                                      //Nivel de prioridad de la interrupcion por desbordamiento del TMR2
	MOV	#24576, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;SensorNivel.c,247 :: 		IPC2bits.U1RXIP = 0x05;                                                    //Nivel de prioridad de la interrupcion UARTRX
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;SensorNivel.c,249 :: 		Delay_ms(100);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#21, W8
	MOV	#22619, W7
L_ConfiguracionPrincipal11:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal11
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal11
;SensorNivel.c,251 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_ProcesarSolicitud:
	LNK	#8

;SensorNivel.c,256 :: 		void ProcesarSolicitud(unsigned char *cabeceraSolicitud, unsigned char *payloadSolicitud){
;SensorNivel.c,266 :: 		ptrNumDatosResp = (unsigned char *) & numDatosResp;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #2, W0
; ptrNumDatosResp start address is: 18 (W9)
	MOV	W0, W9
;SensorNivel.c,267 :: 		ptrDatoInt = (unsigned char *) & datoInt;
	ADD	W14, #0, W0
; ptrDatoInt start address is: 4 (W2)
	MOV	W0, W2
;SensorNivel.c,268 :: 		ptrDatoFloat = (unsigned char *) & datoFloat;
	ADD	W14, #4, W0
; ptrDatoFloat start address is: 6 (W3)
	MOV	W0, W3
;SensorNivel.c,271 :: 		funcionSolicitud = cabeceraSolicitud[1];
	ADD	W10, #1, W0
; funcionSolicitud start address is: 2 (W1)
	MOV.B	[W0], W1
;SensorNivel.c,272 :: 		subFuncionSolicitud = cabeceraSolicitud[2];
	ADD	W10, #2, W0
; subFuncionSolicitud start address is: 0 (W0)
	MOV.B	[W0], W0
;SensorNivel.c,274 :: 		switch (funcionSolicitud){
	GOTO	L_ProcesarSolicitud13
; ptrNumDatosResp end address is: 18 (W9)
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
; funcionSolicitud end address is: 2 (W1)
;SensorNivel.c,275 :: 		case 1:
L_ProcesarSolicitud15:
;SensorNivel.c,276 :: 		switch (subFuncionSolicitud){
	GOTO	L_ProcesarSolicitud16
; subFuncionSolicitud end address is: 0 (W0)
;SensorNivel.c,277 :: 		case 1:
L_ProcesarSolicitud18:
;SensorNivel.c,279 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,281 :: 		break;
	GOTO	L_ProcesarSolicitud17
;SensorNivel.c,282 :: 		case 2:
L_ProcesarSolicitud19:
;SensorNivel.c,284 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,285 :: 		CapturarMuestras();
	CALL	_CapturarMuestras
;SensorNivel.c,286 :: 		break;
	GOTO	L_ProcesarSolicitud17
;SensorNivel.c,287 :: 		case 3:
L_ProcesarSolicitud20:
;SensorNivel.c,289 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,290 :: 		ProbarMuestreo();
	CALL	_ProbarMuestreo
;SensorNivel.c,291 :: 		break;
	GOTO	L_ProcesarSolicitud17
;SensorNivel.c,293 :: 		case 4:
L_ProcesarSolicitud21:
;SensorNivel.c,295 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,296 :: 		ProbarEnvioTrama();
	CALL	_ProbarEnvioTrama
;SensorNivel.c,297 :: 		break;
	GOTO	L_ProcesarSolicitud17
;SensorNivel.c,298 :: 		default:
L_ProcesarSolicitud22:
;SensorNivel.c,300 :: 		temperaturaRaw = LeerDS18B20();
	CALL	_LeerDS18B20
	MOV	W0, _temperaturaRaw
;SensorNivel.c,302 :: 		break;
	GOTO	L_ProcesarSolicitud17
;SensorNivel.c,303 :: 		}
L_ProcesarSolicitud16:
; subFuncionSolicitud start address is: 0 (W0)
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitud104
	GOTO	L_ProcesarSolicitud18
L__ProcesarSolicitud104:
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud105
	GOTO	L_ProcesarSolicitud19
L__ProcesarSolicitud105:
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud106
	GOTO	L_ProcesarSolicitud20
L__ProcesarSolicitud106:
	CP.B	W0, #4
	BRA NZ	L__ProcesarSolicitud107
	GOTO	L_ProcesarSolicitud21
L__ProcesarSolicitud107:
; subFuncionSolicitud end address is: 0 (W0)
	GOTO	L_ProcesarSolicitud22
L_ProcesarSolicitud17:
;SensorNivel.c,304 :: 		break;
	GOTO	L_ProcesarSolicitud14
;SensorNivel.c,305 :: 		case 2:
L_ProcesarSolicitud23:
;SensorNivel.c,308 :: 		switch (subFuncionSolicitud){
; subFuncionSolicitud start address is: 0 (W0)
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	GOTO	L_ProcesarSolicitud24
; subFuncionSolicitud end address is: 0 (W0)
;SensorNivel.c,309 :: 		case 1:
L_ProcesarSolicitud26:
;SensorNivel.c,312 :: 		datoInt = temperaturaRaw;
	MOV	_temperaturaRaw, W0
	MOV	W0, [W14+0]
;SensorNivel.c,313 :: 		datoFloat = TOF;
	MOV	_TOF, W0
	MOV	_TOF+2, W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;SensorNivel.c,314 :: 		respuestaPyloadRS485[0] = *(ptrDatoFloat);
	MOV.B	[W3], W1
	MOV	#lo_addr(_respuestaPyloadRS485), W0
	MOV.B	W1, [W0]
;SensorNivel.c,315 :: 		respuestaPyloadRS485[1] = *(ptrDatoFloat+1);
	ADD	W3, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+1), W0
	MOV.B	W1, [W0]
;SensorNivel.c,316 :: 		respuestaPyloadRS485[2] = *(ptrDatoFloat+2);
	ADD	W3, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+2), W0
	MOV.B	W1, [W0]
;SensorNivel.c,317 :: 		respuestaPyloadRS485[3] = *(ptrDatoFloat+3);
	ADD	W3, #3, W0
; ptrDatoFloat end address is: 6 (W3)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+3), W0
	MOV.B	W1, [W0]
;SensorNivel.c,318 :: 		respuestaPyloadRS485[4] = *(ptrDatoInt);
	MOV.B	[W2], W1
	MOV	#lo_addr(_respuestaPyloadRS485+4), W0
	MOV.B	W1, [W0]
;SensorNivel.c,319 :: 		respuestaPyloadRS485[5] = *(ptrDatoInt+1);
	ADD	W2, #1, W0
; ptrDatoInt end address is: 4 (W2)
	MOV.B	[W0], W1
	MOV	#lo_addr(_respuestaPyloadRS485+5), W0
	MOV.B	W1, [W0]
;SensorNivel.c,321 :: 		numDatosResp = 6;
	MOV	#6, W0
	MOV	W0, [W14+2]
;SensorNivel.c,322 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,323 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,324 :: 		EnviarTramaRS485(1, cabeceraSolicitud, respuestaPyloadRS485);
	MOV	#lo_addr(_respuestaPyloadRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,325 :: 		break;
	GOTO	L_ProcesarSolicitud25
;SensorNivel.c,326 :: 		case 2:
L_ProcesarSolicitud27:
;SensorNivel.c,329 :: 		numDatosResp = 702;
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#702, W0
	MOV	W0, [W14+2]
;SensorNivel.c,330 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,331 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,332 :: 		EnviarTramaInt(cabeceraSolicitud, temperaturaRaw);
	MOV	_temperaturaRaw, W11
	CALL	_EnviarTramaInt
;SensorNivel.c,333 :: 		break;
	GOTO	L_ProcesarSolicitud25
;SensorNivel.c,334 :: 		}
L_ProcesarSolicitud24:
; subFuncionSolicitud start address is: 0 (W0)
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitud108
	GOTO	L_ProcesarSolicitud26
L__ProcesarSolicitud108:
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud109
	GOTO	L_ProcesarSolicitud27
L__ProcesarSolicitud109:
; ptrNumDatosResp end address is: 18 (W9)
; subFuncionSolicitud end address is: 0 (W0)
L_ProcesarSolicitud25:
;SensorNivel.c,335 :: 		break;
	GOTO	L_ProcesarSolicitud14
;SensorNivel.c,336 :: 		case 4:
L_ProcesarSolicitud28:
;SensorNivel.c,338 :: 		switch (subFuncionSolicitud){
; subFuncionSolicitud start address is: 0 (W0)
; ptrNumDatosResp start address is: 18 (W9)
	GOTO	L_ProcesarSolicitud29
; subFuncionSolicitud end address is: 0 (W0)
;SensorNivel.c,339 :: 		case 2:
L_ProcesarSolicitud31:
;SensorNivel.c,342 :: 		numDatosResp = 10;
	MOV	#10, W0
	MOV	W0, [W14+2]
;SensorNivel.c,343 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,344 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,345 :: 		EnviarTramaRS485(1, cabeceraSolicitud, tramaPruebaRS485);
	MOV	#lo_addr(_tramaPruebaRS485), W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;SensorNivel.c,346 :: 		break;
	GOTO	L_ProcesarSolicitud30
;SensorNivel.c,347 :: 		case 3:
L_ProcesarSolicitud32:
;SensorNivel.c,350 :: 		numDatosResp = 512;
; ptrNumDatosResp start address is: 18 (W9)
	MOV	#512, W0
	MOV	W0, [W14+2]
;SensorNivel.c,351 :: 		cabeceraSolicitud[3] = *(ptrNumDatosResp);
	ADD	W10, #3, W0
	MOV.B	[W9], [W0]
;SensorNivel.c,352 :: 		cabeceraSolicitud[4] = *(ptrNumDatosResp+1);
	ADD	W10, #4, W1
	ADD	W9, #1, W0
; ptrNumDatosResp end address is: 18 (W9)
	MOV.B	[W0], [W1]
;SensorNivel.c,353 :: 		GenerarTramaPrueba(numDatosResp, cabeceraSolicitud);
	MOV	W10, W11
	MOV	[W14+2], W10
	CALL	_GenerarTramaPrueba
;SensorNivel.c,354 :: 		break;
	GOTO	L_ProcesarSolicitud30
;SensorNivel.c,355 :: 		}
L_ProcesarSolicitud29:
; subFuncionSolicitud start address is: 0 (W0)
; ptrNumDatosResp start address is: 18 (W9)
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitud110
	GOTO	L_ProcesarSolicitud31
L__ProcesarSolicitud110:
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitud111
	GOTO	L_ProcesarSolicitud32
L__ProcesarSolicitud111:
; ptrNumDatosResp end address is: 18 (W9)
; subFuncionSolicitud end address is: 0 (W0)
L_ProcesarSolicitud30:
;SensorNivel.c,356 :: 		break;
	GOTO	L_ProcesarSolicitud14
;SensorNivel.c,357 :: 		}
L_ProcesarSolicitud13:
; subFuncionSolicitud start address is: 0 (W0)
; funcionSolicitud start address is: 2 (W1)
; ptrDatoFloat start address is: 6 (W3)
; ptrDatoInt start address is: 4 (W2)
; ptrNumDatosResp start address is: 18 (W9)
	CP.B	W1, #1
	BRA NZ	L__ProcesarSolicitud112
	GOTO	L_ProcesarSolicitud15
L__ProcesarSolicitud112:
	CP.B	W1, #2
	BRA NZ	L__ProcesarSolicitud113
	GOTO	L_ProcesarSolicitud23
L__ProcesarSolicitud113:
; ptrDatoInt end address is: 4 (W2)
; ptrDatoFloat end address is: 6 (W3)
	CP.B	W1, #4
	BRA NZ	L__ProcesarSolicitud114
	GOTO	L_ProcesarSolicitud28
L__ProcesarSolicitud114:
; ptrNumDatosResp end address is: 18 (W9)
; funcionSolicitud end address is: 2 (W1)
; subFuncionSolicitud end address is: 0 (W0)
L_ProcesarSolicitud14:
;SensorNivel.c,359 :: 		banderaPeticion = 0;
	MOV	#lo_addr(_banderaPeticion), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,361 :: 		}
L_end_ProcesarSolicitud:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _ProcesarSolicitud

_GenerarTramaPrueba:
	LNK	#516

;SensorNivel.c,366 :: 		void GenerarTramaPrueba(unsigned int numDatosPrueba, unsigned char *cabeceraPrueba){
;SensorNivel.c,368 :: 		unsigned int contadorMuestras = 0;
	PUSH	W12
; contadorMuestras start address is: 4 (W2)
	CLR	W2
;SensorNivel.c,372 :: 		for (j=0;j<numDatosPrueba;j++){
	CLR	W0
	MOV	W0, _j
; contadorMuestras end address is: 4 (W2)
L_GenerarTramaPrueba33:
; contadorMuestras start address is: 4 (W2)
	MOV	#lo_addr(_j), W0
	CP	W10, [W0]
	BRA GTU	L__GenerarTramaPrueba116
	GOTO	L_GenerarTramaPrueba34
L__GenerarTramaPrueba116:
;SensorNivel.c,373 :: 		outputPyloadRS485[j] = contadorMuestras;
	ADD	W14, #0, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;SensorNivel.c,374 :: 		contadorMuestras++;
	ADD	W2, #1, W1
	MOV	W1, W2
;SensorNivel.c,375 :: 		if (contadorMuestras>255) {
	MOV	#255, W0
	CP	W1, W0
	BRA GTU	L__GenerarTramaPrueba117
	GOTO	L__GenerarTramaPrueba81
L__GenerarTramaPrueba117:
;SensorNivel.c,376 :: 		contadorMuestras = 0;
	CLR	W2
; contadorMuestras end address is: 4 (W2)
;SensorNivel.c,377 :: 		}
	GOTO	L_GenerarTramaPrueba36
L__GenerarTramaPrueba81:
;SensorNivel.c,375 :: 		if (contadorMuestras>255) {
;SensorNivel.c,377 :: 		}
L_GenerarTramaPrueba36:
;SensorNivel.c,372 :: 		for (j=0;j<numDatosPrueba;j++){
; contadorMuestras start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,378 :: 		}
; contadorMuestras end address is: 4 (W2)
	GOTO	L_GenerarTramaPrueba33
L_GenerarTramaPrueba34:
;SensorNivel.c,380 :: 		EnviarTramaRS485(1, cabeceraPrueba, outputPyloadRS485);
	ADD	W14, #0, W0
	PUSH	W10
	MOV	W0, W12
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
	POP	W10
;SensorNivel.c,382 :: 		}
L_end_GenerarTramaPrueba:
	POP	W12
	ULNK
	RETURN
; end of _GenerarTramaPrueba

_LeerDS18B20:

;SensorNivel.c,387 :: 		unsigned int LeerDS18B20(){
;SensorNivel.c,391 :: 		LED1 = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,394 :: 		Ow_Reset(&PORTA, 0);                                                       //Onewire reset signal
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,395 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,396 :: 		Ow_Write(&PORTA, 0, 0x44);                                                 //Issue command CONVERT_T
	MOV.B	#68, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,397 :: 		Delay_ms(750);
	MOV	#153, W8
	MOV	#38577, W7
L_LeerDS18B2037:
	DEC	W7
	BRA NZ	L_LeerDS18B2037
	DEC	W8
	BRA NZ	L_LeerDS18B2037
	NOP
	NOP
;SensorNivel.c,398 :: 		Ow_Reset(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Reset
;SensorNivel.c,399 :: 		Ow_Write(&PORTA, 0, 0xCC);                                                 //Issue command SKIP_ROM
	MOV.B	#204, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,400 :: 		Ow_Write(&PORTA, 0, 0xBE);                                                 //Issue command READ_SCRATCHPAD
	MOV.B	#190, W12
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Write
;SensorNivel.c,401 :: 		Delay_us(100);
	MOV	#1333, W7
L_LeerDS18B2039:
	DEC	W7
	BRA NZ	L_LeerDS18B2039
	NOP
;SensorNivel.c,402 :: 		temp = Ow_Read(&PORTA, 0);
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
; temp start address is: 10 (W5)
	ZE	W0, W5
;SensorNivel.c,403 :: 		temp = (Ow_Read(&PORTA, 0) << 8) + temp;
	CLR	W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Ow_Read
	ZE	W0, W0
	SL	W0, #8, W0
	ADD	W0, W5, W0
; temp end address is: 10 (W5)
;SensorNivel.c,405 :: 		LED1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,409 :: 		return temperaturaCrudo;
;SensorNivel.c,411 :: 		}
;SensorNivel.c,409 :: 		return temperaturaCrudo;
;SensorNivel.c,411 :: 		}
L_end_LeerDS18B20:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _LeerDS18B20

_ProbarEnvioTrama:

;SensorNivel.c,415 :: 		void ProbarEnvioTrama(){
;SensorNivel.c,417 :: 		LED1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,419 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,420 :: 		while (i<numeroMuestras){
L_ProbarEnvioTrama41:
	MOV	_i, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__ProbarEnvioTrama120
	GOTO	L_ProbarEnvioTrama42
L__ProbarEnvioTrama120:
;SensorNivel.c,421 :: 		vectorMuestras[j] = 500;                                           //Almacena el valor actual de la conversion del ADC en el vectorMuestras
	MOV	_j, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W1
	MOV	#500, W0
	MOV	W0, [W1]
;SensorNivel.c,422 :: 		i++;                                                                    //Aumenta en 1 el subindice del vector de Muestras
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,423 :: 		}
	GOTO	L_ProbarEnvioTrama41
L_ProbarEnvioTrama42:
;SensorNivel.c,425 :: 		LED1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,426 :: 		delay_ms(200);
	MOV	#41, W8
	MOV	#45239, W7
L_ProbarEnvioTrama43:
	DEC	W7
	BRA NZ	L_ProbarEnvioTrama43
	DEC	W8
	BRA NZ	L_ProbarEnvioTrama43
;SensorNivel.c,427 :: 		LED1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,428 :: 		delay_ms(200);
	MOV	#41, W8
	MOV	#45239, W7
L_ProbarEnvioTrama45:
	DEC	W7
	BRA NZ	L_ProbarEnvioTrama45
	DEC	W8
	BRA NZ	L_ProbarEnvioTrama45
;SensorNivel.c,429 :: 		LED1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,431 :: 		}
L_end_ProbarEnvioTrama:
	RETURN
; end of _ProbarEnvioTrama

_ProbarMuestreo:

;SensorNivel.c,435 :: 		void ProbarMuestreo(){
;SensorNivel.c,437 :: 		LED1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,439 :: 		TMR1 = 0;                                                                  //Encera el TMR1
	CLR	TMR1
;SensorNivel.c,440 :: 		T1CON.TON = 1;                                                             //Enciende el TMR1
	BSET	T1CON, #15
;SensorNivel.c,441 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,442 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,443 :: 		while(bm!=1);
L_ProbarMuestreo47:
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__ProbarMuestreo122
	GOTO	L_ProbarMuestreo48
L__ProbarMuestreo122:
	GOTO	L_ProbarMuestreo47
L_ProbarMuestreo48:
;SensorNivel.c,445 :: 		LED1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,447 :: 		}
L_end_ProbarMuestreo:
	RETURN
; end of _ProbarMuestreo

_CapturarMuestras:

;SensorNivel.c,452 :: 		void CapturarMuestras(){
;SensorNivel.c,454 :: 		LED1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,457 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,458 :: 		contPulsos = 0;                                                            //Limpia la variable del contador de pulsos
	CLR	W0
	MOV	W0, _contPulsos
;SensorNivel.c,459 :: 		RB2_bit = 0;                                                               //Limpia el pin que produce los pulsos de exitacion del transductor
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,460 :: 		T1CON.TON = 0;                                                             //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,461 :: 		TMR2 = 0;                                                                  //Encera el TMR2
	CLR	TMR2
;SensorNivel.c,462 :: 		T2CON.TON = 1;                                                             //Enciende el TMR2
	BSET	T2CON, #15
;SensorNivel.c,463 :: 		i = 0;                                                                     //Limpia las variables asociadas al almacenamiento de la senal muestreada
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,464 :: 		while(bm!=1);
L_CapturarMuestras49:
	MOV	#lo_addr(_bm), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__CapturarMuestras124
	GOTO	L_CapturarMuestras50
L__CapturarMuestras124:
	GOTO	L_CapturarMuestras49
L_CapturarMuestras50:
;SensorNivel.c,466 :: 		LED1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;SensorNivel.c,468 :: 		}
L_end_CapturarMuestras:
	RETURN
; end of _CapturarMuestras

_EnviarTramaInt:
	LNK	#708

;SensorNivel.c,584 :: 		void EnviarTramaInt(unsigned char* cabecera, unsigned int temperatura){
;SensorNivel.c,592 :: 		ptrValorInt = (unsigned char *) & valorInt;
	PUSH	W12
	MOV	#706, W0
	ADD	W14, W0, W0
; ptrValorInt start address is: 8 (W4)
	MOV	W0, W4
;SensorNivel.c,593 :: 		ptrTemperatura = (unsigned char *) & temperatura;
	MOV	#lo_addr(W11), W0
; ptrTemperatura start address is: 6 (W3)
	MOV	W0, W3
;SensorNivel.c,596 :: 		for (j=0;j<numeroMuestras;j++){
	CLR	W0
	MOV	W0, _j
; ptrTemperatura end address is: 6 (W3)
L_EnviarTramaInt51:
; ptrTemperatura start address is: 6 (W3)
; ptrValorInt start address is: 8 (W4)
; ptrValorInt end address is: 8 (W4)
	MOV	_j, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaInt126
	GOTO	L_EnviarTramaInt52
L__EnviarTramaInt126:
; ptrValorInt end address is: 8 (W4)
;SensorNivel.c,597 :: 		valorInt = vectorMuestras[j];
; ptrValorInt start address is: 8 (W4)
	MOV	_j, W0
	SL	W0, #1, W2
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W2, W0
	MOV	[W0], W0
	MOV	W0, [W14+706]
;SensorNivel.c,598 :: 		tramaShort[j*2] = *(ptrValorInt);
	ADD	W14, #0, W1
	ADD	W1, W2, W0
	MOV.B	[W4], [W0]
;SensorNivel.c,599 :: 		tramaShort[(j*2)+1] = *(ptrValorInt+1);
	MOV	_j, W0
	SL	W0, #1, W0
	INC	W0
	ADD	W1, W0, W1
	ADD	W4, #1, W0
	MOV.B	[W0], [W1]
;SensorNivel.c,596 :: 		for (j=0;j<numeroMuestras;j++){
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,600 :: 		}
; ptrValorInt end address is: 8 (W4)
	GOTO	L_EnviarTramaInt51
L_EnviarTramaInt52:
;SensorNivel.c,603 :: 		tramaShort[700] = *(ptrTemperatura);
	ADD	W14, #0, W2
	MOV	#700, W0
	ADD	W2, W0, W0
	MOV.B	[W3], [W0]
;SensorNivel.c,604 :: 		tramaShort[701] = *(ptrTemperatura+1);
	MOV	#701, W0
	ADD	W2, W0, W1
	ADD	W3, #1, W0
; ptrTemperatura end address is: 6 (W3)
	MOV.B	[W0], [W1]
;SensorNivel.c,607 :: 		EnviarTramaRS485(1, cabecera, tramaShort);
	PUSH.D	W10
	MOV	W2, W12
	MOV	W10, W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
	POP.D	W10
;SensorNivel.c,609 :: 		}
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

;SensorNivel.c,617 :: 		void Timer1Interrupt() iv IVT_ADDR_T1INTERRUPT{
;SensorNivel.c,618 :: 		SAMP_bit = 0;                                                              //Limpia el bit SAMP para iniciar la conversion del ADC
	BCLR	SAMP_bit, BitPos(SAMP_bit+0)
;SensorNivel.c,619 :: 		while (!AD1CON1bits.DONE);                                                 //Espera hasta que se complete la conversion
L_Timer1Interrupt54:
	BTSC	AD1CON1bits, #0
	GOTO	L_Timer1Interrupt55
	GOTO	L_Timer1Interrupt54
L_Timer1Interrupt55:
;SensorNivel.c,620 :: 		if (i<numeroMuestras){
	MOV	_i, W1
	MOV	#350, W0
	CP	W1, W0
	BRA LTU	L__Timer1Interrupt128
	GOTO	L_Timer1Interrupt56
L__Timer1Interrupt128:
;SensorNivel.c,621 :: 		vectorMuestras[i] = ADC1BUF0;                                           //Almacena el valor actual de la conversion del ADC en el vectorMuestras
	MOV	_i, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_vectorMuestras), W0
	ADD	W0, W1, W1
	MOV	ADC1BUF0, WREG
	MOV	W0, [W1]
;SensorNivel.c,622 :: 		i++;                                                                    //Aumenta en 1 el subindice del vector de Muestras
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,623 :: 		} else {
	GOTO	L_Timer1Interrupt57
L_Timer1Interrupt56:
;SensorNivel.c,624 :: 		bm = 1;                                                                 //Cambia el valor de la bandera bm para terminar con el muestreo y dar comienzo al procesamiento de la senal
	MOV	#lo_addr(_bm), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,625 :: 		T1CON.TON = 0;                                                          //Apaga el TMR1
	BCLR	T1CON, #15
;SensorNivel.c,626 :: 		}
L_Timer1Interrupt57:
;SensorNivel.c,627 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorNivel.c,628 :: 		}
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

;SensorNivel.c,631 :: 		void Timer2Interrupt() iv IVT_ADDR_T2INTERRUPT{
;SensorNivel.c,633 :: 		if (contPulsos<10){                                                        //Controla el numero total de pulsos de exitacion del transductor ultrasonico. (
	MOV	_contPulsos, W0
	CP	W0, #10
	BRA LTU	L__Timer2Interrupt130
	GOTO	L_Timer2Interrupt58
L__Timer2Interrupt130:
;SensorNivel.c,634 :: 		RB2_bit = ~RB2_bit;                                                   //Conmuta el valor del pin RB14
	BTG	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,635 :: 		}else {
	GOTO	L_Timer2Interrupt59
L_Timer2Interrupt58:
;SensorNivel.c,636 :: 		RB2_bit = 0;                                                          //Pone a cero despues de enviar todos los pulsos de exitacion.
	BCLR	RB2_bit, BitPos(RB2_bit+0)
;SensorNivel.c,637 :: 		if (contPulsos==110){
	MOV	#110, W1
	MOV	#lo_addr(_contPulsos), W0
	CP	W1, [W0]
	BRA Z	L__Timer2Interrupt131
	GOTO	L_Timer2Interrupt60
L__Timer2Interrupt131:
;SensorNivel.c,638 :: 		T2CON.TON = 0;                                                    //Apaga el TMR2
	BCLR	T2CON, #15
;SensorNivel.c,639 :: 		TMR1 = 0;                                                         //Encera el TMR1
	CLR	TMR1
;SensorNivel.c,640 :: 		T1CON.TON = 1;                                                    //Enciende el TMR1
	BSET	T1CON, #15
;SensorNivel.c,641 :: 		bm = 0;
	MOV	#lo_addr(_bm), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,642 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;SensorNivel.c,643 :: 		}
L_Timer2Interrupt60:
;SensorNivel.c,644 :: 		}
L_Timer2Interrupt59:
;SensorNivel.c,645 :: 		contPulsos++;                                                              //Aumenta el contador en una unidad.
	MOV	#1, W1
	MOV	#lo_addr(_contPulsos), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,646 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;SensorNivel.c,648 :: 		}
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

;SensorNivel.c,651 :: 		void UART1Interrupt() iv IVT_ADDR_U1RXINTERRUPT {
;SensorNivel.c,653 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion de UARTRX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;SensorNivel.c,654 :: 		byteRS485 = UART1_Read();                                                  //Lee el byte recibido
	CALL	_UART1_Read
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	W0, [W1]
;SensorNivel.c,657 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__UART1Interrupt133
	GOTO	L_UART1Interrupt61
L__UART1Interrupt133:
;SensorNivel.c,659 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__UART1Interrupt134
	GOTO	L_UART1Interrupt62
L__UART1Interrupt134:
;SensorNivel.c,660 :: 		solicitudPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_solicitudPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,661 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,662 :: 		} else {
	GOTO	L_UART1Interrupt63
L_UART1Interrupt62:
;SensorNivel.c,663 :: 		banRSI = 0;                                                      //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,664 :: 		banRSC = 1;                                                      //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,665 :: 		}
L_UART1Interrupt63:
;SensorNivel.c,666 :: 		}
L_UART1Interrupt61:
;SensorNivel.c,669 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt135
	GOTO	L__UART1Interrupt87
L__UART1Interrupt135:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__UART1Interrupt136
	GOTO	L__UART1Interrupt86
L__UART1Interrupt136:
L__UART1Interrupt85:
;SensorNivel.c,670 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__UART1Interrupt137
	GOTO	L_UART1Interrupt67
L__UART1Interrupt137:
;SensorNivel.c,671 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,672 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,673 :: 		}
L_UART1Interrupt67:
;SensorNivel.c,669 :: 		if ((banRSI==0)&&(banRSC==0)){
L__UART1Interrupt87:
L__UART1Interrupt86:
;SensorNivel.c,675 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt138
	GOTO	L__UART1Interrupt90
L__UART1Interrupt138:
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt139
	GOTO	L__UART1Interrupt89
L__UART1Interrupt139:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__UART1Interrupt140
	GOTO	L__UART1Interrupt88
L__UART1Interrupt140:
L__UART1Interrupt84:
;SensorNivel.c,676 :: 		solicitudCabeceraRS485[i_rs485] = byteRS485;                          //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_solicitudCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,677 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;SensorNivel.c,675 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
L__UART1Interrupt90:
L__UART1Interrupt89:
L__UART1Interrupt88:
;SensorNivel.c,679 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt141
	GOTO	L__UART1Interrupt94
L__UART1Interrupt141:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__UART1Interrupt142
	GOTO	L__UART1Interrupt93
L__UART1Interrupt142:
L__UART1Interrupt83:
;SensorNivel.c,681 :: 		if ((solicitudCabeceraRS485[0]==IDNODO)||(solicitudCabeceraRS485[0]==255)){
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__UART1Interrupt143
	GOTO	L__UART1Interrupt92
L__UART1Interrupt143:
	MOV	#lo_addr(_solicitudCabeceraRS485), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__UART1Interrupt144
	GOTO	L__UART1Interrupt91
L__UART1Interrupt144:
	GOTO	L_UART1Interrupt76
L__UART1Interrupt92:
L__UART1Interrupt91:
;SensorNivel.c,683 :: 		*(ptrNumDatosRS485) = solicitudCabeceraRS485[3];
	MOV	#lo_addr(_solicitudCabeceraRS485+3), W1
	MOV	_ptrNumDatosRS485, W0
	MOV.B	[W1], [W0]
;SensorNivel.c,684 :: 		*(ptrNumDatosRS485+1) = solicitudCabeceraRS485[4];
	MOV	_ptrNumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_solicitudCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;SensorNivel.c,685 :: 		i_rs485 = 0;                                                     //Encera el subindice para almacenar el payload
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,686 :: 		banRSI = 2;                                                      //Cambia el valor de la bandera para salir del bucle
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;SensorNivel.c,687 :: 		} else {
	GOTO	L_UART1Interrupt77
L_UART1Interrupt76:
;SensorNivel.c,688 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,689 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,690 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;SensorNivel.c,691 :: 		}
L_UART1Interrupt77:
;SensorNivel.c,679 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__UART1Interrupt94:
L__UART1Interrupt93:
;SensorNivel.c,695 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__UART1Interrupt145
	GOTO	L_UART1Interrupt78
L__UART1Interrupt145:
;SensorNivel.c,696 :: 		Delay_ms(100);                                                        //**Ojo: Este retardo es importante para que el Concentrador tenga tiempo de recibir la respuesta
	MOV	#21, W8
	MOV	#22619, W7
L_UART1Interrupt79:
	DEC	W7
	BRA NZ	L_UART1Interrupt79
	DEC	W8
	BRA NZ	L_UART1Interrupt79
;SensorNivel.c,700 :: 		banderaPeticion = 1;
	MOV	#lo_addr(_banderaPeticion), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;SensorNivel.c,702 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;SensorNivel.c,703 :: 		}
L_UART1Interrupt78:
;SensorNivel.c,704 :: 		}
L_end_UART1Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _UART1Interrupt
