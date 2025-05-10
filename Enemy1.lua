Enemy1 = Class{}

require 'Animation'

-- Enemy 1 AI
local MOVE_SPEED = 50
local timer = 0
local interval = 1
local upper_interval = 2

local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

local play = true

local p = love.physics

-- init function
function Enemy1:init(main)
    enemy1 = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 5
    self.y = tileHeight * (mapHeight / 2 - 1) - self.height

    self.dx = 0
    self.dy = 0

    self.currentFrame = nil
    self.direction = nil
    self.texture = love.graphics.newImage('Sprites/Enemies.png')
    self.frames = generateQuads(self.texture, 16, 16)
    

    self.state = 'idle'
-- Animation states
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        },
        ['move_up'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1], self.frames[2]
            },
            interval = 0.15
        },
        ['move_down'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[3], self.frames[4]
            },
            interval = 0.15
        },
        ['destroy'] = Animation {
            texture = self.texture,
            frames = {
                -- Empty quad
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions())
            },
            interval = 0
        }
    }
    
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

-- only idle is used 
    self.behaviors = {
        ['idle'] = function(dt)
           timer = timer + dt
           if timer < interval and octorok1_health > 0 then
            self.y = self.y -MOVE_SPEED * dt
            self.animation = self.animations['move_up']
       
            enemy1.b:setLinearVelocity(0,-MOVE_SPEED)
            enemy1.b:setPosition(Enemy1.x + 8,Enemy1.y + 8)

            Collision:CheckUpCollision(self)
           elseif timer > interval and timer < upper_interval and octorok1_health > 0 then
            self.y = self.y + MOVE_SPEED * dt
            self.animation = self.animations['move_down']
        
            enemy1.b:setLinearVelocity(0,MOVE_SPEED)
            enemy1.b:setPosition(Enemy1.x + 8,Enemy1.y + 8)

            Collision:CheckDownCollision(self)
    
           elseif timer > upper_interval then
            interval = interval + 2
            upper_interval = upper_interval + 2
           else 
            enemy1.b = p.newBody(world,0,0,'dynamic')
            self.animation = self.animations['destroy']
            if play then
                sounds['enemy_die']:play()
                play = false
                end    
           end
        end,
    }
    
end
-- Enemy's 1 position reset
function Enemy1:reset()
    enemy1.b = p.newBody(world,Enemy1.x + 8 ,Enemy1.y + 8,'dynamic')
    enemy1.b:setFixedRotation(true)
    enemy1.s = p.newRectangleShape(16,16)
    enemy1.f = p.newFixture(enemy1.b,enemy1.s)
end

-- Update behaviors, animatoins, and frames
function Enemy1:update(dt)
    self.behaviors[self.state](dt) 
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()
end

function Enemy1:render()
-- Renders/draws the sprite and frames
    love.graphics.draw(self.texture,self.currentFrame, math.floor(self.x),math.floor(self.y))
end