Triforce = Class{}

-- local variables 
local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10

-- sprite position in spritesheet
TRIFORCE = 8

local p = love.physics

local world = love.physics.newWorld()
-- triforce init function
function Triforce:init(main)
    triforce = {}
    self.width = 16
    self.height = 16

    self.x = tileWidth * 12
    self.y = tileHeight * 26

    self.dx = 0
    self.dy = 0

    self.currentFrame = nil
    
    self.texture = love.graphics.newImage('Sprites/Hearts_tree_walls.png')
    self.frames = generateQuads(self.texture, 16, 16)
      
    self.state = 'idle'
    -- set the animation to the triforce sprite
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[TRIFORCE]
            },
            interval = 1
        }
    }
    -- set the animation to idle 
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- set the animation to remain at idle 
    self.behaviors = {
        ['idle'] = function(dt)
            self.animation = self.animations['idle']
         
    end
    }
    
end

-- update the triforce's behavior, animation, and frames
function Triforce:update(dt)
    self.behaviors[self.state](dt) 
    self.animation:update(dt) 
    self.currentFrame = self.animation:getCurrentFrame()

   
end

function Triforce:render()
    -- draw the triforce onto the screen
    love.graphics.draw(self.texture,self.currentFrame, math.floor(self.x),math.floor(self.y))
   
end