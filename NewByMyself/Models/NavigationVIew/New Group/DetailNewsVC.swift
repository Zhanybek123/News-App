//
//  Navigation controller.swift
//  NewByMyself
//
//  Created by zhanybek salgarin on 4/20/22.
//

import Foundation
import UIKit

class DetailNewsVC: UIViewController {
    
    var newsItem: News
    
    var viewFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        return view
    }()
    
    var viewFrameBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 10
        return view
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    var sourseAndDate: UILabel = {
        let source = UILabel()
        source.textColor = .black
        return source
    }()
    
    var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .black
        return description
    }()
    
    init(newsItem: News) {
        self.newsItem = newsItem
        super.init(nibName: nil, bundle: nil)
        self.set(data: newsItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissSelf))
        configure()
        self.title = "Article"
        
    }
    
//    @objc private func dismissSelf() {
//        dismiss(animated: true, completion: nil)
//    }
    
    func configure() {
        self.view.backgroundColor = .white
        [viewFrame, viewFrameBottom, image, label, sourseAndDate, descriptionLabel] .forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            
            viewFrame.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            viewFrame.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
            viewFrame.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
            viewFrame.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            
            viewFrameBottom.topAnchor.constraint(equalTo: viewFrame.bottomAnchor),
            viewFrameBottom.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
            viewFrameBottom.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
            viewFrameBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            
            image.topAnchor.constraint(equalTo: viewFrame.topAnchor),
            image.leftAnchor.constraint(equalTo: viewFrame.leftAnchor),
            image.rightAnchor.constraint(equalTo: viewFrame.rightAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30),
            label.leftAnchor.constraint(equalTo: viewFrame.leftAnchor, constant: 4),
            label.rightAnchor.constraint(equalTo: viewFrame.rightAnchor, constant: -4),
            
        ])
        
    }
    
    func set(data: News) {
        
        label.text = data.content
        
        //        var info = ""
        //        if let id = data.source?.id {
        //            info += id
        //        }
        //        if let name = data.source?.name {
        //            info += name
        //        }
        //        if let published = data.publishedAt {
        //            info += published
        //        }
        //        sourseAndDate.text = info
        //        descriptionLabel.text = data.content
        
        DispatchQueue.global().async { [weak self] in
            do {
                if let url = URL(string: data.urlToImage ?? "") {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.sync {
                        self?.image.image = UIImage(data: data)
                    }
                }
            } catch (let error) {
                self?.show(error: error)
            }
        }
    }
    
    func show (error: Error) {
        DispatchQueue.main.async {
            let AlertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            self.present(AlertVC, animated: true)
        }
    }
}



