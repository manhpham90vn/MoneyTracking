//
//  HomeViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit
import MJRefresh

final class HomeViewController: BaseTableViewViewController {
    
    var presenter: HomePresenter!

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: presenter as AnyObject)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = addBtn
        
        let logOutBtn = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = logOutBtn
        
        tableView.register(cellType: HomeTableViewCell.self)
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        presenter.bind(paggingable: self)
        
        disposeBag ~ [
            Observable.merge(rx.viewWillAppear.mapTo(()),
                             headerRefreshTrigger.asObservable())
                ~> presenter.trigger,
            
            rx.viewWillAppear.mapTo(())
                ~> presenter.trigger,
            
            presenter.elements.bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.reuseIdentifier,
                                                           cellType: HomeTableViewCell.self)) { _, element, cell in
                cell.config(transaction: element)
            }
        ]
    }
    
    @objc
    func handleLogOut() {
        presenter.handleLogOut()
    }
    
    @objc
    func handleAdd() {
        presenter.handleAdd()
    }
    
    override func tableViewFooter() -> MJRefreshFooter? {
        nil
    }
    
}

extension HomeViewController: HomeViewInterface {}
