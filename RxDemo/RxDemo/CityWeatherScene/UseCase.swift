//
//  UseCase.swift
//  RxDemo
//
//  Created by maliang on 2019/9/25.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Weather {
    let city : String
    let weather : String
    let temperature : String
    let des : String
}

protocol UseCaseProtocol {
    func getWeatherStream() -> Observable<Weather?>
    func getWeatherLoadingStream() -> Observable<Bool>
    func fetchWeather(city:String)
}

class UseCase {
    
    let disposeBag = DisposeBag()
    let weatherRequestLoadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let weatherRequestErrorStream : BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    let weatherStream : BehaviorRelay<Weather?>
    
    
    init() {
        
        weatherStream = BehaviorRelay(value: nil)
        
    }
    
}

extension UseCase : UseCaseProtocol {
    func fetchWeather(city:String) {
        weatherRequestLoadingStream.accept(true)
        weatherProvider.rx.request(.getByCity(city))
            .subscribe{ [weak self] event in
            switch event {
            case let .success(response):
                //数据处理
                self?.weatherRequestLoadingStream.accept(false)
                self?.weatherRequestErrorStream.accept(nil)
                guard let dict = try? JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String:Any] else {
                    return
                }
                let today: [String: AnyObject] = ((dict["result"]) as! [String: AnyObject])["today"] as! [String:AnyObject]
                let wea = today["weather"] as! String
                let temp = today["temperature"] as! String
                let description = today["dressing_advice"] as! String
                self?.weatherStream.accept(Weather(city: city, weather: wea, temperature: temp, des: description))
                
            case let .error(error):
                self?.weatherRequestLoadingStream.accept(false)
                self?.weatherRequestErrorStream.accept(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func getWeatherLoadingStream() -> Observable<Bool> {
        return weatherRequestLoadingStream.asObservable()
    }
    
    
    func getWeatherStream() -> Observable<Weather?> {
        return weatherStream.asObservable()
    }
}
