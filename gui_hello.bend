import Base

# Simple GUI test: a window with a gradient that responds to clicks.
# Press Escape or close the window to quit.

def main_color(+x: U32, +y: U32, +offset: U32) -> U32:
  +r = U32.min(((x + offset) * 256 / 512 : U32), 255)
  +g = U32.min(((y + offset) * 256 / 512 : U32), 255)
  +b = U32.min(((x + y + offset) * 128 / 512 : U32), 255)
  ((r * 65536 : U32) + (g * 256 : U32) + b : U32)

def gradient(+d: Nat, +x0: U32, +y0: U32, +offset: U32) -> Image:
  match d:
    case 0n:
      Pix{main_color(x0, y0, offset)}
    case 1n+e:
      +h = U32.shln(1, e)
      +x1 = (x0 + h : U32)
      +y1 = (y0 + h : U32)
      Qua{gradient(e, x0, y0, offset), gradient(e, x1, y0, offset),
          gradient(e, x0, y1, offset), gradient(e, x1, y1, offset)}

def view(offset: U32) -> U32 & Image:
  +o = offset
  (o, gradient(9n, 0, 0, o))

def event(e: Event, +offset: U32) -> Maybe<U32>:
  match e:
    case Key{27, True{}}:
      None{}
    case Close{}:
      None{}
    case Mouse{x, y, button, True{}}:
      Some{((x + y) : U32)}
    case _:
      Some{offset}

def go(events: List<Event>, +offset: U32) -> Maybe<U32>:
  match events:
    case []:
      Some{offset}
    case e <> rest:
      Maybe.bind(&1, U32, U32, event(e, offset), m => go(rest, m))

def tick(events: List<Event>, offset: U32) -> IO(Maybe<U32>):
  IO.pure(Maybe<U32>, go(events, offset))

def main() -> IO(Unit):
  App.run(~U32, ~App{view, tick}, "Hello Bend!", 512, 512, 0)
