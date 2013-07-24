void drawObjects(drawableObject d1)
{
 String type = d1.type;
 int x = d1.xPos;
 int y = d1.yPos;
 int w = d1.oWidth;
 int h = d1.oHeight;
 color c = d1.fillColor;
 
 if(type == "cloud")
  { 
    float fills = (height-y)/height*211;
    float h1 = height;
    fill(y/h1*240);
    stroke(211);
   ellipseMode(CENTER);
   ellipse(x,y,20,20);
   ellipse(x+10,y-5,20,20);
   ellipse(x+20,y-10,30,30);
   ellipse(x+30,y-5,20,20);
   ellipse(x+40,y,20,20);
   rect(x-15,y,70,10);
    
  }
  else if(type == "ground")
  {
    fill(c,2*c/3,0);
    stroke(c,2*c/3,0);
    rect(x,y,width/10,height/5);
  }
  else if (type=="Player")
  {
   fill(c);
  stroke(0);
   rect(x,y,w,h);
  }
  else if (type =="tree")
  {
   PImage img  = loadImage("objectImages/tree.png");
   image(img,x,y-37);
  }
  else if (type=="shooter")
  {
   fill(0);
   stroke(0);
   rect(x,y,20,5);
  }
  else if (type=="bullet")
  {
   fill(c);
   stroke(0);
   rect(x,y,w,h);
  }
  else if (type == "health")
  {
   fill(47,222,50);
   stroke(47,222,50);
   rect(x,y,w,h);
  }
  else if(type == "bomb")
  {
   fill(c);
   stroke(c);
   rect(x,y,w,h); 
  }
   
   
  
}


class drawableObject
{
 int xPos;
 int yPos;
 int xSpeed;
 int ySpeed;
 String type; 
 int oWidth;
 int oHeight;
 int fillColor; 
 
 drawableObject()
 {
  xPos = 0;
  yPos = 0;
  xSpeed = 0;
  ySpeed = 0;
  type = "rect";
  oWidth = 20;
  oHeight = 20; 
   
 }
 
 drawableObject(int x, int y, int xS, int yS, String stype)
 {
  xPos = x;
  yPos = y;
  xSpeed = xS;
  ySpeed = yS;
  type = stype; 
  oWidth = 20;
  oHeight = 20; 
 }
 
 drawableObject(int x, int y, int xS, int yS, String stype, int w, int h)
 {
  xPos = x;
  yPos = y;
  xSpeed = xS;
  ySpeed = yS;
  type = stype; 
  oWidth = w;
  oHeight = h;
 }
 
  drawableObject(int x, int y, int xS, int yS, String stype, int w, int h, int newColor)
 {
  xPos = x;
  yPos = y;
  xSpeed = xS;
  ySpeed = yS;
  type = stype; 
  oWidth = w;
  oHeight = h; 
  fillColor = newColor;
  
 }
 
/*   drawableObject(int x, int y, int xS, int yS, String stype, int w, int h, color newColor)
 {
  xPos = x;
  yPos = y;
  xSpeed = xS;
  ySpeed = yS;
  type = stype; 
  oWidth = w;
  oHeight = h; 
  fillColor = newColor;
  
 }
 */
 
 void drawObject()
 {
  if(type == "rect")
  {
    fill(0);
   rect(xPos,yPos,oWidth,oHeight); 
  }
  else{
    drawObjects(this);
  }
  
 }
 
 void moveObject()
 {
  xPos += xSpeed;
  yPos -= ySpeed; 
 }
 
 void moveObject(int xS, int yS)
 {
  xPos +=xS;
  yPos -=yS; 
 }
 
 boolean checkInBounds()
 {
   int xtra = 10;
  if(xPos<-xtra || xPos>width+xtra || yPos<-xtra || yPos>height+xtra)
     return false;
    else 
     return true; 
 }
 
}
