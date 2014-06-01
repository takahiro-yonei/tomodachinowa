@isTest
global class UnitTest_MockHttpResGenerator implements HttpCalloutMock {
	
		
	global HTTPResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"success":"true", "errorMessage":"", "total":"1", "records":[]}');
    res.setStatusCode(200);

    return res;
  }
}