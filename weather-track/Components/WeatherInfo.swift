//
//  WeatherInfo.swift
//  weather-track
//
//  Created by David Bowen on 6/21/18.
//  Copyright © 2018 David Bowen. All rights reserved.
//

import SwiftyJSON

struct WeatherData {
    
    var temperature: String
    var description: String
    var icon: String
    
    init(data: Any) {
        let json = JSON(data)
        let currentWeather = json["currently"]
        
        if let temperature = currentWeather["temperature"].float {
            self.temperature = String(format: "%.0f", temperature) + " ºF"
        } else {
            self.temperature = "--"
        }
        
        self.description = currentWeather["summary"].string ?? "--"
        self.icon = currentWeather["icon"].string ?? "--"
    }
}
