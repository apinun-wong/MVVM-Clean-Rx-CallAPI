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
    
    public override func loadView() {
        super.loadView()
        bindInput()
        bindOutput()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
    }

    private func bindInput() {
        rx.viewDidLoad.bind(to: self.viewModel.input.viewDidLoad).disposed(by: bag)
        rx.viewWillAppear.bind(to: self.viewModel.input.viewWillAppear).disposed(by: bag)
    }
    
    private func bindOutput() {
        viewModel.output.updateTypeOfFood.drive(onNext: { items in
            print("updateTypeOfFood\(items)")
        }).disposed(by: bag)
    }
}

