//
//  CityListViewController.swift
//  RxDemo
//
//  Created by maliang on 2019/9/27.
//  Copyright © 2019 maliang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel : CityListViewModelProtocol & UITableViewDataSource = CityListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        bindViewModel()
        
    }
    
    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = viewModel
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.getBlockListStream().subscribe().disposed(by: disposeBag)
    }
    
}

extension CityListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.getSelectCityStream(at: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.city = city
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
