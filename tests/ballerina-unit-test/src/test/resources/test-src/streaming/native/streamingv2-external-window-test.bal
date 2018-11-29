// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/runtime;
import ballerina/streams;

type Teacher record {
    string name;
    int age;
    string status;
    string batch;
    string school;
    int timeStamp;
};

type TeacherOutput record {
    string name;
    int age;
    int sumAge;
};

int index = 0;
stream<Teacher> inputStream;
stream<TeacherOutput> outputStream;

TeacherOutput[] globalEmployeeArray = [];

function startExternalTimeWindowQuery() returns (TeacherOutput[]) {

    Teacher[] teachers = [];
    Teacher t1 =
    { name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College", timeStamp: 1000 };
    Teacher t2 =
    { name: "Raja", age: 45, status: "single", batch: "LK2014", school: "Hindu College", timeStamp: 1400 };
    Teacher t3 =
    { name: "Naveen", age: 35, status: "single", batch: "LK2014", school: "Hindu College", timeStamp: 3000 };
    Teacher t4 =
    { name: "Amal", age: 50, status: "single", batch: "LK2014", school: "Hindu College", timeStamp: 3200 };

    teachers[0] = t1;
    teachers[1] = t2;
    teachers[2] = t3;
    teachers[3] = t4;

    createStreamingConstruct();

    outputStream.subscribe(function (TeacherOutput e) {printTeachers(e);});
    foreach t in teachers {
        inputStream.publish(t);
    }

    int count = 0;
    while (true) {
        runtime:sleep(500);
        count += 1;
        if ((globalEmployeeArray.length()) == 4 || count == 10) {
            break;
        }
    }

    return globalEmployeeArray;
}


//  ------------- Query to be implemented -------------------------------------------------------
//  from teacherStream window externalTime(Teacher.timeStamp, 1000)
//        select name, age, sum(age) as sumAge
//        => (TeacherOutput[] t) {
//            outPutStream.publish(t);
//        }
//

function createStreamingConstruct() {

    function (map<anydata>[]) outputFunc = function (map<anydata>[] events) {
        foreach m in events {
            // just cast input map into the output type
            var t = <TeacherOutput>TeacherOutput.stamp(m.clone());
            outputStream.publish(t);
        }
    };

    streams:OutputProcess outputProcess = streams:createOutputProcess(outputFunc);

    streams:Sum iSumAggregator = new();

    streams:Aggregator[] aggregators = [];
    aggregators[0] = iSumAggregator;

    streams:Select select = streams:createSelect(function (streams:StreamEvent[] e) {outputProcess.process(e);},
        aggregators,
        [function (streams:StreamEvent e) returns string {
            return <string>e.data["inputStream.school"];
        }],
        function (streams:StreamEvent e, streams:Aggregator[] aggregatorArray) returns map<anydata> {
            streams:Sum iSumAggregator1 = <streams:Sum>aggregatorArray[0];
            // got rid of type casting
            return {
                "name": e.data["inputStream.name"],
                "age": e.data["inputStream.age"],
                "sumAge": iSumAggregator1.process(e.data["inputStream.age"], e.eventType)
            };
        });

    streams:Window tmpWindow = streams:externalTimeWindow(["inputStream.timeStamp", 1000],
        nextProcessPointer = function (streams:StreamEvent[] e) {select.process(e);});

    inputStream.subscribe(function (Teacher t) {
            streams:StreamEvent[] eventArr = streams:buildStreamEvent(t, "inputStream");
            tmpWindow.process(eventArr);

        });
}

function printTeachers(TeacherOutput e) {
    addToGlobalEmployeeArray(e);
}

function addToGlobalEmployeeArray(TeacherOutput e) {
    globalEmployeeArray[index] = e;
    index = index + 1;
}