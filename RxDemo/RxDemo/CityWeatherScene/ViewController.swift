//
//  ViewController.swift
//  RxDemo
//
//  Created by maliang on 2019/9/20.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var viewmodel : ViewModelProtocol = ViewModel()
    
    public var city : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTextSignal()
        
    }
    
    
    func bindTextSignal() {
        viewmodel.fetchWeather(city: city!)
        viewmodel.getWeatherCityStream().bind(to: cityLabel.rx.text).disposed(by: disposeBag)
        viewmodel.getWeatherTemperatureStream().bind(to: temperatureLabel.rx.text).disposed(by: disposeBag)
        viewmodel.getWeatherStream().bind(to: weatherLabel.rx.text).disposed(by: disposeBag)
        viewmodel.getWeatherDescriptionStream().bind(to: desLabel.rx.text).disposed(by: disposeBag)
        
        viewmodel.getLoadingStream().subscribe(onNext: {[weak self](result) in
            if (result) {
                HUD.show(.progress, onView: self?.view)
            }else {
                HUD.hide()
            }
        }).disposed(by: disposeBag)
        
    }
    
}

