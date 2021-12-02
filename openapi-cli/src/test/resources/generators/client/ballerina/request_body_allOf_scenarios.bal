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
    public isolated function init(http:ClientConfiguration clientConfig = {}, string serviceUrl = "https://petstore.swagger.io:443/v2") returns error? {
        http:Client httpEp = check new(serviceUrl, clientConfig);
        self.clientEp = httpEp;
        return;
    }
    # Request Body has allOf with specific properties.
    #
    # + return - OK
    remote isolated function updateXMLUser(Path01Body payload) returns http:Response|error {
        string resourcePath = string `/path01`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        xml? xmlBody = check xmldata:fromJson(jsonBody);
        request.setPayload(xmlBody, "application/xml");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Request Body has nested allOf.
    #
    # + return - OK
    remote isolated function postXMLUser(Path01Body1 payload) returns http:Response|error {
        string resourcePath = string `/path01`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Request Body has Array type AllOf.
    #
    # + return - OK
    remote isolated function postXMLUserInLineArray(CompoundArrayItemPostXMLUserInLineArrayRequest payload) returns http:Response|error {
        string resourcePath = string `/path02`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        xml? xmlBody = check xmldata:fromJson(jsonBody);
        request.setPayload(xmlBody, "application/xml");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
}
