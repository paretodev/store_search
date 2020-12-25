//
//  ViewController.swift
//  storesearch
//
//  Created by 한석희 on 12/24/20.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Ins Vars
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [String]()
    
    //MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        // delegate search bar  - done in SB
    }
}

//MARK: - Search Bar Delegate
extension SearchViewController : UISearchBarDelegate {
    // 1.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print( "The search text is : \(searchBar.text!)" )
        searchResults = []
        for i in 0...2{
            searchResults.append(
                String( format: " Fake result %d for '%@' ", i, searchBar.text! )// %d, %f, %@ : int, float, object(class, struct) -> format specifier
            )
        }
        self.tableView.reloadData()
    }
    // 2.
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
        // allowing their background content to show through the status bar
    }
    //
}

//MARK: - TableView Related Delegate
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - DataSource
        // 1.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
        // 2.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "SearchResultCell"
        var cell : UITableViewCell! = tableView.dequeueReusableCell( withIdentifier: cellID )
        // using the class or nib file you previously registered, If not return nil
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID )
        }
        cell.textLabel!.text = searchResults[indexPath.row]
        return cell
    }
    //
    
}
