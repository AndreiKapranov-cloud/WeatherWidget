@isTest
global class GetResponceFromApiMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "coord": {"lon": -0.1257,"lat": 51.5085 },"weather": [  {"id": 804,"main": "Clouds","description": "overcast clouds","icon": "04d" }],"base": "stations","main": {"temp": 40,"feels_like": 285.16, "temp_min": 284.87, "temp_max": 287.45,"pressure": 1018,"humidity": 67 },"visibility": 10000,"wind": {"speed": 2.57,"deg": 270},"clouds": { "all": 100},"dt": 1650273309,"sys": {"type": 2,"id": 2019646, "country": "GB", "sunrise": 1650257909,"sunset": 1650308451},"timezone": 3600,"id": 2643743,"name": "London","cod": 200}');
        response.setStatusCode(200);
        return response; 
    }
  }