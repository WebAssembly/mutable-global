(module $Mg
  (global $glob (export "glob") i32 (i32.const 42))
  (func (export "get") (result i32) (get_global $glob))

  ;; export mutable globals
  (global $mut_glob (export "mut_glob") (mut i32) (i32.const 142))
  (func (export "get_mut") (result i32) (get_global $mut_glob))
  (func (export "set_mut") (param i32) (set_global $mut_glob (get_local 0)))
)
(register "Mg" $Mg)

(module $Ng
  (global $x (import "Mg" "glob") i32)
  (global $mut_glob (import "Mg" "mut_glob") (mut i32))
  (func $f (import "Mg" "get") (result i32))
  (func $get_mut (import "Mg" "get_mut") (result i32))
  (func $set_mut (import "Mg" "set_mut") (param i32))

  (export "Mg.glob" (global $x))
  (export "Mg.get" (func $f))
  (global $glob (export "glob") i32 (i32.const 43))
  (func (export "get") (result i32) (get_global $glob))

  (export "Mg.mut_glob" (global $mut_glob))
  (export "Mg.get_mut" (func $get_mut))
  (export "Mg.set_mut" (func $set_mut))
)

(assert_return (get $Mg "mut_glob") (i32.const 142))
(assert_return (get $Ng "Mg.mut_glob") (i32.const 142))
(assert_return (invoke $Mg "get_mut") (i32.const 142))
(assert_return (invoke $Ng "Mg.get_mut") (i32.const 142))

(assert_return (invoke $Mg "set_mut" (i32.const 241)))
(assert_return (get $Mg "mut_glob") (i32.const 241))
(assert_return (get $Ng "Mg.mut_glob") (i32.const 241))
(assert_return (invoke $Mg "get_mut") (i32.const 241))
(assert_return (invoke $Ng "Mg.get_mut") (i32.const 241))


(assert_unlinkable
  (module (import "Mg" "mut_glob" (global i32)))
  "incompatible import type"
)
(assert_unlinkable
  (module (import "Mg" "glob" (global (mut i32))))
  "incompatible import type"
)
