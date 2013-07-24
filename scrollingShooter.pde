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
  checkHitsAndPickups(e1, p1);
  fill(0);
  textFont(font,30);
  text(p1.score,width/2,30);
  p1.score++;
}






