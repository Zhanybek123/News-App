//
//  News.swift
//  NewByMyself
//
//  Created by zhanybek salgarin on 4/15/22.
//

import Foundation

struct News: Decodable {
    
    var urlToImage: String?
    var title: String?
    var author: String?
    var publishedAt: String?
    var source: NewsSource?
    var content: String?
}

struct NewsSource: Decodable {
    
    var id: String?
    var name: String?
    
}




