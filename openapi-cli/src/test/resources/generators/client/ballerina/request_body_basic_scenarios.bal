import ballerina/http;
import ballerina/xmldata;

# refComponent
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + serviceUrl - URL of the target service
    # + return - An error if connector initialization failed
    public isolated function init(http:ClientConfiguration clientConfig =  {}, string serviceUrl = "https://petstore.swagger.io:443/v2") returns error? {
        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.clientEp = httpEp;
        return;
    }
    # 02 Example for rb has inline requestbody.
    #
    # + return - OK
    remote isolated function updateUser(Path01Body payload) returns http:Response|error {
        string resourcePath = string `/path01`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # 01 Request body with reference.
    #
    # + return - OK
    remote isolated function postUser(User payload) returns http:Response|error {
        string resourcePath = string `/path01`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # 04 Example for rb has inline requestbody.
    #
    # + payload - A JSON object containing pet information
    # + return - OK
    remote isolated function updateNewUser(User payload) returns http:Response|error {
        string resourcePath = string `/path02`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # 03 Request body with record reference.
    #
    # + return - OK
    remote isolated function postNewUser(User[] payload) returns http:Response|error {
        string resourcePath = string `/path02`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # 06 Example for rb has array inline requestbody.
    #
    # + return - OK
    remote isolated function updateXMLUser(Path03Body payload) returns http:Response|error {
        string resourcePath = string `/path03`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        xml? xmlBody = check xmldata:fromJson(jsonBody);
        request.setPayload(xmlBody, "application/xml");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # 05 Example for rb has array inline requestbody.
    #
    # + return - OK
    remote isolated function postXMLUser(Path03Body1 payload) returns http:Response|error {
        string resourcePath = string `/path03`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        xml? xmlBody = check xmldata:fromJson(jsonBody);
        request.setPayload(xmlBody, "application/xml");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # 07 Example for rb has array inline requestbody.
    #
    # + return - OK
    remote isolated function postXMLUserInLineArray(Path04Body[] payload) returns http:Response|error {
        string resourcePath = string `/path04`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        xml? xmlBody = check xmldata:fromJson(jsonBody);
        request.setPayload(xmlBody, "application/xml");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
}
