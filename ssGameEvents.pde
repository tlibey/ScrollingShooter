//game events


boolean checkCollision(drawableObject d1, drawableObject d2)
{
   int top1,top2,bot1,bot2,left1,left2,right1,right2;
   top1 = d1.yPos; top2 = d2.yPos;
   bot1 = d1.yPos+d1.oHeight; bot2 = d2.yPos+d2.oHeight;
   left1 = d1.xPos; left2 = d2.xPos;
   right1 = d1.xPos + d1.oWidth; right2 = d2.xPos + d2.oWidth;
   if(top1 >= bot2)
     return false;
   if(bot1 <= top2)
     return false;
   if(left1 >= right2)
     return false;
   if(right1 <= left2)
     return false;
     
   return true;
   
   
   
   /*
    if(d1.xPos > d2.xPos && d1.xPos < d2.xPos+d2.oWidth && d1.yPos > d2.yPos && d1.yPos< d2.yPos+d2.oHeight)
     { return true;}
     else
     return false;
  */
}

void checkHitsAndPickups(Enemies ens, Player pl)
{
 if(ens.enemies.size()>0)
    {
       for(int jj = ens.enemies.size()-1;jj>=0;jj--)
       {
             Enemy en = ens.enemies.get(jj);
             if(checkEnemyHit(en,pl))
               {
                 String[] loots = {"health","bomb"};
                 String thisLoot =  loots[(int)random(0,2)] ;
                 println(thisLoot);
                 ens.eLoot.add(new Loot(thisLoot,en.ebody.xPos,en.ebody.yPos));
                 ens.enemies.remove(jj); 
               }
              if(checkPlayerHit(en,pl))
              {
                 pl.score = 0;
                 pl.hits = 0;
                 
              }
       }
      checkPlayerLoot(ens,pl);      
    }
}

 boolean checkEnemyHit(Enemy en, Player pl)
  {
     boolean hit = false;
    if(pl.pWeapon.ammo.size()>0 )
    { 
   for(int ii = pl.pWeapon.ammo.size()-1; ii >= 0 ; ii--)
   {
    drawableObject temp = pl.pWeapon.ammo.get(ii);
    if(checkCollision(temp,en.ebody))
     {
       pl.pWeapon.ammo.remove(ii);
         en.hits++;       
     }
     if(en.hits>=en.maxHits)
       hit=true;
   }
     
    }
    return hit;
  }
  
  boolean checkPlayerHit(Enemy en, Player pl)
  {
   //check if player is hit by any enemies 
     
   boolean hit = false;
   for(int ii = en.eWeapon.ammo.size()-1; ii >= 0 ; ii--)
   {
    drawableObject temp = en.eWeapon.ammo.get(ii);
    if(checkCollision(temp,pl.body))
     {
       en.eWeapon.ammo.remove(ii);
       pl.hits++; 
     }
     if(pl.hits>=pl.maxHits)
       hit=true;
   }
     
   return hit;    
  }
  
  
  void checkPlayerLoot(Enemies ens, Player pl)
  {
   if(ens.eLoot.size()>0)
  {
   for(int ii = ens.eLoot.size()-1; ii>=0; ii--)
   {
     
     drawableObject temp = ens.eLoot.get(ii).loot;
     ens.eLoot.get(ii).updateLoot(pl);
    if(checkCollision(temp,pl.body))
     {
       pl.playerGetsLoot(ens.eLoot.get(ii).loot.type);
       ens.eLoot.remove(ii);
     }
     
   }
   
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
