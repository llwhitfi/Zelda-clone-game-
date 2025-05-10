--[[
    Represents our player in the game, with its own sprite
]]

Player = Class{}
-- require animation and collision files
require 'Animation'
require 'Collision'

-- constant local variables 
local WALKING_SPEED = 140
local MOVE_SPEED = 80

-- constant local variables
local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10


local p = love.physics
local world = love.physics.newWorld()

-- init function 
function Player:init()
 player = {}
    self.width = 16
    self.height = 16

    -- offset refrence point from top left corner to center of sprite for X axis
    self.xOffset = 8
    self.yOffset = 16

    -- offset refrence point from top left corner to center of sprite for Y axis
    self.xOffset2 = 16
    self.yOffset2 = 8

    self.x = tileWidth * 10
    self.y = tileHeight * (mapHeight / 2 - 1) - self.height
    self.dx = 0
    self.dy = 0

    self.currentFrame = nil
   
    self.texture = love.graphics.newImage('Sprites/Link_movement.png')
    self.frames = {}
-- define animation states
    self.state = 'idle_down'
    self.animations = {
        ['idle_right'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(32,0,16,16,self.texture:getDimensions())
            },
            interval = 1
        },
        ['idle_left'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(48,16,16,16,self.texture:getDimensions())
            },
            interval = 1
        },
        ['idle_up'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0,16,16,16,self.texture:getDimensions())
            },
            interval = 1
        },
        ['idle_down'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0,0,16,16,self.texture:getDimensions())
            },
            interval = 1
        },
        ['walking_right'] = Animation {
            texture = self.texture,
            frames = {
                --4 and 3
                love.graphics.newQuad(48,0,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(32,0,16,16,self.texture:getDimensions())
            },
            interval = 0.15
        },
        ['walking_left'] = Animation {
            texture = self.texture,
            frames = {
                -- 7 and 8
                love.graphics.newQuad(32,16,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(48,16,16,16,self.texture:getDimensions())
            },
            interval = 0.15
        },
        ['walking_up'] = Animation {
            texture = self.texture,
            frames = {
                --6 and 5
                love.graphics.newQuad(16,16,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(0,16,16,16,self.texture:getDimensions())
            },
            interval = 0.15
        },
        ['walking_down'] = Animation {
            texture = self.texture,
            frames = { 
                -- 2 and 1
                love.graphics.newQuad(16,0,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(0,0,16,16,self.texture:getDimensions())
            },
            interval = 0.15
        },
        ['sword_up'] = Animation {
            texture = self.texture,
            frames = {
                -- 10 and 14, the sprite is flipped in spritesheet so its drawn to link's body and not the sword at the upper left hand corner
                love.graphics.newQuad(16,32,16,32,self.texture:getDimensions())
            },
            interval = 1
        },
        ['sword_down'] = Animation {
            texture = self.texture,
            frames = {
                -- Animation for sword down
                love.graphics.newQuad(0,32,16,32,self.texture:getDimensions())
            },
            interval = 1
        },
        ['sword_right'] = Animation {
            texture = self.texture,
            frames = {
                -- 11 and 12 FLIP FOR LEFT
                love.graphics.newQuad(32,32,32,16,self.texture:getDimensions())
            },
            interval = 1
        },
        ['hurt_left'] = Animation {
            texture = self.texture,
            frames = {
                -- left idle and empty quad
                love.graphics.newQuad(48,16,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions()),
             
            },
            interval = 0.15
        }, 
        ['hurt_right'] = Animation {
            texture = self.texture,
            frames = {
                -- right idle and empty quad
                love.graphics.newQuad(32,0,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions())
             
            },
            interval = 0.15
        },
        ['hurt_up'] = Animation {
            texture = self.texture,
            frames = {
                -- up idle and empty quad
                love.graphics.newQuad(0,16,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions())
             
            },
            interval = 0.15
        },
        ['hurt_down'] = Animation {
            texture = self.texture,
            frames = {
                -- down idle and empty quad
                love.graphics.newQuad(0,0,16,16,self.texture:getDimensions()),
                love.graphics.newQuad(-16,-16,16,16,self.texture:getDimensions()),
             
            },
            interval = 0.15
        }
    }
    
-- Define the behavior for the idle_down state
    self.behaviors = {
        ['idle_down'] = function(dt)
            if love.keyboard.isDown('up') then
                self.y = self.y -MOVE_SPEED * dt
                self.animation = self.animations['walking_up']
                self.state = 'idle_up'
                player.b:setLinearVelocity(0,-MOVE_SPEED)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('down') then
                if player.b:isTouching(wall_bottom.b) or player.b:isTouching( wall_bottom2.b) then
                    self.y = self.y + 0 * dt
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif Enemy1_fire:collides(self) or Enemy2_fire:collides(self) 
                or Enemy3_fire:collides(self) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_down']
                    sounds['link_hurt']:play()

                elseif player.b:isTouching(fast_enemy1.b) or player.b:isTouching(fast_enemy2.b) or
                player.b:isTouching(fast_enemy3.b) or player.b:isTouching(fast_enemy4.b) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_down']
                    sounds['link_hurt']:play()

                else
                    self.y = self.y + MOVE_SPEED * dt
                    self.animation = self.animations['walking_down']
                    self.state = 'idle_down'
                    player.b:setLinearVelocity(0,MOVE_SPEED)
                end

            elseif love.keyboard.isDown('left') then
                self.x = self.x -MOVE_SPEED * dt
                self.animation = self.animations['walking_left']
                self.state = 'idle_left'
                player.b:setLinearVelocity(-MOVE_SPEED,0)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('right') then
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['walking_right']
                self.state = 'idle_right'
                player.b:setLinearVelocity(MOVE_SPEED,0)  
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('space')  then
                self.sword = 'sword' 
                self.animation = self.animations['sword_down']
                sounds['sword_slash']:play()
                player_sword.s = p.newRectangleShape(16,32)
                player_sword.b:setPosition(self.x + 8,self.y + 15)
                
                if player_sword.b:isTouching(enemy1.b) then
                    octorok1_health = octorok1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(enemy2.b) then
                    octorok2_health = octorok2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                
                elseif player_sword.b:isTouching(enemy3.b) then
                    octorok3_health = octorok3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                
                elseif player_sword.b:isTouching(fast_enemy1.b) then
                    fast_enemy1_health = fast_enemy1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy2.b) then
                    fast_enemy2_health = fast_enemy2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy3.b) then
                    fast_enemy3_health = fast_enemy3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy4.b) then
                    fast_enemy4_health = fast_enemy4_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                end
            else
                self.animation = self.animations['idle_down']
                player.b:setLinearVelocity(0,0)
            end
            Collision:CheckDownCollision(self)
        end,

      -- Define the behavior for the idle_up state
        ['idle_up'] = function (dt)
            if love.keyboard.isDown('up') then
                if player.b:isTouching(wall_top.b) then
                    self.y = self.y + 0 * dt
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif player.b:isTouching(enemy1.b) or player.b:isTouching(enemy2.b) 
                or player.b:isTouching(enemy3.b) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_up']
                    sounds['link_hurt']:play()

                elseif Enemy1_fire:collides(self) or Enemy2_fire:collides(self) 
                or Enemy3_fire:collides(self) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_up']
                    sounds['link_hurt']:play()
        
                elseif player.b:isTouching(fast_enemy1.b) or player.b:isTouching(fast_enemy2.b) or
                player.b:isTouching(fast_enemy3.b) or player.b:isTouching(fast_enemy4.b) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 0.5
                    self.animation = self.animations['hurt_down']

                else
                    self.y = self.y -MOVE_SPEED * dt
                    self.animation = self.animations['walking_up']
                    self.state = 'idle_up'
                player.b:setLinearVelocity(0,-MOVE_SPEED) 
                end

            elseif love.keyboard.isDown('down') then
                
                self.y = self.y + MOVE_SPEED * dt
                self.animation = self.animations['walking_down']
                self.state = 'idle_down'
                player.b:setLinearVelocity(0,MOVE_SPEED)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('left') then
               
                self.x = self.x -MOVE_SPEED * dt
                self.animation = self.animations['walking_left']
                self.state = 'idle_left'
                player.b:setLinearVelocity(-MOVE_SPEED,0)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('right') then
                
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['walking_right']
                self.state = 'idle_right'
                player.b:setLinearVelocity(MOVE_SPEED,0)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('space')  then
            
                self.sword = 'sword' 
                self.animation = self.animations['sword_up']
                sounds['sword_slash']:play()
                player_sword.s = p.newRectangleShape(16,32)
                player_sword.b:setPosition(self.x + 8,self.y -1)
               
                if player_sword.b:isTouching(enemy1.b) then
                    octorok1_health = octorok1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(enemy2.b) then
                    octorok2_health = octorok2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
              
                elseif player_sword.b:isTouching(enemy3.b) then
                    octorok3_health = octorok3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy1.b) then
                    fast_enemy1_health = fast_enemy1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                
                elseif player_sword.b:isTouching(fast_enemy2.b) then
                    fast_enemy2_health = fast_enemy2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy3.b) then
                    fast_enemy3_health = fast_enemy3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                
                elseif player_sword.b:isTouching(fast_enemy4.b) then
                    fast_enemy4_health = fast_enemy4_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                end
            else
              
                self.animation = self.animations['idle_up']
                player.b:setLinearVelocity(0,0)
            end
            Collision:CheckUpCollision(self)
        end,

