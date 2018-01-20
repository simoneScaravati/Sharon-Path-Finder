// Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

public class Point{
  
  PShape point;
  int cName, x, y;
  
  public Point(int cName){
     this.x = mouseX;
     this.y = mouseY; 
     this.cName= cName;
  }
  
  public void drawPoint(){
   this.point = createShape(ELLIPSE, x, y, 20,20);
   point.setFill(color(random(255), random(255), random(255)));
   shape(point);
  }
  
  public int getX(){ return this.x; }
  public int getY(){ return this.y; }
  
  public void setVisible(){      // inutile
     (this.point).setVisible(true);
  }
  
  public String toString(){
    StringBuilder sb = new StringBuilder();
    sb.append("Point ");
    sb.append(cName);
    return sb.toString();
  }
}