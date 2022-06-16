//
//  Constants.swift
//  OpenTableAU
//
//  Created by Martina on 14/06/22.
//

import Foundation
import UIKit

// Constant data
class Constants {
    
    
    // MARK: - Reservations
    
    // reservations data
    static var reservations: [reservation] = []
    static var newReservation: reservation?
    static var selectedReservation: reservation?
    
    // callback when new reservation is made
    static var callback: (([Constants.reservation]) -> ())?
    
    // reservation structure
    struct reservation {
        
        var name = String()
        var time = Date()
        var party = Int()
        var number = String()
        var notes: String?
        
    }
    
    
    // MARK: - Time slots
    
    // unavailable time slots
    static var unavailableTimeSlots: [timeSlot] = []
    
    // time slots structure
    struct timeSlot {
        
        var time = Date()
        var string = String()
        var available: booked?
        
    }
    
    // booked status
    enum booked {
        
        case unavailable
        case available
        case risky
        
    }
    
    
    // MARK: - Functions
    
    // fetch reservations for home screen
    func fetchReservations(completion: @escaping ([Constants.reservation]) -> ()) {
        
        // create mock data
        let cal = Calendar.current
        let data = [
        
            Constants.reservation(name: "Jane", time: cal.date(bySettingHour: 15, minute: 15, second: 0, of: Date())!, party: 5, number: "0405678253", notes: "Allergic to peanut"),
            Constants.reservation(name: "Marcus", time: cal.date(bySettingHour: 17, minute: 30, second: 0, of: Date())!, party: 2, number: "0402825508", notes: "Window seat"),
            Constants.reservation(name: "Craig", time: cal.date(bySettingHour: 19, minute: 00, second: 0, of: Date())!, party: 3, number: "0404782938", notes: "Window seat")
        
        ]
        
        // append to array
        Constants.reservations.append(contentsOf: data)
        
        // make reserved time slots unavailable
        for d in Constants.reservations {
            
            // call function
            makeSlotUnavailable(d.time)
            
        }
        
        // pass data to VC
        completion(data)
        
    }
    
    // make reserved time slots unavailable
    func makeSlotUnavailable(_ time: Date) {
        
        // 60 mins prior (risky) & 60 mins later (unavailable)
        let s = stride(from: -45, to: 60, by: 15)
        for i in s {
            
            // add time interval & define risky/unavailable
            let t = time.addingTimeInterval(TimeInterval(i*60))
            let u = unavailability(by: i)
            
            // remove duplicates
            if u == .unavailable {
                Constants.unavailableTimeSlots.removeAll(where: { $0.time == t })
            }
            
            // add unavailable time slot
            Constants.unavailableTimeSlots.append(timeSlot(time: t, string: t.timeString(), available: u))
            
        }
        
    }
    
    // create time slots
    func createTimeSlots(completion: @escaping ([timeSlot]) -> ()) {
        
        // from 3PM (15) to 10PM (22)
        let date = Date()
        let cc = Calendar.current
        let time = cc.date(bySettingHour: 15, minute: 0, second: 0, of: date)
        let endTime = cc.date(bySettingHour: 22, minute: 00, second: 0, of: date)

        // define date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        // start calc from 3PM
        if var time = time {
            
            // check if available/risky/unavailable
            let uts = Constants.unavailableTimeSlots
            var timeSlots = [timeSlot(time: time,
                                      string: dateFormatter.string(from: time),
                                      available: uts.first(where:{ $0.time == time})?.available ?? .available)]

            // calculate till 10PM
            while endTime!.timeIntervalSince(time) > 0 {
                
                // add 15m each time
                time += 15*60
                timeSlots.append(timeSlot(time: time, string: dateFormatter.string(from: time), available: uts.first(where:{ $0.time == time})?.available ?? .available))
                
            }

            // pass data
            completion(timeSlots)
        }
        
    }
    
    // check availability status
    func unavailability(by int: Int) -> booked {
        
        switch int {
        
        // risky: can't make booking <60m before a booking or table won't have 60 mins
        case (-45)...(-1):
                return .risky
        // unavailable: can't make booking <60m since booking time, table taken
        case 0...60:
                return .unavailable
        // available: there is no booking in the past or next 60m, table available
        default:
                return .available
            
        }
        
    }
        
    // cancel booking alert for creation flow: delete reservation data and dismiss view
    func cancelBookingAlert(_ vc: UIViewController) {
        
        // create alert
        let alert = UIAlertController(title: "Cancel reservation?", message: "This will delete all your data.", preferredStyle: .alert)
        
        // confirm cancellation
        let action = UIAlertAction(title: "Confirm & cancel", style: .default) { action in
            Constants.newReservation = nil
            vc.dismiss(animated: true)
        }
        
        // dismiss and continue editing
        let cancel = UIAlertAction(title: "Keep editing", style: .cancel)
        
        // set up and present alert
        alert.addAction(action)
        alert.addAction(cancel)
        alert.view.tintColor = .label
        vc.present(alert, animated: true)
        
        
    }
    
    // add new reservation data
    func addNewReservation() {
        
        // get data from optional newReservation
        if let newres = Constants.newReservation {

            // add to array and sort by time
            Constants.reservations.append(newres)
            Constants.reservations.sort(by: { $0.time < $1.time })
            
        }
        
    }

    
    // confirm new reservation string
    func newReservationString() -> String {
        
        // get new reservation data
        let r = Constants.newReservation
        if let name = r?.name,
           let time = r?.time.timeString(),
           let party = r?.party,
           let notes = r?.notes {
            
            // return string
            let txt = "You added a reservation for\n\n\(name)\nat \(time)\nfor \(party) people\nNotes:\n\((notes != "") ? notes : "The guest left no notes.")"
            return txt
        }
        
        return String()
        
    }
    

    
}
