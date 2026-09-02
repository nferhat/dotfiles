; extends

((line_comment (doc_comment) @_first) @injection.language
  .
  ((line_comment (doc_comment) @injection.content))+
  .
  (line_comment (doc_comment) @_last)
  (#lua-match? @_first "^%s*```[a-zA-Z_][a-zA-Z0-9_]*%s*$")
  (#lua-match? @_last "^%s*```%s*")
  (#not-any-lua-match? @injection.content "^%s*```%s*")
  (#gsub! @injection.language "^.*```([a-zA-Z_][a-zA-Z0-9_]*)%s*$" "%1"))
