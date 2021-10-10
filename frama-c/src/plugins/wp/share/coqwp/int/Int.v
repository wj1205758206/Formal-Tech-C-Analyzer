(**************************************************************************)
(*                                                                        *)
(*  The Why3 Verification Platform   /   The Why3 Development Team        *)
(*  Copyright 2010-2013   --   INRIA - CNRS - Paris-Sud University        *)
(*                                                                        *)
(*  This software is distributed under the terms of the GNU Lesser        *)
(*  General Public License version 2.1, with the special exception        *)
(*  on linking described in file LICENSE.                                 *)
(**************************************************************************)

(* This file is generated by Why3's Coq-realize driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.

(* Why3 comment *)
(* infix_ls is replaced with (x < x1)%Z by the coq driver *)

(* Why3 goal *)
Lemma infix_lseq_def : forall (x:Z) (y:Z), (x <= y)%Z <-> ((x < y)%Z \/
  (x = y)).
exact Zle_lt_or_eq_iff.
Qed.

(* Why3 comment *)
(* infix_pl is replaced with (x + x1)%Z by the coq driver *)

(* Why3 comment *)
(* prefix_mn is replaced with (-x)%Z by the coq driver *)

(* Why3 comment *)
(* infix_as is replaced with (x * x1)%Z by the coq driver *)

(* Why3 goal *)
Lemma Assoc : forall (x:Z) (y:Z) (z:Z),
  (((x + y)%Z + z)%Z = (x + (y + z)%Z)%Z).
Proof.
intros x y z.
apply sym_eq.
apply Zplus_assoc.
Qed.

(* Why3 goal *)
Lemma Unit_def_l : forall (x:Z), ((0%Z + x)%Z = x).
Proof.
exact Zplus_0_l.
Qed.

(* Why3 goal *)
Lemma Unit_def_r : forall (x:Z), ((x + 0%Z)%Z = x).
Proof.
exact Zplus_0_r.
Qed.

(* Why3 goal *)
Lemma Inv_def_l : forall (x:Z), (((-x)%Z + x)%Z = 0%Z).
Proof.
exact Zplus_opp_l.
Qed.

(* Why3 goal *)
Lemma Inv_def_r : forall (x:Z), ((x + (-x)%Z)%Z = 0%Z).
Proof.
exact Zplus_opp_r.
Qed.

(* Why3 goal *)
Lemma Comm : forall (x:Z) (y:Z), ((x + y)%Z = (y + x)%Z).
Proof.
exact Zplus_comm.
Qed.

(* Why3 goal *)
Lemma Assoc1 : forall (x:Z) (y:Z) (z:Z),
  (((x * y)%Z * z)%Z = (x * (y * z)%Z)%Z).
Proof.
intros x y z.
apply sym_eq.
apply Zmult_assoc.
Qed.

(* Why3 goal *)
Lemma Mul_distr_l : forall (x:Z) (y:Z) (z:Z),
  ((x * (y + z)%Z)%Z = ((x * y)%Z + (x * z)%Z)%Z).
Proof.
intros x y z.
apply Zmult_plus_distr_r.
Qed.

(* Why3 goal *)
Lemma Mul_distr_r : forall (x:Z) (y:Z) (z:Z),
  (((y + z)%Z * x)%Z = ((y * x)%Z + (z * x)%Z)%Z).
Proof.
intros x y z.
apply Zmult_plus_distr_l.
Qed.

(* Why3 goal *)
Lemma infix_mn_def : forall (x:Z) (y:Z), ((x - y)%Z = (x + (-y)%Z)%Z).
reflexivity.
Qed.

(* Why3 goal *)
Lemma Comm1 : forall (x:Z) (y:Z), ((x * y)%Z = (y * x)%Z).
Proof.
exact Zmult_comm.
Qed.

(* Why3 goal *)
Lemma Unitary : forall (x:Z), ((1%Z * x)%Z = x).
Proof.
exact Zmult_1_l.
Qed.

(* Why3 goal *)
Lemma NonTrivialRing : ~ (0%Z = 1%Z).
Proof.
discriminate.
Qed.

(* Why3 goal *)
Lemma Refl : forall (x:Z), (x <= x)%Z.
Proof.
intros x.
apply Zle_refl.
Qed.

(* Why3 goal *)
Lemma Trans : forall (x:Z) (y:Z) (z:Z), (x <= y)%Z -> ((y <= z)%Z ->
  (x <= z)%Z).
Proof.
exact Zle_trans.
Qed.

(* Why3 goal *)
Lemma Antisymm : forall (x:Z) (y:Z), (x <= y)%Z -> ((y <= x)%Z -> (x = y)).
Proof.
exact Zle_antisym.
Qed.

(* Why3 goal *)
Lemma Total : forall (x:Z) (y:Z), (x <= y)%Z \/ (y <= x)%Z.
Proof.
intros x y.
destruct (Zle_or_lt x y) as [H|H].
left.
assumption.
right.
now apply Zlt_le_weak.
Qed.

(* Why3 goal *)
Lemma ZeroLessOne : (0%Z <= 1%Z)%Z.
Proof.
apply Zle_lt_or_eq_iff.
now left.
Qed.

(* Why3 goal *)
Lemma CompatOrderAdd : forall (x:Z) (y:Z) (z:Z), (x <= y)%Z ->
  ((x + z)%Z <= (y + z)%Z)%Z.
Proof.
exact Zplus_le_compat_r.
Qed.

(* Why3 goal *)
Lemma CompatOrderMult : forall (x:Z) (y:Z) (z:Z), (x <= y)%Z ->
  ((0%Z <= z)%Z -> ((x * z)%Z <= (y * z)%Z)%Z).
Proof.
exact Zmult_le_compat_r.
Qed.

