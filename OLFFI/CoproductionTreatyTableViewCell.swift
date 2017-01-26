//
//  CoproductionTreatyTableViewCell.swift
//  OLFFI
//
//  Created by Gabriel Morin on 25/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit

class CoproductionTreatyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var inForceLabel: UILabel!
    
    var treaty:CoproductionTreatyResponse? {
        didSet {
            if let t = treaty {
                titleLabel.text = "\(t.countries_list!) (\(t.sign_date!))"
                
                projectTypeLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"Project type",
                                              text:t.project_type!)
                
                inForceLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"In force",
                                              text:t.in_force!)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
