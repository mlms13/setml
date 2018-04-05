open Belt;

let meta_content = name => {
  let rec aux = c =>
    switch (c) {
    | [] => ""
    | [hd, ...tl] =>
      let el_name = Webapi.Dom.Element.getAttribute("name", hd);
      switch (el_name) {
      | None => aux(tl)
      | Some(n) =>
        if (n == name) {
          let el_content = Webapi.Dom.Element.getAttribute("content", hd);
          switch (el_content) {
          | None => ""
          | Some(c) => c
          };
        } else {
          aux(tl);
        }
      };
    };
  DocumentRe.getElementsByTagName("meta", Webapi.Dom.document)
  |> Webapi.Dom.HtmlCollection.toArray
  |> List.fromArray
  |> aux;
};

[@bs.get] external location : Dom.window => Dom.location = "";

[@bs.get] external pathname : Dom.location => string = "";

[@bs.get] external protocol : Dom.location => string = "";

[@bs.get] external host : Dom.location => string = "";

let path_parts = () =>
  switch ([%external window]) {
  | None => Array.make(0, "")
  | Some((window: Dom.window)) =>
    switch (window |> location |> pathname) {
    | ""
    | "/" => Array.make(0, "")
    | raw =>
      /* remove the preceeding /, which every pathname seems to have */
      let raw = Js.String.sliceToEnd(~from=1, raw);
      /* remove the trailing /, which some pathnames might have. Ugh */
      let raw =
        switch (Js.String.get(raw, Js.String.length(raw) - 1)) {
        | "/" => Js.String.slice(~from=0, ~to_=-1, raw)
        | _ => raw
        };
      raw |> Js.String.split("/");
    }
  };

let game_id = () => {
  let parts = path_parts();
  if (Array.length(parts) == 2 && parts[0] == Some("games")) {
    parts[1];
  } else {
    None;
  };
};

let hostname = () =>
  switch ([%external window]) {
  | None => None
  | Some((window: Dom.window)) =>
    switch (window |> location |> host) {
    | "" => None
    | host => Some(Js.String.make(host))
    }
  };

let my_protocol = () =>
  switch ([%external window]) {
  | None => None
  | Some((window: Dom.window)) =>
    switch (window |> location |> protocol) {
    | "" => None
    | protocol => Some(Js.String.make(protocol))
    }
  };

let ws_url = () =>
  switch (my_protocol(), hostname(), game_id()) {
  | (Some(p), Some(h), Some(gid)) =>
    let ws_protocol =
      if (p == "https:") {
        "wss:";
      } else {
        "ws:";
      };
    ws_protocol ++ "//" ++ h ++ "/games/" ++ gid ++ "/ws";
  | _ => "";
  };
