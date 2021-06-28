//
//  PhotoCollectionView.swift
//  TestCase
//
//  Created by Anton Scherbaev on 26.06.2021.
//

import UIKit

class PhotoCollectionView: UIView {

    // MARK: - Subviews
    
    private(set) lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private(set) lazy var getPhotosButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get photos", for: .normal)
        button.backgroundColor = .blue
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    private(set) lazy var sendPhotosButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send photos", for: .normal)
        button.backgroundColor = .blue
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
//    let sendPhotosButton = UIButton()
    private(set) lazy var savePhotosThrobber: UIActivityIndicatorView = {
        let throbber = UIActivityIndicatorView()
        throbber.translatesAutoresizingMaskIntoConstraints = false
        throbber.color = .white
        throbber.hidesWhenStopped = true
        throbber.stopAnimating()
        throbber.style = .medium
        return throbber
    }()
    
    private(set) lazy var sendPhotosThrobber: UIActivityIndicatorView = {
        let throbber = UIActivityIndicatorView()
        throbber.translatesAutoresizingMaskIntoConstraints = false
        throbber.color = .white
        throbber.hidesWhenStopped = true
        throbber.stopAnimating()
        throbber.style = .medium
        return throbber
    }()

        
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(getPhotosButton)
        addSubview(sendPhotosButton)
        getPhotosButton.insertSubview(savePhotosThrobber, at: getPhotosButton.subviews.count)
        sendPhotosButton.insertSubview(sendPhotosThrobber, at: sendPhotosButton.subviews.count)
        setupConstraints()
    }
        
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            getPhotosButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10),
            getPhotosButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            getPhotosButton.rightAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -5),
            
            sendPhotosButton.leftAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 5),
            sendPhotosButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            sendPhotosButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10),

            savePhotosThrobber.centerYAnchor.constraint(equalTo: getPhotosButton.centerYAnchor),
            savePhotosThrobber.leftAnchor.constraint(equalTo: getPhotosButton.leftAnchor, constant: 5),
            savePhotosThrobber.heightAnchor.constraint(equalToConstant: 30),
            savePhotosThrobber.widthAnchor.constraint(equalToConstant: 30),

            sendPhotosThrobber.centerYAnchor.constraint(equalTo: sendPhotosButton.centerYAnchor),
            sendPhotosThrobber.leftAnchor.constraint(equalTo: sendPhotosButton.leftAnchor, constant: 5),
            sendPhotosThrobber.heightAnchor.constraint(equalToConstant: 30),
            sendPhotosThrobber.widthAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: getPhotosButton.bottomAnchor)
            
            ])
    }
  
}
