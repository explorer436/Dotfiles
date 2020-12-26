"In Linux, the system vimrc file is in /etc.
"However, if we want to change vim settings, do not mess with the system vimrc.
"Instead, do all the customizations to user vimrc 
"which is located at /home/user/.vimrc
"If it is not already available, create it manually.
"The plugins also go into the ".vim" directory located here : /home/user/.vim

"To create and edit our .vimrc, open terminal and run this : vim ~/.vimrc

"For a clean start : 
"To remove the .vim directory, open terminal and run this : rm -rf ~/.vim
"To remove the .vimrc file, open terminal and run this : rm ~/.vimrc

"On Windows, when you start Vim normally, it
"*either* runs the file “C:\Documents and Settings\(username)\_vimrc” 
"*or*, if that file doesn’t exist (it usually doesn’t, for most users),
"it runs the file “C:\Program Files\Vim\_vimrc”.

"After making changes to the .vimrc file,
"if we want to make them effective immediately (called sourcing them),
":source % (from within vim)
"If you do not know where vimrc is located, running this command would help.
"`:e $MYVIMRC`

"Before using `Plugin` in vimrc to install plug-ins, 
"we need to install it in the machine.
"Look at the githut repo for the plugin manager "plug" 
"for details about installing it : https://github.com/junegunn/vim-plug 

"After making changes to the list of plugins in the .vimrc file,
"if we want to make them effective immediately, 
"run this `:PlugInstall` (from within vim)


"If you want to use this vimrc settings in a machine, 

" either put this line in your .vimrc file : source /home/explorer436/Downloads/GitRepositories/thoughts-notes/my-vim-notes/vimrcFiles/my_vimrc.vim
" or copy paste everything starting from the line below.

"------------------------------
	set nocompatible " Use Vim settings, rather then Vi settings. This setting must be as early as possible, as it has side effects.
"------------------------------
    set guitablabel=%N:%M%t " Show tab numbers on each tab
"------------------------------
    "Run internal vim terminal at current file's directory
    map <F6> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR> 
"------------------------------
" FZF.vim :Rg option also searches for file name in addition to the phrase. If you think this is an issue, use the command below to change the behavior:
" With this command, every time we invoke Rg, FZF + ripgrep will not consider filename as a match in Vim.
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
"------------------------------
    " This requires NertTree plugin
    "increase the size of the NerdTree width
    let g:NERDTreeWinSize = 60 
    "open files in tabs
    "let NERDTreeCustomOpenArgs={'file':{'where': 't'}} 
    let NERDTreeHijackNetrw=1
    let NERDTreeShowHidden=1
    
    let g:NERDSpaceDelims = 1
    
    function! ToggleNERDTree()
      NERDTreeToggle
      silent NERDTreeMirror
    endfunction

    nmap ,n :NERDTreeFind<CR>

    " enable line numbers
    let NERDTreeShowLineNumbers=1
    " make sure relative line numbers are used
    autocmd FileType nerdtree setlocal relativenumber
"------------------------------
    " set space bar as the leader key
	let mapleader = " "                                                  
    nnoremap <leader>u :UndotreeShow<CR>
    "open netrw to the left with a size 30
	nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR> 
    "move cursor to the window on the left
    nnoremap <leader>h :wincmd h<CR>                                     
    "move cursor to the window on the bottom
    nnoremap <leader>j :wincmd j<CR>                                     
    "move cursor to the window on the top
    nnoremap <leader>k :wincmd k<CR>                                     
    "move cursor to the window on the right
    nnoremap <leader>l :wincmd l<CR>                                     
    
    "height increase by 10
    nnoremap <Leader>hi :resize +10<CR>         
    "height decrease by 10
    nnoremap <Leader>hd :resize -10<CR>         
    "width increase by 10
    nnoremap <Leader>wi :vertical resize +10<CR> 
    "width decrease by 10
    nnoremap <Leader>wd :vertical resize -10<CR> 

    "open a new empty tab
    nnoremap <leader>tn :tabnew<CR>              
    "close the tab and all windows in it
    nnoremap <leader>tc :tabc<CR>               

    "open nerdtree on the left
    nmap <leader>n :call ToggleNERDTree()<CR>   
    "run prettier asynchronously
    nmap <leader>p :PrettierAsync<CR>           
