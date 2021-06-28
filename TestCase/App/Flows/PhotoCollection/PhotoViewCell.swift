//
//  PhotoViewCell.swift
//  TestCase
//
//  Created by Anton Scherbaev on 27.06.2021.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupWithPicture(image: UIImage) {
        imageView.image = image
    }
        
    // MARK: - UI
    
    func configureUI() {
        self.contentView.backgroundColor = .lightGray
        self.contentView.addSubview(imageView)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
    
    // MARK: - Reuse Behavior
    
    override func prepareForReuse() {
        imageView.image = nil
    }

}
