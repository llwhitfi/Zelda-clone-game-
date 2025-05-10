Enemy3 = Class{}
-- Top enemy
require 'Animation'

-- local variables 
local MOVE_SPEED = 80
local timer = 0
local interval = 2
local upper_interval = 4

local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10


local play = true 

local p = love.physics
-- enemy3 init function
function Enemy3:init(main)
    -- enemy3 table
    enemy3 = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 9
    self.y = tileHeight * (mapHeight / 2 - 11) - self.height

    self.dx = 0
    self.dy =0


    self.currentFrame = nil
    self.texture = love.graphics.newImage('Sprites/Enemies.png')
    self.frames = generateQuads(self.texture, 16, 16)

    self.state = 'idle'
-- define the animations for enemy 3
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
            -- if timer is less than interval then the enemy will moveto the right
           if timer < interval and octorok3_health > 0 then
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['move_right']
                enemy3.b:setLinearVelocity(0,-MOVE_SPEED)
                enemy3.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckRightCollision(self)
            
          -- if timer is greater than interval then the enemy will moveto the left
           elseif timer > interval and timer < upper_interval and octorok3_health > 0 then
                self.x = self.x - MOVE_SPEED * dt
                self.animation = self.animations['move_left']
                enemy3.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckLeftCollision(self)
            
            -- increment interval and upper interval for AI
           elseif timer > upper_interval then
                interval = interval + 4
                upper_interval = upper_interval + 4

            else 
            enemy3.b = p.newBody(world,0,0,'dynamic')
            self.animation = self.animations['destroy']
            if play then
            sounds['enemy_die']:play()
            play = false
            end
            end
        end
    }
end
-- enemy 3's reset function 
function Enemy3:reset()
    enemy3.b = p.newBody(world,Enemy3.x ,Enemy3.y + 8,'dynamic')
    enemy3.b:setFixedRotation(true)
    enemy3.s = p.newRectangleShape(16,16)
    enemy3.f = p.newFixture(enemy3.b,enemy3.s)
end
-- enemy 3's update function for behaviors, animations, and frames
function Enemy3:update(dt)
    self.behaviors[self.state](dt)  
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()
end

function Enemy3:render()
    -- draws the enemy 3's sprites and frames
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),math.floor(self.y))
end