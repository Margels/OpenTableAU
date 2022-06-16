//
//  reservationAddedViewController.swift
//  OpenTableAU
//
//  Created by Martina on 15/06/22.
//

import UIKit

class reservationAddedViewController: UIViewController {

    // storyboard: text label, "done" button
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // text label set up
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.text = Constants().newReservationString()
        
    }
    
    
    // MARK: - View will appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide back button once reservation is made
        self.navigationItem.hidesBackButton = true
        
    }
    
    
    // MARK: - View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // define cancel button action
        doneButton.target = self
        doneButton.action = #selector(dismissView(sender:))
    }
    
    
    // MARK: - Function
    
    @objc func dismissView(sender: UIBarButtonItem) {
        
        Constants.callback?(Constants.reservations)
        Constants().makeSlotUnavailable(Constants.newReservation!.time)
        Constants.newReservation = nil
        self.dismiss(animated: true)
        
    }

    
}
