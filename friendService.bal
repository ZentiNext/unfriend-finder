import ballerina/http;
import ballerina/io;
import biruntha13/facebook;

string client_id = "2095658253842169";
string redirect_uri = "https://2a711e0d.ngrok.io/unfriendfinder/getAuth";
string access_code_redirect_uri = "https://2a711e0d.ngrok.io/unfriendfinder/getAccessCode";
string client_secret = "df9a37c271971bb30fa688e0fef7c0d5";

endpoint http:Listener listener {
    port: 9090
};

endpoint http:Client postClient {
    url: "https://www.facebook.com/v3.1/dialog/oauth?client_id=" + client_id + "&redirect_uri=" + redirect_uri
};

@http:ServiceConfig {
    basepath: "/api"
}
service<http:Service> unfriendfinder bind listener{
    
    // The callback URI resource
    @http:ResourceConfig {
        method: "GET",
        path: "/getAuth"
    }
    getAuth() {
        string url = "https://graph.facebook.com/oauth/access_token?client_id=" + client_id + "&redirect_uri=" + access_code_redirect_uri + "&client_secret=" + client_secret +"&code=" + code;
        http:Response resp = check postClient->post();
        io:println(check resp.getTextPayload());
    }


    // @http:ResourceConfig {
    //     method: "GET",
    //     path: "/hello"
    // }
    // sayHello(endpoint client, http:Request req) {
        
    //     http:Response response;
    //     json payload = {message: "Hello"};
    //     response.setJsonPayload(untaint payload, contentType = "application/json");

    //     _= client->respond(response);

    // }

}

