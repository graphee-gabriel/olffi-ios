//
//  SearchTableViewCell.swift
//  OLFFI
//
//  Created by Gabriel Morin on 25/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var levelLeftLabel: UILabel!
    @IBOutlet weak var activityRightLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var natureOfProjectLabel: UILabel!
    
    var hit:SearchResultHit? {
        didSet {
            if let h = hit {
                titleLabel.text = "\(h.program_name!) (\(h.country_name!))"
                subtitleLabel.text = h.fb_name!
                
                levelLeftLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"Level",
                                   text:h.level!)
                
                activityRightLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"Activity",
                                   text:h.activity!)

                var projectType = ""
                if let type = h.project_type {
                    projectType = type.joined(separator: ", ")
                }
                
                var natureOfProject = ""
                if let nature = h.nature_of_project {
                    natureOfProject = nature.joined(separator: ", ")
                }
                
                var projectType = ""
                if let type = h.project_type {
                    projectType = type.joined(separator: ", ")
                }
                
                var natureOfProject = ""
                if let nature = h.nature_of_project {
                    natureOfProject = nature.joined(separator: ", ")
                }
                
                projectTypeLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"Project type",
                                              text:projectType)
                
                natureOfProjectLabel.attributedText =
                    ViewHelper.buildLabelWith(title:"Nature of project",
                                              text:natureOfProject)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // backgroundColor = UIColor(red:255.0, green:255.0, blue:255.0, alpha:0.50)
        // backgroundColor = UIColor.clear
        // backgroundView?.backgroundColor = UIColor.clear //UIColor(red:255.0, green:255.0, blue:255.0, alpha:0.50)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
