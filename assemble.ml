open Assemblage

(* OCamlfind packages *)

let cmdliner = pkg    "cmdliner"
let graph    = pkg    "ocamlgraph"
let bytecomp = pkg    "compiler-libs.bytecomp"
let toplevel = pkg    "compiler-libs.toplevel"
let optionalcomp = pkg_pp "optcomp"

(* Library *)

let lib =
  let unit ?deps name = unit ?deps name (`Dir "lib") in
  lib "assemblage"
    ~deps:[cmdliner; graph; bytecomp]
    (`Units [
        unit "as_features";
        unit "as_flags";
        unit "as_resolver";
        unit "as_shell";
        unit "as_git";
        unit "as_build_env";
        unit "as_action";
        unit "as_project";
        unit "as_opam";
        unit "as_ocamlfind";
        unit "as_makefile";
        unit "as_OCaml" ~deps:[optionalcomp; bytecomp];
        unit "as_cmd";
        unit "assemblage";
      ])

let ctypes_gen =
  bin "ctypes-gen" ~deps:[lib] ~native:false (`Units [
      unit "ctypes_gen" (`Dir "bin")
    ])

let assemblage_tool =
  let us = `Units [ unit "tool" (`Dir "bin") ~deps:[toplevel] ] in
  bin "assemblage" ~deps:[lib] ~link_all:true ~native:false us

(* Tests *)

let mk_test name =
  let dir = "examples/" ^ name in
  let args cmd r =
    [ cmd; "--disable-auto-load"; "-I"; root_dir r / build_dir lib r; ]
  in
  test name ~dir [
    test_bin assemblage_tool ~args:(args "describe") ();
    test_bin assemblage_tool ~args:(args "configure") ();
    test_shell "make";
    test_shell "make distclean";
  ]

let tests = [
  mk_test "camlp4";
  mk_test "multi-libs";
  mk_test "containers";
  mk_test "pack";
]

(* Docs *)

let dev_doc = doc ~install:false "dev" [lib]
let doc = doc "public" [pick "assemblage" lib]

(* The project *)

let p =
  let cs = [lib; ctypes_gen; assemblage_tool; dev_doc; doc ] @ tests in
  project "assemblage" cs

let () = assemble p
