@isTest(SeeAllData=true)
public class WeatherWidgetControllerTest {
    
    @isTest static void testWidRef(){
     
    Test.setMock(HttpCalloutMock.class, new GetResponceFromApiMock());  
   
    WeatherWidgetController.refreshWeather('Moscow'); 
    WeatherWidgetController.getCity();
    }  
}