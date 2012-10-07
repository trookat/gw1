require "class2"  -- handles some oo stuff

--[[
globals
--]]

class "Object" {
	x=0;		-- x co-ord
	y=0;		-- y co-ord
	w=0;		-- width pixels
	h=0;		-- height pixels
	xadd=0;		-- xadd
	yadd=0;		-- yadd
	on=false;	-- object on
	fired=false;	-- has fired
	special=0;
	sprite=0;	-- sprite 
}	

Screen={}
Screen.width, Screen.height,Screen.fullscreen,Screen.vsync,Screen.fsaa = love.graphics.getMode( )

aliensMoveby=20; -- pixels per second

aliensAccr=30;
aliensDown=10;
aliensBoon=(aliensAccr*aliensDown)-10
NumRockets=200;

rockets={}
AlienBombs={}
Aliens={}
BonusAlien=Object:new();
Hero=Object:new();

AlienBombCounter=0;  -- no gv_sprite.Aliens bombs on screen
AlienDirection=0;

sprites={} -- sprite imageinfo


--[[
function:setupspritedata()
init arrays and preload graphics

function will be renamed later


]]--

function setupspritedata()
	local ii,xi,yi=0,0,0;
	for xi=1,aliensAccr do
		AlienBombs[xi]={}
		Aliens[xi]={}
		for yi=1,aliensDown do
			AlienBombs[xi][yi]=Object:new();
			Aliens[xi][yi]=Object:new();
		end
	end
		
	for ii=1,NumRockets do
		rockets[ii]=Object:new()
	end
end
	  
--[[
  Name              : newLevel
  function          : init sprites for new level
  variables changed : global Aliens, bonus, 
]]--

function newlevel()
	local i,ii,iii,iv,v,tx,ty; -- counters

	-- init bonus ship
	BonusAlien.on=false;
	BonusAlien.x=0;
	BonusAlien.y=0;
 
	AlienBombCounter=0;  -- no gv_sprite.Aliens bombs on screen
	AlienDirection=1;   -- init gv_sprite.Aliens count--

	-- init gv_sprite.rockets
	for i=1,NumRockets do
		rockets[i].fired=false;
		rockets[i].special=0;
		rockets[i].sprite=0;
		rockets[i].x=0;
		rockets[i].y=0;
		rockets[i].on=false;
		rockets[i].xa=0;
		rockets[i].ya=0;
	end

	-- init counters
	i=0; 
	ty=7; 
	iv=1; 
	iii=1;
	
	-- Aliens setup AlienBombs init
	for ii=1,aliensDown do
		tx=1;
		for i=1,aliensAccr do
			-- init bad_thing 
			AlienBombs[i][ii].x=0;                   -- x corord           
			AlienBombs[i][ii].y=0;                   -- y corord           
			AlienBombs[i][ii].on=false;              -- not on screen      
			AlienBombs[i][ii].fired=false;           -- init fired         
			AlienBombs[i][ii].sprite=0;              -- init sprite number 
		

			-- init gv_sprite.Aliens
			Aliens[i][ii].fired=false;     -- gv_sprite.Aliens has not fired
			Aliens[i][ii].x=tx+2;            -- init x corord
			Aliens[i][ii].y=ty;            -- init y corord
			Aliens[i][ii].on=true;         -- gv_sprite.Aliens is on screen  
			Aliens[i][ii].sprite=math.random(0,6);
     
			tx=tx+15;    -- inc x corords 
		end
		ty=ty+15;  -- inc y corords 
	end

	--move_sprites; { play gvI_Level }
end

	  
	  
	  
	  
function love.load()


	img = newPaddedImage("gw1.png");
	img:setFilter('nearest','nearest');
	
	local iw=img:getWidth();
	local ih=img:getHeight();

	sprites.aliens={}
	local t=0

	for t=0,7 do
		sprites.aliens[t]	= love.graphics.newQuad(0,t*10,10,10,iw,ih)
	end

		sprites.hero		= love.graphics.newQuad(0,70,10,10,iw,ih)
		sprites.bonuship	= love.graphics.newQuad(0,80,16,10,iw,ih)
		sprites.rocket		= love.graphics.newQuad(0,90,2,10,iw,ih)

	setupspritedata();
	newlevel();

	LevelComplete=false;
end

function love.update(dt)
  
  if LevelComplete==false then aliens(dt) end;
end

function love.keypressed(key)
	if key == "escape" or key=="q" then
		love.event.push('quit')
	end
	if key == "r" then
		love.filesystem.load("main.lua")()
		love.load()
	end
end



function drawaliens()
	for yi=1,aliensDown do
		for xi=1,aliensAccr do
			x=Aliens[xi][yi].x;
			y=Aliens[xi][yi].y;
			sprite=Aliens[xi][yi].sprite;
		
			love.graphics.drawq(img, sprites.aliens[sprite],x,y);
		end
	end  
