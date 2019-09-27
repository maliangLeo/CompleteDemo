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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        
        let obs = Observable.just(["大连","北京","广州","乌鲁木齐","长沙","武汉"])
        obs.bind(to: tableView.rx.items){(tableView,row,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
            cell.textLabel?.text = element
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext:{[weak self] item in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.city = item
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
