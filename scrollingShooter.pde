//global variables and constants
/* @pjs preload="objectImages/tree.png"; */
Background bg1; 
Player p1;
Enemies e1;
int groundLevel;
boolean[] keys = new boolean[526];
PFont font;
boolean inGame = false;
boolean inPlayerMenu = false;
boolean inStartMenu = true;


//move to function
int lastBoss = 0;



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
  if(inStartMenu)
  {
    startMenu(bg1);
  }
  
  else if(inGame)
  {
  bg1.updateBackground();
  p1.updatePlayer();
  displayHUD();
  e1.updateEnemies(p1);
  checkHitsAndPickups(e1, p1);
  
  //put in function
     
    if(p1.score>lastBoss+1000) //broken since enemy killing scores can cause this to jump
     { e1.addBoss();
     
     lastBoss = p1.score;
     }
  if(p1.score == 0)
    {
     resetGame(p1,e1);
    }
  }
  else if(inPlayerMenu)
  {
    playerMenu(p1);
  }
  
  if(checkKey('P'))
  {
   inStartMenu = false;
   inGame = false;
   inPlayerMenu = true; 
  }
}

void playerMenu(Player pl)
{
  if(checkKey(ENTER))
  {
   inGame = true;
   inPlayerMenu = false; 
  }
  background(0);
  fill(255);
  bg1.updateBackground();
  textFont(font,30);
  text("PlayerMenu",width/2-100,30);
  text("press ENTER to return to game",width/2-100,150);
  
}

void startMenu(Background bg)
{
  if(checkKey(ENTER))
  {
    inStartMenu = false;
    inGame = true;
  }
  textFont(font,30);
  bg.updateBackground();
  //text("Welcome!!",width/2 - 100,50);
  text("press ENTER to start", width/2 - 100, 150);
  
}

void displayHUD()//Player pl)
{
  fill(0);
  textFont(font,30);
  text(p1.score,width/2,30);
  p1.score++;
  
}


void resetGame(Player pl, Enemies ens)
{
  pl.hits = 0;
 pl.body.xPos = 0;
 pl.body.yPos = groundLevel+pl.body.oHeight;
 println(ens.enemies.size());
 //if(ens.enemies.size()>0)
 //{
 for(int ii = ens.enemies.size()-1;ii>=0;ii--)
 {
  ens.enemies.remove(ii); 
 }
 for(int ii = ens.eLoot.size()-1;ii>=0;ii--)
 {
  ens.eLoot.remove(ii); 
 }
 
 inGame = false;
  inStartMenu = true; 

}



