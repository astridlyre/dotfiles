; extends
; Use HTML syntax highlighting in template for vue.js
; template: `<html>`
(pair
  key: (property_identifier) @_name
    (#eq? @_name "template")
  value: (template_string) @html
)

; Use CSS syntax highlighting in template for web components
; css: `css...`
(pair
  key: (property_identifier) @_name
    (#eq? @_name "css")
  value: (template_string) @css
)

(variable_declarator
  name: (identifier) @_name
	(#match? @_name "\\csql")
  value: [(string) (template_string)] @injection.content
	(#offset! @injection.content 0 1 0 -1)
	(#set! injection.include-children)
	(#set! injection.combined)
	(#set! injection.language "sql"))

(pair
  key: (property_identifier) @_name
	(#match? @_name "\\csql")
  value: [(string) (template_string)] @injection.content
	(#offset! @injection.content 0 1 0 -1)
	(#set! injection.include-children)
	(#set! injection.combined)
	(#set! injection.language "sql"))

