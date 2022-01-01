//
//  FloatingButtonItem.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 12/14/19.
//  Copyright © 2019 simplyAmazingMachines. All rights reserved.
//

import UIKit

public typealias FloatingButtonItemAction = (FloatingButtonItem) -> (Void)

//The buttons/image/lbl that appear when the floating action button is pressed. 

open class FloatingButtonItem: NSObject {

    //the action the item should perform when tapped
    open var action: FloatingButtonItemAction?
    
    //Description of the item's action
    
    open var text: String {
        get {
            return self.label.text!
        }
        set {
            self.label.text = newValue
        }
    }
    
    //view that will hold the item's button and label
    var view: UIView!
    
    //label that contain the item's text
    var label: UILabel!
    
    //main button that will perform the defined action
    var button: UIButton!
    
    //image used by the button
    var image: UIImage!
    
    //size needed for the view property present the item's content
    let viewSize = CGSize(width: 200, height: 35)
    
    //button's size by default the button is 35x35
    let buttonSize = CGSize(width: 35, height: 35)
    
    var labelBackground: UIView!
    let backgroundInset = CGSize(width: 10, height: 10)
    
    public init(title optionalTitle: String?, image: UIImage?) {
        super.init()
        
        //so when the button is pressed a view will appear with buttons and labels that can be pressed. the view has no background either
        
        self.view = UIView(frame: CGRect(origin: CGPoint.zero, size: self.viewSize))
        self.view.alpha = 0
        self.view.isUserInteractionEnabled = true
        
        //make image labelColor
        self.image = image?.withRenderingMode(.alwaysTemplate)
        
        //this creates the button that we can press
        self.button = UIButton(type: .custom)
        self.button.frame = CGRect(origin: CGPoint(x: self.viewSize.width - self.buttonSize.width, y: 0), size: buttonSize)
        self.button.layer.shadowOpacity = 1
        self.button.layer.shadowRadius = 2
        self.button.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.button.layer.shadowColor = UIColor.black.cgColor
        self.button.addTarget(self, action: #selector(FloatingButtonItem.buttonPressed(_:)), for: .touchUpInside)
        button.tintColor = .white
        
        if let unwrappedImage = image {
            self.button.setImage(unwrappedImage, for: UIControl.State())
        }
        
        if let text = optionalTitle, text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            self.label = UILabel()
            self.label.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            self.label.textColor = UIColor.black
            self.label.textAlignment = .right
            self.label.text = text
            self.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FloatingButtonItem.labelTapped(_:))))
            self.label.sizeToFit()
            
            self.labelBackground = UIView()
            self.labelBackground.frame = self.label.frame
            self.labelBackground.backgroundColor = UIColor.white
            self.labelBackground.layer.cornerRadius = 5
            self.labelBackground.layer.shadowOpacity = 0.8
            self.labelBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.labelBackground.layer.shadowRadius = 0.2
            self.labelBackground.layer.shadowColor = UIColor.lightGray.cgColor
            
            //Adjust the label's background inset
            self.labelBackground.frame.size.width = self.label.frame.size.width + backgroundInset.width
            self.labelBackground.frame.size.height = self.label.frame.size.height + backgroundInset.height
            self.label.frame.origin.x = self.label.frame.origin.x + backgroundInset.width / 2
            self.label.frame.origin.y = self.label.frame.origin.y + backgroundInset.height / 2
            //adjust the label's background position
                //distance between the button and the label
            self.labelBackground.frame.origin.x = CGFloat(130 - self.label.frame.size.width)
            self.labelBackground.center.y = self.view.center.y
            self.labelBackground.addSubview(self.label)
            
            //Add Tap gesture recognizer
            let tap = UITapGestureRecognizer(target: self, action: #selector(FloatingButtonItem.labelTapped(_:)))
            self.view.addGestureRecognizer(tap)
            self.view.addSubview(self.labelBackground)
        }
        self.view.addSubview(self.button)
    }
 
    //MARK: -Button Action Methods
    @objc func buttonPressed(_ sender: UIButton) {
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
    
    //MARK: - Gesture Recognizer Methods
    @objc func labelTapped(_ gesture: UIGestureRecognizer) {
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
}
