//Compilar:
//gcc MedirVertedero.c -o /home/rsa/Ejecutables/medirvertedero -lbcm2835 -lwiringPi  

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>

unsigned short idVertedero;

int main(int argc, char *argv[]){
	
	idVertedero = (char)(atoi(argv[1]));
	
	switch (idVertedero){
		  case 1:
					system("sudo /home/rsa/Ejecutables/iniciarsensornivel 1");
					delay (1000);
					system("sudo /home/rsa/Ejecutables/leersensornivel 1");
					delay (1000);
					break;					
		  case 3:
					printf("hola");
					system("sudo /home/rsa/Ejecutables/iniciarsensornivel 3");
					delay (1000);
					system("sudo /home/rsa/Ejecutables/leersensornivel 3");
					delay (1000);
					break;
	}
					
	
		
}