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

}
