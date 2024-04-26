//
//  ScreenManager.swift
//  EfficientImageGrid

import Foundation
import UIKit

enum Storyboard : String {
    case main = "Main"
}

extension UIViewController {
    
    class func push(storyboard:Storyboard, properties: [String:Any]? = nil, animated:Bool = true) {
        let controller = ScreenManager.getController(storyboard: storyboard, identifier: Self.className)
        if let properties = properties {
            controller.setValuesForKeys(properties)
        }
        ScreenManager.pushViewController(controller, animated: animated)
    }
    
    class func present(storyboard:Storyboard, properties: [String:Any]?=nil) {
        let controller = ScreenManager.getController(storyboard: storyboard, identifier: Self.className)
        if let properties = properties {
            controller.setValuesForKeys(properties)
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        ScreenManager.presentViewController(controller)
    }
    
    class func push<T>(storyboard:Storyboard,animated:Bool = true, getController: @escaping (T)->T) where T : UIViewController {
        let controller : T = ScreenManager.getController(storyboard: storyboard, identifier: Self.className) as! T
        ScreenManager.pushViewController(getController(controller),animated: animated)
    }
    
    class func present<T>(storyboard:Storyboard, getController: @escaping (T)->T) where T : UIViewController {
        let controller : T = ScreenManager.getController(storyboard: storyboard, identifier: Self.className) as! T
        ScreenManager.presentViewController(getController(controller))
    }
    
    class func setAsRootController(storyboard:Storyboard, properties: [String:Any]?=nil) {
        let controller = ScreenManager.getController(storyboard: storyboard, identifier: Self.className)
        if let properties = properties {
            controller.setValuesForKeys(properties)
        }
        ScreenManager.resetViewControllers(controller);
    }
    
}

class ScreenManager {
    static let shared = ScreenManager()
    var navigationController: UINavigationController?
    
    private init() {
        //Singleton class
    }
    
    class func pushViewController(_ controller : UIViewController, animated:Bool=true) {
        shared.navigationController?.pushViewController(controller, animated: animated)
    }
    
    class func presentViewController(_ controller : UIViewController) {
        shared.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    class func setAsMainViewController(_ controller: UINavigationController) {
        //        UIApplication.shared.keyWindow?.rootViewController = controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            // Use the window for your scene here
            window.rootViewController = controller
        }
        ScreenManager.shared.navigationController = controller
    }
    
    class func resetViewControllers(_ controller: UIViewController) {
        ScreenManager.shared.navigationController?.setViewControllers([controller], animated: false)
    }
    
    class func popTo(_ viewControllerType: AnyClass, animated: Bool = false) {
        if let viewController = shared.navigationController?.viewControllers.first(where: { $0.isKind(of: viewControllerType) }) {
            shared.navigationController?.popToViewController(viewController, animated: animated)
        }
    }
}

extension ScreenManager {
    
    class func getRootViewController() -> UIViewController {
        let navigationController = ScreenManager.getNavigationController(ScreenManager.getController(storyboard: .main,controller: ImageGridViewController()))
        shared.navigationController = navigationController;
        return navigationController;
    }
    
    class func getNavigationController(_ viewController: UIViewController? = nil) -> UINavigationController {
        let navigationController = NavigationVC()
        if let controller = viewController {
            navigationController.viewControllers = [controller]
        }
        return navigationController
    }
    
    class func getController(storyboard:Storyboard, controller:UIViewController) -> UIViewController {
        return self.getController(storyboard: storyboard, identifier: controller.className)
    }
    
    class func getController(storyboard:Storyboard, controllerType:UIViewController.Type) -> UIViewController {
        return self.getController(storyboard: storyboard, identifier: controllerType.className)
    }
    
    class func getController(storyboard:Storyboard, identifier:String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
    
    class func getController(storyboard:Storyboard) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyBoard.instantiateInitialViewController()!
    }
}

extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
