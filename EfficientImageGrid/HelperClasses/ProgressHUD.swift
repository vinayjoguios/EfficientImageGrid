//
//  ProgressHUD.swift
//  EfficientImageGrid

import UIKit
import MBProgressHUD

private var progressHUD: MBProgressHUD?

extension UIViewController {
    func showProgressHUD(message:String? = nil) {
        view.endEditing(true)
        hideProgressHUD()
        progressHUD = nil
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        
        progressHUD?.bezelView.color = .black //BG color
        progressHUD?.bezelView.style = .solidColor //BG Clear
        progressHUD?.contentColor = .white //Indicator color
        
        if let message = message {
            progressHUD?.label.text = message
            progressHUD?.label.numberOfLines = 0
        }
    }
    
    func hideProgressHUD() {
        if let progressHUD = progressHUD {
            progressHUD.hide(animated: true)
        }
    }
}

extension UIView {
    func showProgressHUD(message:String? = nil) {
        self.endEditing(true)
        hideProgressHUD()
        progressHUD = nil
        progressHUD = MBProgressHUD.showAdded(to: self, animated: true)
        
        progressHUD?.bezelView.color = .black //BG color
        progressHUD?.bezelView.style = .solidColor //BG Clear
        progressHUD?.contentColor = .white //Indicator color
        
        if let message = message {
            progressHUD?.label.text = message
            progressHUD?.label.numberOfLines = 0
        }
    }
    
    func hideProgressHUD() {
        if let progressHUD = progressHUD {
            progressHUD.hide(animated: true)
        }
    }
}
