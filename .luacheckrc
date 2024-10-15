std = luajit
cache = true
codes = true

max_line_length = 150
max_comment_line_length = 200
globals = {
   'HOST',
   'PATH',
   'DEFAULT_LSP_SERVERS',
   'HARPOON_LIST',
   'buf_cache',
   'log',
   'vim'
}

files['lua/core/**'] = { ignore = {'212'} }
