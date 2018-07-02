;; Test exportable mutable globals

;; mutable globals can be exported
(module (global (mut f32) (f32.const 0)) (export "a" (global 0)))
(module (global (export "a") (mut f32) (f32.const 0)))
