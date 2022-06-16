//
//  reservationsListViewController.swift
//  OpenTableAU
//
//  Created by Martina on 14/06/22.
//

import UIKit

class reservationsListViewController: UIViewController {

    // table view data: reservations
    var reservations = Constants.reservations
    
    // storyboard: "create" button and reservations list table view
    @IBOutlet var addReservationButton: UIBarButtonItem!
    @IBOutlet var reservationsTableView: UITableView!
    
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch data for TV
        fetchData()
        
    }
    
    
    // MARK: - View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // add action to "create" button
        addReservationButton.target = self
        addReservationButton.action = #selector(addReservation(sender:))
        
    }
    
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // reload table view data once new reservation is added
        if segue.identifier == "createReservationSegue" {
            
            // pass data through call back
            Constants.callback = { reservations in
                self.reservations = reservations
                self.reservationsTableView.reloadData()
                
            }
            
        }
        
    }
    
    // MARK: - Functions
    
    // action for "create" bar button
    @objc func addReservation(sender: UIBarButtonItem) {
        
        // start create flow through modal segue
        self.performSegue(withIdentifier: "createReservationSegue", sender: self)
        
    }
    
    // fetch data for TV
    func fetchData() {
        
        // find mock data reservations
        Constants().fetchReservations { res in
            
            // get reservations and sort by time
            self.reservations.append(contentsOf: res)
            self.reservations.sort(by: { $0.time < $1.time })
            
            // start passing data to the TV
            self.reservationsTableView.delegate = self
            self.reservationsTableView.dataSource = self
            
        }
        
    }
    

}


// MARK: - Table View

extension reservationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of reservations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reservations.count
    }
    
    // reservations data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference data
        let ref = reservations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationTableViewCell", for: indexPath) as! reservationTableViewCell
        
        // cell setup
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        // pass data to cell
        cell.nameLabel.text = ref.name
        cell.partySizeLabel.text = "\(ref.party)"
        cell.timeLabel.text = ref.time.timeString()
        
        // return cell
        return cell
        
    }
    
    // define static height for cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // height 90
        return 90
    }
    
    // define cell selection action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // define selected reservation & perform segue
        Constants.selectedReservation = reservations[indexPath.row]
        self.performSegue(withIdentifier: "viewReservationSegue", sender: self)
        
    }
    
    
}

// MARK: - Reservation TV Cell

class reservationTableViewCell: UITableViewCell {

    // horizontal stack view (party size > name&time)
    var horizontalStackView: UIStackView = {
        let v = UIStackView()
        v.distribution = .fill
        v.axis = .horizontal
        v.spacing = 30
        return v
    }()
    
    // vertical stack view (name, time)
    var verticalStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fillEqually
        v.alignment = .leading
        return v
    }()
    
    // reservation name
    var nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return l
    }()
    
    // reservation size
    var partySizeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return l
    }()
    
    // time label
    var timeLabel = UILabel()
    
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add horizontal stack view
        self.addSubview(horizontalStackView)
        
        // define position & content
        horizontalStackView.frame = CGRect(x: 20, y: 20, width: self.frame.size.width, height: 50)
        horizontalStackView.addArrangedSubview(partySizeLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        // add name and time in vertical stack view
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(timeLabel)
    }

}
