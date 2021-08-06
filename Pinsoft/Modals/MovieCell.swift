//
//  MovieCell.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailView.layer.cornerRadius = 15
        self.thumbnailView.layer.borderWidth = 2
        self.thumbnailView.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
