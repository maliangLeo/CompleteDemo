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
    func getHometownWeatherStream() -> Observable<Weather?>
    func getWeatherLoadingStream() -> Observable<Bool>
    func getHomeWeatherLoadingStream() -> Observable<Bool>
    
    func requestWeatherErrorStream() -> Observable<Error?>
    func requestHomeWeatherErrorStream() -> Observable<Error?>
    func fetchWeather(city:String)
}

class UseCase {
    
    private let disposeBag = DisposeBag()
    private let weatherRequestLoadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let homeWeatherRequestLoadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let weatherRequestErrorStream : BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let homeWeatherRequestErrorStream : BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let weatherStream : BehaviorRelay<Weather?> = BehaviorRelay(value: nil)
    private let hometownWeatherStream : BehaviorRelay<Weather?> = BehaviorRelay(value: nil)
    
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
                self?.weatherRequestErrorStream.accept(error)
                print("======json error\(error)=======")
            }
            
        }) { [weak self](error) in
            self?.weatherRequestLoadingStream.accept(false)
            self?.weatherRequestErrorStream.accept(error)
        }
        .disposed(by: disposeBag)
        
        homeWeatherRequestLoadingStream.accept(true)
        weatherProvider.rx.request(.getByCity("锦州")).subscribe(onSuccess: { [weak self](response) in
            self?.homeWeatherRequestLoadingStream.accept(false)
            self?.homeWeatherRequestErrorStream.accept(nil)
            
            do {
                let wea = try JSONDecoder().decode(WeatherResult.self, from: response.data)
                self?.hometownWeatherStream.accept(wea.result.today)
            }catch {
                self?.homeWeatherRequestErrorStream.accept(error)
                print("======json error\(error)=======")
            }
        }) { [weak self](error) in
            self?.homeWeatherRequestLoadingStream.accept(false)
            self?.homeWeatherRequestErrorStream.accept(error)
        }.disposed(by: disposeBag)
    }
    
    func getWeatherLoadingStream() -> Observable<Bool> {
        return weatherRequestLoadingStream.asObservable()
    }
    
    func getHomeWeatherLoadingStream() -> Observable<Bool> {
        return homeWeatherRequestLoadingStream.asObservable()
    }
    
    func requestWeatherErrorStream() -> Observable<Error?> {
        return weatherRequestErrorStream.asObservable()
    }
    
    func requestHomeWeatherErrorStream() -> Observable<Error?> {
        return homeWeatherRequestErrorStream.asObservable()
    }
    
    func getWeatherStream() -> Observable<Weather?> {
        return weatherStream.asObservable()
    }
    
    func getHometownWeatherStream() -> Observable<Weather?> {
        return hometownWeatherStream.asObservable()
    }
}
