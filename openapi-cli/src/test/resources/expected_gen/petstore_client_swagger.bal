import ballerina/http;
import ballerina/mime;

# This is a sample server Petstore server.  You can find out more about     Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).      For this sample, you can use the api key `special-key` to test the authorization     filters.
public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector`
    # + serviceUrl - URL of the target service
    # + return - An error if connector initialization failed
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://petstore.swagger.io/v2") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            config.auth = <http:BearerTokenConfig>config.auth;
            self.apiKeyConfig = ();
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }
    # Update an existing pet
    #
    # + payload - Pet object that needs to be added to the store
    # + return - Invalid ID supplied
    remote isolated function updatePet(Pet payload) returns http:Response|error {
        string resourcePath = string `/pet`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Add a new pet to the store
    #
    # + payload - Pet object that needs to be added to the store
    # + return - Invalid input
    remote isolated function addPet(Pet payload) returns http:Response|error {
        string resourcePath = string `/pet`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Finds Pets by status
    #
    # + status - Status values that need to be considered for filter
    # + return - successful operation
    remote isolated function findPetsByStatus(("available"|"pending"|"sold")[] status) returns Pet[]|error {
        string resourcePath = string `/pet/findByStatus`;
        map<anydata> queryParam = {"status": status};
        map<Encoding> queryParamEncoding = {"status": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        Pet[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Finds Pets by tags
    #
    # + tags - Tags to filter by
    # + return - successful operation
    #
    # # Deprecated
    @deprecated
    remote isolated function findPetsByTags(string[] tags) returns Pet[]|error {
        string resourcePath = string `/pet/findByTags`;
        map<anydata> queryParam = {"tags": tags};
        map<Encoding> queryParamEncoding = {"tags": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        Pet[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Find pet by ID
    #
    # + petId - ID of pet to return
    # + return - successful operation
    remote isolated function getPetById(int petId) returns Pet|error {
        string resourcePath = string `/pet/${getEncodedUri(petId)}`;
        map<any> headerValues = {};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["api_key"] = self.apiKeyConfig?.api_key;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        Pet response = check self.clientEp->get(resourcePath, httpHeaders);
        return response;
    }
    # Updates a pet in the store with form data
    #
    # + petId - ID of pet that needs to be updated
    # + return - Invalid input
    remote isolated function updatePetWithForm(int petId, Pet_petId_body payload) returns http:Response|error {
        string resourcePath = string `/pet/${getEncodedUri(petId)}`;
        http:Request request = new;
        string encodedRequestBody = createFormURLEncodedRequestBody(payload);
        request.setPayload(encodedRequestBody, "application/x-www-form-urlencoded");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Deletes a pet
    #
    # + petId - Pet id to delete
    # + return - Invalid ID supplied
    remote isolated function deletePet(int petId, string? api_key = ()) returns http:Response|error {
        string resourcePath = string `/pet/${getEncodedUri(petId)}`;
        map<any> headerValues = {"api_key": api_key};
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Response response = check self.clientEp->delete(resourcePath, headers = httpHeaders);
        return response;
    }
    # uploads an image
    #
    # + petId - ID of pet to update
    # + return - successful operation
    remote isolated function uploadFile(int petId, PetId_uploadImage_body payload) returns ApiResponse|error {
        string resourcePath = string `/pet/${getEncodedUri(petId)}/uploadImage`;
        http:Request request = new;
        mime:Entity[] bodyParts = check createBodyParts(payload);
        request.setBodyParts(bodyParts);
        ApiResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns pet inventories by status
    #
    # + return - successful operation
    remote isolated function getInventory() returns json|error {
        string resourcePath = string `/store/inventory`;
        map<any> headerValues = {};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["api_key"] = self.apiKeyConfig?.api_key;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        json response = check self.clientEp->get(resourcePath, httpHeaders);
        return response;
    }
    # Place an order for a pet
    #
    # + request - order placed for purchasing the pet
    # + return - successful operation
    remote isolated function placeOrder(http:Request request) returns Order|error {
        string resourcePath = string `/store/order`;
        // TODO: Update the request as needed;
        Order response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Find purchase order by ID
    #
    # + orderId - ID of pet that needs to be fetched
    # + return - successful operation
    remote isolated function getOrderById(int orderId) returns Order|error {
        string resourcePath = string `/store/order/${getEncodedUri(orderId)}`;
        Order response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Delete purchase order by ID
    #
    # + orderId - ID of the order that needs to be deleted
    # + return - Invalid ID supplied
    remote isolated function deleteOrder(int orderId) returns http:Response|error {
        string resourcePath = string `/store/order/${getEncodedUri(orderId)}`;
        http:Response response = check self.clientEp-> delete(resourcePath);
        return response;
    }
    # Create user
    #
    # + request - Created user object
    # + return - successful operation
    remote isolated function createUser(http:Request request) returns http:Response|error {
        string resourcePath = string `/user`;
        // TODO: Update the request as needed;
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Creates list of users with given input array
    #
    # + request - List of user object
    # + return - successful operation
    remote isolated function createUsersWithArrayInput(http:Request request) returns http:Response|error {
        string resourcePath = string `/user/createWithArray`;
        // TODO: Update the request as needed;
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Creates list of users with given input array
    #
    # + request - List of user object
    # + return - successful operation
    remote isolated function createUsersWithListInput(http:Request request) returns http:Response|error {
        string resourcePath = string `/user/createWithList`;
        // TODO: Update the request as needed;
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Logs user into the system
    #
    # + username - The user name for login
    # + password - The password for login in clear text
    # + return - successful operation
    remote isolated function loginUser(string username, string password) returns string|error {
        string resourcePath = string `/user/login`;
        map<anydata> queryParam = {"username": username, "password": password};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        string response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Logs out current logged in user session
    #
    # + return - successful operation
    remote isolated function logoutUser() returns http:Response|error {
        string resourcePath = string `/user/logout`;
        http:Response response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Get user by user name
    #
    # + username - The name that needs to be fetched. Use user1 for testing.
    # + return - successful operation
    remote isolated function getUserByName(string username) returns User|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        User response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Updated user
    #
    # + username - name that need to be updated
    # + request - Updated user object
    # + return - Invalid user supplied
    remote isolated function updateUser(string username, http:Request request) returns http:Response|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        // TODO: Update the request as needed;
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Delete user
    #
    # + username - The name that needs to be deleted
    # + return - Invalid username supplied
    remote isolated function deleteUser(string username) returns http:Response|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        http:Response response = check self.clientEp-> delete(resourcePath);
        return response;
    }
}
