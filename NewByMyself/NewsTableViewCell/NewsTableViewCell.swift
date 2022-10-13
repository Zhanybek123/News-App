//
//  NewsTableViewCell.swift
//  NewByMyself
//
//  Created by zhanybek salgarin on 4/14/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static let reuseId = "CellID"
    
    var viewCell: UIView = {
        let viewCell = UIView()
        viewCell.backgroundColor = .gray.withAlphaComponent(0.13)
        viewCell.layer.cornerRadius = 10
        return viewCell
    }()
    
    var newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.contentMode = .scaleAspectFill
        newsImage.layer.masksToBounds = true
        newsImage.layer.cornerRadius = 10
        return newsImage
    }()
    
    var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return descriptionLabel
    }()
    
    var sourceLabel: UILabel = {
        let sourceLable = UILabel()
        sourceLable.textColor = .black
        sourceLable.font = .systemFont(ofSize: 12, weight: .medium)
        return sourceLable
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func set(data: News) {
        
        descriptionLabel.text = data.title
        
        var description = ""
        if let author = data.author {
            description += author
        }
        if let source = data.source?.name {
            description += source
        }
        sourceLabel.text = description
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: data.urlToImage ?? "") {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.sync {
                        self?.newsImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func configure() {
        
        [viewCell, newsImage, descriptionLabel, sourceLabel] .forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
//        addConstraintsWithFormat ========== what kind of constraint is that (whatched on youtube)
        NSLayoutConstraint.activate([
            viewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            viewCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            viewCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            viewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            newsImage.topAnchor.constraint(equalTo: viewCell.topAnchor,constant: 4),
            newsImage.leftAnchor.constraint(equalTo: viewCell.leftAnchor, constant: 4),
            newsImage.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor, constant: -4),
            newsImage.widthAnchor.constraint(equalToConstant: 80),
            newsImage.heightAnchor.constraint(equalToConstant: 80),
            
            descriptionLabel.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: viewCell.rightAnchor,constant: -10),
            
            sourceLabel.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor, constant: -10),
            sourceLabel.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 10),
            sourceLabel.rightAnchor.constraint(equalTo: viewCell.rightAnchor,constant: -10),
        ])
        
        
        
    }
}
