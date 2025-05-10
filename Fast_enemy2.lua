Fast_enemy2 = Class{}

-- fast enemy
require 'Animation'

-- local variables 
local MOVE_SPEED = 160
local timer = 0
local interval = 2
local upper_interval = 4

local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

-- play destory sound only once
local play = true

local p = love.physics
-- init function 
function Fast_enemy2:init(main)
    fast_enemy2 = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 5
    self.y = tileHeight * 19

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
        ['hurt_right'] = Animation {
            texture = self.texture,
            frames = {
                -- indicates contact with player
                self.frames[5],
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions()),
            },
            interval = 0.15
        },
        ['hurt_left'] = Animation {
            texture = self.texture,
            frames = {
                -- indicates contact with player
                self.frames[7],
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions())
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

    self.behaviors = {
        ['idle'] = function(dt)
            timer = timer + dt
            -- if timer is less than interval then the enemy will move to the right
            if timer < interval and fast_enemy2_health > 0 then
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['move_right']
                fast_enemy2.b:setLinearVelocity(0,MOVE_SPEED)
                fast_enemy2.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckRightCollision(self)
            
            -- if timer is greater than interval then the enemy will move to the left
            elseif timer > interval and timer < upper_interval and fast_enemy2_health > 0 then
                self.x = self.x - MOVE_SPEED * dt
                self.animation = self.animations['move_left']
                fast_enemy2.b:setLinearVelocity(0,-MOVE_SPEED)
                fast_enemy2.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckLeftCollision(self)
            
            -- increment interval adn upper interval 
            elseif timer > upper_interval then
             interval = interval + 4
             upper_interval = upper_interval + 4
 
             else 
                fast_enemy2.b = p.newBody(world,0,0,'dynamic')
                self.animation = self.animations['destroy']
                if play then
                    sounds['enemy_die']:play()
                    play = false
                end
             end
        end
    }
end
-- reset enemy's position to initial state
function Fast_enemy1:reset()
    self.x = tileWidth * 5
    self.y = tileHeight * 19
end
-- updates the enemy's behaviors, aniamtions, and frames
function Fast_enemy2:update(dt)
    self.behaviors[self.state](dt)  
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()
end

function Fast_enemy2:render()
    -- draws the enemy's sprites and frames
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),math.floor(self.y))
end