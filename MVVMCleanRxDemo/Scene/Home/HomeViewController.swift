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
    var viewModel: HomeViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
    }

    private func bindInput() {
        rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
    }
    
    private func bindOutput() {
    }
}

