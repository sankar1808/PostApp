//
//  Post.swift
//  PostApp
//
//  Created by Sankaranarayana Settyvari on 25/04/24.
//

import UIKit

class PostCell: UITableViewCell {

    //@IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//            self.layer.shadowOpacity = 0.18
//            self.layer.shadowOffset = CGSize(width: 0, height: 2)
//            self.layer.shadowRadius = 2
//            self.layer.shadowColor = UIColor.black.cgColor
//            self.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
