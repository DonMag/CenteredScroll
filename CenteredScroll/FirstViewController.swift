//
//  FirstViewController.swift
//  CenteredScroll
//
//  Created by Don Mag on 5/15/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	// we'll change the constant on this constraint to move the
	//	bottom of the scroll view Up / Down with the keyboard
	@IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func handleKeyboardNotification(_ notification: Notification) {
		
		guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
			return
		}
		
		var h = keyboardRect.height
		if let v = self.tabBarController?.tabBar {
			h -= v.frame.height
		}
		
		let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
		
		scrollViewBottomConstraint?.constant = isKeyboardShowing ? -h : 0
		
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
		
	}
	
	@IBAction func loginTapped(_ sender: Any) {
		// just dismissing the keyboard for now
		view.endEditing(true)
	}
	
}

