Class = require 'class'
push = require 'push'
require 'Util'
require 'Player'
require 'OldMan'
require 'Enemy1'
require 'Enemy2'
require 'Enemy3'
require 'Enemy1_fire'
require 'Enemy2_fire'
require 'Enemy3_fire'
require 'Fast_enemy1'
require 'Fast_enemy2'
require 'Fast_enemy3'
require 'Fast_enemy4'
require 'Triforce'

-- Initialize classes to main
 my_player =  Player:init()
 my_enemy_1 = Enemy1:init()
 my_oldMan = OldMan:init()
 my_enemy_2 = Enemy2:init()
 my_enemy_3 = Enemy3:init()
 enemy_fire1 = Enemy1_fire:init()
 enemy_fire2 = Enemy2_fire:init()
 enemy_fire3 = Enemy3_fire:init()
 my_fast1 = Fast_enemy1:init()
 my_fast2 = Fast_enemy2:init()
 my_fast3 = Fast_enemy3:init()
 my_fast4 = Fast_enemy4:init()
 mytriforce = Triforce:init()

 -- Gamestate
 gameState = 'title'

 -- Initilize empty tile
TILE_EMPTY = -1

-- Tree tiles
TILE_TREE = 4

-- Top wall tiles
TILE_WALL = 2
TILE_BOTTOM_WALL = 7
SECRET_WALL = 6


--Triforce
local TILE_TRIFORCE = 8

-- play sound only once booleans
local play = true
local play2 = true
local play3 = true
local play4 = true


-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- constant scroll speed for camera
local SCROLL_SPEED = 65

-- filter edges to look more crisp
love.graphics.setDefaultFilter('nearest', 'nearest')

-- Constant tile width and heights
local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10
local tiles = {}


-- Life values
link_health = 100
octorok1_health = 50
octorok2_health = 50
octorok3_health = 50
fast_enemy1_health = 50
fast_enemy2_health = 50
fast_enemy3_health = 50
fast_enemy4_health = 50

-- short hand 
local p = love.physics

function love.load()
    -- Create new world for entities
    world = p.newWorld()
    -- Store all sounds in a dict
    sounds = {
        ['title_menu'] = love.audio.newSource('music/title_theme.mp3', 'static'),
        ['overworld'] = love.audio.newSource('music/Overworld.mp3', 'stream'),
        ['sword_slash'] = love.audio.newSource('music/sword_slash.wav', 'static'),
        ['enemy_die'] = love.audio.newSource('music/enemy_die.wav', 'static'),
        ['link_die'] = love.audio.newSource('music/link_die.wav', 'static'),
        ['link_hurt'] = love.audio.newSource('music/link_hurt.wav', 'static'),
        ['enemy_hit'] = love.audio.newSource('music/enemy_hit.wav', 'static'),
        ['secret'] = love.audio.newSource('music/secret.wav', 'static'),
        ['slow_text'] = love.audio.newSource('music/slow_text.wav', 'static'),
        ['fanfare'] = love.audio.newSource('music/fanfare.wav', 'static'),
        
    }