"------------------------------
    " netrw customizations
	let g:netrw_liststyle = 3 " custom settings for the netrw file/directory menu...
                              " available netrw_liststyle options - 
                              " 1 (thin), 2 (long), 3 (wide), 4 (tree)
	let g:netrw_browse_split = 3 " netrw_browse_split| option - zero by default
                                 " used to cause the opening of files to be done in a new window or tab instead of the default.
                                 " When the option is one or two, the splitting will be taken horizontally or vertically, respectively.
                                 " When the option is set to three, a <cr> will cause the file to appear in a new tab.
	let g:netrw_banner = 0 " enable/suppress the banner. =0: suppress the banner =1: banner is enabled (default)
	let g:netrw_winsize = 25 " netrw_winsize - 
                             " specify initial size of new windows made with "o" (see |netrw-o|), "v" (see |netrw-v|),
                             " |:Hexplore| or |:Vexplore|.
                             " The g:netrw_winsize is an integer describing 
                             " the percentage of the current netrw buffer's window to be used for the new window.
	let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " netrw_bufsettings - you can control netrw's buffer settings; change
                                                             " these if you want to change line number displays, relative line number
                                                             " displays and other settings in netrw menu.
"------------------------------
    " ale plugin configuration
    " Set this variable to 1 to fix files when you save them.
    let g:ale_fix_on_save = 1
    " Fix files with prettier, and then ESLint.
    let b:ale_fixers = {'javascript': ['prettier', 'eslint']}

    " This requires prettier plugin
    let g:prettier#config#single_quote = 'true'
    let g:prettier#config#bracket_spacing = 'true'
    let g:prettier#config#jsx_bracket_same_line = 'false'
    let g:prettier#config#arrow_parens = 'avoid'
    let g:prettier#config#trailing_comma = 'es5'
    let g:prettier#config#use_tabs = 'false'
