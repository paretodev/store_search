//
//  ViewController.swift
//  storesearch
//
//  Created by 한석희 on 12/24/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Ins Vars
        //
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
        //
    var searchResults = [SearchResult]()
    var hasSearched = false
    //
    
    //MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.searchBar.backgroundColor = UIColor.blue // 경계선, 배경까지 변형
        // delegate search bar  - done in SB
    }
}

//MARK: - Search Bar Delegate
extension SearchViewController : UISearchBarDelegate {
    // 1.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
        hasSearched = true
        //
        searchBar.resignFirstResponder()
        searchResults = [ ]
        //
        if searchBar.text != "justin bieber" {
            for i in 0...2{
                let searchResult = SearchResult()
                searchResult.name = String(format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
            }
        }
        self.tableView.reloadData()
    }
        
    // 2. SearchBarDelegate : UIBarPositioning(protocol)
        // In default, the delegate returns UIBarPosition.top
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
        guard hasSearched == true else {
            return 0
        }
        guard searchResults.count != 0 else{
            return 1
        }
        return searchResults.count
    }
        // 2.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "SearchResultCell"
        var cell : UITableViewCell! = self.tableView.dequeueReusableCell( withIdentifier: cellID )
        // using the class or nib file you previously registered, If not return nil
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID )
        }
        //
        if searchResults.count == 0 {
            cell.textLabel!.text = "(Nothing Found)"
            cell.textLabel?.textColor = .lightGray
            cell.detailTextLabel!.text = ""
            return cell
        }
        let searchResult = searchResults[indexPath.row]
        cell.textLabel!.text = searchResult.name
        cell.textLabel?.textColor = .black
        cell.detailTextLabel!.text = searchResult.artistName
        //
        return cell
    }
        //
        func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            if hasSearched == false || searchResults.count == 0 {
                return nil
            }
            else {
                return indexPath
            }
        }
        //
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
}
