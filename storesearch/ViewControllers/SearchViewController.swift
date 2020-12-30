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
    var isLoading = false
        //
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
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
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
}

//MARK: - Search Bar Delegate
extension SearchViewController : UISearchBarDelegate {
    // 1.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
        if !self.searchBar.text!.isEmpty {
            //
            searchBar.resignFirstResponder()
            //MARK: - Configure - loading status
            isLoading = true
            tableView.reloadData()
            hasSearched = true
            // MARK: - Query is made here !!
            searchResults = []
           
            //MARK: - Dispatch to Background Queue : let GCD handle the rest
            let url = self.iTunesURL( searchText: searchBar.text! )
            let queue = DispatchQueue.global() // global queue에 대한 레퍼런스, 직접 만들 수도 있으나, 시스템이 주는
            // 표준형 큐를 쓰는 걸로 충분함
            // 시스템이 준 표준 글로벌 큐에, 클로저에 정의된 작업을, asynchronously 실행, 동시 진행한다,
            // 메인 쓰레드는 이거 글로벌큐에 던져주고 자기는 다시 할 거 하러감, 클로저 실행 안함 !!
//            let url = iTunesURL( searchText: searchBar.text! )
            //MARK: -
            queue.async {
                    //MARK: - New Networking Block
                
                
                
                //
            }
//            // MARK:- Reflect Search Results
//            isLoading = false
//            self.tableView.reloadData()
        }
    }
    
    // 2. SearchBarDelegate : UIBarPositioning(protocol)
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //MARK:- Helper Method
    func iTunesURL(searchText : String) -> URL {
        let encodeText = searchText.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed )!
        let urlString = String(
            format : "https://itunes.apple.com/search?term=%@&limit=200",
            encodeText
        )
            let url = URL(string: urlString)
            return url!
        }
    //
    func performStoreRequest(with url : URL) -> Data?{
        do {
            return try Data(contentsOf: url)
                // no network connection
                // no server at specified url
        } catch {
            self.showNetworkError() // bad network -> users side
            return nil
        }
    }
    //
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
        //
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