"------------------------------
 
	filetype indent plugin on " Attempt to determine the type of a file 
                              " based on its name and possibly its contents.
                              " Use this to allow intelligent auto-indenting for each filetype,
                              " and for plugins that are filetype specific.

 
    syntax on " Enable color syntax highlighting - wherever applicable
              " Basic highlighting for a lot of languages.
              " If you want more highlighting for your language,
              " you may have to download additional stuff.
	
	" Vim with default settings does not allow easy switching between multiple files
	" in the same editor window. Users can use multiple split windows or multiple
	" tab pages to edit multiple files, but it is still best to enable an option to
	" allow easier switching between files.
	"
	" When off a buffer is unloaded when it is |abandon|ed.  When on a
	" buffer becomes hidden when it is |abandon|ed.  If the buffer is still
	" displayed in another window, it does not become hidden, of course.
    " It which allows you to re-use the same window 
    " and switch from an unsaved buffer without saving it first. Also allows
	" you to keep an undo history for multiple files when re-using the same window
	" in this way. Note that using persistent undo also lets you undo in multiple
	" files even in the same window, but is less efficient and is actually designed
	" for keeping undo history after closing Vim entirely. Vim will complain if you
	" try to quit without saving, and swap files will keep you safe if your computer
	" crashes.
	" Note that not everyone likes working this way (with the hidden option).
	" Alternatives include using tabs or split windows instead of re-using the same
	" window as mentioned above, and/or either of the following options:
	" set confirm
	" set autowriteall"
	set hidden	

    "File find options in addition to `hidden`
    set path+=**  " Search all subdirectories and recursively
    set wildmenu
    set wildignore+=**/node_modules/**

    "Set default font in mac vim and gvim
    " set guifont=Inconsolata\ for\ Powerline:h24
    set cursorline    " highlight the current line
    set visualbell    " stop that ANNOYING beeping
    set wildmenu
    set wildmode=list:longest,full

    set autoread                           " Reload files changed outside vim
    au FocusGained,BufEnter * :silent! !   " Trigger autoread when changing buffers or coming back to vim in terminal.

	set bs=indent,eol,start " allow backspacing over everything in insert mode
	set ai                  " always set autoindenting on
	"set backup             " keep a backup file
	set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines of registers
	set history=50          " keep 50 lines of command line history
	set ruler               " show the cursor position all the time
	"set guicursor=         " what does this do?
	"set noshowmatch        " When a bracket is inserted, briefly jump to the matching one.
    set laststatus=2        " Always display the status line

   "Hybrid Line Numbers - 
   "Enabling both the absolute and relative line numbers at the same time 
   "sets up the hybrid line number mode.  
   "Hybrid line numbering is the same as the relative line numbering 
   "with the only difference being that the current line 
   "shows its absolute line number instead of showing 0.
	set relativenumber       " shows relative line numbers
	set number               " shows line numbers

	"set hlsearch               " When there is a previous search pattern, highlight all its matches.
	"set nohlsearch             " opposite of set hlsearch
	set noerrorbells            " will not make error sounds when we go to the end of the line, etc.
	set tabstop=4 softtabstop=4            " tabstop means it is only 4 characters long. softtabstop means it is only 4 spaces long.
	set shiftwidth=4            " every time we hit tab, it shifts the characters by 4 spaces instead of 8.
	set expandtab               " convert it from tab character to spaces
	set smartindent             " vim tires its best to indent the code for us
	"set nowrap                 " if the line goes off the screen, keep going to the right instead of showing it on the next line on the screen.
	set ignorecase              " Ignore case in search patterns.  Also used when searching in the tags file.
	"set smartcase              " it ewill do case sensitive searching until we put in a capital letter.
	set noswapfile              " do not create vim.swap files all throughout the project.
	"set nobackup               " it will not create backup files. If you use this, make sure you also use the undodir and undofile.
	"set undodir=~/.vim/undodir            " what does this do?
	"set undofile               " what does this do?
	set incsearch               " turns on incremental search
	"set termguicolors          " what does this do?
	"set scrolloff=8            " what does this do?
	"set cmdheight=2            " Give more space for displaying messages. 
	"set updatetime=50          " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
	"set shortmess+=c           " Don't pass messages to |ins-completion-menu|.
	"set colorcolumn=80          " shows a line at the 80 column of the page
	"highlight ColorColumn ctermbg=0 guibg=lightgrey            " the color that needs to be used for the 80 column line	


"------------------------------

	"set spell               " to turn spell checking on
	"set spelllang=en_us     " to use US English  for spell checking

"------------------------------

" This will look in the current directory for "tags",
" and work up the tree towards root until one is found.
" In other words, you can be anywhere in your source tree instead of just the root of it.
set tags=./tags;/         

"------------------------------
" If Vim keeps complaining about not finding the color scheme at start-up,
" it maybe worth it to copy the gruvbox.vim file to Vim colors file.

" In Linux, it is usually at /usr/share/vim/vim82/colors
" In Linux, Go to /home/explorer436/.vim/plugged/gruvbox/colors/" and run this command: 
" cp gruvbox.vim /usr/share/vim/vim82/colors

" In Windows, the locations of the plugged folder and the vim colors folder
" may be different.

colo gruvbox
set bg=dark
"------------------------------

if has('win32')
    let $PATH .= ';' . 'C:/Program Files (x86)/Git/bin'
endif
if has('win64')
    let $PATH .= ';' . 'C:/Program Files/Git/bin/'
endif

" Before using this, visit the github project for vim-plug for instructions about installing plugged.
" https://github.com/junegunn/vim-plug
" We need to run a command to Download plug.vim and put it in the "autoload" directory.
" We may need to toggle this on and off for installing plugins when behind a
" corporate firewall.
" git config --global http.sslVerify false
" git config --global http.sslVerify true 
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-rooter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-fugitive'

call plug#end()
" After making changes to the list here, run the command ':PlugInstall' to get
" the latest updates.
