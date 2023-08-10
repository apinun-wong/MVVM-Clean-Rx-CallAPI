//
//  ViewController.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    let bag = DisposeBag()
    var viewModel: HomeViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HomeSectionType, HomeItemType>? = nil
    
    public override func loadView() {
        super.loadView()
        bindInput()
        bindOutput()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        self.title = "Home"
    }
    
    private func setUpCollectionView() {
        collectionView.registerNib(type: MenuHomeCollectionViewCell.self)
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        dataSource = UICollectionViewDiffableDataSource<HomeSectionType, HomeItemType>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if let cell: MenuHomeCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) {
                cell.setUp(text: itemIdentifier.title)
                return cell
            }
            return UICollectionViewCell()
        })
    }

    private func bindInput() {
        rx.viewDidLoad.bind(to: self.viewModel.input.viewDidLoad).disposed(by: bag)
        rx.viewWillAppear.bind(to: self.viewModel.input.viewWillAppear).disposed(by: bag)
    }
    
    private func bindOutput() {
        viewModel.output.updateTypeOfFood.drive(onNext: { [weak self] section in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<HomeSectionType, HomeItemType>()
            snapshot.appendSections([section])
            snapshot.appendItems(section.items)
            self.dataSource?.apply(snapshot)
        }).disposed(by: bag)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    cell.transform = .identity
                }, completion: { _ in
                    self.routeToNextPage(indexPath: indexPath)
                })
            }
        }
    }
    
    private func routeToNextPage(indexPath: IndexPath) {
        let datas = viewModel.output.getItemsFromMenu(index: indexPath.row)
        let vc = FoodListViewController(nibName: "FoodListViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
