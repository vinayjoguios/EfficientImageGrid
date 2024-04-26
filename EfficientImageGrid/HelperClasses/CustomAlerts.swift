//
//  CustomAlerts.swift
//  EfficientImageGrid

import UIKit
import Toast

enum ToastType: String {
    case success
    case waring
    case error
}

extension UIViewController {
    func showToast(WithMessage message:String, ForViewKind viewTypeNavigation: Bool = true)  {
        if viewTypeNavigation {
            var style = ToastManager.shared.style
            style.backgroundColor = .green
            style.messageColor = UIColor.white
            self.navigationController?.view.makeToast(message, duration: 2.0, position: .top, style:style)
        } else {
            var style = ToastManager.shared.style
            style.backgroundColor = .green
            style.messageColor = UIColor.white
            //self.navigationController?.view.makeToast(message, duration: 2.0, position: .top, style:style)
            self.view.makeToast(message, duration: 2.0, position: .top, style:style)
        }
    }
    
    func showToastTopView(WithMessage message:String, type:ToastType? = .success)  {
        var style = ToastManager.shared.style
        if type == .error {
            style.backgroundColor = .red
        } else {
            style.backgroundColor = .green
        }
        style.messageColor = UIColor.white
        ScreenManager.shared.navigationController?.topViewController?.view.makeToast(message, duration: 2.0, position: .top, style:style)
    }
    
    
    func showErrorToast(WithMessage message:String, ForViewKind viewTypeNavigation: Bool = true)  {
        if viewTypeNavigation {
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.red
            style.messageColor = UIColor.white
            self.navigationController?.view.makeToast(message, duration: 2.0, position: .top, style:style)
        } else {
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.red
            style.messageColor = UIColor.white
            self.view.makeToast(message, duration: 2.0, position: .top, style:style)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message:String? = nil, okCallback:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_ ) in
            okCallback()
        })
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertContinueCancel(title: String, message:String? = nil, okCallback:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_ ) in
            okCallback()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
