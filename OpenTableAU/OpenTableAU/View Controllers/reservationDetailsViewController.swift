//
//  reservationDetailsViewController.swift
//  OpenTableAU
//
//  Created by Martina on 15/06/22.
//

import UIKit

class reservationDetailsViewController: UIViewController {

    // storyboard: label
    @IBOutlet var partyLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill labels
        fillLabels()
        
    }
    
    
    // MARK: - Functions
    
    func fillLabels() {
        
        // get data
        let r = Constants.selectedReservation
        if let party = r?.party,
           let name = r?.name,
           let number = r?.number,
           let time = r?.time.timeString(),
           let notes = r?.notes {
            
            // pass to labels
            partyLabel.text = String(party)
            nameLabel.text = name
            numberLabel.text = number
            timeLabel.text = time
            notesLabel.text = (notes != "") ? notes : "The guest left no notes."
            
        }
        
    }

}
