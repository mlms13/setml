open OUnit2
open Shared
open Shared.Messages

open Lib
open Lib.Server_messages

open Test_lib.Test_util

let convert_tests =
  let check v =
    let open Server_message_converter in
    let d = v |> to_json |> of_json in
    ae v d ~printer:Messages.to_string
  in
  let messages = [
    make_game_data [
        make_player_data 1 "john" true 5;
        make_player_data 2 "rich" true 4;
        make_player_data 3 "bill" false 6;
        make_player_data 4 "cindy" true 9;
        make_player_data 5 "carol" true 3;
    ] (make_board_cards_of_id_list [
         0;  2;  4;  6;
         8; 10; 33; 52;
        78; 79; 80; 81;
    ]) (make_game_update_data "pending" 15);
    make_player_name 2 "andrew2";
    make_board_card 5 7;
    make_game_update "new" 13;
    make_game_update "pending" 15;
    make_game_update "started" 17;
    make_game_update "complete" 19;
    make_score 6 4;
    make_previous_move 10 20 30;
    make_previous_move 11 21 31;
    make_previous_move 64 77 80;
    make_player_presence 1 true;
    make_player_presence 1 false;
    make_move_data (make_score_data 5 15) (make_previous_move_data 1 2 3)
  ]
  in
  cases_of check messages

let suite = [
  "convert_tests" >::: convert_tests;
]
