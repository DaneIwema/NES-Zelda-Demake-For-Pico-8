pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include room.p8

function _init()
    room_width=32
    room_height=22
    cam_x,cam_y=0,0
    map_x,map_y=0,0
    load_sprites()
    load_map()
end

function _update()
    if (btn(0)) cam_x-=1
    if (btn(1)) cam_x+=1
    if (btn(2)) cam_y-=1
    if (btn(3)) cam_y+=1

    if (btn(4))room=1
    if (btn(5))room=2

    check_map_boundry()
end

function _draw()
    cls()
    
    camera(cam_x, cam_y)

    map(0,0,0,0,18,18)
end
-->8

-- code to directly sprite data for the room data into memory
function load_sprites()
    for ind,sprite in pairs(sprites) do
        for i=0, 8, 1 do
            poke(ind * 4 + (448 * flr(ind / 16) + (64 * i)), unpack(sprite, 1+(i*4), 1+(i*4)+4))
        end
    end 
end

--code to inject the map of the room into memory
function load_map()
    for i=0,17,1 do
        poke(8192+(128*i), unpack(room, i*32+1+(map_y*32)+map_x, i*32+18+(map_y*32)+map_x))
    end
end

--function for loading the map properly in an 18x18 square to save on map sheet resources
--and to keep the camera in bounds of the room
function check_map_boundry()

    if cam_x==17 and map_x!=14 then map_x+=1 cam_x=8 
    elseif cam_x==17 and map_x==14 then cam_x=16 end

    if cam_y==16 and map_y!=3 then map_y+=1 cam_y=8 
    elseif cam_y==17 and map_y==3 then cam_y=16 end

    if cam_x==-1 and map_x!=0 then map_x-=1 cam_x=8 
    elseif cam_x==-1 and map_x==0 then cam_x=0 end

    if cam_y==-1 and map_y!=0 then map_y-=1 cam_y=8 
    elseif cam_y==-1 and map_y==0 then cam_y=0 end

    for i=0,17,1 do
        poke(8192+(128*i), unpack(room, i*32+1+(map_y*32)+map_x, i*32+18+(map_y*32)+map_x))
    end
end
