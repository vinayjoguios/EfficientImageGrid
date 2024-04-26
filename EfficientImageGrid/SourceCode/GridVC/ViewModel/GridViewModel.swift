//
//  GridViewModel.swift
//  EfficientImageGrid

import Foundation
import SwiftUI
enum Event {
    case startLoading
    case stopLoading
    case dataLoaded
    case error(String?)
}


final class GridViewModel {
    
    var images: [ImageModel]?
    var refresh:Bool = false
    var eventHandler: ((_ event: Event) -> Void)?
    
    func fetchImagesRequest(parameters: [String:Any]) {
        self.eventHandler?(.startLoading)
        APIActions.common.fetchImagesRequest(WithParameters: parameters, WithCompletionCallback: { data in
            self.eventHandler?(.stopLoading)
        }, WithSuccessCallback: { response in
            self.eventHandler?(.stopLoading)
                self.images = response
                self.refresh = true
                self.eventHandler?(.dataLoaded)
        }, WithFailureCallback: { error in
            if let error = error {
                self.eventHandler?(.error(error))
            }
        })
    }
}
