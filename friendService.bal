import ballerina/http;
import ballerina/io;
import biruntha13/facebook;

string client_id = "2095658253842169";
string redirect_uri = "https://2a711e0d.ngrok.io/unfriendfinder/getAuth";
string access_code_redirect_uri = "https://2a711e0d.ngrok.io/unfriendfinder/getAuth";
string client_secret = "df9a37c271971bb30fa688e0fef7c0d5";
string code = "";
string accessCode = "";

endpoint http:Listener listener {
    port: 9090
};

endpoint http:Client postClient {
    url: "https://www.facebook.com/v3.1/dialog/oauth?client_id=" + client_id + "&redirect_uri=" + redirect_uri
};

endpoint http:Client getAccessCodePost {
    url: "https://graph.facebook.com/oauth/access_token?client_id=" + client_id + "&redirect_uri=" + access_code_redirect_uri + "&client_secret=" + client_secret +"&code="
};

endpoint facebook:Client facebookEP {
    clientConfig:{
        auth:{
            accessToken:accessCode
        }
    }
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
    getAuth(endpoint client, http:Request req) {
        map codeReq = req.getQueryParams();
        code = untaint <string>codeReq.code;
        http:Response resp = check getAccessCodePost->post(untaint code,"");
        json response = check resp.getJsonPayload();
        io:println(response.access_token);
        accessCode = untaint response.access_token.toString();
        // getFriendList(accessCode);
        var fbRes = facebookEP -> getFriendListDetails(accessCode);
        match fbRes {
            facebook:FriendList list => {
                io:println(list.data);       
            }
            facebook:FacebookError e => io:println(e);
        }
    }

    // getFriendList(string token) {
    //     var fbRes = facebookEP -> getFriendListDetails(token);
    //     match fbRes {
    //         facebook:FriendList list => {
    //             io:println(list.data);       
    //         }
    //         facebook:FacebookError e => io:println(e);
    //     }
    // }

    // The authAPI URI resource
    // @http:ResourceConfig {
    //     method: "GET",
    //     path: "/getauthcode"
    // }
    // getAuthCode(endpoint client, http:Request req) {
    //     // map code = req.getQueryParams();
    //     // string coder = <string>code.code;
    //     // string url = "https://graph.facebook.com/oauth/access_token?client_id=" + client_id + "&redirect_uri=" + access_code_redirect_uri + "&client_secret=" + client_secret +"&code=" + code;
    //     io:println(code);
    //     http:Response resp = check getAccessCodePost->post(code,"");
    //     io:println(check resp.getTextPayload());
    // }


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

