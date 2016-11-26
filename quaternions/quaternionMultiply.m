function quaternion = quaternionMultiply(x, y)
% Multiply two quaternions
%#eml
%#codegen

    x_scalar = x(1);
    x_vector = x(2:4);

    y_scalar = y(1);
    y_vector = y(2:4);

    result_scalar = x_scalar * y_scalar - dot(x_vector, y_vector);
    result_vector = x_scalar * y_vector + y_scalar * x_vector + cross(x_vector, y_vector);

    quaternion = [result_scalar, result_vector']';
end