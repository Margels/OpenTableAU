//
//  addDetailsViewController.swift
//  OpenTableAU
//
//  Created by Martina on 15/06/22.
//

import UIKit

class addDetailsViewController: UIViewController {

    // storyboard: stackview, scrollview, labels and button
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var partySizeLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameTextLine: UIView!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var phoneTextLine: UIView!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var notesTextLine: UIView!
    
    @IBOutlet var charLeft: UILabel!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle save button
        disableSaveButton()
        
        // save button: make rounded, height & width on storyboard
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        
        // scroll view: dismiss keyboard mode
        scrollView.keyboardDismissMode = .interactive
        
        // stackview spacing
        stackView.spacing = 20
        
        // define phone text content, keyboard type
        phoneTextField.keyboardType = .phonePad

        // keyboard handling
        self.registerForKeyboardWillShowNotification(scrollView)
        self.registerForKeyboardWillHideNotification(scrollView)
        
    }
    
    
    // MARK: - View will appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // delegate text field + text view
        [phoneTextField, nameTextField].forEach { v in
            v.delegate = self
        }
        notesTextView.delegate = self
        
        // fetch data
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

    // fetch data
    func fetchData() {
        
        // get reservation
        let r = Constants.newReservation
        
        // fill time & party labels
        if let time = r?.time, let party = r?.party {
            
            // add time & party
            timeLabel.text = time.timeString()
            partySizeLabel.text = String(party)
            
        }
        
        // set up other fields and characters left
        nameTextField.text = r?.name ?? ""
        phoneTextField.text = r?.number ?? ""
        notesTextView.text = r?.notes ?? ""
        charLeft.text = "\(200 - notesTextView.text.count) / 200 "
        
    }
    
    // animating text field
    func animateTextFields(_ view: UIView) {
        
        // line fades upon touch of text field
        view.alpha = 0
        UIView.animate(withDuration: 1, delay: 0) {
            view.alpha = 0.4
        }
    }
    
    // handle save button
    func disableSaveButton() {
     
        // check that required text fields are full
        let r = Constants.newReservation
        let bool = r?.name != "" && r?.number != ""
        
        // handle button
        switch bool {
        case true:
            saveButton.alpha = 1
            saveButton.isUserInteractionEnabled = true
        case false:
            saveButton.alpha = 0.5
            saveButton.isUserInteractionEnabled = false
        
        }
    }
    
    // save alert
    func saveAlert() {
        
        // alert
        let alert = UIAlertController(title: "Save reservation?", message: "This will add the reservation to today's reservations list.", preferredStyle: .alert)
        
        // action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { action in
            
            // add reservation
            Constants().addNewReservation()
            self.performSegue(withIdentifier: "reservationAdded", sender: self)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        // set up
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.view.tintColor = .label
        self.present(alert, animated: true)
        
    }
        
    // MARK: - My words
    @IBAction func saveAction(_ sender: Any) {
        
        // save alert
        saveAlert()
    }
    
    

}

// MARK: - Add details Text Field Delegate

extension addDetailsViewController: UITextFieldDelegate {
    
    // handle animation upon interaction with textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
            
            // name text field
            case nameTextField:
                animateTextFields(nameTextLine)
                
            // phone text field
            case phoneTextField:
                animateTextFields(phoneTextLine)
                
            // default
            default: return
            
        }
        
    }
    
    // user is typing in the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // establish limit of characters and assign new strings to constant's new reservation
        if let newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
            
            // count characters and assign new string
            let numberOfChars = newText.count
            switch textField {
                
                // for the name text field
                case nameTextField:
                    Constants.newReservation?.name = newText
                    disableSaveButton()
                    return numberOfChars < 30
                
                // for the phone text field
                default:
                    Constants.newReservation?.number = newText
                    disableSaveButton()
                    return numberOfChars < 16
                
                }
            
            }
        
        return Bool()
        
        }
        
    }
    

// MARK: - Add details Text View Delegate

extension addDetailsViewController: UITextViewDelegate {
    
    // user is typing in the text field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // add new text to new reservation
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        Constants.newReservation?.notes = newText
        return numberOfChars < 201
        
    }
    
    // handle animation upon interaction with textviews
    func textViewDidBeginEditing(_ textView: UITextView) {
        animateTextFields(notesTextLine)
    }
    
    // increase text view size as user types
    func textViewDidChange(_ textView: UITextView) {
        
        // calculate size:
        let size = CGSize(width: textView.frame.width, height: .infinity)
        
        // change size in real time:
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                
                // stop at height 100 and enable scrolling:
                if estimatedSize.height <= 100 {
                    constraint.constant = estimatedSize.height } else { constraint.constant = 100
                        textView.isScrollEnabled = true
                        
                    }
                
            }
            
        }
        
        // recalculate characters left
        charLeft.text = "\(200 - textView.text.count) / 200 "
            
    }
        
}
