open Lwt.Infix

let (>>=?) m f =
  m >>= (function | Ok x -> f x | Error err -> Lwt.return (Error err))

let create_game_query =
    Caqti_request.find Caqti_type.unit Caqti_type.int
    "insert into games default values returning id"

let create_game (module Db : Caqti_lwt.CONNECTION) =
    Db.find create_game_query () >>=? fun game_id ->
    Lwt.return_ok game_id

let game_exists_query =
    Caqti_request.find Caqti_type.int Caqti_type.bool
    "select exists (select 1 from games where id = ?)"

let game_exists (module Db : Caqti_lwt.CONNECTION) game_id =
    Db.find game_exists_query game_id

let create_player_query =
    Caqti_request.find Caqti_type.unit Caqti_type.int
    "insert into players default values returning id"

let create_player (module Db : Caqti_lwt.CONNECTION) =
    Db.find create_player_query ()

let player_exists_query =
    Caqti_request.find Caqti_type.int Caqti_type.bool
    "select exists (select 1 from players where id = ?)"

let player_exists (module Db : Caqti_lwt.CONNECTION) player_id =
    Db.find player_exists_query player_id

let game_player_present_query =
    Caqti_request.exec Caqti_type.(tup3 int int bool)
    {eos|
    insert into games_players (game_id, player_id, present, updated_at)
    values (?, ?, ?, now())
    on conflict (game_id, player_id)
    do update set present = excluded.present,
    updated_at = excluded.updated_at;
    |eos}

let game_player_presence (module Db : Caqti_lwt.CONNECTION) game_id player_id present =
    Db.exec game_player_present_query (game_id, player_id, present)