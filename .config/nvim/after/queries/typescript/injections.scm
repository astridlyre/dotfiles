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

; Use SQL syntax highlighting in sql template string
; sql: `SQL..`
(pair
  key: (property_identifier) @_name
    (#eq? @_name "sql")
  value: (template_string) @sql
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

(((comment) @_jsdoc_comment
  (#match? @_jsdoc_comment "^/\\*\\*[^\\*].*\\*/")) @jsdoc)

(comment) @comment
(regex_pattern) @regex

(call_expression
 function: ((identifier) @language)
 arguments: ((template_string) @content
   (#offset! @content 0 1 0 -1)))

; TODO: map tag names to languages
(call_expression
 function: ((identifier) @_name
   (#eq? @_name "gql"))
 arguments: ((template_string) @graphql
   (#offset! @graphql 0 1 0 -1)))

(call_expression
 function: ((identifier) @_name
   (#eq? @_name "hbs"))
 arguments: ((template_string) @glimmer
   (#offset! @glimmer 0 1 0 -1)))

; styled.div`<css>`
(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "styled"))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

; styled(Component)`<css>`
(call_expression
 function: (call_expression
   function: (identifier) @_name
     (#eq? @_name "styled"))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

; styled.div.attrs({ prop: "foo" })`<css>`
(call_expression
 function: (call_expression
   function: (member_expression
    object: (member_expression
      object: (identifier) @_name
        (#eq? @_name "styled"))))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

; styled(Component).attrs({ prop: "foo" })`<css>`
(call_expression
 function: (call_expression
   function: (member_expression
    object: (call_expression
      function: (identifier) @_name
        (#eq? @_name "styled"))))
 arguments: ((template_string) @css
   (#offset! @css 0 1 0 -1)))

((comment) @_gql_comment
  (#eq? @_gql_comment "/* GraphQL */")
  (template_string) @graphql)

(((template_string) @_template_string
 (#match? @_template_string "^`#graphql")) @graphql)
