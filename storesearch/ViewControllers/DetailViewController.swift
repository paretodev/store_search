//
//  DetailViewController.swift
//  storesearch
//
//  Created by 한석희 on 1/4/21.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK:- UI Controls Vars
    @IBOutlet var popupView: UIView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceButton: UIButton!
    //MARK:- SearchResult
    var searchResult : SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10 // <-> view
        //
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(close)
        )
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self // recognizer의 작동 방식을 컨트롤 -> 터치로 인식하는 기준 - 컨텐트 뷰여야 한다 !!
        view.addGestureRecognizer(gestureRecognizer)
        //MARK:- Set Up UI controls according to received SearchResult obj
        if let _ = searchResult {
            updateUI()
        }
    }
    deinit {
        if let downloadTask = downloadTask {
            downloadTask.cancel()
            print("Possible Download Task Haleted✋🏻")
        }
        print("A detail VC is about to be deallocated🔥.")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    //MARK:-Helper Methods
    //
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    //
    func updateUI(){
        nameLabel.text = searchResult.name
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        }else{
            artistNameLabel.text = searchResult.artist
        }
        kindLabel.text = searchResult.type
        if searchResult.genre.isEmpty {
            genreLabel.text = "unknown"
        }
        else{
            genreLabel.text = searchResult.genre
        }
        //
        let formatter = NumberFormatter( )
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency // "USD" 화폐 코드 !!
        //
        let priceText : String
        if searchResult.price == 0 {
            priceText = "Free"
        }
        else if let text = formatter.string(from:  searchResult.price as NSNumber  ){ // 실제 숫자를 넣지 않으면, nil을 리턴 !!
            priceText = text
        }
        else{
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        //
        if let largeURL = URL(string: searchResult.imageLarge ){
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }

    @IBAction func openInStore(){
        if let url = URL ( string: searchResult.storeURL ){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //
}

// gesture recognizer 의 델리게이트 라면, 다음의 메세지를 받을 수 있다 !
extension DetailViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
}

