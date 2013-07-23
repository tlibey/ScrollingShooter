//global variables and constants
/* @pjs preload="objectImages/tree.png"; */
Background bg1; 
Player p1;
Enemies e1;
int groundLevel;
boolean[] keys = new boolean[526];
int score = 0;
PFont font;

void setup()
{
  size(960,300);
  groundLevel = 4*height/5;
  bg1 = new Background();
  p1 = new Player();
  e1 = new Enemies(5);
  font = createFont("Arial",16,true);
}


void draw()
{
  bg1.updateBackground();
  p1.updatePlayer();
  e1.updateEnemies(p1);
  fill(0);
  textFont(font,30);
  text(score,width/2,30);
  score++;
}


class Enemies 
{
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  int maxEnemies;
  Enemies()
  {
    maxEnemies = 1;
  }
  Enemies(int num)
  {
   maxEnemies = num; 
  }
  
  
  void updateEnemies(Player pl)
  {
    if(enemies.size()<maxEnemies)
    {
      //make random enemies (shape sizes and ammo counts)
      //enemies.add(new Enemy());
      int eHeight = (int) random(30,groundLevel);
      enemies.add(new Enemy(width,groundLevel-eHeight,-1,0, (int)random(5,20), eHeight, color((int)random(5,255),50,150),3));
      enemies.get(enemies.size()-1).eWeapon.ammoLim = (int)random(1,7);
      Enemy en = enemies.get(enemies.size()-1);
      en.eWeapon.yPos = (int)random(en.ebody.yPos-en.ebody.oHeight,en.ebody.yPos);
  }
    for(int ii = 0; ii< enemies.size(); ii++)
    {
     Enemy en = enemies.get(ii);
     if(en.ebody.checkInBounds()) //checkCollision?
        {   en.updateEnemy();
        }
        else
        {
        enemies.remove(ii);
        }
      
    }
    checkEnemyHit(pl);
    checkPlayerHit(pl);

  }
  
  Enemy getEnemy()
  {
   return enemies.get(enemies.size()-1);
    
  }
  
  void checkEnemyHit(Player pl)
  {
    if(enemies.size()>0 && pl.pWeapon.ammo.size()>0 )
    {
   for(int jj = enemies.size()-1;jj>=0;jj--)
   {
     boolean hit = false;
   for(int ii = pl.pWeapon.ammo.size()-1; ii >= 0 ; ii--)
   {
    drawableObject temp = pl.pWeapon.ammo.get(ii);
    Enemy en = enemies.get(jj);
    if(temp.xPos > en.ebody.xPos && temp.xPos < en.ebody.xPos+en.ebody.oWidth && temp.yPos > en.ebody.yPos && temp.yPos< en.ebody.yPos+en.ebody.oHeight)
     {
       pl.pWeapon.ammo.remove(ii);
         en.hits++;       
     }
     if(en.hits>=en.maxHits)
       hit=true;
   }
     if(hit)
     enemies.remove(jj);
    }
    }
  }
  
  void checkPlayerHit(Player pl)
  {
   //check if player is hit by any enemies 
    if(enemies.size()>0)
    {
   for(int jj = enemies.size()-1;jj>=0;jj--)
   {    
     Enemy en = enemies.get(jj);
     boolean hit = false;
   for(int ii = en.eWeapon.ammo.size()-1; ii >= 0 ; ii--)
   {
    drawableObject temp = en.eWeapon.ammo.get(ii);
    if(temp.xPos > pl.body.xPos && temp.xPos < pl.body.xPos+pl.body.oWidth && temp.yPos > pl.body.yPos && temp.yPos< pl.body.yPos+pl.body.oHeight)
     {
       en.eWeapon.ammo.remove(ii);
         pl.hits++; 
     }
     if(pl.hits>=pl.maxHits)
       hit=true;
   }
     if(hit)
       {score = 0;
       pl.hits = 0;
       }
    }
    }
    //println(pl.body.yPos);
  }
  
}

class Boss extends Enemy
{
  
  
}

class Enemy
{
 drawableObject ebody;
 Weapon eWeapon; 
 int hits = 0;
 int maxHits = 3;
 int weaponYdif;
 Enemy()
 {
  ebody = new drawableObject(width-20,groundLevel-50,-1,0,"Player",20,50,color(40,240,0));
  weaponYdif = (int)random(1,ebody.oHeight);
  eWeapon =  new Weapon(ebody.xPos-30,ebody.yPos,"shooter", 30, 5, color(255,150,0),5,-10,color(0,0,0),20);
 }
 Enemy(int x, int y, int xS, int yS, int w, int h, color c, int hp)
 {
  maxHits = hp;
  ebody = new drawableObject(x,y,xS,yS,"Player",w,h,c);
  weaponYdif = (int)random(1,ebody.oHeight);
  eWeapon =  new Weapon(ebody.xPos-30,weaponYdif,"shooter", 30, 5, color(255,150,0),5,-10,color(0,0,0),20);
 }
 
 void updateEnemy()
 {
  eWeapon.shoot();
  eWeapon.updateAmmo();
  eWeapon.updateWeapon(ebody.xPos-20,ebody.yPos+weaponYdif);
  ebody.drawObject();
  ebody.moveObject(); 
 }
 
  
}





class Player
{
 drawableObject body; 
 Weapon pWeapon;
 int hits = 0;
 int maxHits = 10;
 boolean isjumping = false;
 Player()
{
 body  = new drawableObject(10,groundLevel-30,0,0,"Player",40,30,100);
 pWeapon = new Weapon(body.xPos+body.oWidth,body.yPos,"shooter");
}

