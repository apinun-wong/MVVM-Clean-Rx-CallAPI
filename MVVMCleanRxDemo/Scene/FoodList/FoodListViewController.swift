//
//  FoodListViewController.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import UIKit
import RxCocoa
import RxSwift

final class FoodListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<FoodListSectionType, FoodListItemType>? = nil
    var viewModel: FoodListViewModel!
    let bag: DisposeBag = DisposeBag()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: FoodListViewModel) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigation()
    }
    
    override func loadView() {
        super.loadView()
        bindIntputs()
        bindOutputs()
    }
    
    private func setUpNavigation() {
        //Family: Ekkamai New Font names: ["EkkamaiNew-Regular", "EkkamaiNew-Thin", "EkkamaiNew-Bold"]
        guard let customFont = UIFont(name: "EkkamaiNew-Bold", size: 18) else {
            fatalError("Custom font not found")
        }
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: customFont]
        
        //backbutton
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.font: customFont]
        appearance.backButtonAppearance = backButtonAppearance
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "กลับ", style: .plain, target: nil, action: nil)
        
        //set up config to navigation controller
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setUpTableView() {
        tableView.registerNib(type: FoodListItemTableViewCell.self)
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource<FoodListSectionType, FoodListItemType>(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            if let cell: FoodListItemTableViewCell = tableView.dequeueReusableCell() {
                cell.setUp(foodName: itemIdentifier.foodName,
                           calloriesText: itemIdentifier.callories,
                           portionText: itemIdentifier.portion)
               return cell
            }
            return UITableViewCell()
        })
    }
    
    private func bindIntputs() {
        rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.updateTypeOfFood.drive(onNext: { [weak self] section in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<FoodListSectionType, FoodListItemType>()
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
            self.dataSource?.apply(snapshot)
        }).disposed(by: bag)
    }
}

extension FoodListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
