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

(** The module stores the current file,line, and working directory in a
    hidden internal state, modified by the three following
    functions.  *)

val newline: unit -> unit  (** Call this function to announce a new line *)

val currentLoc: unit -> Lexing.position * Lexing.position

(** This function is used especially when the preprocessor has
    generated linemarkers in the output that let us know the current
    working directory at the time of preprocessing (option
    -fworking-directory for GNU CPP). *)
val setCurrentWorkingDirectory: string -> unit

(** If normalize is false, [setCurrentFile ~normalize:false path]
    accepts [path] as the current file "as is". Else (the default), if
    [path] is relative, make it relative to the current working
    directory if it has been set; then in any case attempts to shorten
    the path to the current file using [Filepath.normalize]. 

    This function should not be called with a string argument which
    has been already normalized (because normalization can make [path]
    relative to a different path). *)
val setCurrentFile: ?normalize:bool -> string -> unit
val setCurrentLine: int -> unit

(** Call this function to start parsing. *)
val startParsing: string -> Lexing.lexbuf

val finishParsing: unit -> unit (** Call this function to finish parsing and
                                    close the input channel *)


(** prints the line identified by the position, together with [ctx] lines
    of context before and after. [ctx] defaults to 2.
    If [start_line] is specified, then all lines between [start_line] and
    [pos.pos_lnum] are considered part of the error.
 *)
val pp_context_from_file:
  ?ctx:int -> ?start_line:int -> Format.formatter -> Lexing.position -> unit

(** Parse errors are usually fatal, but their reporting is sometimes
    delayed until the end of the current parsing phase. Functions that
    intend to ultimately fail should call {!clear_errors} when they
    start, and check {!had_errors} when they end. *)
val parse_error:
  ?source:Lexing.position -> ('a, Format.formatter, unit, 'b) format4 -> 'a

val had_errors : unit -> bool
(** Has an error been raised since the last call to {!clear_errors}? *)

val clear_errors : unit -> unit
