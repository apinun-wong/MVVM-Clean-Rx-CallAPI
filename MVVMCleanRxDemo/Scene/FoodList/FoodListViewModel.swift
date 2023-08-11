//
//  FoodListViewModel.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 11/8/2566 BE.
//

import Foundation
import RxCocoa
import RxSwift

protocol FoodListInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol FoodListOutput {
    var updateTypeOfFood: Driver<FoodListSectionType> { get set }
}

protocol FoodListViewModel: FoodListInput, FoodListOutput {
    var input: FoodListInput { get }
    var output: FoodListOutput { get }
}

final class FoodListViewModelImpl: FoodListViewModel {
    var input: FoodListInput { return self }
    var output: FoodListOutput { return self }
    
    private let bag = DisposeBag()
    
    // Input
    var viewDidLoad: PublishRelay<Void> = .init()
    
    // Output
    var updateTypeOfFood: Driver<FoodListSectionType> = .empty()
    
    var items: BehaviorRelay<[FoodData]> = .init(value: [])
    
    init(data: [FoodData]) {
        items = .init(value: data)
        
        updateTypeOfFood = viewDidLoad
            .withLatestFrom(items)
            .map({ items in
                var foodListItems = [FoodListItemType]()
                for (index, item) in items.enumerated() {
                    let foodItem = FoodListItemType(id: "\(index)",
                                                    foodName: item.name,
                                                    callories: item.calories,
                                                    portion: item.portion)
                    foodListItems.append(foodItem)
                }
                return FoodListSectionType(id: 0, item: foodListItems)
            })
            .asDriver(onErrorDriveWith: .empty())
    }
}
