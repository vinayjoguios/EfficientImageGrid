//
//  CommonActions.swift
//  EfficientImageGrid

import Foundation
import Alamofire

class CommonActions  {
    //MARK: - Fetch Profiles API's
    func fetchImagesRequest(WithHTTPHeaders httpheaders: HTTPHeaders? = nil,
                             WithParameters parameters: Parameters? = nil,
                             WithCompletionCallback completionCallback: @escaping(Data?) -> Void,
                             WithSuccessCallback successCallback: @escaping([ImageModel]) -> Void,
                             WithFailureCallback failureCallback: @escaping(String?) -> Void) {
        APIManager.shared.request(WithUrlStr:APIEndpoints.images.url,
                                  WithHttpMethod: .get,
                                  WithHeaders: httpheaders,
                                  WithParameters: parameters,
                                  WithCompletionCallback: completionCallback,
                                  WithSuccessCallback: successCallback,
                                  WithFailureCallback: failureCallback)
    }
}
