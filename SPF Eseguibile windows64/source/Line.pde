// Copyright (C) 2018  Simone Scaravati, Noah Rosa, Stefano Radaelli

public class Line{
  
  PShape line;
  Point head, tail;     
  
  public Line(Point head, Point tail){
    this.head = head;
    this.tail = tail;
  }
  
  public void drawLine(){
     stroke(color(20,100,255));
     strokeWeight(7);
     line(this.head.getX(), this.head.getY(), this.tail.getX(), this.tail.getY());
     strokeWeight(1);
     stroke(0);
  }
  
  public int getStartX(){ return this.head.getX();  }
  public int getStartY(){ return this.head.getY();  }
  public int getEndX(){ return this.tail.getX();  }
  public int getEndY(){ return this.tail.getY();  }  
  
}