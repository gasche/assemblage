(*
 * Copyright (c) 2014 Thomas Gazagnaire <thomas@gazagnaire.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

type t = {
  ocamlc: string;
  ocamlopt: string;
  ocamldep: string;
  ocamlmklib: string;
  ocamldoc: string;
  preprocessor: string option;
  js_of_ocaml: string;
  mkdir: string;
  ln: string;
  build_dir: string;
  lib_dir: string;
  root_dir: string;
  pkgs: string list -> As_flags.t;
}

type maker =
  ?ocamlc:string ->
  ?ocamlopt:string ->
  ?ocamldep:string ->
  ?ocamlmklib:string ->
  ?ocamldoc:string ->
  ?preprocessor: string option ->
  ?ln:string ->
  ?mkdir:string ->
  ?js_of_ocaml:string ->
  ?build_dir:string ->
  ?lib_dir:string ->
  ?root_dir:string ->
  ?pkgs:(string list -> As_flags.t) ->
  unit -> t

let create
    ?(ocamlc="ocamlc")
    ?(ocamlopt="ocamlopt")
    ?(ocamldep="ocamldep")
    ?(ocamlmklib="ocamlmklib")
    ?(ocamldoc="ocamldoc")
    ?(preprocessor=Some "ocaml-dumpast")
    ?(ln="ln -sf")
    ?(mkdir="mkdir -p")
    ?(js_of_ocaml="js_of_ocaml")
    ?(build_dir="_build")
    ?(lib_dir="/usr/lib/ocaml")
    ?root_dir
    ?(pkgs=fun _ -> As_flags.empty) () =
  let root_dir = match root_dir with
  | Some d -> d
  | None   -> Sys.getcwd ()
  in
  { ocamlc; ocamlopt; ocamlmklib; preprocessor;
    js_of_ocaml; ocamldoc; ocamldep;
    ln; mkdir;
    build_dir; lib_dir; root_dir; pkgs }

let ocamlc t = t.ocamlc
let ocamlopt t = t.ocamlopt
let ocamldep t = t.ocamldep
let ocamlmklib t = t.ocamlmklib
let ocamldoc t = t.ocamldoc
let preprocessor t = t.preprocessor
let js_of_ocaml t = t.js_of_ocaml

let ln t = t.ln
let mkdir t = t.mkdir

let build_dir t = t.build_dir
let lib_dir t = t.lib_dir
let root_dir t = t.root_dir
let pkgs t = t.pkgs
