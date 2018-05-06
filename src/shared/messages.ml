open Shared_util


let type_key = "type"
let game_id_key = "game_id"
let player_id_key = "player_id"
let player_name_key = "name"
let value_key = "value"

type message_type =
    | Presence_type
    | Player_name_type

let message_type_to_string = function
    | Presence_type -> "presence"
    | Player_name_type -> "player_name"

let message_type_of_string = function
    | "presence" -> Presence_type
    | "player_name" -> Player_name_type
    | ts -> raise (Invalid_argument ("Unknown message type string: " ^ ts))

type presence_data = {
    player_id: int;
    value: bool;
}

type player_name_data = {
    player_id: int;
    name: string;
}

type t =
    | Presence of presence_data
    | Player_name of player_name_data

let make_presence player_id value =
    Presence {
        player_id;
        value;
    }

let make_player_name player_id name =
    Player_name {
        player_id;
        name;
    }

let to_string = function
    | Presence d ->
        Printf.sprintf "<message (%s) player_id=%d value=%b>"
            (message_type_to_string Presence_type) d.player_id d.value
    | Player_name d ->
        Printf.sprintf "<message (%s) player_id=%d name='%s'>"
            (message_type_to_string Player_name_type) d.player_id d.name


module type CONVERT = sig
    val to_json : t -> string
    val of_json : string -> t
end
