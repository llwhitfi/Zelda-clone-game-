Animation = Class{}
-- Animation class
function Animation:init(params)
    self.texture = params.texture
    self.frames = params.frames
    self.interval = params.interval or 0.05
    self.timer = 0
    self.currentFrame = 1
end
-- animation getcurrentframe function 
function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end
-- animation restart function 
function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end
-- animation update function 
function Animation:update(dt)
    self.timer = self.timer + dt

    if #self.frames == 1 then
        return self.currentFrame
    else
        while self.timer > self.interval do
            self.timer = self.timer - self.interval

            self. currentFrame = (self.currentFrame + 1) % (#self.frames + 1)
            if self.currentFrame == 0 then
                self.currentFrame = 1
            end
        end 
    end
end
