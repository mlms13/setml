open Jest;

open Expect;

open Messages;

open ClientMessages;

{
  let test_convert = a => {
    open ClientMessageConverter;
    let b = a |> to_json |> of_json;
    expect(a) |> toEqual(b);
  };
  describe("ClientMessages", () => {
    test("Server_game", () =>
      test_convert(
        make_server_game(
          [
            make_player_data(1, "john", true, 5, 1),
            make_player_data(2, "rich", true, 4, 2),
            make_player_data(3, "bill", false, 6, 3),
            make_player_data(4, "cindy", true, 9, 4),
            make_player_data(5, "carol", true, 3, 5),
          ],
          make_board_cards_data([0, 2, 4, 6, 8, 10, 33, 52, 78, 79, 80, 81]),
          make_game_update_data(15, "started", "classic", 3, 4, None),
        ),
      )
    );
    test("Server_name", () =>
      test_convert(make_server_name(6, "Billiam"))
    );
    test("Server_card", () =>
      test_convert(make_server_card(5, 7))
    );
    test("Server_board_card", () =>
      test_convert(make_server_board_card(5, 7))
    );
    test("Server_game_update new", () =>
      test_convert(make_server_game_update(5, "new", "classic", 4, 3, None))
    );
    test("Server_game_update started", () =>
      test_convert(make_server_game_update(6, "started", "classic", 3, 4, None))
    );
    test("Server_game_update complete", () =>
      test_convert(make_server_game_update(7, "complete", "classic", 3, 4, None))
    );
    test("Server_game_update new next", () =>
      test_convert(make_server_game_update(5, "new", "classic", 4, 3, Some(49)))
    );
    test("Server_game_update started next", () =>
      test_convert(make_server_game_update(6, "started", "classic", 3, 4, Some(13)))
    );
    test("Server_game_update complete next", () =>
      test_convert(make_server_game_update(7, "complete", "classic", 3, 4, Some(1)))
    );
    test("Server_game_update new", () =>
      test_convert(make_server_game_update(5, "new", "open_source", 4, 3, None))
    );
    test("Server_game_update started", () =>
      test_convert(make_server_game_update(6, "started", "open_source", 3, 4, None))
    );
    test("Server_game_update complete", () =>
      test_convert(make_server_game_update(7, "complete", "open_source", 3, 4, None))
    );
    test("Server_game_update new next", () =>
      test_convert(make_server_game_update(5, "new", "open_source", 4, 3, Some(49)))
    );
    test("Server_game_update started next", () =>
      test_convert(make_server_game_update(6, "started", "open_source", 3, 4, Some(13)))
    );
    test("Server_game_update complete next", () =>
      test_convert(make_server_game_update(7, "complete", "open_source", 3, 4, Some(1)))
    );
    test("Server_game_update new", () =>
      test_convert(make_server_game_update(5, "new", "hero", 4, 3, None))
    );
    test("Server_game_update started", () =>
      test_convert(make_server_game_update(6, "started", "hero", 3, 4, None))
    );
    test("Server_game_update complete", () =>
      test_convert(make_server_game_update(7, "complete", "hero", 3, 4, None))
    );
    test("Server_game_update new next", () =>
      test_convert(make_server_game_update(5, "new", "hero", 4, 3, Some(49)))
    );
    test("Server_game_update started next", () =>
      test_convert(make_server_game_update(6, "started", "hero", 3, 4, Some(13)))
    );
    test("Server_game_update complete next", () =>
      test_convert(make_server_game_update(7, "complete", "hero", 3, 4, Some(1)))
    );
    test("Server_score", () =>
      test_convert(make_server_score(5, 6))
    );
    test("Server_move 1", () =>
      test_convert(make_server_move((1, 10), (2, 20), (3, 30)))
    );
    test("Server_move 2", () =>
      test_convert(make_server_move((4, 11), (5, 21), (6, 31)))
    );
    test("Server_move 3", () =>
      test_convert(make_server_move((7, 64), (8, 77), (9, 80)))
    );
    test("Server_presence true", () =>
      test_convert(make_server_presence(99, true))
    );
    test("Server_presence false", () =>
      test_convert(make_server_presence(101, false))
    );
    test("Server_move_info", () =>
      test_convert(make_server_move_info(make_score_data(23, 25), make_move_data((1, 56), (2, 57), (3, 58))))
    );
    test("Server_shuffles", () =>
      test_convert(make_server_shuffles(18, 19))
    );
    test("Server_player", () =>
      test_convert(make_server_player(6, "willie", true, 9, 11))
    );
    test("Client_move", () =>
      test_convert(make_client_move("token1", make_move_data((1, 11), (2, 22), (3, 33))))
    );
    test("Client_shuffle", () =>
      test_convert(make_client_shuffle("token2"))
    );
    test("Client_start_game", () =>
      test_convert(make_client_start_game("other-token"))
    );
    test("Client_name", () =>
      test_convert(make_client_name("a weird token", "a weird name"))
    );
    test("Client_theme_classic", () =>
      test_convert(make_client_theme("some other token xxx777", Theme.Classic))
    );
    test("Client_theme_open_source", () =>
      test_convert(make_client_theme("some other token yyy888", Theme.Open_source))
    );
    test("Client_theme_hero", () =>
      test_convert(make_client_theme("some other hero token y8", Theme.Hero))
    );
    test("Client_ping", () =>
      test_convert(make_client_ping("fw7tyfwho8wyt478fywth"))
    );
  });
};
