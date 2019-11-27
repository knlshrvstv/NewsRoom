//
//  ArticlesViewController.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import UIKit
import Networking
import LazyResourceFetcher
import Styles

class ArticlesViewController: UIViewController {
    private let viewModel = ArticlesViewModel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let spinner = SpinnerViewController()
    private let errorView = ErrorViewController()
    
    // Because UIViewController is initialized through storyboard, it can't have a custom init,
    // this property has been intentionally made implicitely unwrapped as it is
    // guranteed that this is initialized later and if it not, it will crash during the
    // development phase and hence the issue would be caught, it it comes up.
    private var languageSwitchView: LanguageSwitchView!
    private var refreshControl = UIRefreshControl()    
}

// MARK: View
extension ArticlesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorView()
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
    
    private func setupErrorView() {
        errorView.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: ArticleListCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func setupLanguageSwitchView() {
        let languageSwitchViewModel = LanguageSwitchViewModel(language: viewModel.language, languageChangeAction: { [unowned self] (language) in
            self.viewModel.translate(to: language, didTranslate: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.hideSpinner()
                    self.showError()
                }
            }
        })
        
        languageSwitchView = LanguageSwitchView(viewModel: languageSwitchViewModel)        
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        languageSwitchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(languageSwitchView)
        let guide = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -Constants.paddingL).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        languageSwitchView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        languageSwitchView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        languageSwitchView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        languageSwitchView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    private func showSpinner() {
        addChild(spinner)
        (spinner).view.frame = view.frame
        view.addSubview((spinner).view)
        (spinner).didMove(toParent: self)
    }
    
    private func hideSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    private func showError() {
        addChild(errorView)
        (errorView).view.frame = view.frame
        view.addSubview((errorView).view)
        (errorView).didMove(toParent: self)
    }
    
    private func hideError() {
        errorView.willMove(toParent: nil)
        errorView.view.removeFromSuperview()
        errorView.removeFromParent()
    }
}

// MARK: Data
extension ArticlesViewController {
    private func loadArticles() {
        refreshControl.beginRefreshing()
        hideError()
        showSpinner()
        viewModel.loadArticles(didLoad: { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.hideSpinner()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.hideSpinner()
                self.showError()
            }
        }
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadArticles()
    }
    
    override func didReceiveMemoryWarning() {
        // resourceFetcher is backed by a NSCache which purges automatically upon receiving memory warning
        viewModel.resourceFetcher.cancelAllRequests()
    }
}

// MARK: UITableView delegate methods
extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListCell.identifier, for: indexPath) as? ArticleListCell, let article = viewModel.article(indexPath) else { return UITableViewCell() }
        cell.viewModel = ArticleListCellViewModel(title: article.title, briefDescription: article.body, image: nil)
        
        if let stringURL = article.topImage?.url, let url = URL(string: stringURL) {
            viewModel.resourceFetcher.request(resourceFor: Identifier(url: url)) { (data, source, _) in
                DispatchQueue.main.async {
                    cell.articleImageView.state = .loaded(data: data, source: source)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = viewModel.article(indexPath) else { return }
        
        tableView.deselectRow(at: indexPath, animated: false)
        let vm = ArticleDetailViewModel(article: article, resourceFetcher: viewModel.resourceFetcher)
        let vc = ArticleDetailViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension ArticlesViewController: ErrorViewDelegate {
    func didPressRefresh() {
        loadArticles()
    }
}

