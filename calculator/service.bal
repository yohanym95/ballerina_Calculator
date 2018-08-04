import ballerina/http;

endpoint http:Listener listener {
    port:9090
};

// Calculator REST service
@http:ServiceConfig { basePath: "/calculator" }
service<http:Service> Calculator bind listener {

    // Resource that handles the HTTP POST requests that are directed to
    // the path `/operation` to execute a given calculate operation
    // Sample requests for add operation in JSON format
    // `{ "a": 10, "b":  200, "operation": "add"}`
    // `{ "a": 10, "b":  20.0, "operation": "+"}`

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/operation"
    }
    executeOperation(endpoint client, http:Request req) {
        json operationReq = check req.getJsonPayload();
        string operation = operationReq.operation.toString();

        any result = 0.0;
        // Pick first number for the calculate operation from the JSON request
        float a = 0;
        var input = operationReq.a;
        match input {
            int ivalue => a = ivalue;
            float fvalue => a = fvalue;
            json other => {} //error
        }

        // Pick second number for the calculate operation from the JSON request
        float b = 0;
        input = operationReq.b;
        match input {
            int ivalue => b = ivalue;
            float fvalue => b = fvalue;
            json other => {} //error
        }

        if(operation == "add" || operation == "+") {
            result = add(a, b);
        }

        // Create response message.
        json payload = { status: "Result of " + operation, result: 0.0 };
        payload["result"] = check <float>result;
        http:Response response;
        response.setJsonPayload(payload);

        // Send response to the client.
        _ = client->respond(response);
    }
}
