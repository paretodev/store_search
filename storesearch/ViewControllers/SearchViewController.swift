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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentChaged(_ sender: UISegmentedControl) {
        print("Segment changed: \( sender.selectedSegmentIndex )")
        //
        performSearch()
        //
    }
    //
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask : URLSessionTask?
    
    //MARK: - Helper Data Structure
    struct TableView {
        struct CellIdentifier {
            // struct constant -> search result cell
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            //MARK:-Loading Indicatior View
            static let loadingCell = "LoadingCell"
        }
    }
    
    //MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        self.tableView.contentInset = UIEdgeInsets(top: 94, left: 0, bottom: 0, right: 0)
        self.searchBar.backgroundColor = UIColor.blue
        //
        var cellNib = UINib(nibName: TableView.CellIdentifier.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifier.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.nothingFoundCell)
        //
        cellNib = UINib(nibName: TableView.CellIdentifier.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.loadingCell)
        //
    }
    
    //MARK:- Helper Methods
    func performSearch() {
        if !self.searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            //MARK: - Configure - loading status
            dataTask?.cancel()
            // MARK:- Cancel the "active data task"
            isLoading = true
            tableView.reloadData()
            hasSearched = true
            searchResults = []
            //MARK: - Dispatch to Background Queue : let GCD handle the rest
            let url = self.iTunesURL( searchText: searchBar.text!, category: segmentedControl.selectedSegmentIndex )
            let session = URLSession.shared
            // URLDataSession
            dataTask = session.dataTask(with: url){ data,response, error in // Data?, URLResponse?, Error?
                checkOnMain()
                // MARK:- If the error is about, the task was cancelled before completion
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                //MARK:- Got an HTTPURLResponse
                else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        print("Request accepted!! data : \(data!)")
                    //MARK: - MARK:- Reflect the fetched data
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort( by: < ) // dictionary order
                        DispatchQueue.main.async {
                            checkOnMain()
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                }
                
                //MARK:- no internet connection or didn't get 200 status http response
                else {
                    //
                    if let response = response {
                        print("Failure in Networking \(response)")
                    }
                    else{
                        print("error : \( error?.localizedDescription ?? "No Internet Connection" )")
                    }
                    //
                }
                
                // MARK:- Not on network or failed in loading data from server
                DispatchQueue.main.async {
                    checkOnMain()
                    self.hasSearched = false
                    self.isLoading = false
                    // stop the indicator and show alert
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
                //MARK:- End of completion handler
            }
            
            dataTask?.resume()
        }
    }
    
    //MARK:- Helper Method
    func iTunesURL(searchText : String, category: Int) -> URL {
        //
        let kind : String
        switch category {
            case 1: kind = "musicTrack"
            case 2: kind = "software"
            case 3: kind = "ebook"
            default: kind = ""
        }
        let encodeText = searchText.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed )!
        let urlString = "https://itunes.apple.com/search?term=\(encodeText)&limit=200&entity=\(kind)"
        //
            let url = URL(string: urlString)
            return url!
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch  {
            // in case decoding fails
            print("JSON Error : \(error)")
            return [ ]
        }
    }
    
    func showNetworkError(){
        let alert = UIAlertController(title: "Woops", message: "Error occured during access to iTunes Store. " + "Please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        //
        present(alert, animated: true, completion: nil)
    }
    
    //
}

//MARK: - Search Bar Delegate
extension SearchViewController : UISearchBarDelegate {
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    //
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    //MARK:- End of VC.
}

//MARK: - TableView Related Delegate
    extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    // MARK: - DataSource
        // 1.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isLoading else{
            return 1
        }
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
        //
        guard !isLoading else {
            let cell = tableView.dequeueReusableCell( withIdentifier: TableView.CellIdentifier.loadingCell, for: indexPath )
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        //
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifier.nothingFoundCell, for: indexPath)
        }
        else
        {
            let cellID = TableView.CellIdentifier.searchResultCell
            let cell = tableView.dequeueReusableCell( withIdentifier: cellID, for : indexPath ) as! SearchResultCell
            //
            let searchResult = searchResults[indexPath.row] // +1에 해당하는 셀에 대한 데이터 요구
            //MARK:- Label Configure
            cell.nameLabel.text = searchResult.name
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text  = "Unknown"
            }else {
                cell.artistNameLabel.text = String( format: "%@ (%@)", searchResult.artist, searchResult.type )
            }
            return cell
            }
        //
        }
         // 3).
        func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            if searchResults.count == 0 || isLoading == true{
                return nil
            }
            else {
                return indexPath
            }
        }
        // 4).
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // MARK: - End of vc.
}
