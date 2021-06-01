//
//  Covid19Api.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 9/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//


import Foundation



extension URLRequest {
    mutating func enableJson(){
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

enum WeatherAPI {
    static let API_KEY = "93b63d68b57bd7c4d83f59fc1b599b9d"
    enum ENDPOINT :String{
        case baseUrl = "https://api.openweathermap.org/data/2.5"
    
    
      enum LOOKUP {
            
        case getForcastLastDays(lon:Double,lat:Double,units:String,cnt:Int)
        
        case getCurrentWeather(lon:Double,lat:Double,units:String)
            
             var buildRequest:URLRequest!{
                
           switch self {
                          
                      case .getCurrentWeather(let lon, let lat,let units):
                         let urlLink = WeatherAPI.ENDPOINT.baseUrl.rawValue
                             
                           var request = URLRequest(url:URL(string: urlLink+"/weather?lon=\(lon)&lat=\(lat)&units=\(units)&appid=\(WeatherAPI.API_KEY)")!)
                                  request.httpMethod = "GET"
                                  request.enableJson()
                          
                          return request
                          
                      case .getForcastLastDays(let lon, let lat,let units,let cnt):
                         
                         
                          let urlLink = WeatherAPI.ENDPOINT.baseUrl.rawValue
                          
                      
                          var request = URLRequest(url:URL(string: urlLink+"/forecast?lon=\(lon)&lat=\(lat)&units=\(units)&cnt=\(cnt)&appid=\(WeatherAPI.API_KEY)")!)
                          request.httpMethod = "GET"
                           request.enableJson()
                      return request
                 

                                         
                     
                      }
                
             }
         }
    }
   
}
