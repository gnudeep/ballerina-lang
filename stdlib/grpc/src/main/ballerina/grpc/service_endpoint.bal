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

# Represents server listener where one or more services can be registered. so that ballerina program can offer
# service through this listener.
public type Listener object {

    *AbstractListener;

    private int port = 0;
    private ServiceEndpointConfiguration config = {};

    # Starts the registered service.
    #
    # + return - Returns an error if encounters an error while starting the server, returns nil otherwise.
    public function __start() returns error? {
        return self.start();
    }

    # Stops the registered service.
    #
    # + return - Returns an error if encounters an error while stopping the server, returns nil otherwise.
    public function __stop() returns error? {
        return self.stop();
    }

    # Gets called every time a service attaches itself to this endpoint - also happens at module init time.
    #
    # + serviceType - The type of the service to be registered.
    # + annotationData - Annotations attached to the service.
    # + return - Returns an error if encounters an error while attaching the service, returns nil otherwise.
    public function __attach(service s, map<any> annotationData) returns error? {
        return self.register(s, annotationData);
    }

    # Gets called when the endpoint is being initialize during module init time.
    #
    # + port - Listener port.
    # + config - The ServiceEndpointConfiguration of the endpoint.
    public function __init(int port, ServiceEndpointConfiguration? config = ()) {
        self.config = config ?: {};
        self.port = port;
        self.init(self.port, self.config);
    }

    extern function init(int port, ServiceEndpointConfiguration config);


    extern function register(service serviceType, map<any> annotationData) returns error?;

    extern function start() returns error?;

    extern function stop() returns error?;
};

# Represents the gRPC server endpoint configuration.
#
# + host - The server hostname.
# + secureSocket - The SSL configurations for the client endpoint.
public type ServiceEndpointConfiguration record {
    string host = "0.0.0.0";
    ServiceSecureSocket? secureSocket = ();
    !...
};

# SecureSocket struct represents SSL/TLS options to be used for gRPC service.
#
# + trustStore - TrustStore related options.
# + keyStore - KeyStore related options.
# + certFile - A file containing the certificate of the server.
# + keyFile - A file containing the private key of the server.
# + keyPassword - Password of the private key if it is encrypted.
# + trustedCertFile - A file containing a list of certificates or a single certificate that the server trusts.
# + protocol - SSL/TLS protocol related options.
# + certValidation - Certificate validation against CRL or OCSP related options.
# + ciphers - List of ciphers to be used. eg: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#             TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA.
# + sslVerifyClient - The type of client certificate verification.
# + shareSession - Enable/disable new ssl session creation.
# + ocspStapling - Enable/disable ocsp stapling.
public type ServiceSecureSocket record {
    TrustStore? trustStore = ();
    KeyStore? keyStore = ();
    string certFile = "";
    string keyFile = "";
    string keyPassword = "";
    string trustedCertFile = "";
    Protocols? protocol = ();
    ValidateCert? certValidation = ();
    string[] ciphers = [];
    string sslVerifyClient = "";
    boolean shareSession = true;
    ServiceOcspStapling? ocspStapling = ();
    !...
};
