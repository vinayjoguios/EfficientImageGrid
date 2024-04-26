//
//  ImageGridCell.swift
//  EfficientImageGrid

import UIKit

class ImageGridCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private var image: ImageModel?
    private var imageLoader: ImageLoader?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
    }

    func configure(with image: ImageModel, imageLoader: ImageLoader) {
        self.image = image
        self.imageLoader = imageLoader
        imageLoader.loadImage(image: image){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error loading image: \(error)")
                self.imageView.image = UIImage(systemName: "photo")
            }
        }
    }
}
