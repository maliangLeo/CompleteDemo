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
    func getWeatherModelStream() -> Observable<Weather?>
    func getLoadingStream() -> Observable<Bool>
    func fetchWeather(city:String)
}


class ViewModel{
    
    let weatherModelStream : BehaviorRelay<Weather?> = BehaviorRelay(value: nil)
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
        usecase.getWeatherStream().bind(to: weatherModelStream).disposed(by: disposeBag)
        usecase.getWeatherLoadingStream().bind(to: loadingStream).disposed(by: disposeBag)
    }
}

extension ViewModel : ViewModelProtocol {
    func getWeatherModelStream() -> Observable<Weather?> {
        return weatherModelStream.asObservable()
    }
    
    func fetchWeather(city: String) {
        usecase.fetchWeather(city: city)
    }
    
    func getLoadingStream() -> Observable<Bool> {
        return loadingStream.asObservable()
    }
    
}

