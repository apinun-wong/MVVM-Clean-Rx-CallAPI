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
    var updateTypeOfFood: Driver<[FoodModelResponse]> { get set }
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
    var updateTypeOfFood: Driver<[FoodModelResponse]> = .empty()
    
    init(getFoodListUsecase: GetFoodListUsecase) {
        let getFoodListEvent = viewDidLoad
            .flatMap { _ in
                getFoodListUsecase
                    .execute()
                    .materialize()
            }
        
        let foodListComplete = getFoodListEvent.elements()
        let foodListError = getFoodListEvent.errors()
        
        updateTypeOfFood = foodListComplete
            .asDriver(onErrorDriveWith: .empty())
                
        viewWillAppear
            .subscribe()
            .disposed(by: bag)
    }
}
