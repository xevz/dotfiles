if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif
 
if !exists("main_syntax")
	let main_syntax = "sshauthkeys"
endif
 
" Options
syn keyword sshOption command
syn keyword sshOption environment
syn keyword sshOption from
syn keyword sshOption permitopen
syn keyword sshOption tunnel

syn match sshOption "no-agent-forwarding"
syn match sshOption "no-port-forwarding"
syn match sshOption "no-pty"
syn match sshOption "no-user-rc"
syn match sshOption "no-X11-forwarding"

" SSH1
"
syn match sshSSH1Bits     "\(^\|[ 	]\)[0-9]*" nextgroup=sshSSH1Exponent
syn match sshSSH1Exponent "[ 	][0-9]*" contained nextgroup=sshSSH1Modulus
syn match sshSSH1Modulus  "[ 	][0-9]*" contained nextgroup=sshSSH1Comment
syn match sshSSH1Comment  "[ 	].*" contained

" SSH2 key type
syn match sshSSH2KeyType "ssh-rsa"
syn match sshSSH2KeyType "ssh-dss"
 
" Strings
syn region sshString start=/"/ skip=/\\"/ end=/"/ oneline
 
" Comments
syn match sshComment /^#.*/

syn match sshSSH2Comment /=[ 	].*$/ms=s+1

if version >= 508
	command -nargs=+ HiLink hi link <args>
else
	command -nargs=+ HiLink hi def link <args>
endif
 
HiLink sshSSH1Bits     Type
HiLink sshSSH1Exponent Special
HiLink sshSSH1Comment  Comment

HiLink sshSSH2KeyType Type
HiLink sshSSH2Comment Comment

HiLink sshOption  Keyword
HiLink sshString  String
 
delcommand HiLink
 
let b:current_syntax = "sshauthkeys"
 
if main_syntax == "sshauthkeys"
	unlet main_syntax
endif

