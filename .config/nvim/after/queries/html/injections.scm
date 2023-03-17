((attribute
  (attribute_name (attribute_value) @javascript))
  (#match? @javascript "\\x-\\{")
  (#offset! @javascript 0 5 0 -5))
((attribute
  (attribute_value) @javascript)
  (#match? @javascript "\\x-\\{")
  (#offset! @javascript 0 6 0 -6))
