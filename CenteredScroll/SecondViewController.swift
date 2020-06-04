//
//  SecondViewController.swift
//  CenteredScroll
//
//  Created by Don Mag on 5/15/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
	
	@IBOutlet var emailTextField: CustomTextField!
	@IBOutlet var passwordField: UITextField!
	@IBOutlet var textView: UITextView!
	@IBOutlet var loginButton: UIButton!
	
	@IBOutlet var scrollView: UIScrollView!
	
	@IBOutlet var emailView: UIView!
	
	@IBOutlet var emailViewTopConstraint: NSLayoutConstraint!
	
	var textViewMaxHeight: CGFloat = 120
	var savedKbHeight: CGFloat = 0

	lazy var editViews: [UIView] = [emailTextField, passwordField, textView]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTextField.delegate = self
		passwordField.delegate = self
		textView.delegate = self
		
		loginButton.addTarget(self, action: #selector(self.loginTapped(_:)), for: .touchUpInside)
	}
	
	@IBAction func loginTapped(_ sender: Any) {
		// just dismissing the keyboard for now
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// if not actively editing, adjust views to vertically centered in scroll view
		//	with minimum top space of 8.0
		let activeField: UIView? = editViews.first { $0.isFirstResponder }
		if activeField == nil {
			let contentHeight = (loginButton.frame.maxY - emailView.frame.minY)
			let h = (scrollView.frame.height - contentHeight) * 0.5
			emailViewTopConstraint.constant = max(8.0, h)
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
	}
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func keyboardWillShow(notification:NSNotification) {
		let userInfo = notification.userInfo!
		let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let kbSize = keyboardFrame.size
		var contentInset:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
		
		if let v = self.tabBarController?.tabBar {
			contentInset.bottom -= v.frame.height
		}
		
		scrollView.contentInset = contentInset
		scrollView.scrollIndicatorInsets = contentInset
		
		if textView.isFirstResponder {
			let fr = textView.frame
			scrollView.scrollRectToVisible(fr, animated: false)
		}
		
		savedKbHeight = kbSize.height
		
	}
	
	@objc func keyboardWillHide(notification:NSNotification) {
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInset
		scrollView.scrollIndicatorInsets = contentInset
	}
	
	func textViewDidChange(_ textView: UITextView) {
		
		let estimatedSize = textView.sizeThatFits(textView.frame.size)

		textView.isScrollEnabled = estimatedSize.height > textViewMaxHeight

		if !textView.isScrollEnabled {
			let maxBottom = self.view.frame.height - self.savedKbHeight
			var r = self.textView.frame
			r.size.height = estimatedSize.height
			let tvBottom = self.scrollView.convert(r, to: self.view).maxX
			if tvBottom > maxBottom {
				self.scrollView.scrollRectToVisible(r, animated: true)
			}
		}
		
	}
	
}

