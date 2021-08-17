//
//  HomeViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit
import MJRefresh
import PopupDialog

final class HomeViewController: BaseTableViewViewController {
    
    var presenter: HomePresenter!
    var header: HomeHeader!

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: presenter as AnyObject)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        
        let addBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        let filterBtn = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(handleFilter))
        navigationItem.leftBarButtonItems = [addBtn, filterBtn]
        
        let logOutBtn = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = logOutBtn
        
        tableView.register(cellType: HomeTableViewCell.self)
        tableView.rx.setDelegate(self) ~ disposeBag
        
        header = HomeHeader()
        header.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 100)
        header.loadNibContent()
        tableView.tableHeaderView = header
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        presenter.bind(paggingable: self)
        
        disposeBag ~ [
            Observable.merge(rx.viewWillAppear.mapTo(()),
                             headerRefreshTrigger.asObservable())
                ~> presenter.trigger,
            
            presenter.elements.bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.reuseIdentifier,
                                                           cellType: HomeTableViewCell.self)) { _, element, cell in
                cell.config(transaction: element)
            },
            
            tableView.rx.modelSelected(Transaction.self) ~> presenter.triggerSelect,
            
            presenter.userInfo.unwrap() ~> rx.userInfo
        ]
    }
    
    @objc
    func handleFilter() {
        var selectedDate = Date()
        let popup = PopupView(nibName: "PopupView", bundle: nil)
        popup.loadViewIfNeeded()
        popup.datePicker.onDateSelected = { month, year in
            let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
            var date = DateComponents()
            date.year = year
            date.month = month
            selectedDate = gregorianCalendar.date(from: date) ?? Date()
        }
        let cancelButton = CancelButton(title: "Clean Filter") { [weak self] in
            guard let self = self else { return }
            self.presenter.selectedRange.accept(.all)
        }
        let okButton = DefaultButton(title: "OK") { [weak self] in
            guard let self = self else { return }
            self.presenter.selectedRange.accept(.range(date: selectedDate))
        }
        let vc = PopupDialog(viewController: popup)
        vc.addButtons([cancelButton, okButton])
        present(vc, animated: true, completion: nil)
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, handle in
            guard let transaction = self?.presenter.elements.value[indexPath.row] else { return }
            self?.presenter.triggerRemoveAt.accept(transaction)
            handle(true)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension Reactive where Base: HomeViewController {
    var userInfo: Binder<User> {
        Binder(base) { vc, user in
            vc.header.config(user: user,
                             range: vc.presenter.selectedRange.value,
                             amount: vc.presenter.filtetedAmount.value)
        }
    }
}
