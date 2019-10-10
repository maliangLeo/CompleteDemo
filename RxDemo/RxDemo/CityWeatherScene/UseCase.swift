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


protocol UseCaseProtocol {
    func getWeatherStream() -> Observable<Weather?>
    func getWeatherLoadingStream() -> Observable<Bool>
    func requestWeatherErrorStream() -> Observable<Error?>
    
    func fetchWeather(city:String)
}

class UseCase {
    
    private let disposeBag = DisposeBag()
    private let weatherRequestLoadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let weatherRequestErrorStream : BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let weatherStream : BehaviorRelay<Weather?> = BehaviorRelay(value: nil)
    
    init() {
        
    }
    
}

extension UseCase : UseCaseProtocol {
    func fetchWeather(city:String) {
        
        weatherRequestLoadingStream.accept(true)
        
        weatherProvider.rx.request(.getByCity(city))
        .subscribe(onSuccess: { [weak self](response) in
            self?.weatherRequestLoadingStream.accept(false)
            self?.weatherRequestErrorStream.accept(nil)
            
            do {
                let wea = try JSONDecoder().decode(WeatherResult.self, from: response.data)
                self?.weatherStream.accept(wea.result.today)
            }catch {
                
                print("======json error\(error)=======")
            }
            
        }) { [weak self](error) in
            self?.weatherRequestLoadingStream.accept(false)
            self?.weatherRequestErrorStream.accept(error)
        }
        .disposed(by: disposeBag)
        
    }
    
    func getWeatherLoadingStream() -> Observable<Bool> {
        return weatherRequestLoadingStream.asObservable()
    }
    
    func requestWeatherErrorStream() -> Observable<Error?> {
        return weatherRequestErrorStream.asObservable()
    }
    
    func getWeatherStream() -> Observable<Weather?> {
        return weatherStream.asObservable()
    }
}
