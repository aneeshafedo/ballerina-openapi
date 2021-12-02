import  ballerina/http;

#Here you can find documentation for COVID-19 REST API.
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + serviceUrl - URL of the target service
    # + return - An error if connector initialization failed
    public isolated function init(http:ClientConfiguration clientConfig =  {}, string serviceUrl = "https://api-cov19.now.sh/") returns error? {
        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.clientEp = httpEp;
        return;
    }
    # List of all countries with COVID-19 cases
    #
    #+return-Default response with array of strings
    remote isolated function getCountryList() returns CountryInfo[]|error {
        string resourcePath = string `/api/v1/countries/list/`;
        CountryInfo[] response = check self.clientEp-> get(resourcePath);
        return response;
    }
}