end



function aliens(dt)
	local i,ii,ya,ta; --{ counters }
	ya=0;  --{ init counter }
	ta=0;  --{ init counter }
	for ii=1,aliensDown do  --{ loop though aliens down }
		for i=1,aliensAccr do    --{ loop though aliens accross }
			if Aliens[i][ii].on==true then --{ check if gv_sprite.Aliens is on screen }
				-- if yes then 
				
				-- alien x pos + sprite width + movement 
				if Aliens[i][ii].x+10+aliensMoveby*dt>Screen.width-1 then --{ check if reached far right }
					-- if so then 
					AlienDirection=-1; --{ direction change : to left }
					ya=1;  --{ drop aliens down 1 }
				end
				if Aliens[i][ii].x-aliensMoveby*dt<1 then --{ check if reached far left }
					--{ if so then }
					AlienDirection=1; --{ direction change : to right }
					ya=1; --{ drop aliens down 1 }
				end
				if Aliens[i][ii].y+aliensMoveby>=Screen.height-1 then --{ if gv_sprite.Aliens reached bottom }
					-- { end of game : compleate gvI_Level }
					Lives=-1;
					LevelComplete=true;
				end
				ta=ta+1;--  { tally aliens left }
			end
		end
	end

	for i=1,aliensAccr do  --   { loop though }
		for ii=1,aliensDown do  --   { all aliens  }
			if Aliens[i][ii].on==true then --{ in gv_sprite.Aliens on screen then .. }
			 --  draw_alien (gv_sprite.Aliens[i,ii].x,gv_sprite.Aliens[i,ii].y,gv_sprite.Aliens[i,ii].sprite);-- { draw gv_sprite.Aliens }

			--{ if rebouning then drop aliens down 5 }
				if ya==1 then Aliens[i][ii].y=Aliens[i][ii].y+aliensMoveby/2;end;
			--{ move aliens left or right }
				Aliens[i][ii].x=Aliens[i][ii].x+(aliensMoveby*AlienDirection)*dt;
			--{ random gv_sprite.FireObjects }
			--[[
			if ((gvI_AlienBombCounter<gc_NumBad) and       --        { check if max bombs on screen reached }
				(gv_sprite.Aliens[i,ii].on=true) and       --{ check if gv_sprite.Aliens on    }
				(gv_sprite.Aliens[i,ii].fired=false)) then --{ check gv_sprite.Aliens can gv_sprite.FireObjects then ... }
				if ((ta<=200+(5*gvI_Level)) and        -- { has enough aliens died to gv_sprite.FireObjects back }
					(random(50)+1<10+(gvI_Level*2)) and  --{ random based on gvI_Level }
					(random(ta)<8+gvI_Level)) then
						fire_bad(i,ii); --{ random based on aliens alive }
				end;
			end
			]]--
			end
		end
	end
	
	if ta==0 then LevelComplete=true; end;--{ if no aliens then end gvI_Level }
--[[
	if gv_sprite.BonusAlien.on=true then    --    { is bonus ship on screen ? }
		--  { yes.. calc new position }
		--draw_alien(gv_sprite.BonusAlien.x,gv_sprite.BonusAlien.y,4000);-- { draw bonus gv_sprite.Aliens }
		gv_sprite.BonusAlien.x:=gv_sprite.BonusAlien.x+2;              -- { move gv_sprite.Aliens accross 2 }
		if gv_sprite.BonusAlien.x+10>=319 then gv_sprite.BonusAlien.on:=false;end --{ turn off if reached far right }
	else  --{ no.. randomly turn on }
		if ((ta>15) and (gv_sprite.BonusAlien.on=false) and (random(600)<10) and
		(random(600)>200)) then --{ randomly activate }
		
			gv_sprite.BonusAlien.on:=true; --{ turn bonus ship on }
			gv_sprite.BonusAlien.x:=1;     --{ init x }
			gv_sprite.BonusAlien.y:=1;     --{ init y }
		end;
	end
]]--
end;







function love.draw()
--love.graphics.scale(1.25, 1.25) 
drawaliens();

   --love.graphics.drawq(img, sprites.bonuship,400,0);
   --love.graphics.drawq(img, sprites.hero,400,300);
   --love.graphics.drawq(img, sprites.rocket,400,250);


--   love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy )
	
  love.graphics.print("FPS: "..love.timer.getFPS(), 0, 0)
end



function newPaddedImage(filename)
    local source = love.image.newImageData(filename)
    local w, h = source:getWidth(), source:getHeight()
    
    -- Find closest power-of-two.
    local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
    local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))
    
    -- Only pad if needed:
    if wp ~= w or hp ~= h then
        local padded = love.image.newImageData(wp, hp)
        padded:paste(source, 0, 0)
        return love.graphics.newImage(padded)
    end
    
    return love.graphics.newImage(source)
end