//
//  ArticleListCell.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import UIKit
import Styles

struct ArticleListCellViewModel {
    let title: String
    let briefDescription: String?
    let image: Article.Image?
}

extension ArticleListCellViewModel: Equatable {
    static func ==(lhs: ArticleListCellViewModel, rhs: ArticleListCellViewModel) -> Bool {
        return lhs.title == rhs.title
            && lhs.briefDescription == rhs.briefDescription
            && lhs.image == rhs.image
    }
}

class ArticleListCell: UITableViewCell {
    static let identifier = "ArticleListCell"
    
    var viewModel: ArticleListCellViewModel? {
        didSet {
            guard viewModel != oldValue else { return }
            titleLabel.text = viewModel?.title
            briefDescriptionLabel.text = viewModel?.briefDescription
            
            
            
            setNeedsLayout()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.numberOfLines = 3
        
        return label
    }()
    
    let briefDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        label.numberOfLines = 5
        
        return label
    }()
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(briefDescriptionLabel)
        contentView.addSubview(articleImageView)
        
        let guide = contentView.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: Constants.paddingM).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingM).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Constants.paddingM).isActive = true

        briefDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.paddingM).isActive = true
        briefDescriptionLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingM).isActive = true
        briefDescriptionLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Constants.paddingM).isActive = true
        
        articleImageView.topAnchor.constraint(equalTo: briefDescriptionLabel.bottomAnchor).isActive = true
        articleImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        articleImageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: Constants.imageStandardHeight).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
