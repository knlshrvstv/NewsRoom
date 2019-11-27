//
//  ArticleDetailViewController.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import UIKit
import Styles
import LazyResourceFetcher

class ArticleDetailViewController: UIViewController {
    private let viewModel: ArticleDetailViewModel
    
    private let articleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = false
        textView.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        
        return textView
    }()
    
    let articleImageView: DynamicImageView = {
        let imageView = DynamicImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(articleImageView)
        view.addSubview(articleTextView)
        let guide = view.safeAreaLayoutGuide
        articleImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Constants.paddingM).isActive = true
        articleImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingM).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Constants.paddingM).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: Constants.imageStandardHeight).isActive = true
        
        articleTextView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: Constants.paddingS).isActive = true
        articleTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingM).isActive = true
        articleTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Constants.paddingM).isActive = true
        articleTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -Constants.paddingM).isActive = true
        
        articleTextView.text = viewModel.article.body ?? ""
        
        if let urlString = viewModel.article.topImage?.url, let url = URL(string: urlString) {
            
            viewModel.resourceFetcher.request(resourceFor: Identifier(url: url)) { [unowned self] (data, source, identifier)  in
                self.articleImageView.state = .loaded(data: data, source: source)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
