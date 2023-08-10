//
//  GetFoodListUsecase.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 10/8/2566 BE.
//

import Foundation
import RxSwift

protocol GetFoodListUsecase {
    func execute() -> Observable<[FoodModelResponse]>
}

struct GetFoodListUsecaseImpl: GetFoodListUsecase {
    let requestManager: HttpRequestManager
    func execute() -> Observable<[FoodModelResponse]> {
        return Observable.create { () async throws -> [FoodModelResponse] in
            let request = FoodItemsListRequest.getFoodItemList
            return try await requestManager.perform(request)
        }
    }
}
