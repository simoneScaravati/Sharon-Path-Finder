// Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

import controlP5.*;

public class Settings_Window extends PApplet {

  ControlP5 cp5; 
  Textfield ip_field, port_field;
  Button save;
  String myText;
  
  void exit() {           //override necessario per far chiudere la finestra senza problemi
    println("Leave settings window");
  }
  
  public void settings() {
    size(450, 350);
  }
  
  public void setup(){
    background(0);
    fill(255);
    cp5 = new ControlP5(this);
    PFont font = createFont("arial", (this.height)/10);
    textFont(font);
    ip_field = cp5.addTextfield("IP ADDRESS").setFont(font).setAutoClear(false)
    .setPosition((this.width)/8, (this.height)/12).setSize((this.width)-(this.width/4),(this.height)/7)
    .setFocus(false);
    
    port_field = cp5.addTextfield("PORT").setFont(font).setAutoClear(false)
    .setPosition((this.width)/8, (this.height)/2.5).setSize((this.width)-(this.width/4),(this.height)/7)
    .setFocus(false);
    
  }
  
  public void draw() {
    
    save = new Button("SAVE", (this.width/4), (this.height-this.height/6), ((this.width)/2), this.height/8, 200);
    save.Fill(255,255,255);
    
    if(mouseX > save.getPosX() && mouseX < (save.getPosX() + save.getX()) &&
              mouseY > save.getPosY() && mouseY < (save.getPosY() + save.getY())) 
              //mouse over settings button
      {      
          save.Fill(20,200,20);  //colora il pulsante se ci si posiziona sopra
          if((mousePressed && (mouseButton == LEFT)) || key == ENTER){
            fill(255);
            try{
              background(0);
              ip_address= ip_field.getText();
              port= Integer.parseInt((port_field.getText()));
              println("Ip and Port saved");
              delay(100);
              oscP5 = new OscP5(this, port);  // la porta andrà messa manualmente nelle settings
              net = new NetAddress(ip_address, port); //anche l'ip andrà messo a mano nelle settings
              delay(50);
              myText = "Ip and Port saved";
              
            }catch(Exception e){
               myText= "Error, bad network settings";
            }
            text(myText, width/3, (this.height-this.height/5));
            fill(0);
          }
      }   
  }
  
  
    public class Button{  //classe innestata, perchè se no il button lo legge dal main
  
    PShape rect;
    String name;
    int posX, posY, x ,y,c ;
    
    public Button(String name,int posX,int posY, int x, int y, int c){
      this.name = name;
      this.rect = createShape(RECT, posX, posY, x, y, c );
      this.rect.setStroke(color(0,100,200));
      strokeWeight(2);
      shape(rect);
      fill(0);
      this.posX = posX;
      this.posY = posY;
      this.x = x;
      this.y = y;
    }
    
    public int getPosX(){ return this.posX; }
    public int getPosY(){ return this.posY; }
    public int getX(){ return this.x; }
    public int getY(){ return this.y; }
    
    public void Fill(int r, int g, int b ){
      this.rect.setFill(color(r, g, b));
      shape(this.rect);
      textSize(height/25);  //dimensione dinamica font
      textAlign(CENTER);
      text(this.name, (posX+ x/2), (posY+ (y/1.7)));
      
    }
    
    public String toString(){
      return this.name;
    }
  }
  
}