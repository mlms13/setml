open Messages;

module ClientMessageConverter: CONVERT = {
  let to_json = x => {
    open! Json.Encode;
    switch (x) {
    | Presence(d) =>
      object_([
        (type_key, string(message_type_to_string(Presence_type))),
        (game_id_key, int(d.game_id)),
        (player_id_key, int(d.player_id)),
        (player_name_key, string(d.player_name)),
        (value_key, bool(d.value)),
      ])
      |> Json.stringify
    | Player_name(d) =>
      object_([
        (type_key, string(message_type_to_string(Player_name_type))),
        (game_id_key, int(d.game_id)),
        (player_id_key, int(d.player_id)),
        (player_name_key, string(d.player_name)),
      ])
      |> Json.stringify
    };
  };
  let of_json = str => {
    let json = Json.parseOrRaise(str);
    open! Json.Decode;
    let msgType = json |> field(type_key, Json.Decode.string) |> message_type_of_string;
    switch (msgType) {
    | Presence_type =>
      make_presence(
        json |> field(game_id_key, int),
        json |> field(player_id_key, int),
        json |> field(player_name_key, string),
        json |> field(value_key, bool),
      )
    | Player_name_type =>
      make_player_name(
        json |> field(game_id_key, int),
        json |> field(player_id_key, int),
        json |> field(player_name_key, string),
      )
    };
  };
};
