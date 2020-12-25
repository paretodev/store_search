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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
