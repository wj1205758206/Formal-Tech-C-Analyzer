(* 
* Small example to view graphically the building process of a slicing project.
* To try it, use the following commands :

  make tests/slicing/anim.byte; \
  tests/slicing/anim.byte -deps -lib-entry -main g -slicing-level 3 -slice-callers \
                          tests/slicing/select_return_bis.c
*)

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

let add_select_fun_calls kf =
  let selections = Db.Slicing.Select.empty_selects in
  let selections =
    Slicing.Api.Select.select_func_calls_into selections ~spare:false kf
  in Slicing.Api.Select.iter_selects_internal
       (fun s -> !Db.Slicing.Request.add_selection_internal s)
       selections

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

let main _ =
  let proj_name = "slicing_project" in

  let n = 0 in

  let title = "Before start" in
  let n = LibAnim.print_proj proj_name title n in

  let kf_send = Globals.Functions.find_by_name "send" in
  add_select_fun_calls kf_send;

  let title = "Select 'send' calls" in
  let n = LibAnim.print_proj proj_name title n in
  let title = "Apply : " ^ title in
  let n = LibAnim.build_all_graphs proj_name title n in

  let kf_send_bis = Globals.Functions.find_by_name  "send_bis" in
  add_select_fun_calls kf_send_bis;

  let title = "Select 'send_bis' calls" in
  let n = LibAnim.print_proj proj_name title n in
  let title = ("Apply : "^title) in
  let _n = LibAnim.build_all_graphs proj_name title n in

  LibAnim.print_help proj_name;;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

let () = Db.Main.extend main
