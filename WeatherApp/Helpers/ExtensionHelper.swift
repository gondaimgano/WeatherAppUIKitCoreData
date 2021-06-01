//
//  ExtensionHelper.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 1/6/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation

//MARK:- APPEND DEGREEE
extension Double{
    func toInt()->Int{
        
        return Int(self)
    }
    func appendDegree()->String{
       
        return "\(toInt() ) \u{00B0}"
    }
}

//MARK:- CONVERTERS FROM INT/IN64 TO DAY OR TIME FORMAT
extension Int{
   func toDay()->String{
        let format = DateFormatter()
        let epochTime = TimeInterval(self)
        let date = Date(timeIntervalSince1970: epochTime)
         format.dateFormat = "dd"
          let day = format.string(from: date)
    return day
    }
    func toTime()->String{
         let format = DateFormatter()
        format.amSymbol = "AM"
        format.pmSymbol = "PM"
         let epochTime = TimeInterval(self)
         let date = Date(timeIntervalSince1970: epochTime)
          format.dateFormat = "HH:mm a"
           let day = format.string(from: date)
     return day
     }
}

extension Int64{
   func toDay()->String{
        let format = DateFormatter()
        let epochTime = TimeInterval(self)
        let date = Date(timeIntervalSince1970: epochTime)
         format.dateFormat = "EEEE"
          let day = format.string(from: date)
    return day
    }
    func toTime()->String{
           let format = DateFormatter()
        format.amSymbol = "AM"
        format.pmSymbol = "PM"
           let epochTime = TimeInterval(self)
           let date = Date(timeIntervalSince1970: epochTime)
            format.dateFormat = "HH:mm a"
             let day = format.string(from: date)
       return day
       }
}
