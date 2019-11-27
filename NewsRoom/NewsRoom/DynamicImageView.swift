//
//  DynamicImageView.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/26/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import UIKit
import Styles

class DynamicImageView: UIView {
    enum State: Equatable {
        case notLoading
        case loading
        case loaded(data: Data, width: Int, height: Int)
        
        static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.notLoading, .notLoading):
                return true
            case (.loading, .loading):
                return true
            case (let .loaded(data1, width1, height1), let .loaded(data2, width2, height2)):
                return data1 == data2
                    && width1 == width2
                    && height1 == height2
            default:
                return false
            }
        }
    }
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var state: State = .notLoading {
        didSet {
            guard state != oldValue else { return }
            switch state {
            case .notLoading:
                backgroundColor = .red
            case .loading:
                backgroundColor = .yellow
            case .loaded(let data, let width, let height):
                backgroundColor = .clear
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(data: data)
            }
        }
    }
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    func setupView() {
        addSubview(imageView)
        let guide = safeAreaLayoutGuide
        
        imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Constants.paddingS).isActive = true
        imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingS).isActive = true
        imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Constants.paddingS).isActive = true
        imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -Constants.paddingS).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
