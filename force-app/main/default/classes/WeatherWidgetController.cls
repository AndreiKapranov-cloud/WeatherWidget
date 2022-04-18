public with sharing class WeatherWidgetController {
  
  @AuraEnabled
  public static a_kap__Weather_Widget_Configuration__c getLastSyncDetails() {
      try {
        a_kap__Weather_Widget_Configuration__c result = a_kap__Weather_Widget_Configuration__c.getValues('Default');
          return result;
      }
      catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
  }


  @AuraEnabled
  public static a_kap__Weather_Widget_Configuration__c refreshWeather(String city) {
      try {
          a_kap__W_Wid__mdt credentials = a_kap__W_Wid__mdt.getInstance('City_and_Api_Key');
          
          String responseBody;
          if (city == null){
          responseBody = getResponseFromAPI(credentials.a_kap__City__c,credentials.a_kap__WeatherMapApiKey__c); 
          }else{
          responseBody = getResponseFromAPI(city,credentials.a_kap__WeatherMapApiKey__c);
          }

          Map<String, Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
          a_kap__Weather_Widget_Configuration__c configRec = new a_kap__Weather_Widget_Configuration__c();
          configRec = getLastSyncDetails();

          String cityName = String.valueOf(responseMap.get('name'));

          Map<String,Object> sysMap = (Map<String,Object>)responseMap.get('sys');
          String countryName = String.valueOf(sysMap.get('country'));

          Map<String,Object> mainMap = (Map<String,Object>)responseMap.get('main');
          Double temperature = Double.valueOf(mainMap.get('temp'));
          List<Object> weatherList = (List<Object>)responseMap.get('weather');
          Map<String,Object> weatherInfo = (Map<String,Object>)weatherList[0];
          String weatherDesc = String.valueOf(weatherInfo.get('description'));
          String weatherIcon = String.valueOf(weatherInfo.get('icon'));

          configRec.name = 'Default';
         if(cityName == null && countryName == null){
            configRec.City__c = credentials.a_kap__City__c;
         }else{
          configRec.City__c = cityName + ', ' + countryName;
         }
          configRec.Temperature__c = temperature;
          configRec.Weather_Description__c = weatherDesc;
          configRec.Icon_Name__c = weatherIcon;
          configRec.API_Key__c = credentials.a_kap__WeatherMapApiKey__c;
          configRec.Last_Synced_on__c = Datetime.now();

          upsert configRec;

          return configRec;
      }
      catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
  }


  // PRIVATE

  private static String getResponseFromAPI(String city, String apiKey) {
      String result;
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      String unit = 'metric';
      String endpoint = 'https://api.openweathermap.org/data/2.5/weather?';
      endpoint += 'q=' + city + '&appid=' + apiKey + '&units=' + unit;
      request.setEndpoint(endpoint);
      request.setMethod('GET');
      HttpResponse res = http.send(request);
      result = res.getBody();

      if(res.getStatusCode() == 401){
          throw new AuraHandledException('Invalid API Key');
      }

      if(res.getStatusCode() == 404){
          throw new AuraHandledException('City not found');
      }

      return result;
  }
  @AuraEnabled
  public static String getCity() {
  return a_kap__W_Wid__mdt.getInstance('City_and_Api_Key').a_kap__City__c;
  }
  
}
