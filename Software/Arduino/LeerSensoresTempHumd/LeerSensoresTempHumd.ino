#include <Wire.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include "DHT.h"
#include <EEPROM.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define DHTPIN 2 
#define DSPIN 9 
#define DHTTYPE DHT22
#define RZERO 1459

// Pin donde se conecta el bus 1-Wire:
//const int pinDatosDQ = 9;

//Variables:
int tempDHT;
int humdDHT;
float tempDS;

int opcion = 1;
boolean ban1 = 0;

byte tempDHT_max;
byte tempDHT_min;
byte humdDHT_max;
byte humdDHT_min;
byte tempDS_max;
byte tempDS_min;
byte Direccion=0;

String Datos;

//Instancias:
//Display y DHT22:
Adafruit_PCD8544 display = Adafruit_PCD8544(7, 6, 5, 4, 3);
DHT dht(DHTPIN, DHTTYPE);
//OneWire y DallasTemperature:
//OneWire oneWireObjeto(pinDatosDQ);
OneWire oneWireObjeto(DSPIN);
DallasTemperature sensorDS18B20(&oneWireObjeto);

void setup() {
  
  Serial.begin(9600);
  display.begin();
  dht.begin();
  sensorDS18B20.begin();
  
  pinMode(10,INPUT);
  pinMode(11,INPUT);
  pinMode(12,INPUT);

  //Se realizan mediciones de temperatura y humedad del DHT22:
  tempDHT_max = dht.readTemperature();
  tempDHT_min = dht.readTemperature();
  humdDHT_max = dht.readHumidity();
  humdDHT_min = dht.readHumidity();
  
  //**La medicion de temperatura del DS18B20 requiere 2 bytes por ser en float. 
  //Hay que usar punteros para guardar este valor en la EEPROM. Muy complicado para ser una simple prueba.
  //sensorDS18B20.requestTemperatures();
  //tempDS_max = sensorDS18B20.getTempCByIndex(0);
  //tempDS_min = sensorDS18B20.getTempCByIndex(0);
  
  //Guarda los valores leidos en la EEPROM:  
  EEPROM.write(Direccion,tempDHT_max);
  EEPROM.write(Direccion+1,tempDHT_min);
  EEPROM.write(Direccion+2,humdDHT_max);
  EEPROM.write(Direccion+3,humdDHT_min);
      
  display.setContrast(50);
   
}

void Portada(int tDHT, int hDHT, float tDS){
	
//Imprime en el display los valores actuales del DHT22 y del DS18B20:  

  String temp_act = " "+String(tDHT)+ " C";
  String humd_act = " "+String(hDHT)+ " %";
  String tempDS_act = " "+String(tDS)+ " C";
   
  display.setTextSize(1);
  
  display.setCursor(0,5);
  display.setTextColor(WHITE, BLACK);
  display.print(" Temp DHT:");
  display.setTextColor(BLACK);
  display.println(temp_act);
  
  display.setCursor(0,15);
  display.setTextColor(WHITE, BLACK);
  display.print(" Humd DHT:");
  display.setTextColor(BLACK);
  display.println(humd_act);
  
  display.setCursor(0,25);
  display.setTextColor(WHITE, BLACK);
  display.print(" Temp DS:");
  display.setTextColor(BLACK);
  display.println(tempDS_act);
      
  display.display();
  display.clearDisplay();   // clears the screen and buffer
  
}

void DisplayTemperatura(int t, int t_max, int t_min){
	
//Imprime en el display la temperatura actual, la maxima y la minima

  String temp_act = " "+String(t)+ " C";
  String temp_max = " "+String(t_max)+ " C";
  String temp_min = " "+String(t_min)+ " C";
  
  display.setTextSize(1);
  display.setCursor(4,5);
  display.setTextColor(WHITE, BLACK);
  display.print(" Temperatura DHT22 ");
  display.setCursor(0,15);
  display.setTextColor(WHITE, BLACK);
  display.print(" act: ");
  display.setTextColor(BLACK);
  display.println(temp_act);
  display.setCursor(0,25);
  display.setTextColor(WHITE, BLACK);
  display.print(" max: ");
  display.setTextColor(BLACK);
  display.println(temp_max); 
  display.setCursor(0,35);
  display.setTextColor(WHITE, BLACK);
  display.print(" min: ");
  display.setTextColor(BLACK);
  display.println(temp_min); 

  display.display();
  display.clearDisplay();   // clears the screen and buffer
  
}

