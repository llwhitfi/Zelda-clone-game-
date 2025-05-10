Fast_enemy4 = Class{}

-- fast enemy

-- require animation class
require 'Animation'


local MOVE_SPEED = 160
local timer = 0
local interval = 2
local upper_interval = 4

-- Constant variables that are local
local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

-- Play destroy sound once
local play = true

local p = love.physics

-- init values
function Fast_enemy4:init(main)
    -- fast enemy 4 table
    fast_enemy4 = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 5
    self.y = tileHeight * 23

    self.dx = 0
    self.dy =0


    self.currentFrame = nil
    self.texture = love.graphics.newImage('Sprites/Enemies.png')
    self.frames = generateQuads(self.texture, 16, 16)

    self.state = 'idle'

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5]
            },
            interval = 1
        },
        ['move_right'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5], self.frames[6]
            },
            interval = 0.15
        },
        ['move_left'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[7], self.frames[8]
            },
            interval = 0.15
        },
         ['destroy'] = Animation {
            texture = self.texture,
            frames = {
                -- Empty Quad
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions())
            },
            interval = 0
        }
    }
-- set animation to idle
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

-- define behaviors 
    self.behaviors = {
        ['idle'] = function(dt)
            timer = timer + dt
            -- If timer is less than interval then the enemy moves to the right
            if timer < interval and fast_enemy4_health > 0 then
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['move_right']
                fast_enemy4.b:setLinearVelocity(0,MOVE_SPEED)
                fast_enemy4.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckRightCollision(self)
            
            -- If timer is greater than interval then the enemy moves to the left
            elseif timer > interval and timer < upper_interval and fast_enemy4_health > 0 then
                self.x = self.x - MOVE_SPEED * dt
                self.animation = self.animations['move_left']
                fast_enemy4.b:setLinearVelocity(0,-MOVE_SPEED)
                fast_enemy4.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckLeftCollision(self)
            
            -- Increment interval and upper interval for AI
            elseif timer > upper_interval then
                interval = interval + 4
                upper_interval = upper_interval + 4
 
             else 
                fast_enemy4.b = p.newBody(world,0,0,'dynamic')
                self.animation = self.animations['destroy']
                if play then
                    sounds['enemy_die']:play()
                    play = false
                    end
             end
        end
    }
end
-- reset function for fastEnemy 4's position
function Fast_enemy1:reset()
    self.x = tileWidth * 5
    self.y = tileHeight * 23
end

-- Updates behaviors, animations, and frames
function Fast_enemy4:update(dt)
    self.behaviors[self.state](dt)  
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()
end

function Fast_enemy4:render()
    -- Draws the sprite and frames
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),math.floor(self.y))
end