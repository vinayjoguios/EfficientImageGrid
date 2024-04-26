//
//  ImageGridViewController.swift
//  EfficientImageGrid

import UIKit
class ImageGridViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let imageLoader = ImageLoader()
    private var images: [ImageModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var viewModel = GridViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImages()
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        fetchImagesAPI()
    }
}

//MARK: - Setup
extension ImageGridViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        collectionView.register(ImageGridCell.self, forCellWithReuseIdentifier: "ImageGridCell")
    }

    private func loadImages() {
        fetchImagesAPI()
    }
}

//MARK: - API Calls
extension ImageGridViewController {
    func fetchImagesAPI() {
        let parameters:[String:Any] = [:]
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .startLoading:
                debugPrint("")
                self.showProgressHUD()
            case .stopLoading:
                debugPrint("")
                self.hideProgressHUD()
            case .dataLoaded:
                debugPrint("")
                self.hideProgressHUD()
                // DATA LOADED
                self.images = viewModel.images ?? []
            case .error(let error):
                debugPrint("")
                self.showErrorToast(WithMessage: error ?? "")
            }
        }
        viewModel.fetchImagesRequest(parameters: parameters)
    }
}

//MARK: - CollectionView
extension ImageGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGridCell", for: indexPath) as? ImageGridCell else {
            return UICollectionViewCell()
        }

        let image = images[indexPath.item]
        cell.configure(with: image, imageLoader: imageLoader)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        
        ImageDetailsVC.present(storyboard: .main) { controller -> ImageDetailsVC in
            controller.imageData
             = image
            controller.modalPresentationStyle = .overFullScreen
            return controller
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 24) / 3
        return CGSize(width: width, height: width)
    }
}
