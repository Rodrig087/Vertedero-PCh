//Compilar:
//gcc MedirVertedero.c -o /home/rsa/Ejecutables/medirvertedero -lbcm2835 -lwiringPi  

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>


int main(void) {
	
	system("sudo /home/rsa/Ejecutables/iniciarmedicion 2");
	delay (1000);
	system("sudo /home/rsa/Ejecutables/inspeccionarultrasonido");
	delay (1000);
		
}