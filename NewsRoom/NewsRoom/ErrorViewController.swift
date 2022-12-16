//
//  ErrorViewController.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/25/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import UIKit
import Styles

protocol ErrorViewDelegate: AnyObject {
    func didPressRefresh()
}

class ErrorViewController: UIViewController {
    weak var delegate: ErrorViewDelegate?
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "An error has occurred."
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        view.addSubview(errorLabel)
        view.addSubview(refreshButton)
        
        let guide = view.safeAreaLayoutGuide
        
        errorLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Constants.paddingS).isActive = true
        refreshButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
        refreshButton.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: Constants.paddingM).isActive = true
    }
    
    @objc func refreshAction() {
        delegate?.didPressRefresh()
    }
}
