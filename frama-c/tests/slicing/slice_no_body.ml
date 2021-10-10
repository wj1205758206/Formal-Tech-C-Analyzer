(* ledit bin/toplevel.top -deps tests/slicing/slice_no_body.c
  #use "tests/slicing/select.ml";;
*)

include LibSelect;;

let callers kf = !Db.Value.callers kf

(** simple implementation to select every calls to [kf] source function.
* The problem of this implementation is that it can generate several slice
* for one function during propagation to the callers.
* See [Slicing.Api.Request.select_fun_calls] for a better implementation.
* *)
let call_f kf =
  let callers = callers kf in
  let process_caller (kf_caller,_) =
    let ff_caller = Slicing.Api.Slice.create kf_caller in
    Slicing.Api.Request.add_call_fun ~caller:ff_caller ~to_call:kf;
    prop_to_callers (kf_caller, ff_caller);
  in
    List.iter process_caller callers

let slice_on_fun_calls kf =
  let table = Cil_datatype.Varinfo.Hashtbl.create 17 in
  let get_slice kf =
    let vf = Kernel_function.get_vi kf in
    try Cil_datatype.Varinfo.Hashtbl.find table vf
    with Not_found ->
      let ff = Slicing.Api.Slice.create kf in
        Cil_datatype.Varinfo.Hashtbl.add table vf ff;
        ff
  in
  let rec process_ff_caller ff (kf_caller,_) =
    let ff_caller = get_slice kf_caller in
      Slicing.Api.Request.add_call_slice ~caller:ff_caller ~to_call:ff;
      process_ff_callers (kf_caller, ff_caller)
  and process_ff_callers (kf, ff) =
    List.iter (process_ff_caller ff) (callers kf)
  in
  let process_src_caller kf_to_call (kf_caller,_) =
    let ff_caller = get_slice kf_caller in
    Slicing.Api.Request.add_call_fun ~caller:ff_caller ~to_call:kf_to_call;
    process_ff_callers (kf_caller, ff_caller)
  in
  List.iter (process_src_caller kf) (callers kf)

let main _ =
  let kf_f = find_kf "f" in

  Slicing.Api.Project.reset_slicing ();
  call_f kf_f;
  print_project ();
  extract_and_print ();

  Slicing.Api.Project.reset_slicing ();
  slice_on_fun_calls kf_f;
  Slicing.Api.Request.apply_all_internal ();
  print_project ();
  extract_and_print ()

let () = Db.Main.extend main
