# load the project support code
include shared-gdrive(
  "cs111-2020.arr",
  "1imMXJxpNWFCUaawtzIJzPhbDuaLHtuDX")

include shared-gdrive(
  "project-2-support.arr",
  "1N1pwFonshMA_CH99wH00h0HuuiXRja9A")

include image
include tables
include reactors
import lists as L

ssid = "1Jt90nPp_qpoFg5oRFwiBCSWJWCZbecWsRHnWxbtwYGY"
maze-data = load-maze(ssid)
item-data = load-items(ssid)

data Posn:
  | posn(x :: Number, y :: Number)
end

data Player:
  | new-player(img :: Image, pos :: Posn, portals :: Number)
end

data Portal:
  | new-portal(img :: Image, pos :: Posn)
end

data GameState:
  | game(player :: Player, portals :: List<Portal>)
end

init-posn = posn(45, 45)

doug = new-player(load-texture("doug-down.png"), init-posn, 0)


portals = [list: new-portal(load-texture("pop-rocks.png"), posn((8 * 30) + 15, (8 * 30) + 15))]

init-state = game(doug, portals)

wall = load-texture("walls.png")
tile = load-texture("tile.png")
portal = load-texture("pop-rocks.png")

fun create-row(ro :: List<String>) -> Image:
  cases (List) ro:
    | empty => empty-image
    | link(f, r) => 
      if (f == "x"):
        beside(wall, create-row(r))
      else:
        beside(tile, create-row(r))
      end
  end
end

fun create-maze(maze :: List<List<String>>) -> Image:
  cases (List) maze:
    | empty => empty-image
    | link(f, r) =>
      above(create-row(f), create-maze(r))
  end
end

maze-fin = create-maze(maze-data)

fun draw-portals(lop :: List<Portal>) -> Image:
  cases (List) lop:
    | empty => maze-fin
    | link(f, r) =>
      place-image(f.img, f.pos.x, f.pos.y, draw-portals(r))
  end
end

fun draw-game(state :: GameState) -> Image:

  place-image(state.player.img, state.player.pos.x, state.player.pos.y, draw-portals(state.portals))

end

#draw-game(init-state)


fun key-pressed(state :: GameState, key :: String) -> GameState:
  posx = state.player.pos.x
  tilex = (state.player.pos.x - 15) / 30
  posy = state.player.pos.y
  tiley = (state.player.pos.y - 15) / 30
  pimg = state.player.img
  pport = state.player.portals

  if (key == "w") and (maze-data.get(tiley - 1).get(tilex) == "o"):
      game(new-player(pimg, posn(posx, posy - 30), pport), state.portals)
  else if (key == "a") and (maze-data.get(tiley).get(tilex - 1) == "o"):
    game(new-player(pimg, posn(posx - 30, posy), pport), state.portals)
  else if (key == "s") and (maze-data.get(tiley + 1).get(tilex) == "o"):
    game(new-player(pimg, posn(posx, posy + 30), pport), state.portals) 
  else if (key == "d") and (maze-data.get(tiley).get(tilex + 1) == "o"):
    game(new-player(pimg, posn(posx + 30, posy), pport), state.portals)
  else:
    state
  end
end

maze-game =
  reactor:
    init              : init-state,
    to-draw           : draw-game,
    # on-mouse        : mouse-click, # portals only
    on-key            : key-pressed,
    # stop-when       : game-complete, # [up to you]
    # close-when-stop : true, # [up to you]
    title             : "Captured by Candy!" # [you can change this title]
  end

interact(maze-game)



