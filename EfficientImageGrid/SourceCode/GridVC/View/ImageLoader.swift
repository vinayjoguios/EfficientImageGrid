//
//  ImageLoader.swift
//  EfficientImageGrid

import Foundation
import UIKit

class ImageLoader {
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCache = URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "image-cache")
    
    func loadImage(image: ImageModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlString = "\(image.thumbnail?.domain ?? "")/\(image.thumbnail?.basePath ?? "")/0/\(image.thumbnail?.key ?? "")"
        if let imageURL = URL(string: urlString) {
            self.loadImage(from: imageURL, completion: completion)
        }
    }

    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = memoryCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(image))
            return
        }

        if let cachedResponse = diskCache.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            memoryCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(.success(image))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "https://acharyaprashant.org", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])))
                return
            }

            self.memoryCache.setObject(image, forKey: url.absoluteString as NSString)
            self.diskCache.storeCachedResponse(CachedURLResponse(response: response ?? HTTPURLResponse(), data: data), for: URLRequest(url: url))
            completion(.success(image))
        }
        task.resume()
    }
}
