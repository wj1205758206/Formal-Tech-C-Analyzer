(*****************************************************************************)
(*                                                                           *)
(*  This file was originally part of Objective Caml                          *)
(*                                                                           *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt               *)
(*                                                                           *)
(*  Copyright (C) 1996 INRIA                                                 *)
(*    INRIA (Institut National de Recherche en Informatique et en            *)
(*           Automatique)                                                    *)
(*                                                                           *)
(*  All rights reserved.                                                     *)
(*                                                                           *)
(*  This file is distributed under the terms of the GNU Library General      *)
(*  Public License version 2, with the special exception on linking          *)
(*  described below. See the GNU Library General Public License version      *)
(*  2 for more details (enclosed in the file licenses/LGPLv2).               *)
(*                                                                           *)
(*  As a special exception to the GNU Library General Public License,        *)
(*  you may link, statically or dynamically, a "work that uses the Library"  *)
(*  with a publicly distributed version of the Library to                    *)
(*  produce an executable file containing portions of the Library, and       *)
(*  distribute that executable file under terms of your choice, without      *)
(*  any of the additional requirements listed in clause 6 of the GNU         *)
(*  Library General Public License.                                          *)
(*  By "a publicly distributed version of the Library",                      *)
(*  we mean either the unmodified Library as                                 *)
(*  distributed by INRIA, or a modified version of the Library that is       *)
(*  distributed under the conditions defined in clause 2 of the GNU          *)
(*  Library General Public License.  This exception does not however         *)
(*  invalidate any other reasons why the executable file might be            *)
(*  covered by the GNU Library General Public License.                       *)
(*                                                                           *)
(*  File modified by CEA (Commissariat ?? l'??nergie atomique et aux           *)
(*                        ??nergies alternatives).                            *)
(*                                                                           *)
(*****************************************************************************)

(** Extensible buffers.

   This module implements buffers that automatically expand
   as necessary.  It provides accumulative concatenation of strings
   in quasi-linear time (instead of quadratic time when strings are
   concatenated pairwise).
*)

type t
(** The abstract type of buffers. *)

val create : int -> t
(** [create n] returns a fresh buffer, initially empty.
   The [n] parameter is the initial size of the internal byte sequence
   that holds the buffer contents. That byte sequence is automatically
   reallocated when more than [n] characters are stored in the buffer,
   but shrinks back to [n] characters when [reset] is called.
   For best performance, [n] should be of the same order of magnitude
   as the number of characters that are expected to be stored in
   the buffer (for instance, 80 for a buffer that holds one output
   line).  Nothing bad will happen if the buffer grows beyond that
   limit, however. In doubt, take [n = 16] for instance.
   If [n] is not between 1 and {!Sys.max_string_length}, it will
   be clipped to that interval. *)

val contents : t -> string
(** Return a copy of the current contents of the buffer.
    The buffer itself is unchanged. *)

val to_bytes : t -> bytes
(** Return a copy of the current contents of the buffer.
    The buffer itself is unchanged.
    @since 4.02 *)

val sub : t -> int -> int -> string
(** [Buffer.sub b off len] returns (a copy of) the bytes from the
    current contents of the buffer [b] starting at offset [off] of
    length [len] bytes. May raise [Invalid_argument] if out of bounds
    request. The buffer itself is unaffected. *)

val sub_bytes : t -> int -> int -> bytes
(** Same as [sub] but return a byte sequence instead of a string.
    @since 4.05 *)

val blit : t -> int -> bytes -> int -> int -> unit
(** [Buffer.blit src srcoff dst dstoff len] copies [len] characters from
   the current contents of the buffer [src], starting at offset [srcoff]
   to [dst], starting at character [dstoff].

   Raise [Invalid_argument] if [srcoff] and [len] do not designate a valid
   range of [src], or if [dstoff] and [len] do not designate a valid
   range of [dst].
   @since 3.11.2
*)

val blit_buffer : t -> int -> t -> int -> int -> unit
(** Similar to [blit], but copies to a buffer, and allows the destination
    buffer to grow, that is, [dstoff + len] can be larger than the length of
    [dst]. However, there cannot be any holes, i.e. [dstoff] must be smaller
    than the original length of [dst].
    @since 4.05 *)

val blit_substring : string -> int -> t -> int -> int -> unit
(** Same as [blit_buffer], but copies from a string to a buffer.
    @since 4.05 *)

val blit_subbytes : bytes -> int -> t -> int -> int -> unit
(** Same as [blit_buffer], but copies from bytes to a buffer.
    @since 4.05 *)

val nth : t -> int -> char
(** get the n-th character of the buffer. Raise [Invalid_argument] if
    index out of bounds *)

val length : t -> int
(** Return the number of characters currently contained in the buffer. *)

val clear : t -> unit
(** Empty the buffer. *)

val reset : t -> unit
(** Empty the buffer and deallocate the internal byte sequence holding the
   buffer contents, replacing it with the initial internal byte sequence
   of length [n] that was allocated by {!Buffer.create} [n].
   For long-lived buffers that may have grown a lot, [reset] allows
   faster reclamation of the space used by the buffer. *)

val truncate : t -> int -> unit
(** [truncate b c] truncates the length of [b] to be no larger than [c].
    Does nothing if the length of [b] is already smaller than or equal [c].
    In particular, it does not change the size of the underlying buffer.
    Raise [Invalid_argument] if [c < 0].
    @since 4.05 *)

val add_char : t -> char -> unit
(** [add_char b c] appends the character [c] at the end of the buffer [b]. *)

val add_string : t -> string -> unit
(** [add_string b s] appends the string [s] at the end of the buffer [b]. *)

val add_bytes : t -> bytes -> unit
(** [add_string b s] appends the string [s] at the end of the buffer [b].
    @since 4.02 *)

val add_substring : t -> string -> int -> int -> unit
(** [add_substring b s ofs len] takes [len] characters from offset
   [ofs] in string [s] and appends them at the end of the buffer [b]. *)

val add_subbytes : t -> bytes -> int -> int -> unit
(** [add_substring b s ofs len] takes [len] characters from offset
    [ofs] in byte sequence [s] and appends them at the end of the buffer [b].
    @since 4.02 *)

val add_substitute : t -> (string -> string) -> string -> unit
(** [add_substitute b f s] appends the string pattern [s] at the end
   of the buffer [b] with substitution.
   The substitution process looks for variables into
   the pattern and substitutes each variable name by its value, as
   obtained by applying the mapping [f] to the variable name. Inside the
   string pattern, a variable name immediately follows a non-escaped
   [$] character and is one of the following:
   - a non empty sequence of alphanumeric or [_] characters,
   - an arbitrary sequence of characters enclosed by a pair of
   matching parentheses or curly brackets.
   An escaped [$] character is a [$] that immediately follows a backslash
   character; it then stands for a plain [$].
   Raise [Not_found] if the closing character of a parenthesized variable
   cannot be found. *)

val add_buffer : t -> t -> unit
(** [add_buffer b1 b2] appends the current contents of buffer [b2]
   at the end of buffer [b1].  [b2] is not modified. *)

val add_channel : t -> in_channel -> int -> unit
(** [add_channel b ic n] reads at most [n] characters from the
   input channel [ic] and stores them at the end of buffer [b].
   Raise [End_of_file] if the channel contains fewer than [n]
   characters. In this case the characters are still added to
   the buffer, so as to avoid loss of data. *)

val output_buffer : out_channel -> t -> unit
(** [output_buffer oc b] writes the current contents of buffer [b]
   on the output channel [oc]. *)
