
class Loot
{
 drawableObject loot = new drawableObject();
 String lootType = ""; 
 Loot()
{
 
}

Loot(String type)
{
 lootType = type;
 generateLootImage(type); 
}

Loot(String type,int x, int y)
{
 loot.xPos =x;
 loot.yPos = y;
 generateLootImage(type);
  
}

void generateLootImage(String type)
{
  if(type == "health")
  {
   loot.type = "health"; 
  }
  else if(type == "bomb")
  {
   loot.type = "bomb";
   loot.fillColor = color(255,0,0);
   loot.xSpeed = -3;
  }

}

void updateLoot(Player pl)
{
 
 if(loot.type == "bomb")
 {
   if(pl.body.yPos<loot.yPos)
      loot.ySpeed = 3;
      else
      loot.ySpeed = -3;
 }
 
 loot.moveObject(); 
 loot.drawObject();
}
  
  
  
}

class Enemies 
{
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Loot> eLoot = new ArrayList<Loot>();
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
     if(en.ebody.checkInBounds()) 
        {   en.updateEnemy();
        }
        else
        {
        enemies.remove(ii);
        pl.score = 0;
        }
      }
  }
  
  void addBoss()
  {
   enemies.add(new Enemy(width-60,groundLevel-40,0,0,40,40,0,50));
   Enemy boss = enemies.get(enemies.size()-1);
   boss.eWeapon.ammoLim = 20;
   boss.eWeapon.yPos = 20;
   boss.ebody.type = "boss";
    
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
 int maxHits = 100;
 int score = 0;
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
  fill(redc,greenc,0);
  text("Health "+(maxHits-hits),10,30); 
   
 }
 void playerGetsLoot(String lootType)
 {
  if(lootType == "health")
 {
  hits = hits - 25;
  if(hits<0)
    hits = 0;
 } 
 
 if(lootType == "bomb")
 {
  hits = hits + 25;
    
 }
 
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