-- Use Zelda image for BG on the title screen
   if gameState == 'title' then
    background = love.graphics.newImage("background/zelda_title_screen.jpg")
   end

    -- Create collision boxes for each object
    wall_left = {}
        wall_left.b = p.newBody(world,8,115,'static')
        wall_left.s = p.newRectangleShape(tileWidth,tileHeight * 45)
        wall_left.f = p.newFixture(wall_left.b,wall_left.s)

    wall_right = {}
        wall_right.b = p.newBody(world,424,1,'static')
        wall_right.s = p.newRectangleShape(tileWidth,tileHeight * 60)
        wall_right.f = p.newFixture(wall_right.b,wall_right.s)

    wall_top = {}
        wall_top.b = p.newBody(world,210,8,'static')
        wall_top.s = p.newRectangleShape(420,tileHeight)
        wall_top.f = p.newFixture(wall_top.b,wall_top.s)

    wall_bottom = {}
        wall_bottom.b = p.newBody(world,206,232,'static')
        wall_bottom.s = p.newRectangleShape(385,tileHeight)
        wall_bottom.f = p.newFixture(wall_bottom.b,wall_bottom.s)

    wall_bottom2 = {}
        wall_bottom2.b = p.newBody(world,206,440,'static')
        wall_bottom2.s = p.newRectangleShape(385,tileHeight)
        wall_bottom2.f = p.newFixture(wall_bottom2.b,wall_bottom2.s)

    secret_wall = {}
        secret_wall.b = p.newBody(world,408,232,'static')
        secret_wall.s = p.newRectangleShape(tileWidth,tileHeight)
        secret_wall.f = p.newFixture(secret_wall.b,secret_wall.s)

    tree_top = {}
        tree_top.b = p.newBody(world,152,71,'static')
        tree_top.s = p.newRectangleShape(tileWidth * 11,tileHeight)
        tree_top.f = p.newFixture(tree_top.b,tree_top.s)

    tree_bottom = {}
        tree_bottom.b = p.newBody(world,151,136,'static')
        tree_bottom.s = p.newRectangleShape(tileWidth * 11,tileHeight) 
        tree_bottom.f = p.newFixture(tree_bottom.b,tree_bottom.s)

    tree_left = {}
        tree_left.b = p.newBody(world,344,105,'static')
        tree_left.s = p.newRectangleShape(tileWidth,tileHeight * 7)
        tree_left.f = p.newFixture(tree_left.b,tree_left.s)
       
        -- Link
        player.b = p.newBody(world,Player.x + 8,Player.y + 8,'dynamic')
        player.b:setFixedRotation(true)
        player.s = p.newRectangleShape(16,16)
        player.f = p.newFixture(player.b,player.s)

        --Link_sword
        player_sword = {}
        player_sword.b = p.newBody(world,Player.x + 8,Player.y + 8,'static')
        player_sword.b:setFixedRotation(true)
        player_sword.s = p.newRectangleShape(16,32) -- idle down values
        player_sword.f = p.newFixture(player_sword.b,player_sword.s)

        -- Ocotorok 1
        enemy1.b = p.newBody(world,Enemy1.x + 8 ,Enemy1.y + 8,'dynamic')
        enemy1.b:setFixedRotation(true)
        enemy1.s = p.newRectangleShape(16,16)
        enemy1.f = p.newFixture(enemy1.b,enemy1.s)
      
        -- Ocotorok 2
        enemy2.b = p.newBody(world,Enemy2.x,Enemy2.y + 8,'dynamic')
        enemy2.b:setFixedRotation(true)
        enemy2.s = p.newRectangleShape(16,16)
        enemy2.f = p.newFixture(enemy2.b,enemy2.s)

        -- Ocotorok 3
        enemy3.b = p.newBody(world,Enemy3.x ,Enemy3.y + 8,'dynamic')
        enemy3.b:setFixedRotation(true)
        enemy3.s = p.newRectangleShape(16,16)
        enemy3.f = p.newFixture(enemy3.b,enemy3.s)

        -- Fast Ocotorok 1
        fast_enemy1.b = p.newBody(world,Fast_enemy1.x ,Fast_enemy1.y + 8,'dynamic')
        fast_enemy1.b:setFixedRotation(true)
        fast_enemy1.s = p.newRectangleShape(16,16)
        fast_enemy1.f = p.newFixture(fast_enemy1.b,fast_enemy1.s)

        -- Fast Ocotorok 2
        fast_enemy2.b = p.newBody(world,Fast_enemy2.x ,Fast_enemy2.y + 8,'dynamic')
        fast_enemy2.b:setFixedRotation(true)
        fast_enemy2.s = p.newRectangleShape(16,16)
        fast_enemy2.f = p.newFixture(fast_enemy2.b,fast_enemy2.s)

        
        -- Fast Ocotorok 3
        fast_enemy3.b = p.newBody(world,Fast_enemy3.x ,Fast_enemy3.y + 8,'dynamic')
        fast_enemy3.b:setFixedRotation(true)
        fast_enemy3.s = p.newRectangleShape(16,16)
        fast_enemy3.f = p.newFixture(fast_enemy3.b,fast_enemy3.s)

        -- Fast Ocotorok 4
        fast_enemy4.b = p.newBody(world,Fast_enemy4.x ,Fast_enemy4.y + 8,'dynamic')
        fast_enemy4.b:setFixedRotation(true)
        fast_enemy4.s = p.newRectangleShape(16,16)
        fast_enemy4.f = p.newFixture(fast_enemy4.b,fast_enemy4.s)

        -- old man
        old_man.b = p.newBody(world,OldMan.x + 8 ,OldMan.y + 8,'static')
        old_man.s = p.newRectangleShape(16,16)
        old_man.f = p.newFixture(old_man.b,old_man.s)

        -- triforce
        triforce.b = p.newBody(world,Triforce.x + 8,Triforce.y + 8,'kinematic')
        triforce.s = p.newRectangleShape(16,16)
        triforce.f = p.newFixture(triforce.b,triforce.s)

        -- Font for Link's health display
        life_font = love.graphics.newFont('04B_03__.ttf', 20)
        end_font = love.graphics.newFont('04B_03__.ttf', 14)
        OldMan_font = love.graphics.newFont('04B_03__.ttf', 10)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true
    })

    -- set spritesheet
    spritesheet = love.graphics.newImage('Sprites/hearts_tree_walls.png')
   
    
    -- camera offsets
    camX = 0
    camY = -3

    sprites = generateQuads(spritesheet, 16, 16)
    
    -- cache width and height of map in pixels
    mapHeightPixels = mapHeight * tileHeight


    -- first, fill map with empty tiles
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            
            -- support for multiple sheets per tile; storing tiles as tables 
            setTile(x, y, TILE_EMPTY)
        end
    end
    -- create wall tiles on the bottom of the screen
    for y = mapHeight / 2 + 1, mapHeight / 2 + 1  do
        for x = 0, 25 do
            setTile(x, y, TILE_WALL)
        end
    end
    -- create wall tiles on the bottom of the screen
    for y = 28, 28  do
        for x = 0, 26 do
            setTile(x, y, TILE_WALL)
        end
    end

     -- create wall tiles on the bottom of room 2
     for y = mapHeight / 2 + 1, mapHeight / 2 + 1  do
        for x = 0, 25 do
            setTile(x, y, TILE_BOTTOM_WALL)
        end
    end

    -- Secret wall
    if player.b:isTouching(secret_wall.b) then
        for y = mapHeight / 2 + 1, mapHeight / 2 + 1  do
            for x = 26, 26 do
                setTile(x, y, TILE_EMPTY)
            end
        end
    else
    for y = mapHeight / 2 + 1, mapHeight / 2 + 1  do
        for x = 26, 26 do
            setTile(x, y, SECRET_WALL)
        end
    end
