type t

val make : ?n:int -> string -> Clients.t -> t
val subscribe : t -> int -> unit
val unsubscribe : t -> int -> unit
val start : t -> unit