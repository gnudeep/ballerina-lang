import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/cbr"
}
service contentBasedRouting on new http:Listener(9090) {

    //Use `resourceConfig` annotation to declare the HTTP method.
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/route"
    }
    resource function cbrResource(http:Caller outboundEP, http:Request req) {
        //Define the attributes associated with the client endpoint here.
        http:Client locationEP = new("http://www.mocky.io");

        //Get the JSON payload from the request message.
        var jsonMsg = req.getJsonPayload();

        if (jsonMsg is json) {
                //Get the string value relevant to the key `name`.
            string nameString = jsonMsg["name"].toString();
            http:Response|error clientResponse;

            if (nameString == "sanFrancisco") {
                //Here, `post` represents the POST remote function of the HTTP client connector.
                //This routes the payload to the relevant service when the server accepts the enclosed entity.
                clientResponse =
                        locationEP->post("/v2/594e018c1100002811d6d39a", ());

            } else {
                clientResponse =
                        locationEP->post("/v2/594e026c1100004011d6d39c", ());
            }
            //Use the native function 'respond' to send the client response back to the caller.
            if (clientResponse is http:Response) {
                var result = outboundEP->respond(clientResponse);
                if (result is error) {
                   log:printError("Error sending response", err = result);
                }
            } else {
                http:Response res = new;
                res.statusCode = 500;
                res.setPayload(<string>clientResponse.detail().message);
                var result = outboundEP->respond(res);
                if (result is error) {
                   log:printError("Error sending response", err = result);
                }
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload(untaint <string>jsonMsg.detail().message);

            var result = outboundEP->respond(res);
            if (result is error) {
               log:printError("Error sending response", err = result);
            }
        }
    }
}
