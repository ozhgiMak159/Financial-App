//
//  SearchPlaceholderView.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import UIKit

class SearchPlaceholderView: UIView {
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "imLaunch")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Search for companies to calculate potential returns via dollar cost averaging."
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)!
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    
    
}

