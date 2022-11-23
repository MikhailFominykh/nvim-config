language en_US

set noswapfile
set cursorline
set number
set expandtab
set shiftwidth=4

set termguicolors
hi CursorLine cterm=underline guibg=#303030
hi Normal ctermbg=black ctermfg=white guibg=#262626 guifg=#C6AE7A
hi Pmenu ctermbg=bg ctermfg=fg guibg=#404040 guifg=fg
hi PmenuSel ctermbg=fg ctermfg=bg guibg=#323232 guifg=fg
hi Visual guibg=#08335E
hi LineNr guifg=#606060
hi CursorLineNr guifg=#a0a0a0

let mapleader = " "
nnoremap <F4> <cmd>source ~\AppData\Local\nvim\init.vim<CR>

lua require('plugins')
lua require('mike')
