import ballerina/io;

public function main() {

    //Tuple variables can be de-structured with new values when they used as tuple variable reference based binding
    //pattern as below.
    (string, (int, boolean)) (a1, (a2, a3)) = ("Hello", (123, true));
    (a1, (a2, a3)) = ("Ballerina", (453, false));
    io:println("Tuple variable : ", a1, a2, a3);

    //The variable can also be updated individually, because once they are defined, they are treated as individual
    //variables at runtime.
    (string, (int, boolean)) (b1, (b2, b3)) = ("Hello", (123, true));
    b1 = "Ballerina";
    b2 = 453;
    b3 = false;
    io:println("Tuple variable : ", b1, b2, b3);

    //The binding patterns are recursive in nature. Following examples shows how we can write complex recursive
    //variable references for de-structuring.

    (string, (int, (boolean, float))) (c1, (c2, (c3, c4))) =
                                        ("Test", (123, (true, 5.6)));
    ((c1, c2), c3) = (("Ballerina", 453), false);
    (c2, c3, c4) = (657, true, 76.8);
    io:println("Tuple variable : ", c1, c2, c3, c4);

    //Tuple variables can also be referenced using tuple type expressions as below.
    ((string, (int, (boolean, int))), (float, int)) v1 =
                            (("Ballerina", (3, (true, 34))), (5.6, 45));
    ((string, (int, (boolean, int))),
                        (float, int)) ((d1, (d2, (d3, d4))), (d5, d6)) = v1;
    ((d1, (d2, (d3, d4))), (d5, d6)) = bar();
    io:println("Tuple variable : ", d1, d2, d3, d4, d5, d6);

    //Tuple type can also take "var" as the type label, which in that case, the type will be inferred from the RHS.
    var (e1, (e2, e3)) = ("Test", (123, true));
    (e1, (e2, e3)) = foo();
    io:println("Tuple variable : ", e1, e2, e3);

    var v2 = (("Test", (5, (false, 54))), (9.8, 234));
    ((string, (int, (boolean, int))),
                        (float, int)) ((f1, (f2, (f3, f4))), (f5, f6)) = v2;
    ((f1, (f2, (f3, f4))), (f5, f6)) = bar();
    io:println("Tuple variable : ", f1, f2, f3, f4, f5, f6);
}

function foo() returns (string, (int, boolean)) {
    return ("Ballerina", (453, false));
}

function bar() returns ((string, (int, (boolean, int))), (float, int)) {
    return (("Ballerina", (3, (true, 34))), (5.6, 45));
}

