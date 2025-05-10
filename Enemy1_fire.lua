Enemy1_fire = Class{} -- Blueprint class for octorok 1 ball
require 'Animation'

-- Declare variables for intervals of when the ball is released and reset
local timer = 0
local interval = 4.5
local lower_interval = 4
local upper_interval = 4.6

local MOVE_SPEED = 70

local world = love.physics.newWorld()
-- Only shoots the ball up
function Enemy1_fire:init() -- calls on itself
    self.x = Enemy1.x + 7
    self.y = Enemy1.y 
    self.width = 4
    self.height = 4
  
end

function Enemy1_fire:update(dt) -- Update the ball's movement
    self.y = self.y -MOVE_SPEED *dt 
    timer = timer + dt
   if timer > lower_interval and timer < upper_interval  then
    self.y = Enemy1.y

   elseif timer > interval then
    lower_interval = interval + 4.5
    upper_interval = upper_interval + 4.5 
    interval = interval + 4.5
   end
end

function Enemy1_fire:reset()
    self.x = Enemy1.x + 7
    self.y = Enemy1.y 
end

function Enemy1_fire:collides(box) -- Collision method for ball
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end
    
    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Enemy1_fire:render() -- Renders the ball to center
   
    if octorok1_health > 0 then
        love.graphics.rectangle('fill', self.x, self.y,4,4)
    else
        -- avoid ghost balls and just move them out of the screen
        self.x = -5
        self.y = -5
    end

end