//
//  partySizeViewController.swift
//  OpenTableAU
//
//  Created by Martina on 15/06/22.
//

import UIKit

class partySizeViewController: UIViewController {
    
    // options 1 to 5
    var options: [Int] = []
    
    // storyboard: table view and "cancel" button (top right)
    @IBOutlet var partySizeTableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    // save data as user moves from one VC to another
    var previousSelection = Constants.newReservation?.party
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare TV and data
        prepareOptions()
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

    // fetch data for TV
    func prepareOptions() {
        
        // from 1 to 5
        for i in 1...5 {
            
            // appent to array
            options.append(i)
            
            // when done...
            if i == 5 {
                
                // pass data to TV
                partySizeTableView.delegate = self
                partySizeTableView.dataSource = self
                
                // set up tv
                partySizeTableView.tableFooterView = UIView()
                partySizeTableView.separatorStyle = .none
                
            }
            
        }
        
    }

}

// MARK: - Party size TV

extension partySizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of options
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference data
        let ref = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "partySizeTableViewCell", for: indexPath) as! partySizeTableViewCell
        
        // cell setup
        cell.selectionStyle = .none
        if let selection = previousSelection, selection == ref {
            cell.setSelected(true, animated: true)
        }
        
        // cell data
        cell.numberLabel.text = "\(ref)"
        cell.numberLabel.layer.cornerRadius = cell.numberLabel.frame.height/2
        cell.numberLabel.layer.masksToBounds = true
        
        // return cell
        return cell
    }
    
    // define static height for cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // height 100
        return 100
    }
    
    // define cell selection action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // reference data
        let ref = options[indexPath.row]
        
        // pass data and perform segue
        Constants.newReservation?.party = ref
        self.performSegue(withIdentifier: "addDetailsSegue", sender: self)
        
    }
    
}

// MARK: - Party size TV Cell

class partySizeTableViewCell: UITableViewCell {
    
    // height and width
    var size: CGFloat = 60
    
    // number label
    lazy var numberLabel: UILabel = {
        let l = UILabel()
        l.frame = CGRect(x: UIScreen.main.bounds.width/2-(size/2),
                         y: self.frame.height/2-(size/2),
                         width: size,
                         height: size)
        l.backgroundColor = UIColor(named: "Colour")
        l.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        l.textAlignment = .center
        l.textColor = .white
        return l
    }()
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.addSubview(numberLabel)
    }
    
    // selected status: border around button
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            numberLabel.layer.borderColor = UIColor.label.cgColor
            numberLabel.layer.borderWidth = 5
        } else {
            numberLabel.layer.borderColor = UIColor.clear.cgColor
            numberLabel.layer.borderWidth = 0
        }
    }
    
}
