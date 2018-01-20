// Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

#include <NewPing.h>
#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <OSCBundle.h>
#include <OSCBoards.h>

int pinI1=D0;//define I1 port  // GPIO16
int pinI2=D1;//define I2 port  // GPIO5
int speedpin=D2;//define EA(PWM speed regulation)port  // GPIO4
int pinI3=D5;//define I1 port  // GPIO14
int pinI4=D6;//define I2 port  // GPIO12
int speedpin1=D7;//define EA(PWM speed regulation)port // GPIO13
int powerS = 980;
int powerD = 1020;
#define TRIGGER D3 // GPIO0
#define ECHO D4 // GPIO2
NewPing sonar(TRIGGER, ECHO, 400);


int dist=0;
int giroD=0;
int giroS=0;
int modalita = 0;
int giri180deg= 8;
int maxDistanzaSchermo= 1200;
int maxGiri=50;

boolean mod=false;

//boolean receivedRoute= false;
int lungArray;
int angle;
int distance;
int distanzaGiri;
int angoloGiri;
boolean checkDist=false;

/*const String ssid="OnePlus 5T";
const String pass="12345678";*/

const String ssid="FASTWEB-1-Scara";
const String pass="SCARAnet@456";

/*const String ssid="noah-HP-15-Notebook-PC";
const String pass="BJkd9jw4";

/*const String ssid="HUAWEI P8 lite 2017";
const String pass="ciaonoah123";*/

const byte MAX_MSG_SIZE PROGMEM=10000;
byte packetBuffer[MAX_MSG_SIZE];  //buffer to hold incoming udp packet
WiFiUDP Udp;

void setup() {
Serial.begin(115200);
pinMode(pinI1,OUTPUT);//define this port as output
pinMode(pinI2,OUTPUT);
pinMode(speedpin,OUTPUT);
pinMode(pinI3,OUTPUT);//define this port as output
pinMode(pinI4,OUTPUT);
pinMode(speedpin1,OUTPUT);
pinMode(D8, INPUT);  // GPIO15
pinMode(3, INPUT);   //GPIO3 = Rx Node
attachInterrupt(digitalPinToInterrupt(D8), girS, RISING);
attachInterrupt(digitalPinToInterrupt(3), girD, RISING);

WiFi.mode(WIFI_STA);
WiFi.begin(ssid.c_str(), pass.c_str());

Serial.print("Connecting...");
while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
}
Serial.println();

Serial.print("Connected, IP address: ");
Serial.println(WiFi.localIP());
// ...fin qui

//setup ethernet part
Udp.begin(8000); // porta default OSC

}

void girS(){
  //Serial.println("giroS");
  giroS++;
  }
  
void girD(){
  //Serial.println("giroD");
  giroD++;
  }


void loop() {
  receiveOSC();

  if(mod== true){
    dist = sonar.ping_cm();
      if(dist>=15 || dist==0) {
        avanti();
      } 
      if(dist<15 && dist!=0) {
        avantiDestra();
        delay(850);
        stopp();
        delay(5);
        dist=sonar.ping_cm();
        avantiSinistra();
        delay(1700);
        stopp();
        delay(5);
        if((dist>sonar.ping_cm() && sonar.ping_cm()!=0) || (dist==0 && sonar.ping_cm()!=0)) {
          avantiDestra();
          delay(1700);
        }
      }
  }
  else{
    switch(modalita){
    case 0: stopp(); break;
    case 1: avanti(); break;
    case 2: indietro(); break;
    case 3: avantiDestra(); break;
    case 4: avantiSinistra(); break;
  }
  }

  calibrate();
  
}


void calibrate(){
  if(modalita==1 || modalita== 5){
      if (giroS>giroD){
        if (powerD<1020)
          powerD+=1;
        else
          powerS-=1;
        }
      else if (giroD>giroS){
        if (powerS<1020)
          powerS+=1;
        else
          powerD-=1;
        }
        if (powerS<970)
          powerS=970;
        if (powerD<970)
          powerD=970;
        Serial.print(giroS);
        Serial.print(",");
        Serial.print(giroD);
        Serial.print(",");
        Serial.print(powerS);
        Serial.print(",");
        Serial.println(powerD);
    }
}

boolean sonarDistanceCheck(){
  dist = sonar.ping_cm();
  
  if(dist<15 && dist!=0) {
    //modalita=0;
    //stopp();
    Serial.println("WARNING, ostacolo rilevato, interruzione della marcia...");
    return true;
  }else{
    return false;
  }
  
}

void receiveOSC() {
    OSCMessage messageIN;
    int size;
    if( (size = Udp.parsePacket())> 0) {
        
        Udp.read(packetBuffer,size);
        messageIN.fill(packetBuffer,size);
        
        if(!messageIN.hasError()) {
            //Serial.println("----------->  no error");
            //Serial.println();
            messageIN.send(Serial);
            if(mod == false){
              messageIN.route("/UP", avanti);
              messageIN.route("/DOWN", indietro);
              messageIN.route("/LEFT", avantiSinistra);
              messageIN.route("/RIGHT", avantiDestra);
              messageIN.route("/ROUTE", routed); 
              messageIN.route("/STOP", stopp);
              messageIN.route("/ai", AI);
            }else{
              messageIN.route("/manual", manual);
            }       
        }
        Udp.flush();
    }
}

