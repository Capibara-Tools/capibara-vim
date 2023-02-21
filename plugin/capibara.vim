" Title:        Capibara Plugin
" Description:  A plugin to interface with Capibara documentation.
" Last Change:  20 February 2023
" Maintainer:   Justin Woodring <https://github.com/JustinWoodring>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_capibara")
    finish
endif
let g:loaded_capibara = 1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 CapibaraLookUp call capibara#CapibaraLookUp()
command! -nargs=0 CapibaraRefreshDefinitions call capibara#CapibaraRefreshDefinitions()
command! -nargs=0 CapibaraSponsorPlugin call capibara#CapibaraSponsorPlugin()
map <F2> :CapibaraLookUp<CR>