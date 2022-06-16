//
//  Extensions.swift
//  OpenTableAU
//
//  Created by Martina on 15/06/22.
//

import Foundation
import UIKit

// MARK: - Date

extension Date {
    
    // transform date to string
    func timeString() -> String {
        
        // format to extract the time only
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
        
    }
    
}

// MARK: - View Controller, Scroll View

extension UIViewController {
    
    // notification for keyboard will show
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
            
            // scroll to show text field
            let scrollPoint = CGPoint(x: 0, y: keyboardSize.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
            
        })
        
    }
    
    // notification for keyboard will hide
    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
        scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
        block?(keyboardSize)
            
        })
        
    }
    
}



extension UIScrollView {
    
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
        
    }
    
}
