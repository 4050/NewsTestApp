//
//  ViewController.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 13.03.2021.
//

import UIKit
import SafariServices


class ViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    private var requestArticle = [Article]()
    private var responseArticleModel: ResponseArticleModel
    private var imageArticle: UIImage?
    private var timer: Timer?
    
    init(responseArticleModel: ResponseArticleModel) {
        self.responseArticleModel = responseArticleModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = Constants.topHeadlines
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupSearchBar()
        requestData(urlString: Constants.url)
        
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type something here to search"
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UINib(nibName: Constants.tableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func requestData(urlString: String) {
        responseArticleModel.requestArticle(urlString: urlString, completion: { (searchResults) in
            self.requestArticle = searchResults!.articles
            self.tableView.reloadData()
        })
    }
    
    private func requestFoundArticles(urlString: String) {
        responseArticleModel.requestFoundArticles(urlString: urlString, completion: { (searchResults) in
            self.requestArticle = searchResults!.articles
        })
    }
    
    private func segueToSafari(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
    private func setImageToImageView(cell: ArticleTableViewCell, urlString: String) {
        cell.articleImageView.isHidden = true
        cell.spinnerAnimation(shouldSpin: true)
        responseArticleModel.downloadImage(url: urlString) { (imageData) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.articleImageView.image = UIImage(data: data)
                    cell.spinnerAnimation(shouldSpin: false)
                    cell.articleImageView.isHidden = false
                }
            } else {
                print("Error loading image");
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requestArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = requestArticle[indexPath.row]
        cell.labelTitle.text = article.title
        cell.labelDescription.text = article.articleDescription
        setImageToImageView(cell: cell, urlString: article.urlToImage ?? Constants.imageNotFoundURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: requestArticle[indexPath.row].url) else { return }
        segueToSafari(url: url)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" { return }
        self.requestFoundArticles(urlString: "https://newsapi.org/v2/everything?q=\(searchText)&apiKey=4495630cd6554dd6beb7903b040611e3")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        requestData(urlString: Constants.url)
        tableView.isHidden = false
    }
}


