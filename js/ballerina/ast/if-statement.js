/**
 * Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
define(['lodash', 'log', './conditional-statement'], function (_, log, ConditionalStatement) {

    /**
     * Class for if conditions in ballerina. Extended from Conditional-Statement
     * @param elseStatements The 'else' statements of an IF condition.
     * @param elseIfStatements The 'else if' statements of an IF condition.
     * @constructor
     */
    var IfStatement = function (condition,statements) {
        if(!_.isNil(condition)){
            this._condition = condition;
        }
        this._statements = statements || [];
        ConditionalStatement.call(this);
    };

    IfStatement.prototype = Object.create(ConditionalStatement.prototype);
    IfStatement.prototype.constructor = IfStatement;

    IfStatement.prototype.setCondition = function(condition){
        if(!_.isNil(condition)){
            this._condition = condition;
        }
    };

    IfStatement.prototype.getCondition = function() {
        return this._condition;
    };

    return IfStatement;
});