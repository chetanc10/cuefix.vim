# Cuefix.vim

Cuefix is a quickfix-based helper plugin for Vim that helps navigate and mark code issues (e.g. GCC/MISRA errors) as fixed or discard directly from quickfix window.

## Features

- Navigate errors from quickfix window and lets user to fix/discard errors/warnings.
- Removes fixed error entries on the fly from quickfix window as well as quickfix source file.
- Auto-reloads quickfix upon fixed-error entry removal.
- Close vim and restart session later and continue with unfixed errors.
- Supports multiple quickfix source files (One error file per session).
- Quickfix errorformat customization support.
- Optional keymaps for quicker navigation.

## Installation

Use your favorite Vim plugin manager. For example, with vim-plug:

    Plug 'chetanc10/cuefix.vim'

Then reload Vim and run:

    :PlugInstall

## Commands

- ```:Cuefo <file>```  
  Opens a Cuefix session using the given file.

- ```:Cuefd```  
  Deletes current quickfix entry from quickfix window and also quickfix source file.

## Configuration Options

Cuefix provides configuration options via global variables that can be set in your .vimrc. All of these options are unset by default.

- ```g:cuefix_no_keymaps``` - Disable automatic keymap setup.

- ```g:cuefix_errfmt``` - Set a custom errorformat for parsing quickfix entries. If not set, default errorformat is used:  %-G#\ %f,%f:%l:%c:%m   
  Refer to vim's errorformat for more info: ```:help errorformat```

- ```g:cuefix_lpos``` - Controls line positioning in the quickfix window. Accepted values:
  - ```'center'``` - position current quickfix line at center
  - ```'top'```    - position current quickfix line at top

- ```g:cuefix_nohl``` - Enables/Disables quickfix entry background highlight.

## Keymaps

If ```g:cuefix_no_keymaps``` is not set, Cuefix provides these mappings

- ```Ctrl+x+q``` - Start a Cuefix session (asks for file)

- ```Ctrl+d``` - Delete current quickfix entry

- ```Ctrl+Down``` - Jump to next quickfix entry

- ```Ctrl+Up``` - Jump to previous quickfix entry

- ```Ctrl+x+Down``` - Close Cuefix session