void DisplayHumedad(int h_act, int h_max, int h_min){
	
//Imprime en el display la temperatura actual, la maxima y la minima

  String hmd_act = " "+String(h_act)+ " %";
  String hmd_max = " "+String(h_max)+ " %";
  String hmd_min = " "+String(h_min)+ " %";
  
  display.setTextSize(1);
  display.setCursor(14,5);
  display.setTextColor(WHITE, BLACK);
  display.print(" Humedad DHT22 ");
  display.setCursor(0,15);
  display.setTextColor(WHITE, BLACK);
  display.print(" act: ");
  display.setTextColor(BLACK);
  display.println(hmd_act);
  display.setCursor(0,25);
  display.setTextColor(WHITE, BLACK);
  display.print(" max: ");
  display.setTextColor(BLACK);
  display.println(hmd_max); 
  display.setCursor(0,35);
  display.setTextColor(WHITE, BLACK);
  display.print(" min: ");
  display.setTextColor(BLACK);
  display.println(hmd_min); 

  display.display();
  display.clearDisplay();   // clears the screen and buffer
  
}

void DisplayTemperaturaDS18B20(float t_act, float t_max, float t_min){
	
//Imprime en el display la temperatura actual, la maxima y la minima

  String temp_act = " "+String(t_act)+ " C";
  String temp_max = " "+String(t_max)+ " C";
  String temp_min = " "+String(t_min)+ " C";
  
  display.setTextSize(1);
  display.setCursor(4,5);
  display.setTextColor(WHITE, BLACK);
  display.print(" Temperatura DS18B20 ");
  display.setCursor(0,15);
  display.setTextColor(WHITE, BLACK);
  display.print(" act: ");
  display.setTextColor(BLACK);
  display.println(temp_act);
  display.setCursor(0,25);
  display.setTextColor(WHITE, BLACK);
  display.print(" max: ");
  display.setTextColor(BLACK);
  display.println(temp_max); 
  display.setCursor(0,35);
  display.setTextColor(WHITE, BLACK);
  display.print(" min: ");
  display.setTextColor(BLACK);
  display.println(temp_min); 

  display.display();
  display.clearDisplay();   // clears the screen and buffer
  
}


void Comunicacion(int t, int hm){

  String C_temp;
  String C_humd;
  String C_nh3;

  //Normaliza el formato de los datos en 2 digitos (00-99):
  if (t <= 9){
    C_temp = "0"+String(t);  
  }else{
    C_temp = String(t);
  }
  if (hm <= 9){
    C_humd = "0"+String(hm);  
  }else{
    C_humd = String(hm);
  }
    
  Datos=String(C_temp)+String(C_humd);
  Serial.println(Datos);
  delay(200);
  
}

void loop() {
//////////////////////////////////////////////////////////////////////

//Se desplaza a traves del menu de 5 elementos
  boolean menu = digitalRead(10);
  delay(50);
  
  if (menu==0 and ban1==0){
    opcion++;
    ban1 = 1;
    if (opcion>5){
      opcion=1;  
    }
  } else if (menu==1){
      ban1=0;  
  }

//////////////////////////////////////////////////////////////////////  

//Realiza una lectura del DHT22:
  tempDHT = dht.readTemperature();
  humdDHT = dht.readHumidity();
//Realiza una lectura del DS18B20:
  sensorDS18B20.requestTemperatures();
  tempDS = sensorDS18B20.getTempCByIndex(0);
  
//////////////////////////////////////////////////////////////////////

  
//////////////////////////////////////////////////////////////////////  

//Actualiza los valores maximos y minimos de temperatura y humedad del DHT22: 
  if (tempDHT>tempDHT_max){
    tempDHT_max = tempDHT;
  }
  if (tempDHT<tempDHT_min){
    tempDHT_min = tempDHT;
  }
  if (humdDHT>humdDHT_max){
    humdDHT_max = humdDHT;
  }
  if (humdDHT<humdDHT_min){
    humdDHT_min = humdDHT;
  }
//Actualiza los valores maximos y minimos de temperatura del DS18B20:
  if (tempDS>tempDS_max){
    tempDS_max = tempDS;
  }
  if (tempDS<tempDS_min){
    tempDS_min = tempDS;
  }
   
//////////////////////////////////////////////////////////////////////

//Revisa el estado del menu para visualizar la portada o cada uno de los datos  
  if (opcion == 1){
    Portada(tempDHT,humdDHT,tempDS);
  }
  else if (opcion == 2){
    DisplayTemperatura(tempDHT,tempDHT_max, tempDHT_min);
  }
  else if (opcion == 3){
    DisplayHumedad(humdDHT, humdDHT_max, humdDHT_min);
  }
  else if (opcion == 4){
    DisplayTemperaturaDS18B20(tempDS, tempDS_max, tempDS_min);
  }
    
//////////////////////////////////////////////////////////////////////
}
