//
//  ImageDetailsVC.swift
//  EfficientImageGrid

import UIKit

class ImageDetailsVC: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTV: UITextView!
    var imageData: ImageModel?
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

//MARK: - Setup
extension ImageDetailsVC {
    func setupUI() {
        guard let imageData = imageData else {return}
        
        self.titleLabel.text = imageData.title
        let publishedOn = "Published On : \(imageData.publishedAt ?? "")\n"
        let publishedBy = "Published By  : \(imageData.publishedBy ?? "")\n\n"
        let link = "click below to view full article :\n\(imageData.coverageURL ?? "")"
        
        let details = (publishedOn.isEmpty ? "" : publishedOn) + (publishedBy.isEmpty ? "" : publishedBy) + (link.isEmpty ? "" : link)
        self.detailsTV.text = details
        
        self.setImage(with: imageData)
    }
    
    func setImage(with image: ImageModel) {
        let imageLoader = ImageLoader()
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
