//
//  ArticlesViewController.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import UIKit
import Networking

class ArticlesViewController: UIViewController {
    private let viewModel = ArticlesViewModel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    // Because UIViewController is initialized through storyboard can't have a custom init,
    // this property has been intentionally made implicitely unwrapped as it is
    // guranteed that this is initialized later and if it not, it will crash during the
    // development phase and hence the issue would be caught, it it comes up.
    private var languageSwitchView: LanguageSwitchView!
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPullToRefresh()
        setupLanguageSwitchView()
        setupView()
        loadArticles()
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }
    
    private func setupLanguageSwitchView() {
        let languageSwitchViewModel = LanguageSwitchViewModel(language: viewModel.language, languageChangeAction: { [unowned self] (language) in
            self.viewModel.translate(to: language, didTranslate: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }) { (error) in
                // TODO: Show error
                print("Show error")
            }
        })
        
        languageSwitchView = LanguageSwitchView(viewModel: languageSwitchViewModel)
        
        languageSwitchView.backgroundColor = .red
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        languageSwitchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(languageSwitchView)
        let guide = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -40).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        languageSwitchView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        languageSwitchView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        languageSwitchView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        languageSwitchView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    private func loadArticles() {
        self.refreshControl.beginRefreshing()
        viewModel.loadArticles(didLoad: { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            // TODO: Display error
            print(error)
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        loadArticles()
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = viewModel.article(indexPath)
        cell.textLabel?.text = article?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.article(indexPath)
        
        let vc = ArticleDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

