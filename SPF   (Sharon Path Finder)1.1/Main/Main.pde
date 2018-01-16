  // Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

import netP5.*;
import oscP5.*;
import java.lang.Math;

public OscP5 oscP5;
OscMessage msg;
public NetAddress net;
public String ip_address="";
public int port= 0;

static int cName = 1;      // variabile sequenziale che dà il nome al Point
static ArrayList<Point> punti = new ArrayList();  // array di Point
static ArrayList<Double> angoli = new ArrayList();  //array degli angoli tra un punto e un altro
Button reset, calculate, settings,start,back,exit;
String messageRun ="";

Settings_Window sett;
String[] args = {"SETTINGS"};

double angle;
PImage img;
PImage intro;
PImage logo, title;
static int state=0;
int i=0, j=255;

void setup(){
  frameRate(30);
  img = loadImage("x.jpg");
  img.resize(width, height);
  intro= loadImage("intro.jpg");
  intro.resize(width, height);
  logo= loadImage("logo1.png");
  //logo.resize((width/2),height/9);
  title= loadImage("title.png");
  title.resize(width,height); 
}
void settings() {
  
  //size(1000,700);  //finestra schermo intero
  fullScreen();
}

void draw() {
 if(state==0){    //pagina intro software
 background(0);
   if(keyPressed == true){
     state=1;
   }else{
     if(i<255) { //fade in intro
      tint(255, i);
      image(intro, 0,0);
      i=(int)(i+3);
     }
     else if(j>0){ //fade out intro
      tint(255, j);
      image(intro, 0,0);
      j=(int)(j-3);
     }
     else{
      i=0;
      j=255; 
      state=1;
     }
   }
 }
 else if(state==1){
  if(keyPressed ==true){
    state=2;
  }else{
    background(0);
     if(i<255) { //fade in intro
      tint(255, i);
      image(title, 0,0);
      i=(int)(i+3);
     }
     else if(j>0){ //fade out intro
      tint(255, j);
      image(title, 0,0);
      j=(int)(j-3);
     }
     else{
       state=2;
     }
  }
 }
 else if(state==2){  //start menu
   background(img);
   tint(255,255);    //restore the transparency of the image
   image(logo, width/8, (height-(height-90)));
   start = new Button("START",((width/2)- ((width/5)/2)),(height/3),(width/5), (height/8),10);
   start.Fill(200,200,200);
   settings = new Button("SETTINGS",((width/2)- ((width/5)/2)),(height/2),(width/5), (height/8),10);
   settings.Fill(200,200,200);
   exit = new Button("EXIT",((width/2)- ((width/5)/2)),(height-(height/3)),(width/5), (height/8),10);
   exit.Fill(200,200,200);
   textAlign(CENTER);
   textSize(16);  //copyright text
   text("Software developed by Simone Scaravati, Stefano Radaelli and Noah Rosa.\n Written and debugged with Processing(3.3.6) ", width/2, (height-(height/15)));
   
   if(mouseX > start.getPosX() && mouseX < (start.getPosX() + start.getX()) &&
              mouseY > start.getPosY() && mouseY < (start.getPosY() + start.getY())) 
              //mouse over settings button
      {      
          start.Fill(0,100,200);  //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            state=3;
            background(img);
            delay(100);
          }
      }
   
   else if(mouseX > settings.getPosX() && mouseX < (settings.getPosX() + settings.getX()) &&
              mouseY > settings.getPosY() && mouseY < (settings.getPosY() + settings.getY())) 
              //mouse over settings button
      {      
          settings.Fill(0,100,200);  //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            sett = new Settings_Window();
            PApplet.runSketch(args, sett);
            delay(100);
          }
      }
      
   else if(mouseX > exit.getPosX() && mouseX < (exit.getPosX() + exit.getX()) &&
              mouseY > exit.getPosY() && mouseY < (exit.getPosY() + exit.getY())) 
              //mouse over settings button
      {      
          exit.Fill(255,30,10);  //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            exit();
          }
      }
   
 }
 else{  //main software
      reset= new Button("RESET", ((width/7)), (height/4), (width/5), (height/8),10);
      reset.Fill(255,255,255);
      calculate= new Button("RUN", (width/7), (height/2), (width/5), (height/8),10);
      calculate.Fill(255,255,255);
      back = new Button("BACK", width/20, height/20, width/12, height/15,0);
      back.Fill(130,0,0);
      line((reset.getPosX()+ reset.getX()+50), 0 ,(reset.getPosX()+ reset.getX()+50),height);
      textAlign(LEFT); 
      textSize(16);  //copyright text
      text("You can start drawing your route up here!\n(Sharon will go forward considering Points from bottom to the top) ",
      (reset.getPosX()+ reset.getX()+70) , (height-(height/20)));
   
       
      if(mouseX > reset.getPosX() && mouseX < (reset.getPosX() + reset.getX()) &&
         mouseY > reset.getPosY() && mouseY < (reset.getPosY() + reset.getY()) )    
        //mouse over RESET button: stop disegno punti(prima del ciclo), ripistino arraylist, reset background e nomi
        {   
          reset.Fill(0,100,200); //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            punti.clear();
            angoli.clear();
            background(img);
            cName= 1;
          }
        }
      
      else if(mouseX > back.getPosX() && mouseX < (back.getPosX() + back.getX()) &&
              mouseY > back.getPosY() && mouseY < (back.getPosY() + back.getY())) 
              //mouse over back button
      {      
          back.Fill(50,0,0);  //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            state=2;
            return;
          }
      }
        
      else if(mouseX > calculate.getPosX() && mouseX < (calculate.getPosX() + calculate.getX()) &&
              mouseY > calculate.getPosY() && mouseY < (calculate.getPosY() + calculate.getY())) 
              //mouse over Run button
      {      
          calculate.Fill(0,200,50);  //colora il pulsante se ci si posiziona sopra
          if(mousePressed && (mouseButton == LEFT)){
            fill(255,0,0);
            textSize(16);
            textAlign(CENTER);
            text(messageRun, (calculate.getPosX()+ (calculate.getX()/2)), (calculate.getPosY()+ calculate.getY() + 30 ));
            delay(50);
            
            //interazioni con arduino 
            //to do....
            try{
            messageRun = "Elaborating...";
            msg= new OscMessage("/UP");
            oscP5.send(msg,net);
            delay(3000);
            msg = new OscMessage("/STOP");
            oscP5.send(msg,net);
            }catch(NullPointerException e){
              messageRun = "Trasmission Error! \n(Probably ip and/or port aren't correct)";
            }
          }
      }
      
    //creazione punti
    else if(mousePressed && (mouseButton == LEFT) && (mouseX> (reset.getPosX()+ reset.getX()+50))) //check mouse
      {         
        Point p = new Point(cName);
        p.drawPoint();
        punti.add(p);
          if(punti.size()>1){
            Line l = new Line(punti.get(punti.size()-2), punti.get(punti.size()-1) ); 
            l.drawLine();
            angle= punti.size()<=2 ? calcAngle(punti.get(punti.size()-2), punti.get(punti.size()-1)):  calcAngle(punti.get(punti.size()-3),punti.get(punti.size()-2), punti.get(punti.size()-1));
            angoli.add(angle);
          }else{ //alla creazione del primo punto mette nell'array degli angoli null
            angoli.add((double)0.0);
          }
          //stampe nomi e numeri
          textAlign(LEFT);
          textSize(width/80);  //dimensione dinamica del font
          if(mouseX>width/2){   // print destra o sinistra del nome dei punti
            text(p.toString(), mouseX+15, mouseY+5);
            if(angoli.size()>1)  //stampa l'angolo solo se l'array non è vuoto
              text(angle+"°", mouseX+15, mouseY+20);
          }else{
            text(p.toString(), mouseX-80, mouseY+5);
            if(angoli.size()>1)  //stampa l'angolo solo se l'array non è vuoto
              text(angle+"°", mouseX-80, mouseY+20);
          }
        
        delay(120);
        cName++;   // incrementa int per il nome dei punti
      }
      
      else{
        ; // sta cippa di minchia
      }
   }
}
  
