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
  | new-portal(pos :: Posn)
end

data GameState:
  | game(player :: Player, portals :: List<Portal>)
end

init-posn = posn(100, 100)

doug = new-player(load-texture("doug-down.png"), init-posn, 0)

portals = [list:]

init-state = game(doug, portals)
#|
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
|#

wall = load-texture("walls.png")
tile = load-texture("tile.png")

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

maze-fin = create-maze(load-maze(ssid))

fun draw-game(state :: GameState) -> Image:
  
  place-image(state.player.img, state.player.pos.x, state.player.pos.y, maze-fin)
  
end

draw-game(init-state)





