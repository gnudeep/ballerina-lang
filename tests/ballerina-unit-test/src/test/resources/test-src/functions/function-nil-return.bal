import ballerina/io;

function testPrint1() {
    io:println("Hello");
    io:println(sampleFunction1());
    io:println("Ballerina");
}

function testPrint2() {
    io:println("Hello");
    io:println(sampleFunction2());
    io:println("Ballerina");
}

function testPrint3() {
    io:println("Hello");
    io:println(sampleFunction3());
    io:println("Ballerina");
}

function testPrint4() {
    io:println("Hello");
    io:println(sampleFunction4());
    io:println("Ballerina");
}

function testPrintInMatchBlock() {
    match (sampleFunction1()){
        () => {
            io:println("Hello");
            io:println(sampleFunction2());
            io:println("Ballerina");
        }
    }
}

function testPrintInWorkers() {
    worker w1 {
        string hello = "Hello";
        hello -> w2;
    }

    worker w2 {
        string hello = "";
        hello = <- w1;
        io:println(hello);
        io:println(sampleFunction1());
        io:println("Ballerina");
    }
    wait w2;
}

function testNoReturnFuncInvocnInNilReturnFuncRetStmt() {
    io:println(nilReturnFuncInvokingNoRetFuncInRetStmt());
}

function testNilReturnFuncInvocnInNilReturnFuncRetStmt() {
    io:println(nilReturnFuncInvokingNilRetFuncInRetStmt());
}

function sampleFunction1() {
    // Do nothing
}

function sampleFunction2() returns () {
    // Do nothing
}

function sampleFunction3() {
    return ();
}

function sampleFunction4() returns () {
    return ();
}

function nilReturnFuncInvokingNoRetFuncInRetStmt() returns () {
    io:println("nil returns here");
    return noReturnFunc();
}

function nilReturnFuncInvokingNilRetFuncInRetStmt() returns () {
    io:println("nil returns here");
    return nilReturnFunc();
}

function noReturnFunc() {
    io:println("no returns here");
}

function nilReturnFunc() returns () {
    io:println("explicit nil returns here");
    return;
}
