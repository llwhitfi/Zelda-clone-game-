Enemy2_fire = Class{} -- Blueprint class for octorok 1 ball

-- Declare variables for intervals of when the ball is released and reset
local timer = 0
local interval = 5
local lower_interval = 4.5
local upper_interval = 5.1


local world = love.physics.newWorld()
-- Only shoots the ball up
function Enemy2_fire:init() -- calls on itself
    self.x = Enemy2.x + 6
    self.y = Enemy2.y
    self.width = 4
    self.height = 4
    self.dy = 70
end

function Enemy2_fire:collides(box) -- Collision method for ball
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end
    
    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Enemy2_fire:update(dt) -- Update the ball's movement
    self.y = self.y + self.dy *dt 
    timer = timer + dt
   if timer > lower_interval and timer < upper_interval  then
    self.y = Enemy2.y + 10

   elseif timer > interval then
    lower_interval = interval + 5
    upper_interval = upper_interval + 5 
    interval = interval + 5
   end
end
-- resets enemy 2's fire
function Enemy2_fire:reset()
    self.x = Enemy2.x + 6
    self.y = Enemy2.y
end

function Enemy2_fire:render() -- Renders the ball to center
    if octorok2_health > 0 then
        love.graphics.rectangle('fill', self.x, self.y,4,4)
    else
        -- avoid ghost balls and just move them out of the screen
        self.x = -5
        self.y = -5
    end
end