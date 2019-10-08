//
//  CityListUseCase.swift
//  RxDemo
//
//  Created by maliang on 2019/10/8.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CityListProtocol {
    func getListDataSourceStream() -> Observable<Array<String>>
    func getCity(at index:Int) -> String
}

class CityListUseCase {
    
    var arr : [String]
    init() {
        arr = ["大连","北京","广州","乌鲁木齐","长沙","武汉"]
    }
    
}

extension CityListUseCase: CityListProtocol {
    func getCity(at index: Int) -> String {
        return arr[index]
    }
    
    func getListDataSourceStream() -> Observable<Array<String>> {
        return Observable.just(arr)
    }
    
}
