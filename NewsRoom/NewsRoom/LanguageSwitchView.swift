//
//  LanguageSwitchView.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import UIKit
import Styles

struct LanguageSwitchViewModel {
    var language: Language
    let languageChangeAction: (Language) -> Void
    
}

class LanguageSwitchView: UIView {
    private let languageSwitch = UISwitch(frame: .zero)
    private let languageLabel = UILabel()
    private var viewModel: LanguageSwitchViewModel
    
    init(viewModel: LanguageSwitchViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        
        setupView()
    }
    
    private func setupView() {
        languageLabel.text = viewModel.language.rawValue.localizedCapitalized
        languageSwitch.isOn = viewModel.language == .martian
        
        languageSwitch.addTarget(self, action: #selector(switchChangedState), for: UIControl.Event.valueChanged)
        
        translatesAutoresizingMaskIntoConstraints = false
        languageSwitch.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(languageSwitch)
        addSubview(languageLabel)
        
        let guide = safeAreaLayoutGuide
        
        languageLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        languageLabel.centerYAnchor.constraint(equalTo: languageSwitch.centerYAnchor).isActive = true
        languageLabel.leadingAnchor.constraint(equalTo: languageSwitch.trailingAnchor, constant: Constants.paddingM).isActive = true
        languageSwitch.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Constants.paddingM).isActive = true
        languageSwitch.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        languageSwitch.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    @objc func switchChangedState(langSwitch: UISwitch) {
        viewModel.languageChangeAction(langSwitch.isOn ? Language.martian : Language.english)
        viewModel.language = langSwitch.isOn ? Language.martian : Language.english
        languageLabel.text = viewModel.language.rawValue.localizedCapitalized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
