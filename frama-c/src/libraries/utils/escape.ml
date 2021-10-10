(****************************************************************************)
(*                                                                          *)
(*  Copyright (C) 2001-2003                                                 *)
(*   George C. Necula    <necula@cs.berkeley.edu>                           *)
(*   Scott McPeak        <smcpeak@cs.berkeley.edu>                          *)
(*   Wes Weimer          <weimer@cs.berkeley.edu>                           *)
(*   Ben Liblit          <liblit@cs.berkeley.edu>                           *)
(*  All rights reserved.                                                    *)
(*                                                                          *)
(*  Redistribution and use in source and binary forms, with or without      *)
(*  modification, are permitted provided that the following conditions      *)
(*  are met:                                                                *)
(*                                                                          *)
(*  1. Redistributions of source code must retain the above copyright       *)
(*  notice, this list of conditions and the following disclaimer.           *)
(*                                                                          *)
(*  2. Redistributions in binary form must reproduce the above copyright    *)
(*  notice, this list of conditions and the following disclaimer in the     *)
(*  documentation and/or other materials provided with the distribution.    *)
(*                                                                          *)
(*  3. The names of the contributors may not be used to endorse or          *)
(*  promote products derived from this software without specific prior      *)
(*  written permission.                                                     *)
(*                                                                          *)
(*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     *)
(*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       *)
(*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       *)
(*  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE          *)
(*  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,     *)
(*  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,    *)
(*  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;        *)
(*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER        *)
(*  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT      *)
(*  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN       *)
(*  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         *)
(*  POSSIBILITY OF SUCH DAMAGE.                                             *)
(*                                                                          *)
(*  File modified by CEA (Commissariat à l'énergie atomique et aux          *)
(*                        énergies alternatives)                            *)
(*               and INRIA (Institut National de Recherche en Informatique  *)
(*                          et Automatique).                                *)
(****************************************************************************)


(** OCaml types used to represent wide characters and strings *)
type wchar = int64
type wstring = wchar list

let escape_char_internal maybe_trigraph =
  function
  | '\007' -> maybe_trigraph := false; "\\a"
  | '\b' -> maybe_trigraph := false; "\\b"
  | '\t' -> maybe_trigraph := false; "\\t"
  | '\n' -> maybe_trigraph := false; "\\n"
  | '\011' -> maybe_trigraph := false; "\\v"
  | '\012' -> maybe_trigraph := false; "\\f"
  | '\r' -> maybe_trigraph := false; "\\r"
  | '"' -> maybe_trigraph := false; "\\\""
  | '\'' -> maybe_trigraph := false; "\\'"
  | '\\' -> maybe_trigraph := false; "\\\\"
  | '?' ->
    let s = if !maybe_trigraph then "\\?" else "?" in
    maybe_trigraph := true;
    s
  | ' ' .. '~' as printable -> maybe_trigraph := false; String.make 1 printable
  | unprintable -> maybe_trigraph := false; Printf.sprintf "\\%03o" (Char.code unprintable)

let escape_char c =
  let r = ref false in
  escape_char_internal r c

let escape_string str =
  let length = String.length str in
  let buffer = Buffer.create length in
  let maybe_trigraph = ref false in
  for index = 0 to length - 1 do
    Buffer.add_string buffer (escape_char_internal maybe_trigraph (String.get str index))
  done;
  Buffer.contents buffer

(* a wide char represented as an int64 *)
let escape_wchar =
  (* limit checks whether upper > probe *)
  let limit upper probe = (Int64.to_float (Int64.sub upper probe)) > 0.5 in
  let fits_byte = limit (Int64.of_int 0x100) in
  let fits_octal_escape = limit (Int64.of_int 0o1000) in
  let fits_universal_4 = limit (Int64.of_int 0x10000) in
  let fits_universal_8 = limit (Int64.of_string "0x100000000") in
  fun charcode ->
    if fits_byte charcode then
      escape_char (Char.chr (Int64.to_int charcode))
    else if fits_octal_escape charcode then
      Printf.sprintf "\\%03Lo" charcode
    else if fits_universal_4 charcode then
      Printf.sprintf "\\u%04Lx" charcode
    else if fits_universal_8 charcode then
      Printf.sprintf "\\u%04Lx" charcode
    else
      invalid_arg "Cprint.escape_string_intlist"

(* a wide string represented as a list of int64s *)
let escape_wstring (str : int64 list) =
  let length = List.length str in
  let buffer = Buffer.create length in
  let append charcode =
    let addition = escape_wchar charcode in
    Buffer.add_string buffer addition
  in
  List.iter append str;
  Buffer.contents buffer
