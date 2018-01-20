// Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

public class Button{

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
    textSize(height/35);  //dimensione dinamica font
    textAlign(CENTER);
    text(this.name, (posX+ x/2), (posY+ (y/1.7)));
    
  }
  
  public String toString(){
    return this.name;
  }
}