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
    var inputSearchText: BehaviorRelay<String> { get }
}

protocol FoodListOutput {
    var updateTypeOfFood: Driver<FoodListSectionType> { get set }
    func getTitle() -> String
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
    var inputSearchText: BehaviorRelay<String> = .init(value: "")
    
    // Output
    var updateTypeOfFood: Driver<FoodListSectionType> = .empty()
    
    var items: BehaviorRelay<[FoodData]> = .init(value: [])
    var searchText: BehaviorRelay<String> = .init(value: "")
    private var title: String = ""
    
    init(data: [FoodData],
         title: String) {
        items = .init(value: data)
        self.title = title
        let startFoodList = viewDidLoad
            .withLatestFrom(items)
            .map(convertFoodListToSectionType)
        
        inputSearchText
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .asObservable()
            .bind(to: searchText)
            .disposed(by: bag)
        
        let filterFromSearchText = searchText
            .distinctUntilChanged()
            .withLatestFrom(items) { searchText, items in
                guard !searchText.isEmpty else {
                    return items
                }
                let result = items.filter { data in
                    return data.name.lowercased().contains(searchText.lowercased())
                }
                return result
            }.map(convertFoodListToSectionType)
        
        updateTypeOfFood = Observable.merge(filterFromSearchText, startFoodList)
            .asDriver(onErrorDriveWith: .empty())
    }
    
    private func convertFoodListToSectionType(items: [FoodData]) -> FoodListSectionType {
        var foodListItems = [FoodListItemType]()
        for (index, item) in items.enumerated() {
            let foodItem = FoodListItemType(id: "\(index)",
                                            foodName: item.name,
                                            callories: item.calories,
                                            portion: item.portion)
            foodListItems.append(foodItem)
        }
        return FoodListSectionType(id: 0, item: foodListItems)
    }
    
    func getTitle() -> String {
        return title
    }
}
