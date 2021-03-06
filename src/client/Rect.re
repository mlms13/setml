open Belt;

type t = {
  x: float,
  y: float,
  w: float,
  h: float,
};

let to_string = r => Printf.sprintf("x: %f, y: %f, w: %f, h: %f", r.x, r.y, r.w, r.h);

let make = (x, y, w, h) => {x, y, w, h};

let makei = (x, y, w, h) => make(float_of_int(x), float_of_int(y), float_of_int(w), float_of_int(h));

let empty = {x: 0.0, y: 0.0, w: 0.0, h: 0.0};

let top = rect => rect.y;

let bottom = rect => rect.y +. rect.h;

let left = rect => rect.x;

let right = rect => rect.x +. rect.w;

let shift = rect => make(0.0, 0.0, rect.w, rect.h);

let toStyle = rect =>
  ReactDOMRe.Style.make(
    ~top=Shared_util.roundis(top(rect)) ++ "px",
    ~bottom=Shared_util.roundis(bottom(rect)) ++ "px",
    ~left=Shared_util.roundis(left(rect)) ++ "px",
    ~right=Shared_util.roundis(right(rect)) ++ "px",
    ~width=Shared_util.roundis(rect.w) ++ "px",
    ~height=Shared_util.roundis(rect.h) ++ "px",
  );

let isWithin = (rect, (x, y)) => rect.x <= x && x <= right(rect) && rect.y <= y && y <= bottom(rect);

let findRect = (rects, (x, y)) => {
  let rec aux = i =>
    switch (rects[i]) {
    | Some(rect) =>
      if (isWithin(rect, (x, y))) {
        Some(i);
      } else {
        aux(i + 1);
      }
    | None => None
    };
  aux(0);
};

let shrink = (~i, rect) => make(rect.x +. i /. 2.0, rect.y +. i /. 2.0, rect.w -. i, rect.h -. i);

let pad = (~i, rect) => make(rect.x +. i, rect.y +. i, rect.w -. i *. 2.0, rect.h -. i *. 2.0);

let padNW = (~i, rect) => make(rect.x +. i, rect.y +. i, rect.w -. i, rect.h -. i);

let padSW = (~i, rect) => make(rect.x, rect.y, rect.w -. i, rect.h -. i);

let crop = (~i, rect) => make(rect.x +. i, rect.y +. i, rect.w -. 2. *. i, rect.h -. 2. *. i);

let eq = (r0, r1) => r0.x == r1.x && r0.y == r1.y && r0.w == r0.w && r0.h == r0.h;

let area = r => r.w *. r.h;

let compare = (r0, r1) =>
  if (eq(r0, r1)) {
    0;
  } else if (area(r0) <= area(r1)) {
    (-1);
  } else {
    1;
  };