void AI(OSCMessage &messageIN, int addrOffset){
  mod= true;
}

void manual(OSCMessage &messageIN, int addrOffset){
  mod= false;
  stopp();
}


void routed(OSCMessage &messageIN, int addrOffset) {

  //receivedRoute= true;
  
  lungArray=messageIN.getInt(0);
  Serial.println("Lung. array ");
  Serial.println(lungArray);
  int i=0;
    
  while(i < lungArray){
    if(checkDist == true){
        stopp();
        modalita=0;
        return;
    }
        angle = messageIN.getInt(2*i+1);
        distance = messageIN.getInt(2*i+2);

        if(angle >= 0){
          angoloGiri= map(angle, 0,180, 1, giri180deg);
          Serial.println("angolo positivo ");
          Serial.println(angle);
          Serial.println("angolo giri ");
          Serial.println(angoloGiri);
          sinistraComposite(angoloGiri);
        }
        if(angle < 0){
          angoloGiri= map(angle, -1,-180, 1, giri180deg);
          Serial.println("angolo negativo ");
          Serial.println(angle);
          Serial.println("angolo giri ");
          Serial.println(angoloGiri);
          destraComposite(angoloGiri);
        }

      Serial.println("distanza ");
      Serial.println(distance);
      distanzaGiri= map(distance, 1, maxDistanzaSchermo, 1, maxGiri);  // mapping della distanza con i giri delle route
      Serial.println("distanzagiri ");
      Serial.println(distanzaGiri);
      avantiComposite(distanzaGiri);
      Serial.println("Ora dovrebbe ritornare all'inizio del loop");
      i++;
  }
  Serial.println("STOP, fine circuito! ");
  //modalita=0;
  stopp();
  checkDist = false;
}


void avanti(OSCMessage &messageIN, int addrOffset) {
  modalita=1; 
  giroS=giroD=0;
}
void avanti() {
  analogWrite(speedpin,powerS);//input a value to set the speed
  digitalWrite(pinI2,LOW);
  digitalWrite(pinI1,HIGH);
  analogWrite(speedpin1,powerD);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);
}

void avantiComposite(int distanzaAvanti) {
  giroS=giroD=0;
  while((distanzaAvanti>=giroS || distanzaAvanti>=giroD) /*|| checkDist==false*/){
      ESP.wdtFeed();
      if (checkDist = sonarDistanceCheck()) break;
      avanti();
      calibrate();
    }
  modalita=0;
  stopp();
}

void destraComposite(int angle) {
  modalita=3;
  giroS=giroD=0;
  while(giroD < angle || giroS < angle){
      ESP.wdtFeed();
      avantiDestra();
    }
  stopp();
}

void sinistraComposite(int angle) {
   modalita=4;
   giroS=giroD=0;
   while(giroS < angle || giroD < angle){
        ESP.wdtFeed();
        avantiSinistra();
      }
    stopp();
}


void indietro(OSCMessage &messageIN, int addrOffset) {
  modalita= 2;
}
void indietro() {
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,HIGH);
  digitalWrite(pinI1,LOW);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,HIGH);
  digitalWrite(pinI3,LOW);
}

void avantiDestra(OSCMessage &messageIN, int addrOffset) {
  modalita=3;
}
void avantiDestra() {
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,LOW);
  digitalWrite(pinI1,HIGH);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,HIGH);
  digitalWrite(pinI3,LOW);
}


void avantiSinistra(OSCMessage &messageIN, int addrOffset) {
  modalita=4;
}
void avantiSinistra() {
  /*analogWrite(speedpin, 0);//input a value to set the speed
  digitalWrite(pinI2,LOW);
  digitalWrite(pinI1,LOW);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);*/
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,HIGH);
  digitalWrite(pinI1,LOW);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);
}


void stopp(OSCMessage &messageIN, int addrOffset) {
  modalita=0;
}
void stopp() {
  analogWrite(speedpin,0);//input a value to set the speed
  digitalWrite(pinI2,LOW);
  digitalWrite(pinI1,HIGH);
  analogWrite(speedpin1,0);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);
}


/*void indietroDestra(OSCMessage &messageIN, int addrOffset) {
  //modalita=3;
}
void indietroDestra() {
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,LOW);
  digitalWrite(pinI1,HIGH);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,HIGH);
  digitalWrite(pinI3,LOW);
}

void indietroSinistra(OSCMessage &messageIN, int addrOffset) {
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,HIGH);
  digitalWrite(pinI1,LOW);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);
}

void indietroSinistra() {
  analogWrite(speedpin,1023);//input a value to set the speed
  digitalWrite(pinI2,HIGH);
  digitalWrite(pinI1,LOW);
  analogWrite(speedpin1,1023);//input a value to set the speed
  digitalWrite(pinI4,LOW);
  digitalWrite(pinI3,HIGH);
}*/









