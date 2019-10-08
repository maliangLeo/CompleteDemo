//
//  ViewModel.swift
//  RxDemo
//
//  Created by maliang on 2019/9/25.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    func getWeatherCityStream() -> Observable<String>
    func getWeatherTemperatureStream() -> Observable<String>
    func getWeatherStream() -> Observable<String>
    func getWeatherDescriptionStream() -> Observable<String>
    
    func getLoadingStream() -> Observable<Bool>
    func fetchWeather(city:String)
}


class ViewModel{
    
    let weatherCityStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let weatherTemperatureStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let weatherStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let weatherDescriptionStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let loadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let fetchWeather : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let usecase : UseCaseProtocol = UseCase()
    let disposeBag = DisposeBag()
    
    init() {
        bindSignal()
    }
}

extension ViewModel {
    func bindSignal() {
        usecase.getWeatherStream().map{($0?.city ?? "None")}.bind(to: weatherCityStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{("温度:\($0?.temperature ?? "None")")}.bind(to: weatherTemperatureStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{"天气:\($0?.weather ?? "None")"}.bind(to: weatherStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{($0?.des ?? "None")}.bind(to: weatherDescriptionStream).disposed(by: disposeBag)
        usecase.getWeatherLoadingStream().bind(to: loadingStream).disposed(by: disposeBag)
    }
}

extension ViewModel : ViewModelProtocol {
    func getWeatherCityStream() -> Observable<String> {
        return weatherCityStream.asObservable()
    }
    
    func getWeatherTemperatureStream() -> Observable<String> {
        return weatherTemperatureStream.asObservable()
    }
    
    func getWeatherStream() -> Observable<String> {
        return weatherStream.asObservable()
    }
    
    func getWeatherDescriptionStream() -> Observable<String> {
        return weatherDescriptionStream.asObservable()
    }
    
    func fetchWeather(city: String) {
        usecase.fetchWeather(city: city)
    }
    
    func getLoadingStream() -> Observable<Bool> {
        return loadingStream.asObservable()
    }
    
}