public int calcAngle(Point start, Point end){
  float b = -(start.getX()-end.getX());
  //b = b>0? b: -b;   //modulo base
  float h = -(end.getY()- start.getY());
  //h = h>0? h: -h;   // modulo altezza
  //double div = (double)h/b;
  double angle = atan2(h,b);    //il metodo di Math ritorna theta avendo come parametri x e y del triangolo
  double deg = Math.toDegrees(angle);
  angoli.add(deg);
  return (int)deg;
}

public int calcAngle(Point before, Point start, Point end){
  float b2 = -(start.getX()-end.getX());
  //b = b>0? b: -b;   //modulo base
  float h2 = -(end.getY()- start.getY());
  //h = h>0? h: -h;   // modulo altezza
  float b1 = -(before.getX()-start.getX());
  //b = b>0? b: -b;   //modulo base
  float h1 = -(start.getY()- before.getY());
  //h = h>0? h: -h;   // modulo altezza
  //double div = (double)h/b;
  double angle = atan2(h2,b2);    //il metodo di Math ritorna theta avendo come parametri x e y del triangolo
  double beforeag = atan2(h1,b1); 
  double deg = Math.toDegrees(angle);
  double beforedg = Math.toDegrees(beforeag);
  deg = deg - beforedg;
  deg = deg%180;
  angoli.add(deg);
  return (int)deg;
}
public void keyPressed(){
  if(state < 2){
    state++;
    delay(100);
  }
}