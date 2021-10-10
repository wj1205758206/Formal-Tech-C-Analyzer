(* ledit -h jnl bin/toplevel.top -deps  -lib-entry g -slice-callers \
                                 tests/slicing/min_call.c

*)

include LibSelect;;

let main _ =
  (* SlicingKernel.Mode.Calls.set 3; *)
  let _kf_get = Globals.Functions.find_by_name "get" in
  let _kf_send = Globals.Functions.find_by_name "send" in
  let kf_send_bis = Globals.Functions.find_by_name "send_bis" in
  let kf_k = Globals.Functions.find_def_by_name "k" in
  let _kf_f = Globals.Functions.find_def_by_name "f" in
  let _kf_g = Globals.Functions.find_def_by_name "g" in

  let _top_mark = Slicing.Api.Mark.make ~addr:true ~ctrl:true ~data:true in

  let add_select_fun_calls to_call =
    let selections = Slicing.Api.Select.empty_selects in
    let selections =
      Slicing.Api.Select.select_func_calls_into selections ~spare:false to_call
    in
    Slicing.Api.Request.add_persistent_selection selections
  in
  (*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
  (* Project1 :
   * Select the call to [send_bis] in [k] as a persistent selection :
   * this will create a fist slice for [k].
   * Then create manually a second slice for [k] :
   * the call to [send_bis] is visible as wished. *)

  Slicing.Api.Project.reset_slicing ();
  (*let pdg_k = !Db.Pdg.get kf_k;;*)
  let calls = !Db.Pdg.find_call_stmts ~caller:kf_k(*pdg_k*) kf_send_bis in
  let sb_call = match calls with c::[] -> c | _ -> assert false in
  let mark = Slicing.Api.Mark.make ~data:true ~addr:false ~ctrl:false in
  let select = Slicing.Api.Select.select_stmt_internal kf_k sb_call mark in
  Slicing.Api.Request.add_selection_internal select ;
  Slicing.Api.Request.apply_all_internal ();
  Log.print_on_output (fun fmt -> Format.fprintf fmt "@[Project1 - result1 :@\n@]") ;
  extract_and_print ();

  let _ff2_k = Slicing.Api.Slice.create kf_k in
  Log.print_on_output (fun fmt -> Format.fprintf fmt "@[Project1 - result2 :@\n@]") ;
  Slicing.Api.Project.pretty fmt;
  extract_and_print ();

  (*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
  (* Project2 :
   * same than project1, except that we use [select_min_call_internal].
   * But as [send_bis] is an undefined function, this makes no difference.
   *)
  Slicing.Api.Project.reset_slicing ();
  (*let pdg_k = !Db.Pdg.get kf_k;;*)
  let calls = !Db.Pdg.find_call_stmts (*pdg_k*)~caller:kf_k kf_send_bis in
  let sb_call = match calls with c::[] -> c | _ -> assert false in
  let mark = Slicing.Api.Mark.make ~data:true ~addr:false ~ctrl:false in
  let select = Slicing.Api.Select.select_min_call_internal kf_k sb_call mark in
  Slicing.Api.Request.add_selection_internal select ;
  print_requests ();
  Slicing.Api.Request.apply_all_internal ();
  Log.print_on_output (fun fmt -> Format.fprintf fmt "@[Project3 - result :@\n@]") ;
  Slicing.Api.Project.pretty fmt;
  extract_and_print ();

  (*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
  (* Project3 :
   * Select the calls to [k] to be visible in a minimal version.
   * This builds an empty slice [k_1] for [k] and call it in [f] and [g].
   * [f_1] is also called in [g_1] because it calls [k_1].
   *)

  Slicing.Api.Project.reset_slicing ();
  add_select_fun_calls kf_k;
  print_requests ();
  Slicing.Api.Request.apply_next_internal ();
  print_requests ();
  Slicing.Api.Request.apply_all_internal ();
  Log.print_on_output (fun fmt -> Format.fprintf fmt "@[Project3 - result :@\n@]") ;
  Slicing.Api.Project.pretty fmt;
  extract_and_print ()


(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(* Project4 is CAS_1 from Patrick's 19th April 2007 mail.
* step 1 - select calls to send and apply : OK
* step 2 - (automatically done in step1)
* step 3 - select calls to send_bis and apply : TODO
* step 4 - (automatically done in step3)
*)

(*
let project = mk_project();;

add_select_fun_calls project kf_send;;
print_requests project;;
Slicing.Api.Request.apply_next_internal project;;
print_requests project;;
Slicing.Api.Request.apply_all_internal project;;

Format.printf "@[CAS 1 - step 1+2 - result :@\n@]";;
extract_and_print project;;

add_select_fun_calls project kf_send_bis;;
print_requests project;;
Slicing.Api.Request.apply_all_internal project;;

Format.printf "@[CAS 1 - step 3+4 - result :@\n@]";;
Slicing.Api.Project.pretty fmt project;;
extract_and_print project;;
*)

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(* Project5 : same than the previous one,
* except that we create the two requests before applying.
* *)

(*
let project = mk_project();;

add_select_fun_calls project kf_send;;
add_select_fun_calls project kf_send_bis;;
print_requests project;;

Format.printf "@[Project 5 - result :@\n@]";;
Slicing.Api.Project.pretty fmt project;;
extract_and_print project;;
*)
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

let () = Db.Main.extend main
