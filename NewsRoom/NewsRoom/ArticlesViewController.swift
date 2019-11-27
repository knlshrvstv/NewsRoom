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
    
    // Because UIViewController is initialized through storyboard can't have a custom init,
    // this property has been intentionally made implicitely unwrapped as it is
    // guranteed that this is initialized later and if it not, it will crash during the
    // development phase and hence the issue would be caught, it it comes up.
    private var languageSwitchView: LanguageSwitchView!
    private var refreshControl = UIRefreshControl()
    private let resourceFetcher: LazyResourceFetcher = LazyResourceFetcher<IndexPath>()
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
                self.loadImagesOnScreen()
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
    
    private func loadImagesOnScreen() {
        guard viewModel.numberOfRows() > 0 else { return }
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPaths {
            guard let cell = tableView.cellForRow(at: indexPath) as? ArticleListCell else { return }
            guard let article = viewModel.article(indexPath) else { return }
            guard let stringURL = article.images.filter ({ $0.topImage }).first?.url, let url = URL(string: stringURL) else { return }
            
            cell.articleImageView.state = .loading
            resourceFetcher.request(resourceFor: Identifier(id: indexPath, url: url)) { (data) in
                DispatchQueue.main.async {
                    cell.articleImageView.state = .loaded(data: data, width: 100, height: 100)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        // resourceFetcher is backed by a NSCache which purges automatically upon receiving memory warning
        resourceFetcher.cancelAllRequests()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let article = viewModel.article(indexPath)
//        
//        let vc = ArticleDetailViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// Only fetch image if user's scrolling is deaccelerating, meaning that they are soon going to rest on some content on the screen. This is done to prevent extraneous image fetches if they are simply scrolling quickly through the page and not intend to stop at any point during that fast scroll.
extension ArticlesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else { return }
        
        loadImagesOnScreen()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesOnScreen()
    }
}

extension ArticlesViewController: ErrorViewDelegate {
    func didPressRefresh() {
        loadArticles()
    }
}

