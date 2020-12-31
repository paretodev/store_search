//
//  SearchResultCell.swift
//  storesearch
//
//  Created by 한석희 on 12/25/20.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var artistNameLabel : UILabel!
    @IBOutlet var artworkImageView : UIImageView!
    //
    var downloadTask : URLSessionDownloadTask? // 셀.다운로드테스크 -> 캔슬 !! -> 기존 셀들의 다운로드를 캔슬 시키고 -> 재개 !!

    //MARK: - a cell object loaded from nib -> before -> being added to the tableview
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK:- Initialization code
        let selectedView = UIView(frame: CGRect.zero)
        // MARK: - How to instantiate a color
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.3)
        selectedBackgroundView = selectedView
        //
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for result : SearchResult){
        nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        }else{
            artistNameLabel.text = String( format: "%@ (%@)", result.artist, result.type )
        }
        // MARK: - Image Setting
            // 1. placeholder
        artworkImageView.image = UIImage(systemName: "square")
            // 2. SearchedResult.imageSmall -> string -> URL obj -> URL OBJ -> load -> async downloading
                // after it succeeds update image to it !!
        if let smallURL = URL(string: result.imageSmall){
            // MARK:- 하나의 테이블뷰 셀이 download task 레퍼런스를 가진다 !!
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }
    //MARK:- Cell Prepare Reuse
        // 보이지 않아서, 원래 다른 인덱스를 나타내던 셀이 -> 재활용되려고 할 때 -> 그 전에 호출되는 메서드 !!
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for < cell reuse > to represent different searchResult")
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    //
}
