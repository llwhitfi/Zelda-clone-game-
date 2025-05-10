Enemy3_fire = Class{} -- Blueprint class for octorok 1 ball

-- Declare variables for intervals of when the ball is released and reset
local timer = 0
local interval = 4.5
local lower_interval = 4
local upper_interval = 4.6

local world = love.physics.newWorld()
-- Only shoots the ball up
function Enemy3_fire:init() -- calls on itself
    enemyBall3 = {}
 
    self.x = Enemy3.x 
    self.y = Enemy3.y + 6
    self.width = 4
    self.height = 4
    self.dx = 85
end

function Enemy3_fire:collides(box) -- Collision method for ball
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end
    
    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Enemy3_fire:reset()
    self.x = Enemy3.x 
    self.y = Enemy3.y + 6
end

function Enemy3_fire:update(dt) -- Update the ball's movement
    self.x = self.x + self.dx *dt 
    timer = timer + dt
   if timer > lower_interval and timer < upper_interval  then
    self.x = Enemy3.x + 16

   elseif timer > interval then
    lower_interval = interval + 4.5
    upper_interval = upper_interval + 4.5 
    interval = interval + 4.5
   end
end

function Enemy3_fire:render() -- Renders the ball to center
    if octorok3_health > 0 then
        love.graphics.rectangle('fill', self.x, self.y,4,4)
    else
        -- avoid ghost balls and just move them out of the screen
        self.x = -5
        self.y = -5
    end
end