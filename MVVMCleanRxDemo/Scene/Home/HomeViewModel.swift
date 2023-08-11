//
//  HomeViewModel.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeInput {
    var viewDidLoad: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
}

protocol HomeOutput {
    var updateTypeOfFood: Driver<HomeSectionType> { get set }
    func getItemsFromMenu(index: Int) -> [FoodData]
    func getTitleFromMenu(index: Int) -> String
    var isLoading: Driver<Bool> { get }
}

protocol HomeViewModel: HomeInput, HomeOutput {
    var input: HomeInput { get }
    var output: HomeOutput { get }
}

final class HomeViewModelImpl: HomeViewModel {
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
    
    private let bag = DisposeBag()
    
    // Input
    var viewDidLoad: PublishRelay<Void> = .init()
    var viewWillAppear: PublishRelay<Void> = .init()
    
    // Output
    var updateTypeOfFood: Driver<HomeSectionType> = .empty()
    var isLoading: Driver<Bool> = .empty()
    
    var items: BehaviorRelay<[FoodModelResponse]> = .init(value: [])
    
    init(getFoodListUsecase: GetFoodListUsecase) {
        let activityIndicator = ActivityIndicator()
        isLoading = activityIndicator
            .skip(1)
            .asDriver()
        
        let getFoodListEvent = viewDidLoad
            .flatMap { _ in
                return getFoodListUsecase
                    .execute()
                    .trackActivity(activityIndicator)
                    .materialize()
            }
        
        let foodListComplete = getFoodListEvent.elements()
        let _ = getFoodListEvent.errors()
        
        updateTypeOfFood = foodListComplete
            .map({ items in
                var menuItems = [HomeItemType]()
                for (index, item) in items.enumerated() {
                    menuItems.append(HomeItemType(id: "\(index)", title: item.typeName))
                }
                return HomeSectionType(id: 0, item: menuItems)
            })
            .asDriver(onErrorDriveWith: .empty())
        
        foodListComplete
            .bind(to: items)
            .disposed(by: bag)
                
        viewWillAppear
            .subscribe()
            .disposed(by: bag)
    }
    
    func getItemsFromMenu(index: Int) -> [FoodData] {
        let section = items.value[index]
        return section.data
    }
    
    func getTitleFromMenu(index: Int) -> String {
        let section = items.value[index]
        return section.typeName
    }
}