-- Define the behavior for the idle_right state
        ['idle_right'] = function (dt)
            if love.keyboard.isDown('up') then
                
                self.y = self.y -MOVE_SPEED * dt
                self.animation = self.animations['walking_up']
                self.state = 'idle_up'
                player.b:setLinearVelocity(0,-MOVE_SPEED)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('down') then
               
                self.y = self.y + MOVE_SPEED * dt
                self.animation = self.animations['walking_down']
                self.state = 'idle_down'
                player.b:setLinearVelocity(0,MOVE_SPEED)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('left') then
               
                self.x = self.x -MOVE_SPEED * dt
                self.animation = self.animations['walking_left']
                self.state = 'idle_left'
                player.b:setLinearVelocity(-MOVE_SPEED,0)
                player.b:setPosition(Player.x + 8,Player.y + 8)

            elseif love.keyboard.isDown('right') then
                if player.b:isTouching(wall_right.b) then
                    self.x = self.x + 0 * dt
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif player.b:isTouching(enemy1.b) or player.b:isTouching(enemy2.b) 
                or player.b:isTouching(enemy3.b) then
                    self.x = self.x - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_right']
                    sounds['link_hurt']:play()

                elseif Enemy1_fire:collides(self) or Enemy2_fire:collides(self) 
                or Enemy3_fire:collides(self) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_right']
                    sounds['link_hurt']:play()

                elseif player.b:isTouching(fast_enemy1.b) or player.b:isTouching(fast_enemy2.b) or
                player.b:isTouching(fast_enemy3.b) or player.b:isTouching(fast_enemy4.b) then
                    self.y = self.y - 0 * dt
                    link_health = link_health - 1
                    self.animation = self.animations['hurt_down']

                else
                self.x = self.x + MOVE_SPEED * dt
                self.animation = self.animations['walking_right']
                self.state = 'idle_right'
                player.b:setLinearVelocity(MOVE_SPEED,0)
                end

            elseif love.keyboard.isDown('space')  then
            
                self.animation = self.animations['sword_right']
                self.sword = 'sword' 
                sounds['sword_slash']:play()
                player_sword.s = p.newRectangleShape(32,16)
                player_sword.b:setPosition(self.x + 20,self.y + 8)
                
                if player_sword.b:isTouching(enemy1.b) then
                    octorok1_health = octorok1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(enemy2.b) then
                    octorok2_health = octorok2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(enemy3.b) then
                    octorok3_health = octorok3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy1.b) then
                    fast_enemy1_health = fast_enemy1_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy2.b) then
                    fast_enemy2_health = fast_enemy2_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                
                elseif player_sword.b:isTouching(fast_enemy3.b) then
                    fast_enemy3_health = fast_enemy3_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
               
                elseif player_sword.b:isTouching(fast_enemy4.b) then
                    fast_enemy4_health = fast_enemy4_health - 1
                    self.x = self.x - 0 * dt 
                    sounds['enemy_hit']:play()
                    player_sword.b:setLinearVelocity(0,0)
                end
           
            else
                self.animation = self.animations['idle_right']
                player.b:setLinearVelocity(0,0)
               
            end 
            Collision:CheckRightCollision(self)             
        end,

