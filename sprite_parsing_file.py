from PIL import Image

#color library for pico-8 to know what color
colors=[(0,0,0), (1,1,1), (1,1,1), (1,1,1), (200,76,12), (1,1,1), (116,116,116), (252,252,252), (1,1,1), (1,1,1), (1,1,1), (0,168,0), (32,56,236), (1,1,1), (1,1,1), (252,216,168)]

img_sprites=[]

#TODO
#def huffman_encode(data):

def location(list, img):
    if img in list:
        return list.index(img)
    list.append(img)
    return len(list) - 1

def get_room(location=0):
    im = Image.open("overworld.png")
    x1 = location % 16 * 256
    y1 = location // 16 * 168
    return  im.crop((x1, y1, x1 + 256, y1 + 168))

def parse_map(im, num=0):
    return [location(img_sprites, im.crop((x % 32 * 8, (x // 32 * 8), (x % 32 * 8) + 8, (x // 32 * 8) + 8))) for x in range(672)]

def parse_sprites():
    return [[colors.index(sprite.load()[i,j]) for j in range(8) for i in range(8)] for sprite in img_sprites]

def condense_sprites(sprites_data):
    return [[sprite[x + 1]<<4 | sprite[x] for x in range(0,64,2)] for sprite in sprites_data]

#writing the data to the room file for pico-8 to read
def write_to_file(f,map,sprites_data,num):
    strg="room = {"
    f.write(strg)
    for x in map:
        f.write(str(x+1))
        f.write(", ")
    f.write("}\nsprites = {")
    for sprite in sprites_data:
        f.write("{")
        for x in sprite:
            f.write(str(x))
            f.write(", ")
        f.write("}, ")
    f.write("}\n")

#control function to orderly parse and define data of the room number
def parse_room(num):
    room = get_room(num)
    map = parse_map(room, num)
    sprites_data = parse_sprites()
    condensensed_sprites = condense_sprites(sprites_data)
    f = open("room.p8", "w")
    write_to_file(f,map,condensensed_sprites,num)


parse_room(int(input('Enter a room number 0-127: ')))
print('Please reload Pico-8 to see the room!')