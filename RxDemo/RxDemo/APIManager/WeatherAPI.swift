//
//  WeatherAPI.swift
//  RxDemo
//
//  Created by maliang on 2019/9/26.
//  Copyright © 2019 maliang. All rights reserved.
//

import Foundation
import Moya

//key ,免费使用500次
let serverKey = "91ce6b59e121a156b50c5de2bb6a420f"

let weatherProvider = MoyaProvider<WeatherAPI>()

public enum WeatherAPI {
    case getByCity(String)
}

//请求配置
extension WeatherAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://v.juhe.cn")!
    }
    
    public var path: String {
        return "/weather/index"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .getByCity(let city):
            var params:[String:Any] = [:]
            params["cityname"] = city
            params["key"] = serverKey
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}

