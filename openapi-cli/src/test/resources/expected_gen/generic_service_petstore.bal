import ballerina/http;

listener http:Listener ep0 = new (80, config = {host: "petstore.openapi.io"});

service /v1 on ep0 {
    resource function get pets(http:Caller caller, http:Request request) {
    }
    resource function post pets(http:Caller caller, http:Request request) {
    }
    resource function get pets/[string petId](http:Caller caller, http:Request request) {
    }
}
