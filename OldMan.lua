
OldMan = Class{}


local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

-- set ghost tile to empty tile and set oldman tile to the tile with the old man sprite
GHOST = 9
OLD_MAN = 1

-- constant local variables 
local p = love.physics
local timer = 0
local interval = 15

local world = love.physics.newWorld()
-- init function 
function OldMan:init(main)
    old_man = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 9
    self.y = tileHeight * 6

    self.dx = 0
    self.dy = 0

    self.currentFrame = nil
    
    self.texture = love.graphics.newImage('Sprites/old_man.png')
    self.frames = generateQuads(self.texture, 16, 16)
      
    self.state = 'ghost'

    self.animations = {
        ['ghost'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[GHOST]
            },
            interval = 1
        },
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[OLD_MAN]
            },
            interval = 1
        }
    }
    -- set the animation to ghost 
    self.animation = self.animations['ghost']
    self.currentFrame = self.animation:getCurrentFrame()

self.behaviors = {
    -- state is ghost if the timer is less than the interval, if not, the animation is idle 
    ['ghost'] = function (dt)
        timer = timer + dt
        if timer > interval then
            self.animation = self.animations['idle']
        end
    end
}
end
-- old man's update
function OldMan:update(dt)
    self.behaviors[self.state](dt) 
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()

end

function OldMan:render()
    -- draws old man's sprite 
    love.graphics.draw(self.texture,self.currentFrame, math.floor(self.x),math.floor(self.y))
end