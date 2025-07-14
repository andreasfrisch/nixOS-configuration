{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nerdtree
      YouCompleteMe
      syntastic
      vim-flake8
      vim-nix
      vim-devicons
    ];

    extraConfig = ''
      hi clear
      filetype plugin indent on
      syntax on
      hi Normal ctermbg=NONE
      hi NonText ctermbg=NONE
      hi SpecialKey ctermbg=NONE
      hi ExtraWhitespace ctermbg=red
      match ExtraWhitespace /\s\+$/
      autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
      autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
      autocmd InsertLeave * match ExtraWhitespace /\s\+$/
      autocmd BufWinLeave * call clearmatches()
      autocmd BufRead,BufNewFile *.tsx setfiletype typescript

      autocmd VimEnter * NERDTree | wincmd p
      " Close NERDTree if it is the only window open
      autocmd bufenter * if (winnr('$') == 1 && getbufvar(winbufnr(0), "&filetype") == "nerdtree") | quit | endif

      set encoding=utf-8
      set nocompatible
      set modelines=0
      set scrolloff=3
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set autoindent
      set showmode
      set showcmd
      set wildmenu
      set wildmode=list:longest
      set visualbell
      set cursorline
      set ruler
      set relativenumber
      set statusline=2
      set undofile
      set backspace=indent,eol,start
      let mapleader = ","

      " Sane search
      nnoremap / /\v
      set ignorecase
      set smartcase
      set incsearch
      set showmatch
      set hlsearch
      set gdefault
      nnoremap <leader><space> :noh<cr>
      nnoremap <tab> %
      vnoremap <tab> %

      " Text wrapping
      set colorcolumn=80
      hi ColorColumn ctermbg=238

      let NERDTreeIgnore=['\.pyc$', '\~$']
      set list
      set listchars=tab:▸\ ,eol:¬

      " Keybindings
      nnoremap ; :
      au FocusLost * :wa
      nnoremap <leader>ft Vatzf
      inoremap jj <ESC>
      nnoremap <leader>w <C-w>v<C-w>l
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
      map <C-n> :NERDTreeToggle<CR>

      " make F search for the word under the cursor
      nnoremap F *

      " make space select indentation block
      function! SelectIndentBlock()
      let l:cur_indent = indent('.')
      let l:start = line('.')
      let l:end = line('.')
      let l:last = line('$')

      " Extend upwards while indent >= current (ignore blank line content)
      while l:start > 1 && (indent(l:start - 1) >= l:cur_indent || getline(l:start - 1) =~ '^\s*$')
      let l:start -= 1
      endwhile

      " Extend downwards while indent >= current (ignore blank line content)
      while l:end < l:last && (indent(l:end + 1) >= l:cur_indent || getline(l:end + 1) =~ '^\s*$')
      let l:end += 1
      endwhile

      execute l:start . ',' . l:end . 'normal! V'
      endfunction

      nnoremap <silent> <Space> :call SelectIndentBlock()<CR>
    '';
  };
}
