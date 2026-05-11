;; extends

((function_call
   name: (_) @_vimcmd_identifier
   arguments: (arguments
      .
      (string 
         content: _ @injection.content)
      .
      (_)?))
   (#set! injection.language "vim")
   (#any-of? @_vimcmd_identifier "m.cmd" "m.esc"))
