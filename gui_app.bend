import Base

type Gui is Data:
  Gui{input: +List<U32>, cursor: U32}

def Gui.pick(c: Bool, a: U32, b: U32) -> U32:
  match c:
    case True{}: a
    case False{}: b

def Font.get_lo(c: U32) -> U32:
  match c:
    case 32: 0
    case 33: 2164391936
    case 43: 2164260864
    case 45: 0
    case 46: 0
    case 47: 68157440
    case 48: 405766144
    case 49: 2168651776
    case 50: 137330688
    case 51: 137330688
    case 52: 2248671232
    case 53: 4030709760
    case 54: 405766144
    case 55: 69189632
    case 56: 405766144
    case 57: 405766144
    case 58: 3279945728
    case 61: 4026531840
    case 63: 137330688
    case 65: 340197376
    case 66: 405782528
    case 67: 272596992
    case 68: 338149376
    case 69: 272613376
    case 70: 272613376
    case 71: 272596992
    case 72: 405815296
    case 73: 2166341632
    case 74: 69189632
    case 75: 2452111360
    case 76: 270548992
    case 77: 1550860288
    case 78: 1483751424
    case 79: 405766144
    case 80: 405782528
    case 81: 405766144
    case 82: 405782528
    case 83: 272596992
    case 84: 2166341632
    case 85: 405815296
    case 86: 405815296
    case 87: 405815296
    case 88: 1146109952
    case 89: 1146109952
    case 90: 69189632
    case 97: 62914560
    case 98: 3491774464
    case 99: 532676608
    case 100: 3825729536
    case 101: 398458880
    case 102: 3767402496
    case 103: 465567744
    case 104: 3491774464
    case 105: 3221356544
    case 106: 524288
    case 107: 270548992
    case 108: 2164457472
    case 109: 2996830208
    case 110: 933232640
    case 111: 398458880
    case 112: 933232640
    case 113: 465567744
    case 114: 1730150400
    case 115: 532676608
    case 116: 3766550528
    case 117: 404750336
    case 118: 404750336
    case 119: 404750336
    case 120: 673185792
    case 121: 404750336
    case 122: 266338304
    case 40: 1090781184
    case 41: 16842752
    case _: 0

def Font.get_hi(c: U32) -> U32:
  match c:
    case 32: 0
    case 33: 135266368
    case 43: 1057784
    case 45: 1016
    case 46: 473432064
    case 47: 17043521
    case 48: 1049044622
    case 49: 1041244224
    case 50: 2130839028
    case 51: 1048773092
    case 52: 553554210
    case 53: 1048773123
    case 54: 1048774136
    case 55: 135274561
    case 56: 1048774132
    case 57: 1048773620
    case 58: 3698689
    case 61: 130055
    case 63: 134226372
    case 65: 1099106300
    case 66: 1065551356
    case 67: 2114061320
    case 68: 524486156
    case 69: 2130838776
    case 70: 16909560
    case 71: 1048774088
    case 72: 1099106300
    case 73: 2131763264
    case 74: 507674882
    case 75: 555885624
    case 76: 2130838536
    case 77: 1099105869
    case 78: 1103316556
    case 79: 1048774156
    case 80: 16909820
    case 81: 2118338060
    case 82: 1094862332
    case 83: 1065419248
    case 84: 135274560
    case 85: 1048774156
    case 86: 136874508
    case 87: 1103582796
    case 88: 1094996033
    case 89: 135274561
    case 90: 2130972737
    case 97: 1048774130
    case 98: 1032259099
    case 99: 2114061320
    case 100: 1585645069
    case 101: 1040320508
    case 102: 67637287
    case 103: 1044478476
    case 104: 1099105819
    case 105: 1041244224
    case 106: 507674883
    case 107: 286399561
    case 108: 1041244224
    case 109: 1099126445
    case 110: 1099105804
    case 111: 1048774156
    case 112: 24841740
    case 113: 549258764
    case 114: 16909320
    case 115: 1065419248
    case 116: 940052519
    case 117: 1048774156
    case 118: 136874508
    case 119: 1103582796
    case 120: 1094996130
    case 121: 1044478476
    case 122: 2130972737
    case 40: 269488160
    case 41: 68173953
    case _: 0

def Gui.pick_bool(c: Bool, a: Bool, b: Bool) -> Bool:
  match c:
    case True{}: a
    case False{}: b

def Font.pixel(+c: U32, +row: Nat, +col: Nat) -> Bool:
  +pos = Nat.add(Nat.mul(row, 7n), col)
  +lo = Font.get_lo(c)
  +hi = Font.get_hi(c)
  +check_lo = Nat.is_lt(pos, 32n)
  +shift_hi = Nat.sub(pos, 32n)
  +bit_lo = U32.is_eq(U32.and(U32.shrn(lo, pos), 1), 1)
  +bit_hi = U32.is_eq(U32.and(U32.shrn(hi, shift_hi), 1), 1)
  Gui.pick_bool(check_lo, bit_lo, bit_hi)

def Gui.char_pixel_go(+fg: U32, +bg: U32, +row: Nat, +col: Nat, m: Maybe<&2, U32>) -> U32:
  match m:
    case Some{c}:
      Gui.pick(Font.pixel(c, row, col), fg, bg)
    case None{}: bg

