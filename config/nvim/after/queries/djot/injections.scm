; extends


; inject toml in the frontmatter.
; markdown already has a "standard" of using +++ so I use it in djot too
((document
  .
  (paragraph) @injection.content)
  (#lua-match? @injection.content "^%+%+%+\n.*\n%+%+%+\n?$")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.language "toml"))
