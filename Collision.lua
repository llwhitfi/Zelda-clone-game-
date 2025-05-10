local tileWidth = 16
local tileHeight = 16
local mapWidth = 30
local mapHeight = 28
local xOffset = 8
local yOffset = 10
local tiles = {}

Collision = {}


function Collision:CheckUpCollision(name)
    -- Checks if tile at top right and left corners are empty
    if tileAt(name.x, name.y - 1).id == TILE_TREE or
        tileAt(name.x + name.width - 1, name.y - 1).id == TILE_TREE or
        tileAt(name.x, name.y - 1).id == TILE_WALL or
        tileAt(name.x + name.width - 1, name.y - 1).id == TILE_WALL then
        --if not then reset position
        name.y = tileAt(name.x, name.y - 1).y * tileHeight 
    end
end

function Collision:CheckDownCollision(name)
    -- Checks if tile at the bottom right and left corners are empty 
        if tileAt(name.x, name.y + name.height).id == TILE_TREE or
            tileAt(name.x + name.width - 1, name.y + name.height).id == TILE_TREE or 
            tileAt(name.x, name.y + name.height).id == TILE_BOTTOM_WALL or
            tileAt(name.x + name.width - 1, name.y + name.height).id == TILE_BOTTOM_WALL then
                -- if not then reset position
            name.y = (tileAt(name.x, name.y + name.height).y-1) * tileHeight - name.height
    end
end

-- checks two tiles to our left to see if a collision occurred
function Collision:CheckLeftCollision(name)
        if tileAt(name.x - 1, name.y).id == TILE_TREE or
            tileAt(name.x - 1, name.y + name.height - 1).id == TILE_TREE or
            tileAt(name.x - 1, name.y).id == TILE_WALL or
            tileAt(name.x - 1, name.y + name.height - 1).id == TILE_WALL  then
            --if so, reset position and change state
            name.x = tileAt(name.x - 1, name.y).x * tileWidth
    end
end

-- checks two tiles to our right to see if a collision occurred
function Collision:CheckRightCollision(name)
    --Checks if tile id is empty at top right and bottom corners 
        if tileAt(name.x + name.width, name.y).id == TILE_TREE or
            tileAt(name.x + name.width, name.y + name.height-1).id == TILE_TREE or
            tileAt(name.x + name.width, name.y).id == TILE_WALL or
            tileAt(name.x + name.width, name.y + name.height-1).id == TILE_WALL then      
            -- if so, change position and change state
            name.x = (tileAt(name.x + name.width, name.y).x - 1) * tileWidth - name.width
    end
end

