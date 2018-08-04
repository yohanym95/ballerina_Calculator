import ballerina/http;
import ballerina/log;
import ballerina/io;

endpoint http:Client clientEndpoint {
    url: "http://localhost:9090"
};

function main(string... args) {
    // Send a GET request to the Hello World service endpoint.
    var response = clientEndpoint->get("/hello/sayHello");

    match response {
        http:Response resp => {
            io:println(resp.getTextPayload());
        }
        error err => { log:printError(err.message, err = err); }
    }
}