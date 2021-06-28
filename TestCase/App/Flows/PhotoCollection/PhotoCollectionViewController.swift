//
//  PhotoCollectionViewController.swift
//  TestCase
//
//  Created by Anton Scherbaev on 26.06.2021.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private struct Constants {
        static let cellIndentifier = "Cell"
    }
    
    private var DBService: DBLogicSupport
    private var networkService: NetworkServiceProtocol
    
    private var photosView: PhotoCollectionView {
        return self.view as! PhotoCollectionView
    }
    
    private var photoContainer: [PhotoObject] = [] {
        didSet {
            if photoContainer == [] {
                setButtonState(button: self.photosView.sendPhotosButton, isEnabled: false, throbberActive: false)
            } else {
                setButtonState(button: self.photosView.sendPhotosButton, isEnabled: true, throbberActive: false)
            }
            photosView.collectionView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        setButtonState(button: photosView.getPhotosButton, isEnabled: true, throbberActive: false)
        setButtonState(button: photosView.sendPhotosButton, isEnabled: false, throbberActive: false)
    }
    
    private func configureBehavior() {
        photosView.collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: Constants.cellIndentifier)
        photosView.collectionView.dataSource = self
        photosView.collectionView.delegate = self
        photosView.getPhotosButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        photosView.sendPhotosButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }
    
    @objc func addButtonAction() {
        setButtonState(button: photosView.getPhotosButton, isEnabled: false, throbberActive: true)
        presentPicker()
    }
    
    @objc func sendButtonAction() {
        setButtonState(button: photosView.sendPhotosButton, isEnabled: false, throbberActive: true)
        setButtonState(button: photosView.getPhotosButton, isEnabled: false, throbberActive: false)

        let factory = UploadFileModelFactory()
        let photosToUpload = factory.convertPhotosForUpload(fromObject: photoContainer)
        networkService.uploadWithUpdateTokenIfNeeded(files: photosToUpload){ result in
            if result == .success {
                self.DBService.updateObjects(updateObjectsBlock: {
                    for item in self.photoContainer {
                        item.sendPictureDate = Date()
                    }
                }){ isUpdated in
                        if isUpdated, let dump = self.DBService.getDumpFile(){
                            let dumpToUpload = factory.convertRealmDumpForUpload(fromFile: dump)
                            self.networkService.uploadWithUpdateTokenIfNeeded(files: dumpToUpload){ dumpUploaded in
                                if dumpUploaded == .success {
                                    self.showAlert(with: "Загрузили, обновили, дамп отправили... Мы большие молодцы!")
                                    self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
                                    self.photoContainer = [PhotoObject]()
                                } else if dumpUploaded == .error {
                                    self.showAlert(with: "Инфо в базе обновили, Фото на сервер отправили. Дамп файл отправим позже.")
                                    self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
                                    self.photoContainer = [PhotoObject]()
                                }
                            }
                        } else {
                            self.showAlert(with: "Фото загружены. Информацию в базе данных обновим позже")
                            self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
                            self.photoContainer = [PhotoObject]()
                        }
                    
                }
            } else {
                self.setButtonState(button: self.photosView.sendPhotosButton, isEnabled: true, throbberActive: false)
                self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
                self.showAlert(with: "Загрузка не удалась. Но файлы сохранены и нужно дополнить логику последующими попытками отправки")
            }
        }
    }
    
    private func setButtonState(button: UIButton, isEnabled: Bool, throbberActive: Bool) {
        
        if isEnabled {
            button.backgroundColor = .blue
            button.isUserInteractionEnabled = true
        } else {
            button.backgroundColor = .gray
            button.isUserInteractionEnabled = false
        }
        
        if button === photosView.getPhotosButton {
            throbberActive ? photosView.savePhotosThrobber.startAnimating() : photosView.savePhotosThrobber.stopAnimating()
        } else if button === photosView.sendPhotosButton {
            throbberActive ? photosView.sendPhotosThrobber.startAnimating() : photosView.sendPhotosThrobber.stopAnimating()
        }
    }
    
    private func presentPicker() {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = false
            picker.delegate = self
            self.present(picker, animated: true, completion: {
                self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
            })
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveToDB() {
        if !photoContainer.isEmpty {
            setButtonState(button: photosView.getPhotosButton, isEnabled: false, throbberActive: true)
            setButtonState(button: photosView.sendPhotosButton, isEnabled: false, throbberActive: false)
            DispatchQueue.main.async {
                self.DBService.saveToDB(objects: self.photoContainer) { successed in
                    if successed {
                        self.setButtonState(button: self.photosView.sendPhotosButton, isEnabled: true, throbberActive: false)
                        self.showAlert(with: "Фото сохранены в Realm. Теперь можно отправить на сервер")
                    } else {
                        self.setButtonState(button: self.photosView.sendPhotosButton, isEnabled: false, throbberActive: false)
                        self.showAlert(with: "Не получилось созранить. Попробуй сделать фото еще раз")
                    }
                    self.setButtonState(button: self.photosView.getPhotosButton, isEnabled: true, throbberActive: false)
                }
            }
        }
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = PhotoCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBehavior()
        configureUI()
        
        DBService.clearStorage()
        
    }
    
    // MARK: - Init
    
    init (DBService: DBLogicSupport, networkService: NetworkServiceProtocol) {
        self.DBService = DBService
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Collection DataSource and Delegate

extension PhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoContainer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosView.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIndentifier, for: indexPath) as! PhotoViewCell
        let photo = photoContainer[indexPath.item]
        if let image = UIImage(data: photo.photoData) {
            cell.setupWithPicture(image: image)
        }
        return cell
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (photosView.frame.size.width - 20) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

// MARK: - Picker and NavigationController Delegate

extension PhotoCollectionViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        var photos = [PhotoObject]()
        for _ in 1...20 {
            let photoObject = PhotoObject(image: photo)
            photos.append(photoObject)
        }
        photoContainer = photos
        picker.dismiss(animated: true){
            self.saveToDB()
        }
    }
}

extension PhotoCollectionViewController: UINavigationControllerDelegate {
    
}