def Gui.char_pixel(+xs: +List<U32>, +idx: Nat, +row: Nat, +col: Nat, +fg: U32, +bg: U32) -> U32:
  Gui.char_pixel_go(fg, bg, row, col, List.get(&2, U32, xs, idx))

def Gui.char_pixel_gap(col: Nat, +xs: +List<U32>, +idx: Nat, +row: Nat, +fg: U32, +bg: U32) -> U32:
  match col:
    case 0n: Gui.char_pixel(xs, idx, row, 0n, fg, bg)
    case 1n: Gui.char_pixel(xs, idx, row, 1n, fg, bg)
    case 2n: Gui.char_pixel(xs, idx, row, 2n, fg, bg)
    case 3n: Gui.char_pixel(xs, idx, row, 3n, fg, bg)
    case 4n: Gui.char_pixel(xs, idx, row, 4n, fg, bg)
    case 5n: Gui.char_pixel(xs, idx, row, 5n, fg, bg)
    case 6n: Gui.char_pixel(xs, idx, row, 6n, fg, bg)
    case _: bg

def List.len(+xs: +List<U32>) -> Nat:
  match xs:
    case []: 0n
    case _ <> rest: Nat.add(1n, List.len(rest))

def Gui.text_pixel_go(+xs: +List<U32>, +tx: U32, +y: U32, +fg: U32, +bg: U32) -> U32:
  +tx3 = U32.div(tx, 3)
  +y3 = U32.div(y, 3)
  +col_in_cell = Nat.mod(U32.to_nat(tx3), 8n)
  +char_x = U32.to_nat(U32.div(tx3, 8))
  +row_in_cell = Nat.mod(U32.to_nat(y3), 9n)
  +line = U32.to_nat(U32.div(y3, 9))
  +char_idx = Nat.add(Nat.mul(line, 21n), char_x)
  +len = List.len(xs)
  Gui.pick(Nat.is_lt(char_idx, len),
    Gui.char_pixel_gap(col_in_cell, xs, Nat.sub(len, Nat.add(char_idx, 1n)), row_in_cell, fg, bg),
    bg)

def Gui.text_pixel(+xs: +List<U32>, +tx: U32, +y: U32, +fg: U32, +bg: U32) -> U32:
  Gui.text_pixel_go(xs, tx, y, fg, bg)

def Gui.color(+x: U32, +y: U32, +input: +List<U32>) -> U32:
  Gui.text_pixel(input, x, y, 13421567, 3362125)

def Gui.flat(d: Nat, +x0: U32, +y0: U32, +input: +List<U32>) -> Bool:
  False{}

def Gui.draw(+d: Nat, flat: Bool, +x0: U32, +y0: U32, +input: +List<U32>) -> Image:
  match d:
    case 0n:
      Pix{Gui.color(x0, y0, input)}
    case 1n+e:
      match flat:
        case True{}:
          Pix{Gui.color(x0, y0, input)}
        case False{}:
          +h = U32.shln(1, e)
          +x1 = (x0 + h : U32)
          +y1 = (y0 + h : U32)
          tl tr bl br = Gui.draw(e, Gui.flat(e, x0, y0, input), x0, y0, input)
            Gui.draw(e, Gui.flat(e, x1, y0, input), x1, y0, input)
            Gui.draw(e, Gui.flat(e, x0, y1, input), x0, y1, input)
            Gui.draw(e, Gui.flat(e, x1, y1, input), x1, y1, input)
          Qua{tl, tr, bl, br}

def Gui.view(gui: Gui) -> Gui & Image:
  Gui{input, cursor} = gui
  +input = input
  +img = Gui.draw(9n, False{}, 0, 0, input)
  (Gui{input, cursor}, img)

def Gui.on_backspace(gui: Gui) -> Maybe<Gui>:
  Gui{input, cursor} = gui
  match input:
    case []: Some{gui}
    case _ <> rest: Some{Gui{rest, 0}}

def Gui.on_event(e: Event, gui: Gui) -> Maybe<Gui>:
  match e:
    case Key{27, True{}}: None{}
    case Close{}: None{}
    case Key{13, True{}}:
      Gui{input, cursor} = gui
      Some{Gui{[], 0}}
    case Key{8, True{}}: Gui.on_backspace(gui)
    case Key{127, True{}}: Gui.on_backspace(gui)
    case Key{65288, True{}}: Gui.on_backspace(gui)
    case Key{code, True{}}:
      Gui{input, cursor} = gui
      Some{Gui{code <> input, 0}}
    case _: Some{gui}

def Gui.on_events(events: List<Event>, gui: Gui) -> Maybe<Gui>:
  match events:
    case []: Some{gui}
    case e <> rest:
      Maybe.bind(&1, Gui, Gui, Gui.on_event(e, gui), g => Gui.on_events(rest, g))

def Gui.tick(events: List<Event>, gui: Gui) -> IO(Maybe<Gui>):
  IO.pure(Maybe<Gui>, Gui.on_events(events, gui))

def main() -> IO(Unit):
  App.run(~Gui, ~App{Gui.view, Gui.tick}, "Bend - Text Input", 512, 256, Gui{[], 0})
