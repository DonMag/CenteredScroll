//
//  FirstViewController.swift
//  CenteredScroll
//
//  Created by Don Mag on 5/15/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

class DashedBorderView: UIView {
	
	// simple view with dashed border
	
	var shapeLayer: CAShapeLayer!
	
	override class var layerClass: AnyClass {
		return CAShapeLayer.self
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	func commonInit() -> Void {
		
		shapeLayer = self.layer as? CAShapeLayer
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.strokeColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0).cgColor
		shapeLayer.lineWidth = 1.0
		shapeLayer.lineDashPattern = [8,8]
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		print(NSStringFromClass(type(of: self)), #function, bounds)
		shapeLayer.path = UIBezierPath(rect: bounds).cgPath
	}
}
