//
//  HomeViewModel.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 8/8/2566 BE.
//

import Foundation
import RxCocoa

protocol HomeInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol HomeOutput {
    var updateTypeOfFood: Driver<Void> { get set }
}

protocol HomeViewModel: HomeInput, HomeOutput {
    var input: HomeInput { get }
    var output: HomeOutput { get }
}

final class HomeViewModelImpl: HomeViewModel {
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
    
    // Input
    var viewDidLoad: PublishRelay<Void> = .init()
    
    // Output
    var updateTypeOfFood: Driver<Void> = .empty()
}
