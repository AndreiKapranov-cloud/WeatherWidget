public with sharing class YTController {
    private static final String SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search';
    private static final String API_KEY = 'AIzaSyB-eKeEY_H9XxiWYi0r-9jnkii6qiJHZT4'; //Put your API_KEY here 

    @AuraEnabled(cacheable=true)
    public static list<mywrapper> getYTVideos(string searchKey){
        searchKey = searchKey == null ? 'salesforce' : searchKey;
        // YouTube API Callouts
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Httpresponse res = null;
        String endpoint  = SEARCH_URL +
        '?part=snippet' +
        '&maxResults=20' +
        '&type=video' +
        '&q=' + EncodingUtil.urlEncode(searchKey, 'UTF-8') +
        '&key=' + API_KEY;

        req.setEndPoint(endpoint);
        req.setMethod('GET');
        res = http.send(req);

        //Deserializing json data
        YouTubeResult.Response response = (YouTubeResult.Response)JSON.deserialize(res.getBody(), YouTubeResult.Response.class);
        List<YouTubeResult.Item> items  =  response.items;

        //Filling Wrapper Data for lightning component
        List<mywrapper> wrp  = new List<mywrapper>();

        for (YouTubeResult.Item itemObj : items) {
            mywrapper YTWrap = new mywrapper();
            YTWrap.videoId = itemObj.id.videoId;
            YTWrap.description = itemObj.Snippet.description;
            YTWrap.thumbnails = itemObj.Snippet.thumbnails.medium.url;
            YTWrap.title = itemObj.Snippet.title;
            YTWrap.channelTitle = itemObj.Snippet.channelTitle;

            wrp.add(YTWrap);
        }
        return wrp;

    }
    public class mywrapper{
        @AuraEnabled public string videoId {get;set;}
        @AuraEnabled public string description {get;set;}
        @AuraEnabled public String thumbnails {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public String channelTitle {get;set;}
        @AuraEnabled public String publishedAt  {get;set;}
    }
}