module GameKey = CCString
module PlayerKey = CCInt

module ConnKey = struct
    type t = (GameKey.t * PlayerKey.t)

    let make x y: t = (x, y)

    let hash x = 0
    let equal a b = false
end
module ConnTable = CCHashtbl.Make(ConnKey)

module GameSet = CCSet.Make(GameKey)
module GamesOfPlayerTable = CCHashtbl.Make(PlayerKey)
module PlayerSet = CCSet.Make(PlayerKey)
module PlayersOfGameTable = CCHashtbl.Make(GameKey)

type t = {
    conns: (Websocket_cohttp_lwt.Frame.t option -> unit) ConnTable.t;
    games_of_player: GameSet.t GamesOfPlayerTable.t;
    players_of_game: PlayerSet.t PlayersOfGameTable.t;
}

let make ?n:(m=32) () =
    {
        conns = ConnTable.create m;
        games_of_player = GamesOfPlayerTable.create m;
        players_of_game = PlayersOfGameTable.create m;
    }

let send conn content =
    Lwt.ignore_result (Lwt.wrap1 conn @@ Some (Websocket_cohttp_lwt.Frame.create ~content ()))

let broadcast_send clients content =
    ConnTable.values clients.conns (fun f -> send f content)

let game_send clients game_id content = ()

let player_send clients player_id content = ()

let games_of_player_send clients player_id content = ()

let games_of_player clients player_id = ()

let add clients game_id player_id send =
    let key = ConnKey.make game_id player_id in
    ConnTable.add clients.conns key send;
    PlayersOfGameTable.update clients.players_of_game ~f:(fun k v ->
        match v with
        | Some (set) -> Some(PlayerSet.add player_id set)
        | None -> Some(PlayerSet.of_list [player_id])
    ) ~k:game_id;
    GamesOfPlayerTable.update clients.games_of_player ~f:(fun k v ->
        match v with
        | Some (set) -> Some(GameSet.add game_id set)
        | None -> Some(GameSet.of_list [game_id])
    ) ~k:player_id