 void updatePlayer()
 {
   int jumpSpeed = 10;
   int jumpHeight = groundLevel;
   int moveSpeed = 10;
   
  if(checkKey('D'))
   body.xSpeed = moveSpeed;
  else if(checkKey('A'))
   body.xSpeed = -moveSpeed;
  else
    body.xSpeed = 0; 
 
   if( checkKey(' ') )//&& body.yPos < groundLevel+10)
   {//isjumping = true;
   body.ySpeed = jumpSpeed;
   
   }
  // if(isjumping)
  //   body.ySpeed += jumpSpeed;
  // else if(!isjumping)
   //  body.ySpeed -= jumpSpeed;
     
   if(body.yPos>groundLevel-body.oHeight)
   {
    body.yPos = groundLevel-body.oHeight;
    body.ySpeed = 0; 
   }
   
   if(body.ySpeed>0 && body.yPos<=0)
    {body.ySpeed = -jumpSpeed;
  //  isjumping = false;
    }
   
   if(mousePressed)
     pWeapon.shoot();
   
   pWeapon.updateAmmo();
   pWeapon.updateWeapon(body.xPos+body.oWidth,body.yPos);
   body.drawObject();
   body.moveObject();
   diplayPlayerStats();
 }
 
 void diplayPlayerStats()
 {
  textFont(font,20);
  float redc = float(hits)/float(maxHits)*255;
  float greenc = float((maxHits-hits))/maxHits*255;
  println(greenc);
  fill(redc,greenc,0);
  text("Health "+(maxHits-hits),10,30); 
   
 }
  
  
}

class Weapon
{
 drawableObject weapon;
 ArrayList<drawableObject> ammo = new ArrayList<drawableObject>();
 int xPos;
 int yPos;
 int ammoSize;
 color ammoColor;
 int ammoLim;
 int ammoSpeed;
 String weaponType;
 color weaponColor;
 int weaponWidth;
  int weaponHeight;
 
 Weapon()
 {
  weapon = new drawableObject(0,0,0,0,"");
 }
 Weapon(int x, int y, String wT)
 {
   xPos = x;
   yPos = y;
    ammoSize = 5;
    ammoColor = color(60,50,255);
    ammoLim = 20;
    ammoSpeed = 10;
   weaponType = wT;
   weapon = new drawableObject(x,y,0,0,wT); 
 }
 Weapon(int x, int y, String wT, int wW, int wH, color wC, int aSi, int aSp,  color aC, int aL)
 {
  xPos = x;
  yPos = y;
  ammoSize = aSi;
  ammoColor = aC;
  ammoSpeed = aSp;
  ammoLim =aL;
  weaponType = wT;
  weaponColor = wC;
  weaponWidth = wW;
  weaponHeight = wH;
  weapon = new drawableObject(x,y,0,0,wT,wW,wH,wC); 
   
 }
 void updateWeapon(int x, int y)
 {
  weapon.xPos = x;
  weapon.yPos = y;
  weapon.drawObject(); 
 }
 
 void shoot()
 {
   int x = weapon.xPos+weapon.oWidth;
   int y = weapon.yPos;
   if(ammo.size()<ammoLim)
     ammo.add(new drawableObject(x,y,ammoSpeed,0,"bullet",ammoSize,ammoSize,ammoColor));
   
 }
 
 void updateAmmo()
 {
    for(int ii =0; ii < ammo.size(); ii++)
 {
  drawableObject am0 = ammo.get(ii);
  if(am0.checkInBounds()) //checkCollision?
  {   
  am0.drawObject();
  am0.moveObject();
  }
  else
  {
  ammo.remove(ii);
  }
 } 
 }
  
}


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
  
  if(type == "cloud")
  { 
    if(yPos > groundLevel+100)
    {
     ySpeed = -ySpeed; 
    }
    float fills = (height-yPos)/height*211;
    float h = height;
    fill(yPos/h*240);
    stroke(211);
   ellipseMode(CENTER);
   ellipse(xPos,yPos,20,20);
   ellipse(xPos+10,yPos-5,20,20);
   ellipse(xPos+20,yPos-10,30,30);
   ellipse(xPos+30,yPos-5,20,20);
   ellipse(xPos+40,yPos,20,20);
   rect(xPos-15,yPos,70,10);
    
  }
  else if(type == "ground")
  {
  // if(fillColor<oldColor)
  //   oldColor++;
   // else if(fillColor>oldColor)
   //   oldColor--; 
    
    fill(fillColor,2*fillColor/3,0);
    stroke(fillColor,2*fillColor/3,0);
    rect(xPos,yPos,width/10,height/5);
  }
  else if (type=="Player")
  {
   fill(fillColor);
  stroke(0);
   rect(xPos,yPos,oWidth,oHeight);
  }
  else if (type =="tree")
  {
   /* int treeH = 30;
    int stumpH = 10;
   fill(50,100,0);
   stroke(50,200,0);
   rect(xPos,yPos-(treeH+stumpH),10,treeH);
   fill(90,60,0);
   stroke(90,60,0);
   */
   PImage img  = loadImage("objectImages/tree.png");
   image(img,xPos,yPos-37);
  // rect(xPos+2,yPos-stumpH,6,stumpH); 
  }
  else if (type=="shooter")
  {
   fill(0);
   stroke(0);
   rect(xPos,yPos,20,5);
  }
  else if (type=="bullet")
  {
   fill(fillColor);
   stroke(0);
   rect(xPos,yPos,oWidth,oHeight);
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



boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];  
  }
  
  return false;
}
 
void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{ 
  keys[keyCode] = false; 
}

