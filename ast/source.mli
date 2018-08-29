(** Copyright (c) 2016-present, Facebook, Inc.

    This source code is licensed under the MIT license found in the
    LICENSE file in the root directory of this source tree. *)

open Expression


type mode =
  | Default
  | DefaultButDontCheck of int list
  | Declare
  | Strict
  | Infer
  | PlaceholderStub
[@@deriving compare, eq, show, sexp, hash]


module Metadata : sig
  type t = {
    autogenerated: bool;
    debug: bool;
    local_mode: mode;
    ignore_lines: Ignore.t list;
    number_of_lines: int;
    version: int;
  }
  [@@deriving compare, eq, show, hash]

  val create
    :  ?autogenerated: bool
    -> ?debug: bool
    -> ?declare: bool
    -> ?ignore_lines: Ignore.t list
    -> ?strict: bool
    -> ?version: int
    -> number_of_lines: int
    -> unit
    -> t

  val parse: string -> string list -> t
end

type t = {
  docstring: string option;
  metadata: Metadata.t;
  path: string;
  qualifier: Access.t;
  statements: Statement.t list;
}
[@@deriving compare, eq, show]


val mode: t -> configuration:Configuration.t -> mode

val create
  :  ?docstring: string option
  -> ?metadata: Metadata.t
  -> ?path: string
  -> ?qualifier: Access.t
  -> Statement.t list
  -> t

val signature_hash: t -> int

val ignore_lines: t -> Ignore.t list

val statements: t -> Statement.t list

val qualifier: path:string -> Access.t
val expand_relative_import: ?path: string -> qualifier: Access.t -> from: Access.t -> Access.t
