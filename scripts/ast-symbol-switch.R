library(rlang)

myexpr <- expr(A[i])
myexpr

is_expression(myexpr)
is_atomic(myexpr)
is_call(myexpr)
is_symbol(myexpr)

is_symbolic(myexpr)
is_syntactic_literal(myexpr)

brack <- call_name(myexpr)

if (call_name(myexpr) == "[") call2("new_idx_df", call_args(myexpr))
