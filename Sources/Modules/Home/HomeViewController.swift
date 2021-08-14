//
//  HomeViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

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
        navigationItem.rightBarButtonItem = addBtn
        tableView.register(cellType: HomeTableViewCell.self)
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        presenter.bind(paggingable: self)
        Observable.just(()) ~> presenter.trigger ~ disposeBag
        presenter.elements.bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.reuseIdentifier,
                                                       cellType: HomeTableViewCell.self)) { _, element, cell in
            
        }
        ~ disposeBag
    }
    
    @objc
    func handleAdd() {
        presenter.handleAdd()
    }
    
}

extension HomeViewController: HomeViewInterface {}
