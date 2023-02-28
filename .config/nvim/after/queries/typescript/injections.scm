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
