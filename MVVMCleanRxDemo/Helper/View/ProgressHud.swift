//
//  ProgressHud.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 11/8/2566 BE.
//

import UIKit
import MBProgressHUD

final class ProgressHudManager {
    private static let indicatorTag: Int = 1111
    
    static func show(in view: UIView) {
        view.isUserInteractionEnabled = false
        let progressView = MBProgressHUD.showAdded(to: view, animated: true)
        progressView.tag = ProgressHudManager.indicatorTag
        progressView.label.text = "กำลังโหลด..."
        progressView.show(animated: true)
    }
    
    static func hide(in view: UIView) {
        DispatchQueue.main.async {
            view.isUserInteractionEnabled = true
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
