//
//  UICollectionView+Extension.swift
//  MVVMCleanRxDemo
//
//  Created by Apinun on 10/8/2566 BE.
//

import UIKit

extension UICollectionView {
    func registerNib(type: AnyClass, bundle: Bundle? = nil) {
        let nibName = String(describing: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func registerNibHeaderFooter(type: AnyClass, bundle: Bundle? = nil) {
        let nibName = String(describing: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T? {
        let cellName = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? T
    }
}

extension UITableView {
    func registerNib(type: AnyClass, bundle: Bundle? = nil) {
        let nibName = String(describing: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    func registerNibHeaderFooter(type: AnyClass, bundle: Bundle? = nil) {
        let nibName = String(describing: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        let cellName = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: cellName) as? T
    }
}
