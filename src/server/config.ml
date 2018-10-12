open Cmdliner

let default_db_pass = "abcd1234"
let default_crypto_secret = "t8sK8LqFLn6Ixt9H6TMiS9HRs6BfcLyw6aXHi02omeOIp7mLYqSIlxtPgxXiETvpentbHMPkGYpiqW8nR9rJmeVU4aEEyzMbzDqIRznNSiqPnDb0Dp9PNerGuODpaeza"

type t = {
    setml_env: string;
    listen_address: string;
    listen_port: int;
    db_name: string;
    db_host: string;
    db_port: int;
    db_user: string;
    db_pass: string;
    db_pool: int;
    crypto_secret: string;
}

let setml_env () =
    match Sys.getenv_opt "SETML_ENV" with
    | Some e -> e
    | None -> "development"

let listen_address =
    let doc = "Listen address" in
    let n = "LISTEN_ADDRESS" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt string "0.0.0.0" & info ["a"; "listen-address"] ~env ~docv:n ~doc)

let listen_port =
    let doc = "Listen port" in
    let n = "LISTEN_PORT" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt int 7777 & info ["p"; "listen-port"] ~env ~docv:n ~doc)

let db_name =
    let doc = "Database name" in
    let n = "DB_NAME" in
    let env = Arg.env_var n ~doc in
    let default = "setml_" ^ (setml_env ()) in
    Arg.(value & opt string default & info ["n"; "db-name"] ~env ~docv:n ~doc)

let db_host =
    let doc = "Database host" in
    let n = "DB_HOST" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt string "localhost" & info ["h"; "db-host"] ~env ~docv:n ~doc)

let db_port =
    let doc = "Database port" in
    let n = "DB_PORT" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt int 5432 & info ["db-port"] ~env ~docv:n ~doc)

let whoami () =
    let whoami = CCUnix.with_process_in "whoami" ~f:CCIO.read_line in
    match whoami with
    | Some u -> u
    | None -> "setml"

let db_user =
    let doc = "Database user name" in
    let n = "DB_USER" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt string (whoami ()) & info ["u"; "db-user"] ~env ~docv:n ~doc)

let db_pass =
    let doc = "Database password" in
    let n = "DB_PASS" in
    let env = Arg.env_var n ~doc in
    let open Arg in
    let i = info ["db-pass"] ~env ~docv:n ~doc in
    match setml_env () with
    | "production" -> required & opt (some string) None & i
    | _ -> value & opt string default_db_pass & i

let db_pool =
    let doc = "Database connection pool size" in
    let n = "DB_POOL" in
    let env = Arg.env_var n ~doc in
    Arg.(value & opt int 8 & info ["db-pool"] ~env ~docv:n ~doc)

let crypto_secret =
    let doc = "Crypto secret key" in
    let n = "CRYTPO_SECRET" in
    let env = Arg.env_var n ~doc in
    let open Arg in
    let i = info ["crypto-secret"] ~env ~docv:n ~doc in
    match setml_env () with
    | "production" -> required & opt (some string) None & i
    | _ -> value & opt string default_crypto_secret & i

let info =
    let doc = "setml" in
    let man = [
        `S Manpage.s_bugs;
        `P "Email bug reports to <hehey at example.org>." ]
    in
    Term.info "setml" ~version:"%%VERSION%%" ~doc ~exits:Term.default_exits ~man

let make listen_address listen_port db_name db_host db_port db_user db_pass db_pool crypto_secret =
    {
        setml_env = setml_env ();
        listen_address;
        listen_port;
        db_name;
        db_host;
        db_port;
        db_user;
        db_pass;
        db_pool;
        crypto_secret;
    }

let config_t =
    let open Term in
    const make $
    listen_address $ listen_port $
    db_name $ db_host $ db_port $ db_user $ db_pass $ db_pool $
    crypto_secret

let parse () = Term.eval (config_t, info)
