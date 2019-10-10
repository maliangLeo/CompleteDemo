//
//  Weather.swift
//  RxDemo
//
//  Created by maliang on 2019/10/10.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit

struct WeatherResult : Codable {
    
    var errorCode : Int
    var resultCode : String
    var reason : String
    var result : TodayWeather
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case resultCode = "resultcode"
        case reason
        case result
    }
    
}


struct TodayWeather : Codable {
    var today : Weather
}

struct Weather : Codable {
    
    var city : String = ""
    var weather : String = ""
    var temperature : String = ""
    var dressingAdvice : String = ""
    
    enum CodingKeys: String, CodingKey {
        case city
        case weather
        case temperature
        case dressingAdvice = "dressing_advice"
    }
    
}

