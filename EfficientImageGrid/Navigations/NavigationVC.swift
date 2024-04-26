//
//  NavigationVC.swift
//  EfficientImageGrid

import UIKit

class NavigationVC: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    override var childForStatusBarHidden: UIViewController? {
            return visibleViewController
    }
}

