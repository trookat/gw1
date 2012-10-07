

-- define some stuff

gc_NumRockets=200;                      -- Number of rockets on screen at a time
gc_ax=30;                               -- number of aliens across
gc_ay=10;                               -- number of aliens down
gc_NumBad=gc_ax*gc_ay-10;               -- number of alien and alien bombs on screen at a time


gc_version='alpha';


--object definions
objects={}				-- stores sprite info
objects.X,
objects.Y,
objects.x2,
objects.y2	=0,0,0,0;               -- x,y positions of sprite
objects.xa,objects.ya	=0,0;		-- movement add 
objects.ON,                             -- Determines if sprite is ON the screen 
objects.fired	=false,false		-- determines if sprite has fired
objects.special=0			-- Special function
objects.sprite=0                        -- sprite picture number




scrap={}
scrap.x,scrap.y,scrap.xa,scrap.ya,scrap.life=0,0,0,0,0;
scrap.on=false;


    
rockets={}; 
AlienBombs={}
Aliens={}
BonusAlien=objects

	function setupspritedata()
		local i,x,y=0,0,0;
		for i=1 to gc_NumRockets do rockets[i]=objects end

		for x=1 to gc_ax do
			AlienBombs[x]={}
			Aliens[x]={}
			for y=1 to gc_ay do
				AlienBombs[x][y]=objects;
				Aliens[x][y]=objects;
			end
		end
      end


--      FireObjects:array[1..gc_NumRockets] of objects; -- leagacy particles






