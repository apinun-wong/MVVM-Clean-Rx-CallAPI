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
        updateNavBarInNormalStatus()
    }
    
    @objc private func searchIconPressed(sender: UIButton) {
        updateNavBarInSearchStatus()
    }
    
    @objc private func closeIconPressed(sender: UIButton) {
        updateNavBarInNormalStatus()
    }
    
    private func updateNavBarInNormalStatus() {
        setUpStyleOfNavigationBar()
        setUpIconSearchInRightBar()
        setUpIconSearchInLeftBar()
        func setUpIconSearchInRightBar() {
            let iconButton = UIButton(type: .custom)
            let search = UIImage(systemName: "magnifyingglass")
            iconButton.setImage(search, for: .normal)
            iconButton.tintColor = .blue
            iconButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            iconButton.addTarget(self, action: #selector(self.searchIconPressed(sender:)), for: .touchUpInside)
            let iconBarButtonItem = UIBarButtonItem(customView: iconButton)
            navigationItem.rightBarButtonItem = iconBarButtonItem
        }
        
        func setUpIconSearchInLeftBar() {
            let iconButton = UIButton(type: .custom)
            let search = UIImage(systemName: "magnifyingglass")
            iconButton.setImage(search, for: .normal)
            iconButton.tintColor = .blue
            iconButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            iconButton.addTarget(self, action: #selector(self.searchIconPressed(sender:)), for: .touchUpInside)
            let iconBarButtonItem = UIBarButtonItem(customView: iconButton)
            navigationItem.rightBarButtonItem = iconBarButtonItem
        }
        
        func setUpStyleOfNavigationBar() {
            //Family: Ekkamai New Font names: ["EkkamaiNew-Regular", "EkkamaiNew-Thin", "EkkamaiNew-Bold"]
            guard let customFont = UIFont(name: "EkkamaiNew-Bold", size: 18) else {
                fatalError("Custom font not found")
            }
            let label = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 20))
            label.font = customFont
            label.textAlignment = .center
            label.text = viewModel.output.getTitle()
            navigationItem.titleView = label
        }
    }
    
    private func updateNavBarInSearchStatus() {
        let widthOfBar = UIScreen.main.bounds.width
        let searchBarWidth = widthOfBar - 60
        let searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, searchBarWidth, 18))
        searchBar.placeholder = "Wording..."
        setUpRightItem()
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        UIView.transition(with: navigationBar,
                          duration: 0.5, options: .transitionCrossDissolve,
                          animations: {
            self.navigationItem.titleView = searchBar
        }, completion: nil)
        
        func setUpRightItem() {
            let iconButton = UIButton(type: .custom)
            let search = UIImage(systemName: "xmark.circle")
            iconButton.setImage(search, for: .normal)
            iconButton.tintColor = .red
            iconButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            iconButton.addTarget(self, action: #selector(self.closeIconPressed(sender:)), for: .touchUpInside)
            let iconBarButtonItem = UIBarButtonItem(customView: iconButton)
            navigationItem.rightBarButtonItem = iconBarButtonItem
        }
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
