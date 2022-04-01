(
    (alias_declaration
        name: (type_identifier) @alias.name
        type: (type_descriptor) @alias.type)
    (set! priority 105)
)

(
    (function_declarator
        declarator: (operator_name) @keyword.operator)
    (set! priority 105)
)

(class_specifier
    name: (type_identifier) @class)

(field_declaration
    type: (primitive_type) @function.return
    declarator: (function_declarator))
