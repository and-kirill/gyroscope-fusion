function skew_anti_sym = vector2antiSkewSymOperator(v)
%#codegen
skew_anti_sym = zeros(3);

skew_anti_sym(1, 2) =   v(3);
skew_anti_sym(1, 3) = - v(2);
skew_anti_sym(2, 1) = - v(3);
skew_anti_sym(2, 3) =   v(1);
skew_anti_sym(3, 1) =   v(2);
skew_anti_sym(3, 2) = - v(1);
