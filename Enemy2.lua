Enemy2 = Class{}
-- Enemy on left
require 'Animation'

-- Local variables
local MOVE_SPEED = 50
local timer = 0
local interval = 2
local upper_interval = 4

-- Constatnt variables
local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

-- play destroy sound once
local play = true

local p = love.physics
--init function
function Enemy2:init(main)
    -- enemy 2 table 
    enemy2 = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 23
    self.y = tileHeight * (mapHeight / 2 - 6) - self.height

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
-- set animation to idle
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviors = {
        ['idle'] = function(dt)
            timer = timer + dt
            --if timer is less than interval then the enemy will move up
           if timer < interval and octorok2_health > 0 then
                self.y = self.y -MOVE_SPEED * dt
                self.animation = self.animations['move_up']
                enemy2.b:setLinearVelocity(0,-MOVE_SPEED)
                enemy2.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckUpCollision(self)
            
            --if timer is greater than interval then the enemy will move down
           elseif timer > interval and timer < upper_interval and octorok2_health > 0 then
                self.y = self.y + MOVE_SPEED * dt
                self.animation = self.animations['move_down']
                enemy2.b:setLinearVelocity(0,-MOVE_SPEED)
                enemy2.b:setPosition(self.x + 8,self.y + 8)
                Collision:CheckDownCollision(self)
            
            -- increment interval and upper interval
           elseif timer > upper_interval then
            interval = interval + 4
            upper_interval = upper_interval + 4
            else 
            enemy2.b = p.newBody(world,0,0,'dynamic')
            self.animation = self.animations['destroy']
            if play then
                sounds['enemy_die']:play()
                play = false
                end
            end
        end
    }
end
-- enemy reset function for position reset
function Enemy2:reset()
    enemy2.b = p.newBody(world,Enemy2.x,Enemy2.y + 8,'dynamic')
    enemy2.b:setFixedRotation(true)
    enemy2.s = p.newRectangleShape(16,16)
    enemy2.f = p.newFixture(enemy2.b,enemy2.s)

end
-- enemy 2 update for behaviors and frames
function Enemy2:update(dt)
    self.behaviors[self.state](dt)  
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()
end

function Enemy2:render()
    -- Drawing the enemy's sprite and frames
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),math.floor(self.y))
end