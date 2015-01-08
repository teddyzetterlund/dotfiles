" Teddy Zetterlund's Vim configuration
" https://www.teddyzetterlund.com
"
" This file is layed out according to :options.
" Vundle, the plug-in manager, is the exception.

" =================================================================
" 1. important
" =================================================================

set nocompatible
set encoding=utf-8

filetype off

" Set the runtime path to include Vundle and initialize.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required.
Plugin 'gmarik/Vundle.vim'

" Lean & mean status/tabline for that is light as air.
Plugin 'bling/vim-airline'

" A Git wrapper so awesome, it should be illegal.
Plugin 'tpope/vim-fugitive'

" Fuzzy file, buffer, mru, tag, etc finder.
Plugin 'kien/ctrlp.vim'

" A code-searching tool similar to ack, but faster.
Plugin 'rking/ag.vim'

" Perform all Vim insert mode completions with Tab.
Plugin 'ervandew/supertab'

" Vim script for text filtering and alignment
Plugin 'godlygeek/tabular'

" Syntax checking hacks for Vim.
Plugin 'scrooloose/syntastic'

" Easily search for, substitute, and abbreviate multiple variants of a word.
Plugin 'tpope/vim-abolish'

" Comment stuff out with style.
Plugin 'tpope/vim-commentary'

" Quoting/parenthesizing made simple.
Plugin 'tpope/vim-surround'

" Ruby and Ruby on Rails.
Plugin 'ruby-matchit'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rails'

" Syntax.
Plugin 'suan/vim-instant-markdown'
Plugin 'othree/html5-syntax.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'pangloss/vim-javascript'

" Writing
Plugin 'reedes/vim-pencil'
Plugin 'reedes/vim-lexical'
Plugin 'reedes/vim-wordy'
Plugin 'reedes/vim-wheel'

call vundle#end()
filetype plugin indent on

" =================================================================
" 2. moving around, searching and patterns
" =================================================================

set incsearch
set hlsearch
set ignorecase
set smartcase

" =================================================================
" 4. displaying text
" =================================================================

set scrolloff=3
set listchars=tab:▸\ ,eol:¬

" =================================================================
" 5. syntax, highlighting and spelling
" =================================================================

filetype plugin indent on
syntax enable

set background=dark
colorscheme base16-railscasts

highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight IncSearch    ctermbg=3   ctermfg=1
highlight Search       ctermbg=1   ctermfg=3
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=3   ctermfg=1
highlight SpellBad     ctermbg=0   ctermfg=1

" =================================================================
" 6. multiple windows
" =================================================================

set laststatus=2
set stl=%!airline#statusline(1)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" =================================================================
" 8. terminal
" =================================================================

set title

" =================================================================
" 11. messages and info
" =================================================================

set showcmd
set showmode
set ruler
set visualbell

" =================================================================
" 13. editing text
" =================================================================

set backspace=indent,eol,start
set showmatch
set complete=.,t
set nrformats-=octal
set omnifunc=syntaxcomplete#Complete

" =================================================================
" 14. tabs and indenting
" =================================================================

set autoindent
set tabstop=2
set expandtab
set smarttab
set shiftwidth=2
set shiftround

" =================================================================
" 18. reading and writing files
" =================================================================

set backupdir=$HOME/.vim/tmp,/private/tmp
set autoread
set fileformats+=mac

" =================================================================
" 19 the swap file
" =================================================================

set directory=$HOME/.vim/tmp,/private/tmp

" =================================================================
" 20 command line editing
" =================================================================

set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.DS_Store
set wildignore+=*tags
set wildignore+=*log/**
set wildignore+=*tmp/*
set wildignore+=*vendor/bundle/**
set wildmenu

" =================================================================
" autocommands
" =================================================================

" Removes superfluous whitespace.
autocmd BufWritePre * :%s/\s\+$//e

autocmd Filetype gitcommit setlocal spell textwidth=72

autocmd BufRead,BufNewFile config.ru set filetype=ruby
autocmd BufRead,BufNewFile *.json set filetype=javascript

augroup pencil
  autocmd!
  autocmd FileType mkd, md, txt call pencil#init() |
                              \ call lexical#init()
augroup END

" =================================================================
" syntastic settings
" =================================================================

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" =================================================================
" custom shortcuts
" =================================================================

" Easier mapping for leader.
let mapleader=" "

" More efficent shortcut mappings through avoiding the <Shift> key.
nnoremap ; :

" Shortcut to rapidly toggle `set list`.
nnoremap <leader>l :set list!<CR>

" Shortcut for running Git Blame on highlighted lines.
map <leader>b :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Stop the highlighting for the 'hlsearch' option.
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Shortcut for silver searcher.
map <leader>a :Ag!<space>

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!bundle exec cucumber " . a:filename
  elseif match(a:filename, '_test\.rb$') != -1
    if filereadable("bin/testrb")
      exec ":!bin/testrb " . a:filename
    else
      exec ":!ruby -Itest " . a:filename
    end
  else
    if filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" run test runner
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

" Redo command with sudo privileges.
cnoremap w!! w !sudo tee % >/dev/null

" Edit the vimrc file.
nmap <silent> ;ev :e $MYVIMRC<CR>
nmap <silent> ;sv :so $MYVIMRC<CR>
