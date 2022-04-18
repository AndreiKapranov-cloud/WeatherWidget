import { LightningElement,api,track,wire} from 'lwc';
import getLastSyncDetails from '@salesforce/apex/WeatherWidgetController.getLastSyncDetails';
import refreshWeather from '@salesforce/apex/WeatherWidgetController.refreshWeather';
import getCity from '@salesforce/apex/WeatherWidgetController.getCity';
import MOON_PICT from '@salesforce/resourceUrl/moon';
import SUNNY_PICT from '@salesforce/resourceUrl/sunny';
import FEW_CLOUDS_PICT from '@salesforce/resourceUrl/cloudy';
import SCATTERED_CLOUDS_PICT from '@salesforce/resourceUrl/scattered_clouds';
import BROKEN_CLOUDS from '@salesforce/resourceUrl/clouds';
import SHOWER_RAIN_PICT from '@salesforce/resourceUrl/shower_rain';
import RAIN_PICT from '@salesforce/resourceUrl/rain';
import STORM_PICT from '@salesforce/resourceUrl/storm';
import SNOW_PICT from '@salesforce/resourceUrl/snow';
import MIST_PICT from '@salesforce/resourceUrl/fog';
export default class WeatherWidget extends LightningElement {
    moonPict = MOON_PICT;
    sunPict = SUNNY_PICT;
    fewCloudsPict = FEW_CLOUDS_PICT;
    scatterdCloudsPict = SCATTERED_CLOUDS_PICT;
    brokenCloudsPict = BROKEN_CLOUDS;
    showerRainPict = SHOWER_RAIN_PICT;
    rainPict = RAIN_PICT;
    stormPict = STORM_PICT;
    snowPict = SNOW_PICT;
    mistPict = MIST_PICT;
   
    error;
    configuration;
    apiKey;
    displayCity;
    temperature;
    weatherDescription;
    weatherIcon;
    timestamp;
    isFormEnabled;
    defaultCity;
    
    @wire(getCity)
    wiredCity({ error, data }) {
        if (data) {
            this.defaultCity = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.defaultCity = undefined;
        }
    }
   

    connectedCallback() {
        this.getLastSync();
    }


    async getLastSync() {
        this.error = '';

        try {
            this.configuration = await getLastSyncDetails();
            this.populateValues();
        }
        catch (error) {
            console.error(error);
            this.error = error;
        }
    }

    async handleRefresh() {
        this.error = '';
        try {
            if(this.displayCity){           
            this.configuration = await refreshWeather({
            city : this.displayCity
            });
       }else{
           this.configuration = await refreshWeather({
               city : this.defaultCity        
               });
        }
            this.populateValues();
        }
        catch (error) {
            console.error(error);
            this.error = error;
        }
    }


    populateValues() {
        const configuration = this.configuration;
        this.isFormEnabled = false;

        if(configuration) {
            this.displayCity = configuration.a_kap__City__c;
            this.temperature = configuration.a_kap__Temperature__c;
            this.weatherDescription = configuration.a_kap__Weather_Description__c;
            this.apiKey = configuration.a_kap__API_Key__c;
            this.timestamp = configuration.Last_Synced_on__c;
        
            switch (configuration.a_kap__Icon_Name__c) { 
            case '01d': this.weatherIcon = this.sunPict; 
            break;
            case '01n': this.weatherIcon = this.moonPict;
            break; 
            case '02d': case '02n': this.weatherIcon = this.fewCloudsPict;
            break;
            case '03d': case'03n': this.weatherIcon = this.scatterdCloudsPict; 
            break;
            case '04d': case '04n': this.weatherIcon = this.brokenCloudsPict;
            break;
            case '09d': case '09n': this.weatherIcon = this.showerRainPict; 
            break;
            case '10d': case '10n': this.weatherIcon = this.rainPict; 
            break;
            case '11d': case '11n': this.weatherIcon = this.stormPict; 
            break;
            case '13d': case '13n': this.weatherIcon = this.snowPict; 
            break;
            case '50d': case '50n': this.weatherIcon = this.mistPict; 
            break;
            default: console.log("value of icon is not equal to any given icons");
            break;
            }
        }
        else {
            this.isFormEnabled = true;
        }
    }


    updateValue(event) {
        let element = event.target.name;
        let value = event.target.value;
        if(element === 'inputCity') {
            this.displayCity = value;
        }
        if(element === 'inputApiKey') {
            if(value !== '') {
                this.apiKey = value;
            }
        }
    }


    handleFormSave() {
        this.handleRefresh();
    }


    handleEdit() {
        this.isFormEnabled = true;
        this.displayCity = null;
    }

}