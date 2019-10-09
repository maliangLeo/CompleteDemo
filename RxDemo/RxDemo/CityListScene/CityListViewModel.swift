//
//  CityListViewModel.swift
//  RxDemo
//
//  Created by maliang on 2019/10/8.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


protocol CityListViewModelProtocol {
    func getBlockListStream() -> Observable<[String]>
    func getSelectCityStream(at indexPath:IndexPath) -> String
}

class CityListViewModel: NSObject {
    private let useCase : CityListProtocol = CityListUseCase()
    private let cellData : BehaviorRelay<[String]> = BehaviorRelay(value: [])
}

extension CityListViewModel : CityListViewModelProtocol {
    func getSelectCityStream(at indexPath: IndexPath) -> String {
        return useCase.getCity(at: indexPath.row)
    }
    
    func getBlockListStream() -> Observable<[String]> {
        return useCase.getListDataSourceStream().do(onNext:{[weak self] (cellData) in
            self?.cellData.accept(cellData)
        })
    }
}

extension CityListViewModel : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell" ,for: indexPath)
        let data = cellData.value[indexPath.row]
        cell.textLabel?.text = data
        
        return cell
    }
    
}

