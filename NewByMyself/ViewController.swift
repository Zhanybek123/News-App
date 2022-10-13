//
//  ViewController.swift
//  NewByMyself
//
//  Created by zhanybek salgarin on 4/14/22.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating {
    
    let refresh = UIRefreshControl()
    var costomView = MainTableView()
    var news: [News] = []   
    var searchedNews: [News] = []
    let searchController = UISearchController()
    
    
    override func loadView() {
        view = costomView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NEWS"
        view.backgroundColor = .systemBlue
        costomView.tableView.dataSource = self
        costomView.tableView.delegate = self
        fetchNews()
        search()
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        costomView.tableView.addSubview(refresh)
//        navigationItem.rightBarButtonItem
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId) as! NewsTableViewCell
        let newsItem = searchedNews.isEmpty ? news[indexPath.row] : searchedNews[indexPath.row]
        cell.set(data: newsItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedNews.isEmpty {
            return news.count
        }
        return searchedNews.count
    }
}

  extension ViewController {
      
      @objc func didPullToRefresh() {
  //        re-fetch data
          print("start refresh")
          DispatchQueue.main.asyncAfter(deadline: .now()+1) {
              self.refresh.endRefreshing()
              self.costomView.tableView.reloadData()
          }
      }
    
    func fetchNews() {
        let baseURL = "https://newsapi.org/v2"
        let apiKey = "2d0dc8266d2e484b9b77d3f3b1d12372"
        let endPoint = "/top-headlines"
        let params = "?apiKey=\(apiKey)&country=US"
        
        let url = URL(string: "\(baseURL)\(endPoint)\(params)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request) { [weak self]
            data, response, error in
            if let error = error {
                self?.show(error: error)
                return
            }
            guard let data = data else {return}
            do {
                let news: NewsResponce = try JSONDecoder().decode(NewsResponce.self, from: data)
                self?.news = news.articles
                DispatchQueue.main.async {
                    self?.costomView.tableView.reloadData()
                }
            } catch (let error) {
                self?.show(error: error)
            }
                        
        }
        session.resume()
    }
    
    func show (error: Error) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alertVC, animated: true)
    }
    }
     
     func search() {
         navigationItem.searchController = searchController
//         searchController.delegate = self
         searchController.searchResultsUpdater = self
//         searchController.searchBar.searchTextField.addTarget(self, action: #selector(didSearchChanged), for: .valueChanged)
     }
    
     func updateSearchResults(for searchController: UISearchController) {
         let text = searchController.searchBar.text ?? ""
//         need explanations--------
         guard !text.isEmpty else {
             searchedNews = []
             costomView.tableView.reloadData()
             return
         }
         searchedNews = news.filter({ item in
             return item.title?.contains(text) ?? false
         })
         costomView.tableView.reloadData()
     }
      
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = news[indexPath.row]
        let detailVC = DetailNewsVC(newsItem: newsItem)
        detailVC.modalPresentationStyle = .fullScreen
//        self.present(detailVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
   
}



