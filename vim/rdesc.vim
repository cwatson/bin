" Vim syntax file
" Language:         R's DESCRIPTION file
" Maintainer:       Chris Watson
" Latest Revision:  2018-08-31

if exists("b:current_syntax")
    finish
endif

syn match   descField       '^[a-zA-Z@]\+' nextgroup=descDelim
syn match   descDelim       ':\s*' nextgroup=descValue

syn match   descValue       contained display '[[:graph:]]\+$' contains=descVersion,descDate,descUrl
syn match   descVersion     contained display '\d\.\d\.\d'
syn match   descVersionMin  contained display '(>=\s\d\.\d\.\d)'
syn match   descDate        contained display '\d\d\d\d\-\d\d\-\d\d'

syn match   descArg         display '[a-z]\+=' nextgroup=descString

syn region  descString      start=+\z(["'`]\)+ skip=+\\\z1+ end=+\z1+ contains=@Spell

syn match   descUrl         contained display /\w\+:\/\/\S\+/

syn match   descPack        '^\s*[[:graph:]]\+,$'
syn match   descPack        '^\s*[a-zA-Z]\+$'
syn match   descPackMin     '^\s*[a-zA-Z]\+\s(>=\s\d\.\d\.\d),$' contains=descVersionMin

hi def link descField       Type
hi def link descValue       PreCondit
hi def link descVersion     Function
hi def link descVersionMin  Function
hi def link descDate        Conditional
hi def link descDelim       Identifier
hi def link descString      String
hi def link descUrl         Underlined
hi def link descArg         Identifier
hi def link descPack        Special
hi def link descPackMin     Special

let b:current_syntax = "rdesc"