--    scrapnal:array[1..200] of scrap; -- worry about this later

    { ----------------------------- Game Vars ----------------------------- }

                                                { hero's rockets : all hero's fired rockets }

    gvI_AlienCounter,                           { Number of aliens on screen               }
    gvI_AlienBombCounter,                       { Number of gv_sprite.AlienBombs on screen }
    gvI_SpecialWeaponsCounter,                  { number of special weapons                }
    gvI_SpecialWeaponType,                      { special weapon type                      }
    gvI_Level,                                  { gvI_Level number                         }
    gvI_Lives,                                  { number of gvI_Lives left                 }
    gvI_Shield:integer;                         { shield couter %                          }
    gvL_Score:longint;                          { gvL_Score                                }
    gvb_LevelComplete:boolean;                  { Level Complete switch                    }
    gvI_herox,                                  { Hero's x location                        }
    gvI_heroy,                                  { Hero's y location                        }
    gvI_MessageTimer,                           { message timer                            }
    gvI_MessageX,                               { message x location                       }
    gvI_Messagey:integer;                       { message y location                       }
    ch:char;                                    { stores key pressed                       }
    gvb_Quit:boolean;                           { gvb_Quit switch: quit game               }
    gvs_message:string;                         { stores message to be displayed           }
    gv_ColorPalette:palettes;                   { stores colors for fading                 }
    gvb_FrameRate:boolean;                      { Frame rate couter switch                 }
    gvb_Useblaster:boolean;                     { Use adlib switch  : forced false         }


    H,M,M2,s1,s2,s100 : word;                   { Storage for timer                        }


{ ------------------------------------------------------------------------
  Name              : BEEP
  function          : Makes Pc speaker sound at frequency F for D
                      milliseconds
  variables changed : NONE
  ------------------------------------------------------------------------ }




{ ------------------------------------------------------------------------
  Name              : Fire Fx
  function          : cool flame in the backgound
  variables changed : Vaddr3 ( virtual screen 3),gv_sprite.FireObjects
 ------------------------------------------------------------------------ }

procedure fire_fx;
var color ,                          { color to be placed                   }
    x,                               { x cord of next calc                  }
    y,                               { y cord of next calc                  }
    counter,                         { for counting                         }
    xt,                              { Temp x for bits drawn                }
    yt: word;                        { Temp y for bits drawn                }

begin

    for counter:=1 to 200 do
    if scrapnal[counter].on then
     with scrapnal[counter] do
      firepage.rectangle(round(x-1),round(y-1),round(x+1),round(y+1),254);


    for counter:=1 to gc_NumRockets do
   begin
    if ((gv_sprite.rockets[counter].on) and
        (gv_sprite.rockets[counter].special>0) and
        (gv_sprite.rockets[counter].y>2)) then
    begin
     xt:=gv_sprite.rockets[counter].x;
     yt:=gv_sprite.rockets[counter].y;
     if random<0.5 then inc(xt) else dec(xt);
     if random<0.5 then inc(yt) else dec(yt);
     color:=210;

     firepage.rectangle(xt-2,yt,xt+2,yt+2,color);
    end;



    if gv_sprite.FireObjects[counter].on=true then
    if gv_sprite.FireObjects[counter].special>0 then
    begin
     xt:=gv_sprite.FireObjects[counter].x;
     if xt>=316 then xt:=314;
     yt:=gv_sprite.FireObjects[counter].y;
     if yt<=6 then yt:=8;
     if xt div 2 <>0 then if random<0.5 then inc(xt) else dec(xt);
     if yt div 2 <>0 then if random<0.5 then inc(yt) else dec(yt);
     if xt<6 then xt:=6;
     color:=200;
     if gv_sprite.FireObjects[counter].fired=true then
     begin
      if xt+10>316 then  xt:=((xt+10)-316)+xt;
      firepage.rectangle(xt,yt,xt+10,yt+4,color)
     end
     else
      firepage.rectangle(xt-4,yt-4,xt+4,yt+4,color);
    end;
   end;
   firepage.average(32,-2,200);

  for counter:=1 to gc_NumRockets do
  with gv_sprite.FireObjects[counter] do
  begin
   fired:=false;
   special:=0;
   sprite:=0;
   x:=0;
   y:=0;
   on:=false;
  end;
end;


{
  Name              :Draw gv_sprite.Aliens
  function          :Draws gv_sprite.Aliens sprite SPR at X,Y location
  variables changed :Vaddr ( virtual screen 1)
}






procedure draw_alien(x,y,spr:integer);


{ sprites are storred in arrays as colors }
const nx=5;                                     { gv_sprite.Aliens width  }
      ny=5;                                     { gv_sprite.Aliens length }

      { bonus ship sprite}
      t4000:array[1..5,1..10] of byte =
      ((000,000,008,008,000,000,007,015,015,000),
       (000,255,255,008,007,007,007,007,015,015),
       (255,255,255,255,008,007,007,007,015,015),
       (000,255,255,008,007,007,007,007,015,015),
       (000,000,008,008,000,000,007,015,015,000));

      { gv_sprite.Aliens ship1  }
      ship:array[1..ny*nx] of byte=(000,006,014,015,000,
                                    006,004,014,004,015,
                                    006,014,014,015,015,
                                    000,014,014,015,000,
                                    006,000,014,000,015);

      { gv_sprite.Aliens ship2  }
     ship1:array[1..ny*nx] of byte =(008,000,000,000,015,
                                     000,007,000,007,000,
                                     008,000,007,000,015,
                                     000,007,000,007,000,
                                     008,000,000,000,015);

     { gv_sprite.Aliens ship3  }
     ship2:array[1..ny*nx] of byte =(001,001,009,009,009,
                                     010,010,009,010,010,
                                     000,001,009,009,000,
                                     001,000,000,000,009,
                                     001,000,000,000,009);

      { gv_sprite.Aliens ship4  }
     ship3:array[1..ny*nx] of byte =(000,009,009,009,000,
                                     001,009,009,009,015,
                                     001,001,009,015,015,
                                     000,001,009,015,000,
                                     000,000,009,000,000);

      { gv_sprite.Aliens ship5  }
     ship4:array[1..ny*nx] of byte =(000,002,010,015,000,
                                     002,012,010,012,015,
                                     002,010,010,010,015,
                                     000,002,010,015,000,
                                     000,000,000,000,000);

      { gv_sprite.Aliens ship6  }
     ship5:array[1..ny*nx] of byte =(015,007,000,007,015,
                                     000,015,007,015,000,
                                     009,009,015,009,009,
                                     000,001,009,001,000,
                                     000,000,009,000,000);

      { gv_sprite.Aliens ship7  }
     ship6:array[1..ny*nx] of byte =(000,002,010,015,000,
                                     002,004,010,004,015,
                                     002,004,010,004,015,
                                     000,010,010,015,000,
                                     000,002,000,015,000);


var i,ii,iii:integer; { counter vars }
    col:byte;           { random color }

begin

                                                { check if bonus ship sprite wanted }
 if spr=4000 then
 begin                                          { if bonus the draw each pixel onto vaddr }
  for ii:=0 to 9 do
  for i :=0 to 4 do
  begin
  col:=random(100)+31;
{   iii:=random(40);                             { select a random gv_sprite.FireObjects color  }
{   if iii<15 then Col:=4 else if iii>28 then Col:=12 else Col:=14;

   { check if pixel then draw approate color or don't draw at all }
   if t4000[i+1,ii+1]=255 then
   begin
    if gv_config.usefire and gv_config.fast then
     firepage.putpixel(x+ii,y+i,col+100);
     drawpage.PutPixel(X+ii,Y+i,Col+100)
   end
   else
     if t4000[i+1,ii+1]<>0 then drawpage.PutPixel(X+ii,Y+i,t4000[i+1,ii+1]);
  end;
 end
 else
case spr of
 1: drawpage.PutPic(X,Y,ship ,5,5);
 2: drawpage.PutPic(X,Y,ship1,5,5);
 3: drawpage.PutPic(X,Y,ship2,5,5);
 4: drawpage.PutPic(X,Y,ship3,5,5);
 5: drawpage.PutPic(X,Y,ship4,5,5);
 6: drawpage.PutPic(X,Y,ship5,5,5);
 7: drawpage.PutPic(X,Y,ship6,5,5);
 end;

end;


{
  Name              : Draw_rocket
  function          : Draws a hero rocket at RX,RY location
  variables changed : vaddr (Virtual screen1)
}

procedure draw_rocket(rx,ry:integer);
CONST ROCK:ARRAY[1..8] OF BYTE=(009,009,015,015,015,255,255,255);
VAR  I,II,iii:INTEGER; { Counter vars }
     gv_ColorPalette:byte;           { random color }
begin;


 { draw rocket: if pixel is 255 draw random color }
       for ii:=0 to 7 do
       if rock[ii+1]=255 then
       begin
          { choose random gv_sprite.FireObjects color }
          iii:=random(40)+210;
{          if gv_config.fast and gv_config.usefire then
          firepage.putpixel(rx,ry+ii-2,iii) else}
          drawpage.PutPixel(rx,RY+ii,iii)
       end
       else
        drawpage.PutPixel(rx,RY+ii,rock[II+1]);


       if (gv_config.usefire and gv_config.fast) then
       begin
        inc(rx);
        if random>0.5 then
        if random<0.6 then dec(rx) else inc (rx);
{        if random<0.5 then dec(ry);}
        firepage.rectangle(rx-1,ry+2,rx+1,ry+4,224);
       end;


end;


{
  Name              :Draw gv_sprite.rockets
  function          :executes draw_rocket for all gv_sprite.rockets
  variables changed :NONE
}

procedure drawsp(i:integer);
const up :array[0..24] of byte= (00,00,15,00,00,
                                 00,15,12,15,00,
                                 15,12,04,12,15,
                                 12,04,00,04,12,
                                 04,00,00,00,04);

const upr:array[0..24] of byte= (04,12,15,15,15,
                                 00,04,12,12,15,
                                 00,00,04,12,15,
                                 00,00,00,04,12,
                                 00,00,00,00,04);
const  r :array[0..24] of byte= (04,12,15,00,00,
                                 00,04,12,15,00,
                                 00,00,04,12,15,
                                 00,04,12,15,00,
                                 04,12,15,00,04);

const upl:array[0..24] of byte= (15,15,15,12,04,
                                 12,12,12,04,00,
                                 15,12,04,00,00,
                                 12,04,00,00,00,
                                 04,00,00,00,00);

const  l :array[0..24] of byte= (00,00,15,12,04,
                                 00,15,12,04,00,
                                 15,12,04,00,00,
                                 00,15,12,04,00,
                                 00,00,15,12,04);

var xx,yy:integer;
begin
  with gv_sprite.rockets[i] do
{     for xx:=0 to 4 do
     for yy:=0 to 4 do}
     case xa of
          0:begin
              drawpage.putpic(x,y,up,5,5);
              firepage.rectangle(x,y,x+5,y+5,254);
            end;

          1:if ya>0 then
            begin
              drawpage.putpic(x,y,upl,5,5);
              firepage.rectangle(x,y,x+5,y+5,254);
             end
            else
             begin
              drawpage.putpic(x,y,l,5,5);
              firepage.rectangle(x,y,x+5,y+5,254);
             end;

         -1:if ya>0 then
            begin
              drawpage.putpic(x,y,upr,5,5);
              firepage.rectangle(x,y,x+5,y+5,254);
            end
            else
             begin
              drawpage.putpic(x,y,l,5,5);
              firepage.rectangle(x,y,x+5,y+5,254);
             end;
     end;
end;

PROCEDURE DRAW_ROCKETS;
var i:integer; { counter var }
BEGIN

     { Draw all gv_sprite.rockets that are "on" }
      FOR i:=1 to gc_NumRockets do
      if gv_sprite.rockets[i].on=true then
      if gv_sprite.rockets[i].special=8 then drawsp(i)
      else
      draw_rocket(gv_sprite.rockets[i].x,gv_sprite.rockets[i].y);
end;

{
  Name              : Draw ship
  function          : Draws hero's ship at X,Y
  variables changed : Vaddr (virtual screen1)
}

procedure draw_ship(x,y:integer);
const ship:array[1..25] of byte =(000,000,005,000,000,
                                  000,009,005,009,000,
                                  009,001,015,001,009,
                                  009,001,015,001,009,
                                  009,001,015,001,009);
shield:array[1..9*7] of byte =(000,000,003,003,003,003,003,000,000,
                               000,003,011,011,011,011,011,003,000,
                               003,011,000,003,000,003,000,011,003,
                               003,011,003,000,003,000,003,011,003,
                               003,011,000,003,000,003,000,011,003,
                               003,011,003,000,003,000,003,011,003,
                               000,003,000,003,000,003,000,003,000);

begin
 drawpage.PutPic(x,y,ship,5,5);
 if gvI_Shield>0 then
 begin
  if round((gvI_Shield/200)*100)<=10 then
            if (gvI_Shield mod 2)=0 then drawpage.PutPic(x-2,y-2,shield,9,7);
  if round((gvI_Shield/200)*100)>10 then drawpage.PutPic(x-2,y-2,shield,9,7);
 end
end;

{
  Name              : Super rocket trigger
  function          : fires special type method gvI_SpecialWeaponType
                      checks if any gv_sprite.rockets are free and fires them
  variables changed : gv_sprite.rockets,gvI_SpecialWeaponsCounter,gvI_Shield
}

procedure super_trigger;
var i,ii:integer;  { counter vars }
begin
  case gvI_SpecialWeaponType of   { gvI_SpecialWeaponType=special weapon type }

  { rocket beam }
  1:if ((gvI_herox>20) and (gvI_herox<300)) then  { check hero's location }
  begin
   gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;    { decrease number of super weapons }
   i:=1;ii:=0;  { init counters }
   repeat
   if gv_sprite.rockets[i].on=false then  { check if rocket is free }
   begin gv_sprite.rockets[i].x:=gvI_herox;      { set x var }
         gv_sprite.rockets[i].y:=190-ii;  { set y var }
         gv_sprite.rockets[i].on:=true;   { set on to true }
         gv_sprite.rockets[i].special:=1;   { set special to true }
         inc(ii);               { inc number of gv_sprite.rockets found }
   end;
   inc(i);                      { inc rocket number : array }

   { continue till out of gv_sprite.rockets or found 20 }
   until ((ii=20) or (i=gc_NumRockets+1));
  end;

  { scatter }
  2:if ((gvI_herox>30) and (gvI_herox<300)) then  { check hero's location }
  begin
   gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;        { decrease number of super weapons }
   i:=1;ii:=0;      { init counters }
   repeat
   if gv_sprite.rockets[i].on=false then   { check if rocket is free }
   begin
         gv_sprite.rockets[i].x:=gvI_herox-(round(20/2)*2)+(ii*2); { set x var }
         gv_sprite.rockets[i].y:=190;                       { set y var }
         gv_sprite.rockets[i].on:=true;                     { set on to true }
         gv_sprite.rockets[i].special:=2;   { set special to true }
         inc(ii);                    { inc number of gv_sprite.rockets found }
   end;
   inc(i);                           { inc rocket number : array }

     { continue till out of gv_sprite.rockets or found 20 }
   until ((ii=20) or (i=gc_NumRockets+1));
  end;

  { Super Scatter}
  3:if ((gvI_herox>80) and (gvI_herox<240)) then  { check hero's location }
  begin;
   gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;           { decrease number of super weapons }
   i:=1;ii:=0;         { init counters }
   repeat
   if gv_sprite.rockets[i].on=false then    { check if rocket is free }
   begin inc(ii);           { inc number of gv_sprite.rockets found }
         gv_sprite.rockets[i].x:=(gvI_herox-(round(20/2)*5))+(ii*5); { set x var }
         gv_sprite.rockets[i].y:=190;                         { set y var }
         gv_sprite.rockets[i].on:=true;                       { set on to true }
         gv_sprite.rockets[i].special:=3;   { set special to true }
   end;
   inc(i);                               { inc rocket number : array }
     { continue till out of gv_sprite.rockets or found 20 }
   until ((ii=20) or (i=gc_NumRockets+1));
  end;

  { Super rocket beam }
  4:if ((gvI_herox>40) and (gvI_herox<280)) then  { check hero's location }
    begin
     gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;        { decrease number of super weapons }
     i:=1;ii:=0;      { init counters }
     repeat
      if gv_sprite.rockets[i].on=false then     { check if rocket is free }
      begin inc(ii);             { inc number of gv_sprite.rockets found }
          gv_sprite.rockets[i].x:=gvI_herox;      { set x var }
          gv_sprite.rockets[i].sprite:=gvI_herox; { set last postion : for sine calc }
          gv_sprite.rockets[i].y:=190-ii;  { set y var }
          gv_sprite.rockets[i].on:=true;   { set on to true }
          gv_sprite.rockets[i].fired:=true; { for sine calc enable }
          gv_sprite.rockets[i].special:=4;   { set special to true }
      end;
      inc(i);                 { inc rocket number : array }
     { continue till out of gv_sprite.rockets or found 20 }
     until ((ii=20) or (i=gc_NumRockets+1));
    end;

  { shield/Invinsability}
  5:begin gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;gvI_Shield:=gvI_Shield+200;end; { make shield active }

  { Cyclone }
  6:if ((gvI_herox>20) and (gvI_herox<300)) then
    begin
     gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;
     i:=1;ii:=0;      { init counters }
     repeat
      if gv_sprite.rockets[i].on=false then
      begin
        gv_sprite.rockets[i].x:=gvI_herox;
        gv_sprite.rockets[i].y:=190-ii;
        gv_sprite.rockets[i].on:=true;
        gv_sprite.rockets[i].fired:=true;
        gv_sprite.rockets[i].sprite:=gvI_herox;
        gv_sprite.rockets[i].special:=6;   { set special to true }
        inc(ii);
      end;
     inc(i);
     until ((ii=20) or (i=gc_NumRockets+1));
     end;

  { super Cyclone }
  7:if ((gvI_herox>40) and (gvI_herox<280)) then
    begin
     gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter-1;
     i:=1;ii:=0;      { init counters }
     repeat
     if gv_sprite.rockets[i].on=false then
      begin
        gv_sprite.rockets[i].x:=gvI_herox;
        gv_sprite.rockets[i].sprite:=gvI_herox;
        gv_sprite.rockets[i].y:=190-ii;
        gv_sprite.rockets[i].on:=true;
        gv_sprite.rockets[i].fired:=true;
        gv_sprite.rockets[i].special:=7;   { set special to true }
           inc(ii);
       end;
      inc(i);
     until ((ii=20) or (i=gc_NumRockets+1));
     end;
  8:if ( gvi_herox>20) and (gvi_herox<299) then
    begin
     dec(gvi_specialweaponscounter);
     i:=1;
     while ((gv_sprite.rockets[i].on=true) and (i<gc_numrockets)) do inc(i);
     if gv_sprite.rockets[i].on=false then
     begin
      gv_sprite.rockets[i].on:=true;
      gv_sprite.rockets[i].special:=8;
      gv_sprite.rockets[i].x:=gvi_herox;
      gv_sprite.rockets[i].xa:=0;
      gv_sprite.rockets[i].ya:=-1;
      gv_sprite.rockets[i].sprite:=3;
     end;
    end;
 end;
end;




{
  Name              : Rocket trigger
  function          : Fires one rocket if any gv_sprite.rockets are free
  variables changed : gv_sprite.rockets
}

procedure  rocket_trigger(tx:integer);
var i:integer; { counter var }
    t:boolean; { rocket found switch }
begin
 i:=1;       { set counter to start of array search }
 t:=false;   { haven't found any gv_sprite.rockets free yet   }
 while (t=false)  do   { if haven't found a rocket repeat below block }
 begin
  if  gv_sprite.rockets[i].on=false then   { if rocket free then }
  begin gv_sprite.rockets[i].x:=tx;         { set x corord      }
        gv_sprite.rockets[i].y:=190;        { set y corord      }
        gv_sprite.rockets[i].on:=true;      { tell sprite it is being used }
        gv_sprite.rockets[i].special:=0;   { set special to true }
        t:=true;                  { found a rocket!!! }
  end;
  i:=i+1; { point to next rocket }
  if i=gc_NumRockets+1 then    { if exceed max gv_sprite.rockets then stop search }
    begin
       t:=true;
     end;
 end;
end;





{scrapnal procs}
procedure make_new_scrap(x,y:integer);
var counter,
    counter1,
    counter2:integer;
    found:boolean;
begin
 found:=false;
 counter:=random(40)+10;
 counter1:=1;
 counter2:=1;
 while (( counter1<200 ) and ( counter2<counter)) do
 begin
  if not scrapnal[counter2].on then
   begin
    scrapnal[counter2].x:=x;
    scrapnal[counter2].y:=y;
    if random<0.5 then
       scrapnal[counter2].xa:=-(random(9)+2) else
       scrapnal[counter2].xa:=(random(9)+2);

    if random<0.2 then
       scrapnal[counter2].ya:=-random(9) else
       scrapnal[counter2].ya:=random(3);

    scrapnal[counter2].on:=true;
    scrapnal[counter2].life:=random(60)+1;
    inc(counter2);
   end;
   inc(counter1);
 end;{while}
end;

procedure check_scrap;
var counter:integer;
begin
 for counter:=1 to 200 do
  if scrapnal[counter].on then
   with scrapnal[counter] do
   begin
    if xa<0 then xa:=xa+0.5 else
    if xa>0 then xa:=xa-0.5;
    if ((y<180) and (ya<4)) then ya:=ya+0.5;
    x:=x+xa;
    if y<190 then y:=y+ya;
    dec(life);
    if ((x<5) or (x>315) or (y<5) or (y>195) or (life<=0)) then on:=false;
   end;
end;


{
  Name              : check gv_sprite.rockets
  function          : checks hero's gv_sprite.rockets for collisions
                      destroys aliens if hit and
                      issues prize if gv_sprite.BonusAlien is hit (bonus gv_sprite.Aliens)
  variables changed : ALIENS,gvI_SpecialWeaponsCounter,gvI_SpecialWeaponType,
                      gv_sprite.rockets,gvL_Score,gvI_Lives,gvs_message,
                      gvI_MessageX,gvI_Messagey,gvI_MessageTimer

}

procedure  check_rockets;
const
        { explosion pic }
        expl:array[1..5,1..5] of byte =((012,000,014,000,012),
                                        (000,004,012,004,000),
                                        (014,012,007,012,014),
                                        (000,004,012,004,000),
                                        (012,000,014,000,012));

var i,ii,iii,iv,  { counter vars }
    tmp,          { temp var     }
    std,std2,     { counter for special weapon }
    tt1,tt2,tt3,
    a,a2:integer; { counter vars }
    fnd:boolean;
begin
 check_scrap;
 std:=1;      { init count }
 std2:=std;
     fnd:=false;
 for i:=1 to gc_NumRockets do  { go though all gv_sprite.rockets }
 if  gv_sprite.rockets[i].on=true then { if rocket is on then .... }
 with gv_sprite do
 begin
   rockets[i].y:=rockets[i].y-6; { make rocket rise 6 pixels }
   if rockets[i].special=8 then tt3:=5 else tt3:=0;
   if (rockets[i].y<=0) or (rockets[i].x<=0) or( rockets[i].x+tt3>=319) then
    { is rocket going off the screen ?}
   begin                 { if yes then clear sprite vars }
    rockets[i].on:=false;
    rockets[i].special:=0;
    rockets[i].sprite:=0;
    rockets[i].fired:=false;
    rockets[i].x:=gvI_herox;
    rockets[i].y:=gvI_heroy;
   end;
  with rockets[i] do
  case special of
  4:if (fired=true )  then { is special weapon 4?}
   begin { if so, has diff calc }
    case std of { which calc? }
     1:x:=round(sqrt(195-y)+sprite);
     2:x:=sprite;
     3:x:=round(-sqrt(195-y)+sprite);
    end;
    std:=std+1; { inc calc formula }
    if std>=4 then std:=1; { if formaula over 4 make equal to 1 }
   end;

  6:if (fired=true)  then
    x:=round(sin(y)*5)+sprite;

  7:if (fired=true)  then
    begin
     case std2 of
      1:x:=round(sqrt(195-y)+round(sin(y)*5)+sprite);
      2:x:=round(sin(y)*5)+sprite;
      3:x:=round(-sqrt(195-y)+round(sin(y)*5)+sprite);
     end;
     std2:=std2+1;
     if std2>=4 then std2:=1;
    end;
  8: begin x:=x+xa; y:=y+ya; end;
  end;


   { ---- check if bonuse ship hit---------------}
    if gv_sprite.rockets[i].special=8 then tt3:=5 else tt3:=0;
    if (gv_sprite.BonusAlien.on=true) then { if bonus ship on and }

    if((gv_sprite.rockets[i].y<=5) and
        (gv_sprite.rockets[i].x>=gv_sprite.BonusAlien.x) and
        (gv_sprite.rockets[i].x+tt3<=gv_sprite.BonusAlien.x+9))then

           { rocket is in same place  then }
        begin { bang! bonus ship is dead! }
         gv_sprite.BonusAlien.on:=false;        { make bonus turn off }
         gv_sprite.rockets[i].sprite:=0;   { init rocket vars }
         gv_sprite.rockets[i].fired:=false;
         gv_sprite.rockets[i].on:=false;
         gv_sprite.rockets[i].special:=0;
         gv_sprite.rockets[i].x:=gvI_herox;
         gv_sprite.rockets[i].y:=gvI_heroy;
         gv_sprite.rockets[i].xa:=0;
         gv_sprite.rockets[i].ya:=0;

{         if gvb_useblaster then initsound(3);}
         { explode bonus ship }
         for iii:=1 to 3 do
         begin
          if (gv_Config.fast and gv_Config.UseFire) then
          begin
           gv_sprite.FireObjects[i].x:=gv_sprite.BonusAlien.x;
           gv_sprite.FireObjects[i].y:=gv_sprite.BonusAlien.y;
           gv_sprite.FireObjects[i].on:=true;
           gv_sprite.FireObjects[i].special:=1;
           gv_sprite.FireObjects[i].fired:=true;
          end
          else
          drawpage.PutPic(gv_sprite.BonusAlien.x+(iii-1)*5,gv_sprite.BonusAlien.y,expl,5,5);
          for a2:=(iii*2) to (iii*5) do
           for i:=1 to 3 do
           if not gvb_Useblaster then beep(round(i*sin(i)*i*2)+20,1,false);
           delay(10);
           fnd:=true;
          end;

     {----- select random prize and initalize it --}

     { choose random number }
     for iii:=1 to random((random(200)))*2+5 do  iv:=(random(3))+1;
     case iv of
     1:begin     { weapon }
       if gvI_SpecialWeaponsCounter<=0 then   { if no special weapons left the choose a new one }
        for iii:=1 to random(40)+5 do gvI_SpecialWeaponType:=random(8)+1;
       gvI_SpecialWeaponsCounter:=gvI_SpecialWeaponsCounter+10;      { inc number of special weapons in stock }
       gvI_MessageTimer:=100;      { set message delay }

       { set message }
       case gvI_SpecialWeaponType of
        1:gvs_message:='ROCKET BEAM';
        2:gvs_message:='SCATTER';
        3:gvs_message:='SUPER SCATTER';
        4:gvs_message:='SUPER ROCKET BEAM';
        5:gvs_message:='SHIELD';
        6:gvs_message:='CYCLONE';
        7:gvs_message:='SUPER CYCLONE';
        8:gvs_message:='SUPER KILL';
       end;
      end;

     2:begin { extra life }
          gvs_message:='1UP'; { set message }
          gvI_MessageTimer:=100;  { set message delay }
          if gvI_Lives<=8 then gvI_Lives:=gvI_Lives+1;  { inc gvI_Lives [max 9] }
       end;

  3..4:begin { random points }
       tmp:=round(random(300)); { set random points }
       gvs_message:=inttostr(tmp)+' POINTS'; { set message }
       gvL_Score:=gvL_Score+tmp; { inc gvL_Score }
       gvI_MessageTimer:=100;  { set message delay }
       end;

    end;
  end;
  end; { end of rocket loop }

 for i:=1 to gc_NumRockets do  { go though all gv_sprite.rockets }
  { ----------- check if any aliens hit ----------- }
    if gv_sprite.rockets[i].on then
    begin
    if gv_sprite.rockets[i].special=8 then tt3:=0 else tt3:=0;
    for ii:=1 to gc_ax do
    for iii:=1 to gc_ay do
    if gv_sprite.Aliens[ii,iii].on=true then
    if ((gv_sprite.rockets[i].x>=gv_sprite.Aliens[ii,iii].x)   and
        (gv_sprite.rockets[i].x+tt3<=gv_sprite.Aliens[ii,iii].x+5) and
        (gv_sprite.rockets[i].y+tt3<=gv_sprite.Aliens[ii,iii].y+5) and
        (gv_sprite.rockets[i].y>=gv_sprite.Aliens[ii,iii].y)) then

   begin
    if (gv_Config.fast and gv_Config.UseFire) then
    begin
      gv_sprite.FireObjects[i].x:=gv_sprite.Aliens[ii,iii].x;
      gv_sprite.FireObjects[i].y:=gv_sprite.Aliens[ii,iii].y;
      gv_sprite.FireObjects[i].on:=true;
      gv_sprite.FireObjects[i].special:=1;
      if random>0.5 then make_new_scrap(gv_sprite.Aliens[ii,iii].x,gv_sprite.Aliens[ii,iii].y);
    end
    else  drawpage.PutPic(gv_sprite.Aliens[ii,iii].X,gv_sprite.Aliens[iI,iii].Y,expl,5,5);

{    if gvb_useblaster then initsound(2)
    else}
    for tt1:=1 to 2 do
       beep(round((tt1*1.5)+sin(tt1*1.5)*tt1*1.5),1,false);

    FND:=TRUE;

    if ((gv_sprite.rockets[i].special=8) and
       (gv_sprite.rockets[i].sprite>0))   then
    begin
     tt1:=1;tt2:=0;
     repeat
      if gv_sprite.rockets[tt1].on=false then
      begin
        gv_sprite.rockets[tt1].x:=gv_sprite.rockets[i].x;
        gv_sprite.rockets[tt1].y:=gv_sprite.rockets[i].y;
        gv_sprite.rockets[tt1].on:=true;
        gv_sprite.rockets[tt1].special:=8;   { set special to true }
        gv_sprite.rockets[tt1].sprite:=gv_sprite.rockets[i].sprite-1;
        case tt2 of
         0:begin gv_sprite.rockets[tt1].xa:=-6;
                 gv_sprite.rockets[tt1].ya:=6; end;

         1:begin gv_sprite.rockets[tt1].xa:=-6;
                 gv_sprite.rockets[tt1].ya:=0; end;

         2:begin gv_sprite.rockets[tt1].xa:=0;
                 gv_sprite.rockets[tt1].ya:=0; end;

         3:begin gv_sprite.rockets[tt1].xa:=6;
                 gv_sprite.rockets[tt1].ya:=0; end;

         4:begin gv_sprite.rockets[tt1].xa:=6;
                 gv_sprite.rockets[tt1].ya:=6; end;
        end;
        inc(tt2);
      end;
      inc(tt1);
      until ((tt2=5) or (tt1=gc_NumRockets+1));
     end;

    gv_sprite.rockets[i].sprite:=0;
    gv_sprite.rockets[i].fired:=false;
    gv_sprite.rockets[i].on:=false;
    gv_sprite.rockets[i].special:=0;
    gv_sprite.rockets[i].x:=gvI_herox;
    gv_sprite.rockets[i].y:=gvI_heroy;
    gv_sprite.rockets[i].xa:=0;
    gv_sprite.rockets[i].ya:=0;
    gv_sprite.Aliens[ii,iii].on:=false;
    gvL_Score:=gvL_Score+1;


  end;
  end;
  IF FND THEN if not gvb_useblaster then  nosound;
end;


{
  Name              : draw gvI_AlienBombCounter dombs
  function          : Draws all on gv_sprite.AlienBombs
  variables changed : vaddr (virtual screen1)
}

PROCEDURE DRAW_bad;
CONST ROCK:ARRAY[1..3] OF BYTE=(2,10,15); { sprite }

VAR  I,II,iii:INTEGER; { counter vars }
BEGIN
     FOR i:=1 to gc_ax do  { for every bomb }
      for ii:=1 to gc_ay do
       if gv_sprite.AlienBombs[i,ii].on=true then { if bomb is on then draw it }
        drawpage.PutPic(gv_sprite.AlienBombs[i,ii].X,gv_sprite.AlienBombs[I,ii].Y,ROCK,1,3);
end;


{
  Name              : Check gvI_AlienBombCounter bombs
  function          : Checks gv_sprite.AlienBombs collision detections
                      Destorys hero
  variables changed : gv_sprite.AlienBombs,gvI_Lives
}

procedure  check_bad;
var i,ii,iii:integer;
begin
    for i:=1 to gc_ax do  { for every gvI_AlienBombCounter thing }
    for ii:=1 to gc_ay do
    if gv_sprite.AlienBombs[i,ii].on then  { check if on }
    begin
    if ((gvI_Shield<1) and            { check if hero is invinsible }
        (gv_sprite.AlienBombs[i,ii].x>=gvI_herox) and    { if not   }
        (gv_sprite.AlienBombs[i,ii].x<=gvI_herox+4) and  { and hero }
        (gv_sprite.AlienBombs[i,ii].y>188) and    { is hit   }
        (gv_sprite.AlienBombs[i,ii].y<193)) then  { then ... }
     begin
      gv_sprite.AlienBombs[i,ii].on:=false;  { turn bomb off   }
      gv_sprite.Aliens[i,ii].fired:=false;    { gv_sprite.Aliens not fired }
      gvI_AlienBombCounter:=gvI_AlienBombCounter-1;                  { number of bombs decreses }
      if gvI_AlienBombCounter<0 then gvI_AlienBombCounter:=0;        { make gvI_AlienBombCounter=0 if below 0 }
      gvI_Lives:=gvI_Lives-1;              { loose a life }
      gvI_Shield:=gvI_Shield+200;              { shield active }
{      if gvb_useblaster then initsound(1)
      else}
       if gv_Config.UseSound then
       for iii:=200 downto 10 do  beep(iii*10,1,false);{ make sound }
      if not gvb_Useblaster then nosound;
      if gvI_Lives<0 then gvb_LevelComplete:=true;          { if dead swich end of gvI_Level}
     end;
 end;

 { bomb calcs and off screen check }
 FOR I:=1 to gc_ax do
 for ii:=1 to gc_ay do
 if gv_sprite.AlienBombs[i,ii].on=true then
 begin
     { gc_speed of drop.... may make single gc_speed ?? }
     gv_sprite.AlienBombs[i,ii].y:=gv_sprite.AlienBombs[i,ii].y+1;
     if ((gvI_Level>3) and (gvI_Level <=6)) then
         gv_sprite.AlienBombs[i,ii].y:=gv_sprite.AlienBombs[i,ii].y+2;
     if ((gvI_Level>6) and (gvI_Level <=9)) then
         gv_sprite.AlienBombs[i,ii].y:=gv_sprite.AlienBombs[i,ii].y+3;
{    if ((gvI_Level>9) and (gvI_Level <=12)) then
         gv_sprite.AlienBombs[i,ii].y:=gv_sprite.AlienBombs[i,ii].y+4;
    if gvI_Level>12  then gv_sprite.AlienBombs[i,ii].y:=gv_sprite.AlienBombs[i,ii].y+5;}

    if gv_sprite.AlienBombs[i,ii].y>=193 then {if off screen delete bomb }
    begin
    gv_sprite.Aliens[i,ii].fired:=false;   { gv_sprite.Aliens can gv_sprite.FireObjects }
    gv_sprite.AlienBombs[i,ii].on:=false; { bomb now off   }
       gvI_AlienBombCounter:=gvI_AlienBombCounter-1;              { one less bomb on screen }
    if gvI_AlienBombCounter<0 then gvI_AlienBombCounter:=0;       { err checking of bomb >=0 }
   end;

 end;

end;


{
  Name              : gv_sprite.FireObjects gvI_AlienBombCounter
  function          : fires gv_sprite.AlienBombs[A,a2] if it is free
  variables changed : gv_sprite.AlienBombs
}

procedure  fire_bad(a,a2:integer);
begin
 if  gv_sprite.AlienBombs[a,a2].on=false then { check if bomb free }
  begin gv_sprite.AlienBombs[a,a2].x:=gv_sprite.Aliens[a,a2].x+2; { init bomb x }
        gv_sprite.AlienBombs[a,a2].y:=gv_sprite.Aliens[a,a2].y+5; { init bomb y }
        gv_sprite.AlienBombs[a,a2].on:=true;           { bomb now drawen }
        gvI_AlienBombCounter:=gvI_AlienBombCounter+1;                          { add bomb on screen total }
        gv_sprite.Aliens[a,a2].fired:=true;            { gv_sprite.Aliens can't gv_sprite.FireObjects now }
  end;
end;

{
  Name              : Aliens
  function          : Checks if aliens  have hit sides of screen and makes
                      them rebound
                      Randomly fires a gv_sprite.AlienBombs
                      Randomly sets up gv_sprite.BonusAlien
                      Checks if aliens have reached bottom
                      Checks if all aliens are dead
  variables changed : gv_sprite.BonusAlien,gv_sprite.Aliens,gvI_Lives,gvb_LevelComplete
}

procedure aliens;
var i,ii,ya,ta:integer; { counters }
begin
 ya:=0;  { init counter }
 ta:=0;  { init counter }
 for ii:= 1 to gc_ay do  { loop though aliens down }
  for i:=1 to gc_ax do    { loop though aliens accross }
  if gv_sprite.Aliens[i,ii].on=true then { check if gv_sprite.Aliens is on screen }
 begin { if yes then }
     if gv_sprite.Aliens[i,ii].x+5>319 then { check if reached far right }
  begin  { if so then }
   gvI_AlienCounter:=-1; { direction change : to left }
   ya:=1;  { drop aliens down 1 }
  end;
  if gv_sprite.Aliens[i,ii].x<1 then  { check if reached far left }
  begin { if so then }
   gvI_AlienCounter:=1; { direction change : to right }
   ya:=1; { drop aliens down 1 }
  end;
  if gv_sprite.Aliens[i,ii].y+5>=190 then  { if gv_sprite.Aliens reached bottom }
   begin { end of game : compleate gvI_Level }
    gvI_Lives:=-1;
    gvb_LevelComplete:=true;
   end;
    ta:=ta+1;  { tally aliens left }
 end;

 for i:= 1 to gc_ax do     { loop though }
 for ii:=1 to gc_ay do     { all aliens  }
 if gv_sprite.Aliens[i,ii].on=true then { in gv_sprite.Aliens on screen then .. }
 begin
  draw_alien (gv_sprite.Aliens[i,ii].x,gv_sprite.Aliens[i,ii].y,gv_sprite.Aliens[i,ii].sprite); { draw gv_sprite.Aliens }

 { if rebouning then drop aliens down 5 }
 if ya=1 then gv_sprite.Aliens[i,ii].y:=gv_sprite.Aliens[i,ii].y+3;

 { move aliens left or right }
  gv_sprite.Aliens[i,ii].x:=gv_sprite.Aliens[i,ii].x+gvI_AlienCounter;
  { random gv_sprite.FireObjects }
 if ((gvI_AlienBombCounter<gc_NumBad) and               { check if max bombs on screen reached }
     (gv_sprite.Aliens[i,ii].on=true) and       { check if gv_sprite.Aliens on    }
     (gv_sprite.Aliens[i,ii].fired=false)) then { check gv_sprite.Aliens can gv_sprite.FireObjects then ... }
 if ((ta<=200+(5*gvI_Level)) and         { has enough aliens died to gv_sprite.FireObjects back }
   (random(50)+1<10+(gvI_Level*2)) and  { random based on gvI_Level }
   (random(ta)<8+gvI_Level)) then
     fire_bad(i,ii); { random based on aliens alive }
 end;
 if ta=0 then gvb_LevelComplete:=true; { if no aliens then end gvI_Level }

 if gv_sprite.BonusAlien.on=true then        { is bonus ship on screen ? }
 begin  { yes.. calc new position }
  draw_alien(gv_sprite.BonusAlien.x,gv_sprite.BonusAlien.y,4000); { draw bonus gv_sprite.Aliens }
  gv_sprite.BonusAlien.x:=gv_sprite.BonusAlien.x+2;               { move gv_sprite.Aliens accross 2 }
  if gv_sprite.BonusAlien.x+10>=319 then gv_sprite.BonusAlien.on:=false; { turn off if reached far right }
 end
 else  { no.. randomly turn on }
 if ((ta>15) and (gv_sprite.BonusAlien.on=false) and (random(600)<10) and
    (random(600)>200)) then { randomly activate }
 begin
  gv_sprite.BonusAlien.on:=true; { turn bonus ship on }
  gv_sprite.BonusAlien.x:=1;     { init x }
  gv_sprite.BonusAlien.y:=1;     { init y }
 end;

end;

{
  Name              : gvL_Score board
  function          : draws current gvL_Score across bottom of screen
  variables changed : vaddr (virtual screen1)
}

procedure scoreb;
var i,ii,iii:integer;  { counter vars }
    ts:string;         { total string }
begin
  { draw ground }
 drawpage.line(0,193,318,193,15);
 drawpage.line(0,194,318,194,7);
 drawpage.line(0,195,318,195,7);
 drawpage.line(0,196,318,196,7);
 drawpage.line(0,197,318,197,7);
 drawpage.line(0,198,318,198,7);
 drawpage.line(0,199,318,199,8);

 ts:='LEVEL:';          { these parts just add to gvL_Score board }
  if gvI_level<10  then ts:=ts+'0';
 ts:=ts+inttostr(gvI_Level)+' ';{ gvI_Level number }

 ts:=ts+'LIVES: ';       { gvI_Lives }
 ts:=ts+inttostr(gvI_Lives);
 ii:=2;

 ts:=ts+' SHIELD:';
 iii:=round((gvI_Shield/200)*100);
 ts:=ts+inttostr(iii);
 ts:=ts+'% ';
 if III<100 then ts:=ts+' ';
 if III<10  then ts:=ts+' ';

    if gvI_SpecialWeaponsCounter>=1 then
    begin
   case gvI_SpecialWeaponType of
     1:ts:=ts+'ROCKET BEAM       : ';
     2:ts:=ts+'SCATTER           : ';
     3:ts:=ts+'SUPER SCATTER     : ';
     4:ts:=ts+'SUPER ROCKET BEAM : ';
     5:ts:=ts+'SHIELD            : ';
     6:ts:=ts+'CYCLONE           : ';
     7:ts:=ts+'SUPER CYCLONE     : ';
     8:ts:=ts+'SUPER KILL        : ';
   end;
  ts:=ts+inttostr(gvI_SpecialWeaponsCounter);
  END
  ELSE TS:=TS+'EMPTY ARMOURY     : ';


  ts:=ts+' SCORE:';      { gvL_Score }
 ts:=ts+inttostr(gvL_Score);


{ for i:=1 to length(ts) do { write gvL_Score board }
 drawpage.small_string(ts,5,194,4);

end;


{
  Name              : Move sprites
  function          : Handles all sprite procedures
  variables changed : allmost all are altered via other procedures and
                      functions
}

procedure move_sprites;

var mat,mat2:integer;{ counter vars }
    ch:char;         { Key board input : a-z }
    Ticks:longint;   { delay counter for fireing }
    h, m, s,s2, hund : Word; { used to count frame/sec rate }
    tick,tick2:longint; { frame rate counters }
    frames:string;      { string for displaying frame rate }
    mus:byte;
begin
{ firepage.cls386(0);}
 gvs_message:=' ';
 gvI_heroy:=188;     { init hero's y corord }
 ch:=#0;      { init input to 0 }
 gvb_LevelComplete:=false;   { gvI_Level is not compleate }
 ticks:=0;          { weapon delay set to 0 }
 aliens;            { draw aliens      }
 Draw_ship(gvI_herox,gvI_heroy);  { dray ship        }
 scoreb;            { draw gvL_Score board }
 drawpage.flipto386(vgaseg);   { copy virtual page to screen }
 fadepal(gv_ColorPalette,0,255,10);{ fade screen in }
 tick:=0;tick2:=0;s2:=0; { init frames per sec counters }
 setfire;
 while (gvb_LevelComplete=false) do { if gvI_Level not compleate loop below block }
 begin
   ch:=#0;          { init key board input }
   ticks:=ticks+1;  { inc gv_sprite.FireObjects delay counter }
   tick:=tick+1;    { inc frame counter }
   GetTime(h,m,s,hund); { get gvI_MessageTimer }
   if s<>s2 then  { check if seconds have changed }
    begin
     tick2:=tick; { make frams per sec = tick }
     s2:=s;       { store last second value }
     tick:=0;     { reset frame counter }
    end;
    str(tick2,frames); { move tick2 into string }
    frames:='FRAME/SEC :'+frames;
      quickshift;  { get shift keys and alt/control status }
   if keypressed then ch:=upcase(readkey); { read kb if key pressed }
   if keypressed then ch:=upcase(readkey); { read kb if key pressed }
  case ch of
  'P':begin ch:=' ' ;  { pause }
      while ch<>'P' do ch:=upcase(readkey);
      end;
 #27,
  'Q':begin gvb_Quit:=true;gvb_LevelComplete:=true; end; { gvb_Quit }
  'F':if gvb_FrameRate=false then gvb_FrameRate:=true else gvb_FrameRate:=false; { frame rate }
  end;
  { movement control ..... }
  if ((leftshift=true) and (rightshift=true)) then gvI_herox:=gvI_herox else
  if (leftshift=true) then BEGIN  IF gvI_herox>=3 THEN gvI_herox:=gvI_herox-3 END else
  if (rightshift=true) then BEGIN  IF gvI_herox<=313 THEN gvI_herox:=gvI_herox+3 END;

  { special weapon button control }
  if (ctrl=true) then  { if button pressed }
  if ticks>8 then    { and 8 frames have passed since last shot }
   begin
     if gvI_SpecialWeaponsCounter>0 then super_trigger; { then gv_sprite.FireObjects if have special weapon(s) }
     ticks:=0;  { init delay counter }
   end;

  { Normal weapon button control }
  if (alt=true) then  { if button pressed }
   if ticks>gv_Config.FireRate then    { and 1 frame has passed since last shot }
       begin
        rocket_trigger(gvI_herox+2); { gv_sprite.FireObjects rocket }
        ticks:=0;              { init gv_sprite.FireObjects delay }
       end;

  { special weapon checking }
  if gvI_SpecialWeaponType=5 then
   if gvI_SpecialWeaponsCounter>5 then gvI_SpecialWeaponsCounter:=5; { make sure no more than 5 shields }
  if gvI_SpecialWeaponsCounter<0 then gvI_SpecialWeaponsCounter:=0;  { no less then 0  special weapons }
  if gvI_SpecialWeaponsCounter>30 then gvI_SpecialWeaponsCounter:=30;{ no more than 30 sepcial weapons }

  { shield checking }
  if gvI_Shield>=1 then dec(gvI_Shield);   { dec shield strength }
  if gvI_Shield>1000 then gvI_Shield:=1000;{ no more than 1000 units of shielding }

  { messaging ( top left corner ) }
  if gvI_MessageTimer>=1 then  { if gvI_MessageTimer on is above 0 then }
   begin
      dec(gvI_MessageTimer); { dec gvI_MessageTimer }

      drawpage.font8x8_string(gvs_message,0,
                              gvI_Messagey,4,gvi_messagetimer+31); { display messgae char }
       end;


   { frame rate display }
   if gvb_FrameRate then { if active then ..}
        drawpage.font8x8_string(frames,0,185,1,10); { display rate }

   if gvI_MessageTimer<=0 then gvI_MessageTimer:=0; { if message timer below 0 make it 0 }

   { hero's x location checking }
   if gvI_herox<=0 then gvI_herox:=0;     { stop movement a extream left  }
   if gvI_herox>=314 then gvI_herox:=314; { stop movement a extream right }


  waitretrace;        { wait til screen update finished   }

  aliens;           { check and draw aliens      }
  check_bad;        { calc aliens bombs position }
  check_rockets;    { check hero's gv_sprite.rockets       }
  draw_bad;         { draw gv_sprite.Aliens bombs           }
  draw_rockets;     { draw hero's gv_sprite.rockets        }
  Draw_ship(gvI_herox,gvI_heroy); { draw hero                  }
  scoreb;           { draw gvL_Score board at bottom }
  waitretrace;        { wait til screen update finished   }
  drawpage.flipto386(vgaseg);    { copy virtual page to screen       }
  if (gv_Config.fast and gv_Config.UseFire ) then
  begin fire_fx; firepage.flipto386(drawpage.screenseg); end
  else drawpage.cls386(0);

 end;

end;


{
  Name              : new gvI_Level
  function          : init sprites
  variables changed : gv_sprite
}

procedure newlevel;
var i,ii,iii,iv,v,tx,ty :integer; { counters }
begin

 { init bonus ship }
 gv_sprite.BonusAlien.on:=false;
 gv_sprite.BonusAlien.x:=0;
 gv_sprite.BonusAlien.y:=0;

 randomize;

 gvI_AlienBombCounter:=0;  { no gv_sprite.Aliens bombs on screen }

 gvI_AlienCounter:=1;   { init gv_sprite.Aliens count }

 { init gv_sprite.rockets }
 for i:=1 to gc_NumRockets do
  with gv_sprite.rockets[i] do
   begin
    fired:=false;
    special:=0;
    sprite:=0;
    x:=0;
    y:=0;
    on:=false;
    xa:=0;
    ya:=0;
   end;

  for i:=1 to gc_NumRockets do
  with gv_sprite.FireObjects[i] do
   begin
    fired:=false;
    special:=0;
    sprite:=0;
    x:=0;
    y:=0;
    on:=false;
   end;

 i:=0;   { init counter }
 ty:=7;  { init counter }
 iv:=1;  { init counter }
 iii:=1; { init counter }

 { gv_sprite.Aliens setup gv_sprite.AlienBombs init}
 for ii:=1 to gc_ay do
 begin
  tx:=1;
  for i:=1 to gc_ax do
  begin

    with gv_sprite.AlienBombs[i,ii] do  { init bad_thing }
     begin
      x:=0;                   { x corord           }
      y:=0;                   { y corord           }
      on:=false;              { not on screen      }
      fired:=false;           { init fired         }
      sprite:=0;              { init sprite number }
     end;

   with gv_sprite.Aliens[i,ii] do { init gv_sprite.Aliens }
   begin
     fired:=false;     { gv_sprite.Aliens has not fired }
     x:=tx;            { init x corord       }
     y:=ty;            { init y corord       }
     ON:=TRUE;         { gv_sprite.Aliens is on screen  }
     repeat   { pick random number }
      for v:=1 to round(random(99)+1) do
      iii:=random(7)+1
     until (iv<>iii);
     iv:=iii; { make sure more differnd aliens }
     sprite:=iii; { assign sprite picture }
     tx:=tx+8;    { inc x corords }
   end;
  end;
 ty:=ty+8;  { inc y corords }
END;

move_sprites; { play gvI_Level }
end;


{
  Name              : setup
  function          : set's up hero and backgound
  variables changed : vaddr,vaddr2,gvI_herox,XA,gvL_Score,gvI_Level,gvI_Lives,gvI_SpecialWeaponsCounter
}

procedure init;
var i:integer;
begin
 waitretrace;
 drawpage.cls386(0);
 drawpage.flipto386(vgaseg);
 gvI_herox:=160;
{ xa:=0;}
 gvL_Score:=0;
 gvI_Level:=0;
 gvI_Lives:=5;
 gvI_shield:=0;
 gvI_SpecialWeaponsCounter:=0;

end;

{
  Name              : highsore
  function          : displayes and records high scores ..
  variables changed : external "gw1.dat
}


{ please note no documentaion ... planing to up date it }
procedure HISCORE(i:integer);
begin
case i of
  1:begin
     handlehigh(true,abs(gvi_level),gvL_Score,@drawpage);
     handlehigh(false,0,0,@drawpage);
    end;
  2:handlehigh(false,0,0,@drawpage);
 end;
 setmcga;
 setfire;
end;



procedure button;
var i:integer;
begin
i:=40;
repeat
beep(round(1000-sin(i)),1,true);
i:=i+5;
until i=100;
end;


procedure do_back(ff:integer);
var   ttt,value,j,g2,g:integer;
      i:byte;

begin
 with gv_Plasma do
 begin
  angle1bak:=angle1;
  angle2bak:=angle2;
  angle3bak:=angle3;
  if gv_Config.fast= true then
  for i:=0 to 159 do
  begin
   angle1:=angle1-6.284/128;
   angle2:=angle2+2*6.284/128;
   angle3:=angle3+4*6.284/128;


   case ff of
   1: begin value:=round(16*sin(angle1)+4*cos(angle2)+4*sin(angle3));
      for j:=0 to 100 do
      begin
       g2:=drawpage.screenseg;

  {       asm
  {        mov ax,j
  {        mov es,ax
  {        mov cl,100
  {        mov di,0
  {        mov ax,value
  {        add ax,55
  {        xor bx,bx
  {    @m2:push ax
                        { move x positon into di }
  {        push  bx      { save bx }
  {        xor   bx,bx   { clear bx }
  {        mov   bl,i    { copy x in to bl }
  {        shl   bx,1    { bx=bx*2 }
  {        mov   di, bx  { copy x offset ito di }
  {        pop   bx      { restore bx }

  {        push cx       { save cx }
                        { calc y positon }
  {        xor   cx,cx   { clear cx }
  {        mov   ch,bl   { bx = y*256 }
  {        shl   cx,1    { bx=bx*2    }
  {        mov   ax, cx  { make another copy of y in ax}
  {        shr   ax, 2   { y2 = y2 * 64}
  {        add   cx, ax  { Work out y location : y = y1+y2 (y=(y*2)*320) }
  {        add   di,cx   { di=(y*2)*320+(x*2) }
  {        pop cx        { restore cx }
  {        pop ax        { restore bx }

  {        mov es:[di],al      { put on all pixels }
  {        mov es:[di+1],al
  {        mov es:[di+320],al
  {        mov es:[di+321],al
  {        inc bl              { inc x positon }
 {         inc ax              { inc color }
{          loop @m2        { loop utill all of y axis is done }

{         end;}
{          drawpage.rectangle(i*2,j*2,i*2+2,j*2+2,55+value);    }
           memw[g2:(j*2)*320+i*2]  :=((55+value) shL 8 )+(55+value);
           memw[g2:(j*2+1)*320+i*2]:=((55+value) shL 8 )+(55+value);
           {g:=j*320+i}


           value:=value+1;
       end;
      end;
   2:begin
      value:=round(16*sin(angle1) + 8*sin(angle2) +4*sin(angle3));
      ttt:=(value)+i;
      if ttt<0 then ttt:=0;
      if ttt>199 then ttt:=199;
      drawpage.line(i+i,ttt,round(i*1.4),199,65-vALUE);
      drawpage.line(i+i,ttt,80+round(i*1.4),0,65-VALUE);
     end;
   end
  end;
  angle1:=angle1bak+((1*6.284/320)*gc_SPEEDCOMP/2);
  angle2:=angle2bak+((3*6.284/320)*gc_SPEEDCOMP/2);
  angle3:=angle3bak+((2*6.284/320)*gc_SPEEDCOMP/2);
 end;
end;



procedure about;
var I,ii,x,ax,ay,xx,y,yy:INTEGER;
    ch:char;
    tangle:real;
    lb,rb:boolean;
    s:string;
begin
  drawpage.cls386(0);
  drawpage.flipto386(vgaseg);
  tangle:=0;
   setmousewindow(0,0,319,199);
 repeat
  ch:=' ';
  if keypressed then ch:=upcase(readkey);
  waitretrace;
  if gv_Config.fast then do_back(1);
 {-------------------------}
 drawpage.draw_box(30,30,280,100);
 s:='Gallatic Warfare:Invaded';
 for i:=1 to length(s) do
 begin
  drawpage.font8x8(S[i],40+i*9+1,round(sin(tangle*2+i))+41,1,25);
  drawpage.font8x8(S[i],40+i*9,round(sin(tangle*2+i))+40,1,16);
 end;
 tangle:=tangle+((1*7.284/320)*gc_SPEEDCOMP/2);
 s:='WRITTEN BY MATTHEW ARMAREGO';
 for i:=1 to length(s) do
 begin
 drawpage.Small_font(s[i],50+i*4+1,round(sin(tangle+i/2))+61,25);
 drawpage.Small_font(s[i],50+i*4,round(sin(tangle+i/2))+60,16);
 end;
 s:='WRITTEN AND COMPILED IN TURBO PASCAL 7 WITH ';
 for i:=1 to length(s) do
 begin
 drawpage.Small_font(s[i],50+i*4+1,round(sin(tangle+i/2))+69,25);
 drawpage.Small_font(s[i],50+i*4,round(sin(tangle+i/2))+68,16);
 end;
 s:='SOME gv_Config.fast ASM STATEMENTS FOR GRAPHICS';
 for i:=1 to length(s) do
 begin
 drawpage.Small_font(s[i],50+i*4+1,round(sin(tangle+i/2))+76,25);
 drawpage. Small_font(s[i],50+i*4,round(sin(tangle+i/2))+75,16);
 end;
 {-------------------------}
  drawpage.draw_box(290,0,319,19);
  drawpage.med_font('O',294,5,1,28);
  drawpage.med_font('K',305,5,1,30);
  {-------------------------}
  if gv_Config.UseMouse=true then MouseInfo(x,y,lb,rb);
  if gv_Config.UseMouse=true then
  for i:=0 to 9 do
   for ii:=0 to 9 do
    if ((gc_point[i+1,ii+1]<>0) and (ii+y<=199) and (i+x<320)) then
     drawpage.putpixel(x+i,y+ii,gc_point[i+1,ii+1]);
  if lb then
  begin
   if ((x>=290) and (x<=319) and
       (y>=0) and (y<=19)) then
       ch:='O';
  end;
  drawpage.flipto386(vgaseg);
  drawpage.cls386(0);
 until ch='O';
 if gv_Config.UseSound then button;
end;


PROCEDURE SETUP(ff:integer);
VAR T:TEXT;
    i,ii,x,y:integer;

    lb,rb:boolean;
    CH:CHAR;
     gvs_message:string;
     f:boolean;

    III,IV,V,tt,ttt:integer;
BEGIN
 drawpage.cls386(0);
 setmousewindow(0,0,319,199);
 f:=EXIST('gw1.CFG');
 if not f then
 begin
  gv_Config.fast:=false;
  gv_Config.UseSound:=false;
  gv_Config.UseFire:=false;
  gv_Config.FireRate:=5;
 end;

 IF ((f=FALSE) or (ff=1)) then
 BEGIN
   drawpage.cls386(0);
   drawpage.flipto386(vgaseg);

 repeat
  ch:='A';
  waitretrace;
    if gv_Config.fast then  do_back(2);
  {-------------------------}
  drawpage.draw_box(0,0,185,15);
  gvs_message:='Do you have a fast computer <ie a Pentium> ?';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),1+(i*4),5,10);

  drawpage.draw_box(186,0,203,15);
  tt:=2;
  if gv_Config.fast=true then tt:=10;
  gvs_message:='YES';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),184+(i*4),5,tt);
  drawpage.draw_box(204,0,221,15);
  tt:=2;
  if gv_Config.fast=false then tt:=10;
  gvs_message:='NO';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),203+(i*4),5,tt);
  {-------------------------}
  drawpage.draw_box(0,16,185,30);
  gvs_message:='Sound   :';
  for i:=1 to length(gvs_message) do
  drawpage.med_font(upcase(gvs_message[i]),1+(i*15),18,1,10);

  drawpage.draw_box(186,16,203,30);
  tt:=2;
  if gv_Config.UseSound=true then begin tt:=10;end;
  gvs_message:='YES';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),184+(i*4),20,tt);

  drawpage.draw_box(204,16,221,30);
  tt:=2;
  if gv_Config.UseSound=false then tt:=10;
  gvs_message:='NO';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),203+(i*4),20,tt);
  {-------------------------}

  if gv_Config.fast then
  begin
  drawpage.draw_box(0,31,185,45);
  gvs_message:='USE FIRE:';
  for i:=1 to length(gvs_message) do
  drawpage.med_font(upcase(gvs_message[i]),1+(i*15),33,1,10);

  drawpage.draw_box(186,31,203,45);
  tt:=2;
  if gv_Config.UseFire=true then begin tt:=10;end;
  gvs_message:='YES';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),184+(i*4),35,tt);

  drawpage.draw_box(204,31,221,45);
  tt:=2;
  if gv_Config.UseFire=false then tt:=10;
  gvs_message:='NO';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),203+(i*4),35,tt);
  end;

{ ------------------------------------}


  drawpage.draw_box(0,46,100,55);
  gvs_message:='Fire RATE delay:';
  for i:=1 to length(gvs_message) do
  drawpage.small_font(upcase(gvs_message[i]),1+(i*5),48,10);

  drawpage.draw_box(101,46,107,55);
  tt:=2;
  if gv_Config.FireRate=1 then begin tt:=10;end;
  gvs_message:='1';
  drawpage.small_font(gvs_message[1],103,48,tt);

  drawpage.draw_box(108,46,114,55);
  tt:=2;
  if gv_Config.FireRate=2 then tt:=10;
  gvs_message:='2';
  drawpage.small_font(gvs_message[1],110,48,tt);

  drawpage.draw_box(115,46,121,55);
  tt:=2;
  if gv_Config.FireRate=3 then tt:=10;
  gvs_message:='3';
  drawpage.small_font(gvs_message[1],117,48,tt);

  drawpage.draw_box(122,46,128,55);
  tt:=2;
  if gv_Config.FireRate=4 then tt:=10;
  gvs_message:='4';
  drawpage.small_font(gvs_message[1],124,48,tt);

  drawpage.draw_box(129,46,135,55);
  tt:=2;
  if gv_Config.FireRate=5 then tt:=10;
  gvs_message:='5';
  drawpage.small_font(gvs_message[1],131,48,tt);


{ ------------------------------------}
  drawpage.draw_box(290,0,319,19);
  gvs_message:='OK';
  for i:=1 to length(gvs_message) do
  drawpage.med_font(upcase(gvs_message[i]),283+(i*11),5,1,10);
  {-------------------------}


  MouseInfo(x,y,lb,rb);

  for i:=0 to 9 do
   for ii:=0 to 9 do
    if ((gc_point[i+1,ii+1]<>0) and (ii+y<=199) and (i+x<320)) then
     drawpage.putpixel(i+x,ii+y,gc_point[i+1,ii+1]);


  if lb then
  begin
   if  ((y>=0)   and (y<=15))  then
   begin
    if ((x>=186) and (x<=203)) then ch:='Y';
    if ((x>=204) and (x<=221)) then ch:='N';
   end;

   if  ((y>=16)  and (y<=30))  then
   begin
    if ((x>=186) and (x<=203)) then ch:='E';
    if ((x>=204) and (x<=221)) then ch:='F';
   end;

   if ((y>=31)   and (y<=44))  then
   begin
    if ((x>=186) and (x<=203)) then ch:='e';
    if ((x>=204) and (x<=221)) then ch:='f';
   end;

   if  ((y>=46)  and (y<=55))  then
   begin
    if ((x>=101) and (x<=107)) then ch:='1';
    if ((x>=108) and (x<=114)) then ch:='2';
    if ((x>=115) and (x<=121)) then ch:='3';
    if ((x>=122) and (x<=128)) then ch:='4';
    if ((x>=129) and (x<=135)) then ch:='5'
   end;

  if ((x>=290) and (x<=319) and
       (y>=0) and (y<=19)) then
       ch:='O';
    repeat mouseinfo(i,ii,lb,rb) until lb=false;
  end;
  case ch of
  'Y','N' :begin gv_Config.fast:=ch='Y';           if gv_Config.UseSound then  button;end;
  'E','F' :begin gv_Config.UseSound:=ch='E';      if gv_Config.UseSound then  button;end;
  'e','f' :begin gv_Config.UseFire:=ch='e';       if gv_Config.UseSound then  button;end;
  '1'..'5':begin gv_Config.FireRate:=(ord(ch)-$30);if gv_Config.UseSound then  button;end;
  end;



   drawpage.flipto386(vgaseg);
   drawpage.cls386(0);
  until ch ='O';
  if gv_Config.UseSound then button;
  assign(t,'gw1.cfg');
  rewrite(t);
  if gv_Config.fast=true then writeln(t,1) else writeln(t,0);
  if gv_Config.UseSound=true then writeln(t,1) else writeln(t,0);
  if gv_Config.UseFire=true then writeln(t,1) else writeln(t,0);
  writeln(t,gv_Config.FireRate);

  close(t);
 end
 else
 begin
  assign(t,'gw1.cfg');
  reset(t);
  readln(t,i);gv_Config.fast:=i=1;
  readln(t,i);gv_Config.UseSound:=i=1;
  readln(t,i);gv_Config.UseFire:=i=1;
  readln(t,gv_Config.FireRate);
  close(t);
 end;

end;


procedure draw_menu;
var i,ii:integer;
   gvs_message:string;
begin
 drawpage.draw_box(50,10,270,25);
 {-------------------------------}
 drawpage.draw_box(0,180,60,199);
 drawpage.med_font('Q',5,185,1,28);
 gvs_message:='UIT';
 for i:=1 to length(gvs_message) do
 drawpage.med_font(gvs_message[i],5+(i*11),185,1,30);
 {------------------------------}
 drawpage.draw_box(260,180,319,189);
 gvs_message:='RUN DEMO';
 for i:=1 to length(gvs_message) do
 drawpage.Small_font(gvs_message[i],262+(i*5),182,10);

 drawpage.draw_box(260,190,319,199);
 gvs_message:='OPTIONS';
 for i:=1 to length(gvs_message) do
 drawpage.Small_font(gvs_message[i],262+(i*5),192,10);
 {---------------------------}
 drawpage.draw_box(61,180,259,199);
 drawpage.med_font('P',120,185,1,28);
 gvs_message:='LAY';
 for i:=1 to length(gvs_message) do
 drawpage.med_font(gvs_message[i],120+(i*21),185,1,30);

end;


procedure draw_main_menu;
var i,ii:integer;
   gvs_message:string;
begin
 drawpage.draw_box(50,10,270,25);
 gvs_message:='Gallatic Warfare:Invader';
 for i:=1 to length(gvs_message) do
 begin
  drawpage.font8x8(gvs_message[i],43+i*9+1,15,1,23);
  drawpage.font8x8(gvs_message[i],43+i*9  ,14,1,16);
 end;
 {-------------------------------}
 drawpage.draw_box(0,180,60,199);
 drawpage.med_font('Q',5,185,1,28);
 gvs_message:='UIT';
 for i:=1 to length(gvs_message) do
 drawpage.med_font(gvs_message[i],5+(i*11),185,1,30);
 {------------------------------}
 drawpage.draw_box(260,180,319,189);
 gvs_message:='RUN DEMO';
 for i:=1 to length(gvs_message) do
 drawpage.Small_font(gvs_message[i],262+(i*5),182,10);

 drawpage.draw_box(260,190,319,199);
 gvs_message:='OPTIONS';
 for i:=1 to length(gvs_message) do
 drawpage.Small_font(gvs_message[i],262+(i*5),192,10);
 {---------------------------}
 drawpage.draw_box(61,180,259,199);
 drawpage.med_font('P',120,185,1,28);
 gvs_message:='LAY';
 for i:=1 to length(gvs_message) do
 drawpage.med_font(gvs_message[i],120+(i*21),185,1,30);

end;



procedure do_menu;
var value,i,j:integer;
    angle1,angle2,angle3:real;
    angle1bak,angle2bak,angle3bak:real;
    III,IV,V,ii,x,y,tt,ttt:integer;
    ch:char;
    lb,rb:boolean;

begin
 angle1:=0;angle2:=0;angle3:=0;
 angle1bak:=0;angle2bak:=0;angle3bak:=0;
 SetMousePos(159,99);
 setmousewindow(0,0,319,199);
 setfire;
 drawpage.cls386(0);
 repeat
  ch:=' ';
  if keypressed then ch:=upcase(readkey);
  if gv_Config.UseMouse=true then MouseInfo(x,y,lb,rb);
  waitretrace;
  if gv_Config.fast=true then
  do_back(1);
  draw_main_menu;
  drawpage.draw_box(1,1,10,10);
  drawpage.small_font('M',2,2,10);
  drawpage.small_font('S',4,4,12);
  drawpage.small_font('A',6,6,1);

  if gv_Config.UseMouse=true then
  for i:=0 to 9 do
   for ii:=0 to 9 do
    if ((gc_point[i+1,ii+1]<>0) and (ii+y<=199) and (i+x<320)) then
     drawpage.putpixel(i+x,ii+y,gc_point[i+1,ii+1]);
  if lb then
  begin
    if ((x>=2)   and (x<=13) and
        (y>=2) and (y<=11)) then
         ch:='A';
   if ((x>=0)   and (x<=60) and
       (y>=180) and (y<=199)) then
       ch:='Q';
   if ((x>=260)   and (x<=319) and
       (y>=180) and (y<=189)) then
       ch:='L';

   if ((x>=260)   and (x<=319) and
       (y>=190) and (y<=199)) then
       ch:='S';
   if ((x>=61)   and (x<=259) and
       (y>=180) and (y<=199)) then
       ch:='P'
  end;


  if ch='P' then
  begin
   if gv_Config.UseSound then button;
   repeat mouseinfo(x,y,lb,rb);until lb=false;
  gvI_Level:=0;
  init;
  fadedown(0,255,5);
  firepage.cls386(0);
  gvb_Quit:=false;
  repeat
    drawpage.cls386(0);
    gvI_Level:=gvI_Level+1;
    newlevel;
    fadedown(0,255,30);
    firepage.cls386(0);
  until ((gvI_Lives<0) or (gvI_Level>=41) or (gvb_Quit=true));
  drawpage.cls386(0);
  fadepal(gv_ColorPalette,0,255,2);
   ch:=' ';
   if gvb_Quit=false then HISCORE(1) else hiscore(2);


  end;

  if ch='A' then
  begin
  if gv_Config.UseSound then button;
  about;

  end;
  if ch='S' then
   begin
   if gv_Config.UseSound then button;
   setup(1);
   if gv_Config.fast=true then

  end;
  drawpage.flipto386(vgaseg);
  drawpage.cls386(0);
 until ch='Q';
 if gv_Config.UseSound then button;
end;



{
  Name              : main
  function          : init graphics,run intro,close graphics
  variables changed : gvI_AlienCounter,gv_ColorPalette,VADDR,VADDR2
}

{ self explanitory }
procedure main;
BEGIN
  if initmouse=false then
  begin
   writeln('Can''t find mouse. Check/install your dos mouse driver!');
   halt(99);
  end;
 gv_Config.UseMouse:=true;
 mouseoff;

{if paramcount>0 then
begin
 if not((paramstr(1)='/ns') or
        (paramstr(1)='/NS')) then initsb
 else
  begin
    write('Soundblaster disabled.');
    gvb_useblaster:=false;
  end;
end else initsb;}


setMcga;
drawpage.init;
firepage.init;
setfire;
for gvI_AlienCounter:=0 to 255 do
getpal(gvI_AlienCounter,thepal[gvI_AlienCounter,1],thepal[gvI_AlienCounter,2],thepal[gvI_AlienCounter,3]);
gv_ColorPalette:=thepal;
setup(2);
gvb_FrameRate:=false;
do_menu;
settext;
drawpage.deinit;
firepage.deinit;
{deinitsb;}
END;


begin
clrscr;
randomize;
gettime(H,M,S1,s100);
for m2:=1 to s100 do m:=random(10);
main;
clrscr;
writeln('This program is FREEWARE!');
writeln('Invader! Version :',gc_version,'. By Matthew Armarego ');
writeln('      If you have any suggestions or         ');
writeln('CONSTRUCTIVE criticism please pass them on to');
writeln;
writeln(' trookat@hotmail.com ');
writeln(' http://trookat.n3.net');
writeln;
writeln(' Thanks go to ,');
writeln('               Ed Dawson      ( currently:Editor of Gamespot Australia)');
writeln('               Steve Copley   ( currently:Gamer/Full time bludger     )');
writeln('               Peter Smith    ( currently:Gamer/Full time bludger     )');

nosound;
end.
