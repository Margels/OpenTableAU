//
//  selectTimeViewController.swift
//  OpenTableAU
//
//  Created by Martina on 14/06/22.
//

import UIKit

class selectTimeViewController: UIViewController {
   
    // storyboard: table view and "cancel" button (top right)
    @IBOutlet var availableSlotsTableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    // time slots for table view
    var timeSlots: [Constants.timeSlot] = []
    
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch data for TV
        fetchData()
        
    }
    
    
    // MARK: - View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // define cancel button action
        cancelButton.target = self
        cancelButton.action = #selector(dismissView(sender:))
    }
    
    
    // MARK: - Functions
    
    // cancel button action
    @objc func dismissView(sender: UIBarButtonItem) {
        
        // dismiss view & cancel new booking data
        Constants().cancelBookingAlert(self)
        
    }
    
    // get data for TV
    func fetchData() {
        
        // create time slots
        let c = Constants()
        c.createTimeSlots { timeSlots in
            
            // create and sort time slots
            self.timeSlots = timeSlots
            self.timeSlots.sort(by: { $0.time < $1.time })
            
            // pass data to TV
            self.availableSlotsTableView.delegate = self
            self.availableSlotsTableView.dataSource = self
            
        }
        
    }
    
    // book where customer can stay 60 mins
    func changeBookingAlert() {
        
        // alert
        let alert = UIAlertController(title: "The next booking is in less than 60 minutes", message: "Please select a different time slot so each customer can enjoy their table for 60 minutes.", preferredStyle: .alert)
        
        // action
        let OK = UIAlertAction(title: "OK", style: .cancel)
        
        // create alert
        alert.addAction(OK)
        alert.view.tintColor = .label
        self.present(alert, animated: true)
        
    }

}

// MARK: - Table view

extension selectTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of time slots
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    // tims slots data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference data
        let ref = timeSlots[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectTimeTableViewCell", for: indexPath) as! selectTimeTableViewCell
        
        // cell setup
        cell.selectionStyle = .none
        
        // cell data
        cell.timeLabel.text = ref.string
        cell.available = ref.available ?? .available
        cell.availableTimeSlot()
        
        // return cell
        return cell
        
    }
    
    // define static height for cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // height 60
        return 60
    }
    
    // define cell selection action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // define reference to data
        let ref = timeSlots[indexPath.row]
        
        // define action depending on availability
        if ref.available == .risky {
            
            // alert: can't book because customer would have less than 60m
            changeBookingAlert()
            
        } else {
            
            // start defining new reservation data and define segue
            Constants.newReservation = Constants.reservation(name: "", time: ref.time, party: 0, number: "", notes: "")
            self.performSegue(withIdentifier: "addPartySegue", sender: self)
        }
        
    }
    
    
}

// MARK: - Select time TV Cell

class selectTimeTableViewCell: UITableViewCell {
    
    // verticall stack view (time, availability status)
    var verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    // time label
    var timeLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return l
    }()
    
    // availability label, not always there
    var unavailableLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        l.textColor = .darkGray
        return l
    }()
    
    // time slot availability
    var available: Constants.booked = .available
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // vertical stack view position and add to subview
        verticalStackView.frame = CGRect(x: 0,
                                         y: 10,
                                         width: UIScreen.main.bounds.width,
                                         height: self.frame.height)
        self.addSubview(verticalStackView)
        
        // add time label to vertical stack view
        verticalStackView.addArrangedSubview(timeLabel)
        
    }
    
    // change behaviour depending on availability
    func availableTimeSlot() {
        
        switch available {
        
            // if available, cell selectable, text color black
            case .available:
            
                self.isUserInteractionEnabled = true
                self.backgroundColor = .systemBackground
                timeLabel.textColor = .label
                unavailableLabel.text = ""
                unavailableLabel.textColor = .clear
            
            // if risky, text red, cell selectable but will get alert
            case .risky:
            
                self.isUserInteractionEnabled = true
                self.backgroundColor = .systemBackground
                timeLabel.textColor = .red
                unavailableLabel.text = ""
                unavailableLabel.textColor = .red
            
            // if unavailable, cell is unselectable, all gray
            default:
            
                self.isUserInteractionEnabled = false
                self.backgroundColor = .secondarySystemBackground
                timeLabel.textColor = .darkGray
                verticalStackView.addArrangedSubview(unavailableLabel)
                unavailableLabel.text = "Not available"
                unavailableLabel.textColor = .darkGray
            
        }
        
    }
    
}
