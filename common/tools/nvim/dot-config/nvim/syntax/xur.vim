if exists('b:current_syntax')
  finish
endif

" Keywords
syn keyword xurKeyword       fn let const return if else while for in loop break continue match use pub struct enum impl as is
syn keyword xurBoolean       true false
syn keyword xurSelf          self

" Builtin types
syn keyword xurType          bool str bytes u8 u16 u32 u64 usize i8 i16 i32 i64 isize f32 f64 Type
syn keyword xurType          Option Result Some None Ok Err

" Comments
syn match   xurLineComment   '//.*$' contains=xurTodo
syn region  xurBlockComment  start='/\*' end='\*/' contains=xurBlockComment,xurTodo
syn keyword xurTodo          TODO FIXME XXX NOTE contained

" Strings
syn region  xurString        start='"' skip='\\"' end='"' contains=xurEscape,xurFmtSpec
syn match   xurEscape        '\\[\\nrt0"{}]' contained
syn match   xurFmtSpec       '{}' contained

" Byte strings
syn match   xurBytePrefix    'b"'me=e-1 nextgroup=xurByteString
syn region  xurByteString    start='"' skip='\\"' end='"' contained contains=xurEscape

" Numbers
syn match   xurNumber        '\<\d[0-9_]*\(\.\d[0-9_]*\)\?\>'
syn match   xurNumber        '\<0x[0-9a-fA-F_]\+\>'
syn match   xurNumber        '\<0b[01_]\+\>'
syn match   xurNumber        '\<0o[0-7_]\+\>'

" Attributes
syn region  xurAttribute     start='#\[' end='\]' contains=xurAttributeInner
syn match   xurAttributeInner '[^]]*' contained

" Operators / punctuation
syn match   xurOperator      '[+\-*/%!<>=&|?@]'
syn match   xurOperator      '=>\|->\|::\|\.\.'

" Record literal prefix
syn match   xurRecordAt      '@{'

" Identifiers after fn (function names)
syn match   xurFuncDef       '\<fn\s\+\zs\w\+' contained containedin=ALLBUT,xurLineComment,xurBlockComment,xurString

hi def link xurKeyword       Keyword
hi def link xurBoolean       Boolean
hi def link xurSelf          Keyword
hi def link xurType          Type
hi def link xurLineComment   Comment
hi def link xurBlockComment  Comment
hi def link xurTodo          Todo
hi def link xurString        String
hi def link xurBytePrefix    String
hi def link xurByteString    String
hi def link xurEscape        SpecialChar
hi def link xurFmtSpec       Special
hi def link xurNumber        Number
hi def link xurAttribute     PreProc
hi def link xurOperator      Operator
hi def link xurRecordAt      Special
hi def link xurFuncDef       Function

let b:current_syntax = 'xur'
