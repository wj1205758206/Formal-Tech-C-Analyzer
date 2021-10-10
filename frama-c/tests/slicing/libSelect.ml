(* To use this in interactive mode :

#use "tests/slicing/select.ml";;
*)

exception Break
exception No_return
exception Unknown_data of string
exception Unknown_stmt of int

(*--------------------------*)
(* Useful functions to find and print thinks *)

let find_kf fct_name = Globals.Functions.find_by_name fct_name
(*
  let f kf res =
    match res with Some kf -> res
      | None -> if Db.get_name kf = fct_name then Some kf else None
  in
    match Db.fold_on_functions f None with
      | None -> raise Not_found
      | Some kf -> kf
      *)

let fmt =  Format.std_formatter;;

(* print instruction number (used as input by other functions) *)
let print_stmt kf =
  Slicing.PrintSlice.print_fct_stmts fmt kf

(* print PDG (for debugging purposes) *)
let print_pdg kf = !Db.Pdg.pretty fmt (!Db.Pdg.get kf) ;;

let print_ff ff = Slicing.Api.Slice.pretty fmt ff

(* print the project (functions with their marks + pending actions) *)
let print_project () = Slicing.Api.Project.pretty fmt ;;

(* print pending actions *)
let print_requests () = Slicing.Api.Request.pretty fmt ;;

(* build the application and print the result *)
let extract_and_print () =
  let prj = Slicing.Api.Project.extract "Sliced code" in
  File.pretty_ast ~prj ()

(*--------------------------*)

let apply () = Slicing.Api.Request.apply_next_internal (); print_project ()

(*--------------------------*)

(** clear a previously computed project and load a new source file,
* starting at [entry_point] to be specified iif it is different from [main].
* DOESN'T WORK at the moment because CIL datas are not cleared...*)
(* [Julien 25/06/2007:] Should be possible to do now (?) *)
                                                              (*
let load_source_file ?entry_point filename  =
  Db.Files.clear ();
  Db.Files.add [ Cil_types.NeedCPP (filename, Db.get_preprocessor_command()) ];
  let entry_point, library = match entry_point with
    | None | Some "main" -> "main", false
    | Some f -> f, true
  in
  ignore (Db.get_cil_file ());
  let kf = Db.find_function_def_by_name entry_point in
    ignore (!Db.Value.compute_entry_point kf ~library);
  Db.iter_on_functions
    (fun kf -> if Db.is_definition kf && Db.Value.is_called kf
     then !Db.From.compute kf)
  *)

let get_stmt sid = fst (Kernel_function.find_from_sid sid)

(** build the [zone] which represents [data] before [kinst] *)
let get_zones str_data (kinst, kf) =
  let lval_term = !Db.Properties.Interp.term_lval kf str_data in
  let lval = !Db.Properties.Interp.term_lval_to_lval ~result:None lval_term in
  let loc = !Db.Value.lval_to_loc (Cil_types.Kstmt kinst) lval in
  Locations.enumerate_valid_bits ~for_writing:false loc
;;

let select_data_before_stmt str_data kinst kf =
  let mark = Slicing.Api.Mark.make ~data:true ~addr:false ~ctrl:false in
  let zone = get_zones str_data (kinst, kf) in
    Slicing.Api.Select.select_stmt_zone_internal kf kinst true zone mark


(** build the selection for returned value of the function *)
let select_retres kf =
  let ki = Kernel_function.find_return kf in
    try
      let loc = Db.Value.find_return_loc kf in
      let zone =
	Locations.enumerate_valid_bits
	  ~for_writing:false
	  loc
      in
      let mark = Slicing.Api.Mark.make ~data:true ~addr:false ~ctrl:false in
      let before = false in
        Slicing.Api.Select.select_stmt_zone_internal kf ki before zone mark
    with Db.Value.Void_Function -> raise No_return
;;

(** build the selection for the [data] at the end of the function *)
let select_data data kf =
  try
    let ki = Kernel_function.find_return kf in
    let mark = Slicing.Api.Mark.make ~data:true ~addr:false ~ctrl:false in
    let zone = get_zones data (ki, kf) in
      Slicing.Api.Select.select_stmt_zone_internal kf ki true zone mark
  (* with Logic_interp.Error (_, str) -> raise (Unknown_data data) *)
  with _ -> raise (Unknown_data data)
;;

(** build the selection ONLY for the control dependencies of the statement
* [numstmt]*)
let select_ctrl numstmt kf =
  try
    let s = get_stmt numstmt in
    (*
    let mark = Slicing.Api.Mark.make ~data:false ~addr:false ~ctrl:true in
    Slicing.Api.Select.select_stmt_internal kf ki mark
    *)
    Slicing.Api.Select.select_stmt_ctrl_internal kf s
  with _ -> raise (Unknown_stmt numstmt)
;;


(** build recursively all the change_call for all the callers to kf in
 * order to call ff instead. *)
let prop_to_callers (kf, ff) =
  let rec prop kf ff =
    let callers = !Db.Value.callers kf in
    let process_caller (kf_caller,_) =
      let ff_caller = Slicing.Api.Slice.create kf_caller in
        Slicing.Api.Request.add_call_slice ~caller:ff_caller ~to_call:ff;
        prop kf_caller ff_caller
    in
      List.iter process_caller callers
  in prop kf ff


(** compute and print a slice of [fname] where the selection is given by
* [select_fct] (which could be [select_retres] or [(select_data str_data)].
* If [do_prop_to_callers] if also recursively computes new functions for
* [fname] callers in order to call the new slices. *)
let test ?(keep_project=false) fname ?(do_prop_to_callers=false) select_fct =
  if not keep_project then Slicing.Api.Project.reset_slicing ();
  try
    let kf = Globals.Functions.find_def_by_name fname in
    let ff = Slicing.Api.Slice.create kf in
    let select = select_fct kf in
    Slicing.Api.Request.add_slice_selection_internal ff select;
    if do_prop_to_callers then
      begin
        Slicing.Api.Request.apply_all_internal ();
        prop_to_callers (kf, ff)
      end;
    let fmt =  Format.std_formatter in
    Slicing.Api.Request.pretty fmt;
    (* Slicing.Api.Request.apply_next_internal *)
    (* Slicing.Api.Project.pretty fmt *)
    extract_and_print ()
  with
  | No_return ->
      Format.printf
        "Impossible to select 'retres' for a void function (%s)\n" fname
  | Unknown_data str ->
      Format.printf
        "Impossible to select this data : %s in %s\n" str fname
;;

let test_select_retres ?(do_prop_to_callers=false) fname =
  test fname ~do_prop_to_callers select_retres

let test_select_data ?(do_prop_to_callers=false) fname data =
  test fname ~do_prop_to_callers (select_data data)
