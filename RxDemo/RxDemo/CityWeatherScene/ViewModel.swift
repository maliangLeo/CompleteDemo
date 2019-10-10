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
    func getCityLabelTextStream() -> Observable<String>
    func getTemperatureLabelTextStream() -> Observable<String>
    func getWeatherLabelTextStream() -> Observable<String>
    func getDesLabelTextStream() -> Observable<String>
    func getErrorStream() -> Observable<Error?>
    func getLoadingStream() -> Observable<Bool>
    func fetchWeather(city:String)
}


class ViewModel{
    
    private let weatherCityStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    private let weatherTemperatureStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    private let weatherStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    private let weatherDescriptionStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let loadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let fetchWeather : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let usecase : UseCaseProtocol = UseCase()
    private let disposeBag = DisposeBag()
    
    init() {
        bindSignal()
    }
}

extension ViewModel {
    func bindSignal() {
        usecase.getWeatherStream().map{($0?.city ?? "None")}.bind(to: weatherCityStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{("温度:\($0?.temperature ?? "None")")}.bind(to: weatherTemperatureStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{"天气:\($0?.weather ?? "None")"}.bind(to: weatherStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{($0?.dressingAdvice ?? "None")}.bind(to: weatherDescriptionStream).disposed(by: disposeBag)
        usecase.getWeatherLoadingStream().bind(to: loadingStream).disposed(by: disposeBag)
    }
}

extension ViewModel : ViewModelProtocol {
    func getCityLabelTextStream() -> Observable<String> {
        return weatherCityStream.asObservable()
    }
    
    func getTemperatureLabelTextStream() -> Observable<String> {
        return weatherTemperatureStream.asObservable()
    }
    
    func getWeatherLabelTextStream() -> Observable<String> {
        return weatherStream.asObservable()
    }
    
    func getDesLabelTextStream() -> Observable<String> {
        return weatherDescriptionStream.asObservable()
    }
    
    func fetchWeather(city: String) {
        usecase.fetchWeather(city: city)
    }
    
    func getLoadingStream() -> Observable<Bool> {
        return loadingStream.asObservable()
    }
    
    func getErrorStream() -> Observable<Error?> {
        return usecase.requestWeatherErrorStream()
    }
}