end
    --left hand side tile
    for y = 0, 30  do
        for x = 1, 1 do
            setTile(x, y, TILE_WALL)
        end
    end
    -- right hand side tiles
    for y = 0, 30  do
        for x = 27, 27 do
            setTile(x, y, TILE_WALL)
        end
    end
    --Top screen tiles
    for y = 1, 1   do
        for x = 0, 26 do
            setTile(x, y, TILE_WALL)
        end
    end
    -- tree top left
    for y = 5, 5   do
        for x = 5, 15 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-left
    for y = 9, 9   do
        for x = 5, 15 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree right 
    for y = mapHeight / 2 - 10, mapHeight / 2 - 4   do
        for x = 22, 22 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-top room 2 rightside (1)
    for y = 17, 17   do
        for x = 15, 26 do
            setTile(x, y, TILE_TREE)
        end
    end
     -- tree bottom-top room 2 leftside (1)
     for y = 17, 17   do
        for x = 2, 12 do
            setTile(x, y, TILE_TREE)
        end
    end
     -- tree bottom-top room 2  rightside (2)
     for y = 19, 19   do
        for x = 15, 26 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-top room 2 leftside (2)
    for y = 19, 19   do
        for x = 2, 12 do
            setTile(x, y, TILE_TREE)
        end
    end
     -- tree bottom-top room 2  rightside (3)
     for y = 21, 21   do
        for x = 15, 26 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-top room 2 leftside (3)
    for y = 21, 21   do
        for x = 2, 12 do
            setTile(x, y, TILE_TREE)
        end
    end
     -- tree bottom-top room 2  rightside (4)
     for y = 23, 23   do
        for x = 15, 26 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-top room 2 leftside (4)
    for y = 23, 23   do
        for x = 2, 12 do
            setTile(x, y, TILE_TREE)
        end
    end
     -- tree bottom-top room 2  rightside (5)
     for y = 25, 25   do
        for x = 15, 26 do
            setTile(x, y, TILE_TREE)
        end
    end
    -- tree bottom-top room 2 leftside (5)
    for y = 25, 25   do
        for x = 2, 12 do
            setTile(x, y, TILE_TREE)
        end
    end
  
-- set the window title
    love.window.setTitle('Legend of Zelda Demo')

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

end

-- Set tile to an id
function setTile(x, y, id)
    tiles[(y - 1) * mapWidth + x] = id
end

