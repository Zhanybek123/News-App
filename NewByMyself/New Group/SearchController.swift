//
//  SearchController.swift
//  NewByMyself
//
//  Created by zhanybek salgarin on 4/26/22.
//

import Foundation
import UIKit

class SearchController: UIViewController {
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
       navigationItem.searchController = searchController
    }
    
}
