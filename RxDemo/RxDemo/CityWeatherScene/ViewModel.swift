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
    func getWeatherlableTextStream() -> Observable<String>
    func getCityLabelTextStream() -> Observable<String>
    func getTemperatureLabelStream() -> Observable<String>
    func getDescriptionLabelStream() -> Observable<String>
    func getLoadingStream() -> Observable<Bool>
    func fetchWeather(city:String)
}


class ViewModel{
    
    let weatherLabelTextStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let cityLabelTextStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let temperatureLabelTextStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    let loadingStream : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let fetchWeather : BehaviorRelay<String> = BehaviorRelay(value: "")
    let descriptionLabelStream : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let usecase : UseCaseProtocol = UseCase()
    let disposeBag = DisposeBag()
    
    init() {
        bindSignal()
    }
}

extension ViewModel {
    func bindSignal() {
        usecase.getWeatherStream().map{$0.city}.bind(to: cityLabelTextStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{"天气:\($0.weather)"}.bind(to: weatherLabelTextStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{"\($0.temperature)"}.bind(to: temperatureLabelTextStream).disposed(by: disposeBag)
        usecase.getWeatherStream().map{"\($0.des)"}.bind(to: descriptionLabelStream).disposed(by: disposeBag)
        usecase.getWeatherLoadingStream().bind(to: loadingStream).disposed(by: disposeBag)
    }
}

extension ViewModel : ViewModelProtocol {
    func getDescriptionLabelStream() -> Observable<String> {
        return descriptionLabelStream.asObservable()
    }
    
    func fetchWeather(city: String) {
        usecase.fetchWeather(city: city)
    }
    
    func getLoadingStream() -> Observable<Bool> {
        return loadingStream.asObservable()
    }
    
    func getWeatherlableTextStream() -> Observable<String> {
        return weatherLabelTextStream.asObservable()
    }
    
    func getCityLabelTextStream() -> Observable<String> {
        return cityLabelTextStream.asObservable()
    }
    
    func getTemperatureLabelStream() -> Observable<String> {
        return temperatureLabelTextStream.asObservable()
    }
}