-- gets the tile type at a given pixel coordinate
function tileAt(x, y)
    return {
        x = math.floor(x / tileWidth) + 1,
        y = math.floor(y / tileHeight) + 1,
        id = getTile(math.floor(x / tileWidth) + 1, math.floor(y / tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function getTile(x, y)
    return tiles[(y - 1) * mapWidth + x]
end

function collides(tile)
    -- define our collidable tiles
     collidables = {
        TILE_TREE,TILE_WALL
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end
    return false
end

-- Enable resize of window
function love.resize(w,h)
    push:resize(w,h)
end

-- Boolean for wasReleased keyboard function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- If key is pressed allow user to esc or restart the game 
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        -- resets all entities to intial start
        reset()
        Player:reset()
        Enemy3_fire:reset()
        Enemy2_fire:reset()
        Enemy1_fire:reset()
        Enemy1:reset()
        Enemy2:reset()
        Enemy3:reset()
        camReset()
        soundReset()
        -- set gamestate to title
        gameState = 'title'
    end

    --love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.update(dt)
-- Allow use to move camera up and down using w and s respectively 
    if love.keyboard.isDown('w') then
        camY = math.max(0,camY - dt * SCROLL_SPEED)

    elseif love.keyboard.isDown('s') then

        camY = math.min(camY + dt * SCROLL_SPEED, mapHeightPixels - VIRTUAL_HEIGHT)
    end
    
    -- Update all files
    world:update(dt)
    Player:update(dt)
    Enemy1:update(dt)
    Enemy2:update(dt)
    Enemy3:update(dt)
    OldMan:update(dt)
    Enemy1_fire:update(dt)
    Enemy2_fire:update(dt)
    Enemy3_fire:update(dt)
    Fast_enemy1:update(dt)
    Fast_enemy2:update(dt)
    Fast_enemy3:update(dt)
    Fast_enemy4:update(dt)
    Triforce:update(dt)
    
    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
   
end

function love.draw()
    push:apply('start')
    if gameState == 'play' then
    -- Clears screen with light brown color
    love.graphics.clear(252/255, 216/255, 169/255, 1)

    -- Link's health
    love.graphics.setFont(life_font)
    love.graphics.print("HP:"..tostring(link_health), VIRTUAL_WIDTH / 2 + 135, VIRTUAL_HEIGHT/2 - 90)

    love.graphics.translate(math.floor(-camX + 0.5), math.floor(-camY + 0.5))

    -- Draws left wall's collision box
    --love.graphics.polygon('line',wall_left.b:getWorldPoints(wall_left.s:getPoints()))
   
    -- Draws right wall's collision box
    --love.graphics.polygon("line", wall_right.b:getWorldPoints(wall_right.s:getPoints()))

    -- Draws top wall's collision box
    --love.graphics.polygon("line", wall_top.b:getWorldPoints(wall_top.s:getPoints()))

    -- Draws bottom wall's collision box
    --love.graphics.polygon("line", wall_bottom.b:getWorldPoints(wall_bottom.s:getPoints()))

    -- Draws room 2's bottom wall's collision box
    --love.graphics.polygon("line", wall_bottom2.b:getWorldPoints(wall_bottom2.s:getPoints()))

    -- Draws secret wall's collision box
    --love.graphics.polygon("line", secret_wall.b:getWorldPoints(secret_wall.s:getPoints()))

    -- Draws Top tree's collision box
    --love.graphics.polygon("line", tree_top.b:getWorldPoints(tree_top.s:getPoints()))

    -- Draws Bottom tree's collision box
    --love.graphics.polygon("line", tree_bottom.b:getWorldPoints(tree_bottom.s:getPoints()))

     -- Draws left tree's collision box
     --love.graphics.polygon("line", tree_left.b:getWorldPoints(tree_left.s:getPoints()))

    -- Draws Link's(player) collision box
    --love.graphics.polygon("line", player.b:getWorldPoints(player.s:getPoints()))

if love.keyboard.isDown('space') then
    -- Draws Link_sword's(player) collision box
    --love.graphics.polygon("line", player_sword.b:getWorldPoints(player_sword.s:getPoints()))
end
    -- Draws enemy1's collision box
    --love.graphics.polygon("line", enemy1.b:getWorldPoints(enemy1.s:getPoints()))
    
    -- Draws enemy2's collision box
    --love.graphics.polygon("line", enemy2.b:getWorldPoints(enemy2.s:getPoints()))
    
    -- Draws enemy3's collision box
    --love.graphics.polygon("line", enemy3.b:getWorldPoints(enemy3.s:getPoints()))

    -- Draws fast enemmy1's 1 collision box
    --love.graphics.polygon("line", fast_enemy1.b:getWorldPoints(fast_enemy1.s:getPoints()))

     -- Draws fast enemmy2's 1 collision box
    --love.graphics.polygon("line", fast_enemy2.b:getWorldPoints(fast_enemy2.s:getPoints()))

     -- Draws fast enemmy3's 1 collision box
    --love.graphics.polygon("line", fast_enemy3.b:getWorldPoints(fast_enemy3.s:getPoints()))

     -- Draws fast enemmy4's 1 collision box
     --love.graphics.polygon("line", fast_enemy4.b:getWorldPoints(fast_enemy4.s:getPoints()))

     -- Draws triforce's collision box
    --love.graphics.polygon("line", triforce.b:getWorldPoints(triforce.s:getPoints()))
-- Play secret chime if player touches the secret wall
    if player.b:isTouching(secret_wall.b) and play then
        sounds['secret']:play()
        play = false
    end

    -- Change gameState to died if player health reaches 0 or below
    if link_health <= 0 then
        gameState = 'died'
    end
   
    if OldMan.state == 'idle' then
    --Draws old man's collsiion box when he appears
    --love.graphics.polygon('line',old_man.b:getWorldPoints(old_man.s:getPoints()))
    end

    --Give player a hint
    if old_man.b:isTouching(player.b) then
        love.graphics.setFont(OldMan_font)
        love.graphics.print("IN THIS ROOM LIES A FALSE WALL.", OldMan.x - 75, OldMan.y - 10)
        
        if play2 then
            sounds['slow_text']:play()
            play2 = false
        end   
    end

-- Once playe reaches the end of the game change gameState to end
    if player.b:isTouching(triforce.b) then
        gameState = 'end'
    end
  
-- Draw tiles onto screen
    local scaleX = -1
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = getTile(x, y)
            if tile ~= TILE_EMPTY then
                love.graphics.draw(spritesheet, sprites[tile],
                    (x - 1) * tileWidth, (y - 1) * tileHeight)
            end
        end
    end
    
    -- Render all files
    Player:render()
    Enemy1:render()
    Enemy2:render()
    Enemy3:render()
    OldMan:render()
    Enemy1_fire:render()
    Enemy2_fire:render()
    Enemy3_fire:render()
    Fast_enemy1:render()
    Fast_enemy2:render()
    Fast_enemy3:render()
    Fast_enemy4:render()
    Triforce:render()

-- gameState is title screen
elseif gameState == 'title' then
    love.graphics.draw(background, -25, -13)
    sounds['title_menu']:play()

    if love.keyboard.isDown('space') then
        gameState = 'play'
        sounds['overworld']:play()
        sounds['title_menu']:stop()
    end

-- End gameState
elseif gameState == 'end' then
    love.graphics.setFont(end_font)
    love.graphics.print("You Found the Triforce and saved Hyrule!",VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT/2)
    love.graphics.print("Press esc to exit",VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT/2 + 20)

    if play4 then
        sounds['fanfare']:play()
        play4 = false
    end

-- Stop playing sounds
    sounds['overworld']:stop()
    sounds['link_hurt']:stop()
    sounds['enemy_hit']:stop()
    sounds['sword_slash']:stop()
    sounds['overworld']:stop()
    sounds['enemy_die']:stop()
    sounds['secret']:stop()
    sounds['slow_text']:stop()

-- Died gameState
elseif gameState == 'died' then
    if play3 then
    sounds['link_die']:play()
    play3 = false
    end

    love.graphics.setFont(life_font)
    love.graphics.print("GAME OVER",VIRTUAL_WIDTH / 2 - 56, VIRTUAL_HEIGHT/2)
    love.graphics.setFont(OldMan_font)
    love.graphics.print("Press r to restart",VIRTUAL_WIDTH / 2 - 52, VIRTUAL_HEIGHT/2 + 16)

    -- Stop playing sounds
    sounds['overworld']:stop()
    sounds['link_hurt']:stop()
    sounds['enemy_hit']:stop()
    sounds['sword_slash']:stop()
    sounds['overworld']:stop()
    sounds['enemy_die']:stop()
    sounds['secret']:stop()
    sounds['slow_text']:stop()

end

    push:apply('end')

end
-- Fully repleneish all entities health when 'r' is presssed to restart game 
function reset()
    link_health = 100
    link_health = 100
    octorok1_health = 50
    octorok2_health = 50
    octorok3_health = 50
    fast_enemy1_health = 50
    fast_enemy2_health = 50
    fast_enemy3_health = 50
    fast_enemy4_health = 50
end

-- Resets camera to initial state
function camReset()
    camY = math.max(0,0)
end

-- Resets sounds that are played once
function soundReset()
    play = true
    play2 = true
    play3 = true
    play4 = true
end