-- Define the behavior for the idle_up state
            ['idle_left'] = function (dt)
                if love.keyboard.isDown('up') then
                  
                    self.y = self.y -MOVE_SPEED * dt
                    self.animation = self.animations['walking_up']
                    self.state = 'idle_up'
                    player.b:setLinearVelocity(0,-MOVE_SPEED)
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif love.keyboard.isDown('down') then
                   
                    self.y = self.y + MOVE_SPEED * dt
                    self.animation = self.animations['walking_down']
                    self.state = 'idle_down'
                    player.b:setLinearVelocity(0,MOVE_SPEED)
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif love.keyboard.isDown('left') then
                    if player.b:isTouching(wall_left.b) then
                        self.x = self.x - 0 * dt 
                        player.b:setPosition(Player.x + 8,Player.y + 8)

                    elseif player.b:isTouching(enemy1.b) or player.b:isTouching(enemy2.b) 
                    or player.b:isTouching(enemy3.b) then
                        self.x = self.x - 0 * dt
                        link_health = link_health - 1
                        sounds['link_hurt']:play()
                        self.animation = self.animations['hurt_left']
                        sounds['link_hurt']:play()

                    elseif Enemy1_fire:collides(self) or Enemy2_fire:collides(self) 
                    or Enemy3_fire:collides(self) then
                        self.y = self.y - 0 * dt
                        link_health = link_health - 1
                        sounds['link_hurt']:play()
                        self.animation = self.animations['hurt_left']
                        sounds['link_hurt']:play()

                    elseif player.b:isTouching(fast_enemy1.b) or player.b:isTouching(fast_enemy2.b) or
                    player.b:isTouching(fast_enemy3.b) or player.b:isTouching(fast_enemy4.b) then
                        self.y = self.y - 0 * dt
                        link_health = link_health - 1
                        sounds['link_hurt']:play()
                        self.animation = self.animations['hurt_down']

                    else

                    self.x = self.x -MOVE_SPEED * dt
                    self.animation = self.animations['walking_left']
                    self.state = 'idle_left'
                    player.b:setLinearVelocity(-MOVE_SPEED,0)
                    end

                elseif love.keyboard.isDown('right') then
                   
                    self.x = self.x + MOVE_SPEED * dt
                    self.animation = self.animations['walking_right']
                    self.state = 'idle_right'
                    player.b:setLinearVelocity(MOVE_SPEED,0)
                    player.b:setPosition(Player.x + 8,Player.y + 8)

                elseif love.keyboard.isDown('space')  then
                  
                    self.animation = self.animations['sword_right']
                    self.sword = 'sword'  
                    sounds['sword_slash']:play()
                    player_sword.s = p.newRectangleShape(32,16)
                    player_sword.b:setPosition(self.x- 3,self.y + 8)

                    if player_sword.b:isTouching(enemy1.b) then
                        octorok1_health = octorok1_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                    
                    elseif player_sword.b:isTouching(enemy2.b) then
                        octorok2_health = octorok2_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                    
                    elseif player_sword.b:isTouching(enemy3.b) then
                        octorok3_health = octorok3_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                    
                    elseif player_sword.b:isTouching(fast_enemy1.b) then
                        fast_enemy1_health = fast_enemy1_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                   
                    elseif player_sword.b:isTouching(fast_enemy2.b) then
                        fast_enemy2_health = fast_enemy2_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                   
                    elseif player_sword.b:isTouching(fast_enemy3.b) then
                        fast_enemy3_health = fast_enemy3_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                    
                    elseif player_sword.b:isTouching(fast_enemy4.b) then
                        fast_enemy4_health = fast_enemy4_health - 1
                        self.x = self.x - 0 * dt 
                        sounds['enemy_hit']:play()
                        player_sword.b:setLinearVelocity(0,0)
                    end
                else
                    self.animation = self.animations['idle_left']
                    player.b:setLinearVelocity(0,0)
            
            end
                Collision:CheckLeftCollision(self)
        end,
    }
  -- player update function for behaviors, animation, and frames   
    function Player:update(dt)
        -- Update behaviors, animations, and frames
        self.behaviors[self.state](dt)
        self.animation:update(dt) 
        self.currentFrame = self.animation:getCurrentFrame() 
    end
    -- Player reset function that resets position back to its initial state
