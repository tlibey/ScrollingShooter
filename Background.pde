

class Background
{
 int bglength = width*5; 
 int bgheight = height*2;
 int xScrollPos;
 int yScrollPos;
 int xScrollSpeed = 5;
 int yScrollSpeed = 10;
 
 int randSeed = 100;
 int totalSeeds = 50;
 float bgSeed[] = new float[totalSeeds];
  int bgObjNum = 10;

 
 
 int groundObjWidth = 10;
 int groundObjNum = (int)width/groundObjWidth;
 boolean changingGroundColor = false;
 int newGroundColor = 0;
 int bgFillColor = 100;

 ArrayList<drawableObject> bgObjects = new ArrayList<drawableObject>();
 ArrayList<drawableObject> ground = new ArrayList<drawableObject>();

 
 
 Background()
 {
   //where to start drawing bgobjects
  xScrollPos = width;
  yScrollPos = height;

  for(int ii = 0;ii<totalSeeds;ii++)
  {
   bgSeed[ii] = random(randSeed); 
  }
  
  //bgObjects.add(new drawableObject(width,(int)(bgSeed[0]/randSeed*height),-10,-10,"rect"));
 }
 
 void newSeeds()
 {
   for(int ii = 0;ii<totalSeeds;ii++)
  {
   bgSeed[ii] = random(-randSeed,randSeed); 
  }
 }
 
 void updateBackground()
 {
  //autoscroll
  //remove pixelbuffer, transfer pixels, addpixels
  /*
   if(keyPressed && key == 'd')
      xScrollSpeed = 10;
   else if(keyPressed && key =='a')
     xScrollSpeed = -10;
   else
    xScrollSpeed = 0; 
  */
  generateBackground();
 
   
 }
 
 void generateBackground()
 {
  background(255);
  fill(0);
  
  //random components
  //rect(test,pos1,20,20);
 newSeeds();
 int seeder = 0;
 while(bgObjects.size() < bgObjNum)
 {
   String[] bgobjType = {"cloud","tree"};
   String thisType = bgobjType[(int)random(bgobjType.length)];
   if(thisType == "cloud")
   {int x = width;
   int y = (int)(bgSeed[seeder++]/randSeed*height);
   if(y>groundLevel-height/3)
     y = groundLevel-height/3;
   int xVel = -xScrollSpeed;//(int)(-bgSeed[seeder++]/randSeed*10);
   int yVel = (int)(-bgSeed[seeder++]/randSeed*5);
   bgObjects.add(new drawableObject(x,y,xVel,yVel,"cloud"));
   }
   else if(thisType=="tree")
   {
   int x = width;
   int y = groundLevel;
   int xVel = -xScrollSpeed;//(int)(-bgSeed[seeder++]/randSeed*10);
   int yVel = 0;
   bgObjects.add(new drawableObject(x,y,xVel,yVel,"tree"));
   }
   
   if(seeder >= 40)
   {
    newSeeds();
    seeder = 0; 
   }

 }
 
 boolean scrollCheck = false;
 if(ground.size()>0)
   scrollCheck = (ground.get(ground.size()-1).xPos<= width-(groundObjWidth));
 else if(ground.size()==0)
    scrollCheck=true;
    
   
   
   if(keyPressed && key=='s')
     changingGroundColor = true;     
  if(changingGroundColor)
   {   
  if(ground.size()>1)
    {
      int lastColor = ground.get(ground.size()-1).fillColor;
      //println(lastColor);
      if(lastColor==ground.get(ground.size()-2).fillColor)
        newGroundColor = (int)random(200); 
      if(newGroundColor < lastColor)
        bgFillColor = lastColor-1;
        else if(newGroundColor>lastColor)
        bgFillColor = lastColor+1;
      else if(newGroundColor==lastColor)
        {changingGroundColor= false;
        }
    }
   }
    
    
  if(ground.size() < groundObjNum && scrollCheck)
 {
   int x = width;
   int y = height/5*4;
   int xVel = -xScrollSpeed;
   int yVel = 0;
   //ground.add(new drawableObject(x,y,xVel,yVel,"ground"));
  // ground.add(new drawableObject(x,y,xVel,yVel,"ground",groundObjWidth,height/5));
    
    
    
   ground.add(new drawableObject(x,y,xVel,yVel,"ground",groundObjWidth,height/5,bgFillColor));

 }
 
  
  for(int ii = bgObjects.size()-1; ii >=0; ii--)
 {
  drawableObject bgO = bgObjects.get(ii);
  if(bgO.checkInBounds())
  {   
  bgO.drawObject();
  bgO.moveObject();
  }
  else
  {
  bgObjects.remove(ii);
  }
 } 
 
  for(int ii = ground.size()-1; ii >=0; ii--)
 {
  drawableObject grndO = ground.get(ii);
  if(grndO.checkInBounds())
  {   
  grndO.drawObject();
  grndO.moveObject();
  }
  else
  {
  ground.remove(ii);
  }
 }
  
   
 } 
  
}
