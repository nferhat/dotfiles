; extends

; highlight frontmatter delimiter
(((document
  .
  (paragraph) @comment @nospell)
  (#lua-match? @comment "^%+%+%+\n.*\n%+%+%+\n?$"))
  (#set! priority 90))
