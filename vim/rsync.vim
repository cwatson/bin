" Vim syntax file
" Language:         rsync logfile
" Maintainer:       Chris Watson
" Latest Revision:  2013-02-09

if exists("b:current_syntax")
    finish
endif

syn match   rsyncDelete     display '*deleting.*'

syn match   rsyncBegin      display '^' nextgroup=rsyncDate

syn match   rsyncDate       contained display '\d\d\d\d/\d\d/\d\d *'
                            \ nextgroup=rsyncHour

syn match   rsyncHour       contained display '\d\d:\d\d:\d\d\ *'
                            \ nextgroup=rsyncPID

syn match   rsyncPID        contained display '\[\d\+] *'

syn match   rsyncFileChange display '>f\.st.*'

syn match   rsyncFileNew    display '>f++.*'

syn match   rsyncLinkNew    display 'cL++.*'
syn match   rsyncLinkNew    display 'cLc\.t.*'

syn match   rsyncDir        display '\.d..[.t].*'

syn match   rsyncDirNew     display 'cd+.*'

syn match   rsyncNum        display ' [0-9\.]*[MKG]*'

syn match   rsyncTimeConst  display ' [0-9\.]* seconds'

hi def link rsyncDelete     Error
hi def link rsyncDate       Special
hi def link rsyncHour       Type
hi def link rsyncPID        Special
hi def link rsyncFileChange Conditional
hi def link rsyncFileNew    Type
hi def link rsyncLinkNew    Identifier
hi def link rsyncDir        PreCondit
hi def link rsyncDirNew     PreCondit
hi def link rsyncNum        Constant
hi def link rsyncTimeconst  Type

let b:current_syntax = "rsync"