function Player:reset()
    self.x = tileWidth * 10
    self.y = tileHeight * (mapHeight / 2 - 1) - self.height
end
-- draws player's sprite and frames
    function Player:render()
        -- Define scale variables

        local scaleX 
        local scaleY 

        -- If space is pressed and the state is left then it will take that current frame (sword_right) and flip it horizontally
        -- This was done since everything is drawn to its upper left corner and to keep consistency 
        if love.keyboard.isDown('space') and self.state == 'idle_left' then
            --Flips 180 degrees
            scaleX = -1
        else
            -- No flip
            scaleX = 1
        end
        -- If space is pressed and the state is up then it will take that current frame and flip it vertically
        if love.keyboard.isDown('space') and self.state == 'idle_up' then
            scaleY = -1
        else
            scaleY = 1
        end

        -- Change reference point from top left corner to the center so it can flip within the same position for both x and y axis flips
        if love.keyboard.isDown('space') and self.state == 'idle_left' then
            love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),math.floor(self.y + self.yOffset),
            0,scaleX,1,self.xOffset,self.yOffset)

        elseif love.keyboard.isDown('space') and self.state == 'idle_up' then
            love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset2),math.floor(self.y + self.yOffset2),
            0,1,scaleY,self.xOffset2,self.yOffset2)
        else
            -- If the first two conditions do not appy, just render the current frames without scaling or rotation
            love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),math.floor(self.y)) 
        end
    end
end