//
//  FloatingButton.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 12/14/19.
//  Copyright © 2019 simplyAmazingMachines. All rights reserved.
//

import UIKit

//Part of the file to create the floating action button.
//It is for the physical button and the action of when it is pressed.
public typealias CameraButtonAction = (FloatingButton) -> Void

open class FloatingButton: NSObject {

    //the action the button should perform when tapped
    var action: CameraButtonAction?
    
    //the button's background color: set default color and selected color
    var backgroundColor: UIColor = UIColor.systemGray {
        willSet {
            floatButton.backgroundColor = newValue
            backgroundColorSelected = newValue
        }
    }
    
    //the button's background color: set default color
    var backgroundColorSelected: UIColor = UIColor.systemBackground
    
    //indicates if the button is active
    var active: Bool = false
    
    //an array of items that the button will present
    var items: [FloatingButtonItem]? {
        willSet {
            if let item = self.items {
                for abi in item {
                    abi.view.removeFromSuperview()
                }
            }
        }
        didSet {
            placeButtonItems()
            showActive(true)
        }
    }
    
    
    //the button that will be presented to the user
    var floatButton: UIButton!
    
    //view that will hold the placement of the button's actions
    var contentView: UIView!
    
    //view where the floatbutton will be displayed
    var parentView: UIView!
    
    //blur effect that will be presented when the button is active
    var blurVisualEffect: UIVisualEffectView!
    
    //distance between each item action
    let itemOffset = -55
    
    //the float button's radius
    let floatBtnRadius = 50
    
    //the float button's trailing padding
    let floatButtonTrailingPadding: CGFloat = 15
    
    //the float button's bottom padding
    let floatButtonBottomPadding: CGFloat = 15
    
    //the view's bottom padding
    let otherButtonBottomPadding: CGFloat = 20
    
    public init(attachedToView view: UIView, items: [FloatingButtonItem]?) {
        super.init()
        
        //creates the float button
        self.parentView = view
        self.items = items
        let bounds = self.parentView.bounds
        
        self.floatButton = UIButton(type: .custom)
        self.floatButton.layer.cornerRadius = CGFloat(floatBtnRadius / 2)
        self.floatButton.layer.shadowOpacity = 1
        self.floatButton.layer.shadowRadius = 2
        self.floatButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.floatButton.layer.shadowColor = UIColor.systemGray.cgColor
        
        let cameraImg = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysTemplate)
        self.floatButton.setImage(cameraImg, for: UIControl.State())
        floatButton.tintColor = .label
        self.floatButton.backgroundColor = self.backgroundColor
        self.floatButton.layer.borderWidth = 1
        self.floatButton.layer.borderColor = UIColor.label.cgColor
        self.floatButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.floatButton.isUserInteractionEnabled = true
        self.floatButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.floatButton.addTarget(self, action: #selector(FloatingButton.buttonTapped(_:)), for: .touchUpInside)
        self.floatButton.addTarget(self, action: #selector(FloatingButton.buttonTouchDown(_:)), for: .touchDown)
        self.parentView.addSubview(self.floatButton)
        
        self.contentView = UIView(frame: bounds)
        self.blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurVisualEffect.frame = self.contentView.frame
        self.contentView.addSubview(self.blurVisualEffect)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.blurVisualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FloatingButton.backgroundTapped(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        self.installConstraints()
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?, forState state: UIControl.State) {
        floatButton.setImage(image, for: state)
        floatButton.adjustsImageWhenHighlighted = false
        floatButton.contentEdgeInsets = UIEdgeInsets.zero
    }
    
    //MARK: - Auto layout methods
    //install all the necessary contraints for the button. by the default the button will be placed at 15pts from the bottom and 15pts from the right of its parentView
    
    func installConstraints() {
        let views: [String: UIView] = ["floatButton": self.floatButton, "parentView":self.parentView]
        let width = NSLayoutConstraint.constraints(withVisualFormat: "H:[floatButton(\(floatBtnRadius))]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        let height = NSLayoutConstraint.constraints(withVisualFormat: "V:[floatButton(\(floatBtnRadius))]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        self.floatButton.addConstraints(width)
        self.floatButton.addConstraints(height)
        
        let trailingSpacing = NSLayoutConstraint.constraints(withVisualFormat: "V:[floatButton]-\(floatButtonTrailingPadding)-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        let bottomSpacing = NSLayoutConstraint.constraints(withVisualFormat: "H:[floatButton]-\(floatButtonBottomPadding)-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        self.parentView.addConstraints(trailingSpacing)
        self.parentView.addConstraints(bottomSpacing)
    }
    
    
    //MARK: -Button Actions methods
    @objc func buttonTapped(_ sender: UIControl) {
        animatePressingWithScale(1.0)
        
        if let unwrappedAction = self.action {
            
            unwrappedAction(self)
            
        }
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        animatePressingWithScale(0.8)
    }
    
    //MARK: - Gesture Recognizer Methods
    @objc func backgroundTapped(_ gesture: UIGestureRecognizer) {
        
        if self.active {
            self.toggle()
        }
    }
    
    //MARK: - Custom Methods
    
    //presents or hides all the actionButton's actions
    func toggleMenu() {
        self.placeButtonItems()
        self.toggle()
    }
    
    
    //MARK: Action Button Item Placement
    //defines the posistion of all the actionButton's actions
    func placeButtonItems() {
        if let optionalItems = self.items {
            for item in optionalItems {
                item.view.center = CGPoint(x: self.floatButton.center.x - 83, y: self.floatButton.center.y)
                item.view.removeFromSuperview()
                
                self.contentView.addSubview(item.view)
                item.view.translatesAutoresizingMaskIntoConstraints = false
                
                let guide = self.contentView.safeAreaLayoutGuide
                item.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -(floatButtonTrailingPadding)).isActive = true
                item.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(otherButtonBottomPadding)).isActive = true
                
                item.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
                item.view.heightAnchor.constraint(equalToConstant: 35).isActive = true
            }
        }
    }
    
    
    //MARK: -Float menu Methods
    //presents or hides all the actionButton's actions and changes the active state
    func toggle() {
        self.animateMenu()
        self.showBlur()
        
        self.active = !self.active
        self.floatButton.backgroundColor = self.active ? backgroundColorSelected : backgroundColor
        self.floatButton.isSelected = self.active
    }
    
    
    func animateMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            self.showActive(false)
        }, completion: {completion in
            if self.active == false {
                self.hideBlur()
            }
        })
    }
    
    func showActive(_ active: Bool) {
        if self.active == active {
            self.contentView.alpha = 1.0
            
            if let optionalItems = self.items {
                for (index, item) in optionalItems.enumerated() {
                    let offset = index + 1
                    let translation = self.itemOffset * offset
                    item.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(translation))
                    item.view.alpha = 1
                }
            }
        } else {
            self.contentView.alpha = 0.0
            if let optionalItems = self.items {
                for item in optionalItems {
                    item.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    item.view.alpha = 0
                }
            }
        }
    }
    
    
    
    func showBlur() {
        self.parentView.insertSubview(self.contentView, belowSubview: self.floatButton)
        self.contentView.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.parentView.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor).isActive = true
        
        self.blurVisualEffect.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.blurVisualEffect.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.blurVisualEffect.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.blurVisualEffect.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    }
    
    func hideBlur() {
        self.contentView.removeFromSuperview()
    }
    
    //animating the button by pressing, by default this method just scales the button down when its pressed and returns to its normal size when the button is no longer pressed
    //parameter scale: how much the button should be scaled
    func animatePressingWithScale(_ scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            self.floatButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
}
