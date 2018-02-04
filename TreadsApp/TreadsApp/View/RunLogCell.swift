//
//  RunLogCell.swift
//  TreadsApp
//
//  Created by Alex on 2/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {

    @IBOutlet weak var runDurationLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(run: Run){
        runDurationLabel.text = run.duration.formatTimeDurationToString()
        totalDistanceLabel.text = "\(run.distance.metersToMiles(to: 2)) mi"
        averagePaceLabel.text = run.pace.formatTimeDurationToString()
        dateLabel.text = run.date.getDateString()
    }

}
