//
//  ASExtendedCircularMenu.swift
//  Pods
//  Created by Anshul Shah on 8/1/17.
//  Copyright © 2017 Anshul Shah. All rights reserved.
//

import UIKit
import Darwin

//Enum for position options
public enum CircularButtonPosition{
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
    case centerRight
    case centerLeft
    case centerTop
    case centerBottom
}

public enum CircularButtonAnimationSpeed{
    case fast
    case modarate
    case slow
}

public enum MenuButtonSize{
    case small
    case medium
    case large
}

public protocol ASCircularButtonDelegate {
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton , indexForButton:Int , button: UIButton)
    func buttonForIndexAt(_ menuButton: ASCircularMenuButton , indexForButton:Int ) -> UIButton
}

public extension ASCircularButtonDelegate where Self:UIViewController{
    
    public func configureCircularMenuButton(button: ASCircularMenuButton, numberOfMenuItems: Int , menuRedius: CGFloat ,postion ofButton: CircularButtonPosition){
        button.configureCircularButton(numberOfMenuItems: numberOfMenuItems, menuRedius: menuRedius, postion: ofButton)
        button.parentViewOfMenuButton = self.view
        button.delegate = self
    }
    
    public func configureDraggebleCircularMenuButton(button: ASCircularMenuButton, numberOfMenuItems: Int , menuRedius: CGFloat ,postion ofButton: CircularButtonPosition){
        button.configureCircularButton(numberOfMenuItems: numberOfMenuItems, menuRedius: menuRedius, postion: ofButton)
        button.parentViewOfMenuButton = self.view
        button.delegate = self
        button.isDreggable = true
    }
    
    public func configureDynamicCircularMenuButton(button: ASCircularMenuButton, numberOfMenuItems: Int){
        button.numberOfMenuItems = numberOfMenuItems
        button.setupDynamically()
        button.parentViewOfMenuButton = self.view
        button.delegate = self
    }
    
}


public class ASCircularMenuButton: UIButton{
    
    //This is varible for give Button to initial position and also it is set dynamically for draggble button and dynamic button
    private var _circularButtonPositon : CircularButtonPosition = .bottomLeft
    public var circularButtonPositon : CircularButtonPosition = .bottomLeft
    
    
    
    //This is varible for redius of circular Menu
    public var menuRedius: CGFloat = 0.0
    public var _menuRedius: CGFloat = 0.0
    
    //This varible is used for number of menu items
    public var numberOfMenuItems : Int = 0
    
    //This is used for animation speed
    public var circularButtonAnimationSpeed : CircularButtonAnimationSpeed = .modarate
    
    //Parent view where the button is added
    public var parentViewOfMenuButton: UIView = UIView()
    
    //Object for protocol/delegete
    public var delegate: ASCircularButtonDelegate?
    
    //This var is used for Adding/removeing 360 degree rotation for main menuButton. By defualt it will be true.
    public var sholudMenuButtonAnimate: Bool = true
    
    //Varibles to set the size for Dynamic button
    private var _menuButtonSize:CGSize = CGSize.init(width: 30 , height: 30)
    public var menuButtonSize: MenuButtonSize = .medium{
        didSet{
            switch menuButtonSize {
            case .small:
                self._menuButtonSize = CGSize.init(width: 30, height: 30)
                break
            case .medium:
                self._menuButtonSize = CGSize.init(width: 40, height: 40)
                break
            case .large:
                self._menuButtonSize = CGSize.init(width: 50, height: 50)
                break
            }
        }
    }
    
    //This is bool to set is button is Dreggble or not and if it is draggeble than it will directly set the target for dragging.
    public var isDreggable: Bool = false{
        didSet{
            if self.isDreggable{
                //Adding targets for dragging schenarios.
                self.addTarget(self,
                               action: #selector(drag(control:event:)),
                               for: UIControlEvents.touchDragInside)
                self.addTarget(self,
                               action: #selector(drag(control:event:)),
                               for: [UIControlEvents.touchDragExit,
                                     UIControlEvents.touchDragOutside])
                
            }
        }
    }
    
    //function for configure MenuButton
    public func configureCircularButton(numberOfMenuItems: Int , menuRedius: CGFloat ,postion: CircularButtonPosition){
        layoutIfNeeded()
        self.numberOfMenuItems = numberOfMenuItems
        self.menuRedius = menuRedius
        layer.cornerRadius = self.frame.width / 2
        setTargetForButton()
        circularButtonPositon = postion
        _circularButtonPositon = circularButtonPositon
    }
    public func setupDynamically(){
        self.customRadiusForButton()
        self.circularButtonPositon = self.setDynamicButtonPosition()
        layer.cornerRadius = self.frame.width / 2
        setTargetForButton()
    }
    
    
    //It is dummy array for save the instance of created button. It will completly flushed when button is Tapped second time.
    private var arrayButton: [UIButton] = []
    
    //This method is called only for initialze some varibles
    required public init?(coder aDecoder: NSCoder) {
        self.isDreggable = false
        super.init(coder: aDecoder)
        self.isSelected = false
        self.tintColor = .clear
    }
    
    //This method is use for set target for MenuButton.
    public func setTargetForButton(){
        self.addTarget(self, action: #selector(onClickMenuButton), for: .touchUpInside)
        self._menuRedius = menuRedius
    }
    
    //If button is draggble than this is the target method will be called.
    @objc func drag(control: UIControl, event: UIEvent) {
        //Clearing constraints of menuButton reguarding it's parent view.
        for objectConstraint in parentViewOfMenuButton.constraints{
            if objectConstraint.firstItem as! NSObject == self{
                parentViewOfMenuButton.removeConstraint(objectConstraint)
            }
        }
        
        if var center = event.allTouches?.first?.location(in: self.parentViewOfMenuButton) {
            
            //This complete hall is use to restrict button to go out of bound
            if(center.x < (self.frame.width / 2)){
                center.x = self.frame.width / 2
            }
            if((center.y ) < (self.frame.height / 2) + 20){
                center.y = (self.frame.height / 2) + 20
            }
            if(center.x > (parentViewOfMenuButton.frame.width - self.frame.width / 2)){
                center.x = parentViewOfMenuButton.frame.width - self.frame.width / 2
            }
            if(center.y > (parentViewOfMenuButton.frame.height - self.frame.height / 2)){
                center.y = parentViewOfMenuButton.frame.height - self.frame.height / 2
            }
            //
            
            //This is use for set constraints for menuButton where it is dragged.
            DispatchQueue.main.async {
                let centerXconstraints = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.parentViewOfMenuButton, attribute: .centerX, multiplier: ((center.x * 2) /  self.parentViewOfMenuButton.frame.width) , constant: 0)
                let centerYconstraints = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.parentViewOfMenuButton, attribute: .centerY, multiplier: ((center.y * 2) /  self.parentViewOfMenuButton.frame.height) , constant: 0)
                NSLayoutConstraint.activate([centerYconstraints , centerXconstraints])
                self.layoutIfNeeded()
            }
            
            //This set button frame Dynamically
            self.customRadiusForButton()
            self.circularButtonPositon = self.setDynamicButtonPosition()
            //
        }
    }
    
    // This function will called when menu button is clicked an create/remove all child buttons
    @objc public func onClickMenuButton(){
        //If menu is not open
        if isDreggable{
            self.circularButtonPositon = self.setDynamicButtonPosition()
            self.customRadiusForButton()
        }
        if !isSelected{
            //will get all origins
            let origines = setupCGPoints()
            
            //creating all buttons at menu button icon
            for i in 0...numberOfMenuItems-1{
                
                if(self.arrayButton.count < numberOfMenuItems){
                    var button: UIButton? = UIButton()
                    button = delegate?.buttonForIndexAt(self, indexForButton: i)
                    button?.frame = self.frame
                    button?.layer.cornerRadius = _menuButtonSize.width / 2
                    button?.tag = i
                    button?.alpha = 0.0
                    button?.imageView?.contentMode = .center
                    button?.addTarget(self, action: #selector(onClickMenuItemButton(sender:)), for: .touchUpInside)
                    arrayButton.append(button!)
                }else{
                    arrayButton[i].frame = self.frame
                    layoutIfNeeded()
                }
                
                self.parentViewOfMenuButton.addSubview(self.arrayButton[i])
                
                if sholudMenuButtonAnimate{
                    rotate360Degrees(isClockwise: true)
                }
                
                //animate buttons from menu button to their origines
                UIView.animate(withDuration: 0.3, delay: 0.025 * Double(i), options: .curveEaseIn, animations: {
                    let origine = CGPoint.init(x: origines[i].x - self._menuButtonSize.width / 2, y: origines[i].y - self._menuButtonSize.width / 2)
                    self.arrayButton[i].frame = CGRect.init(origin: origine, size: self._menuButtonSize)
                    self.arrayButton[i].alpha = 1.0
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            // If menu is already open
        }else{
            for button in arrayButton{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    button.alpha = 0.0
                    button.frame = self.frame
                    self.layoutIfNeeded()
                }, completion: { (status) in
                    button.removeFromSuperview()
                })
                if sholudMenuButtonAnimate{
                    rotate360Degrees(isClockwise: false)
                }
                
            }
            //arrayButton = []
        }
        self.isSelected = !self.isSelected
        
    }
    
    //This function is used for rotate button on click 360 Degree clock or anticlock wise
    private func rotate360Degrees(duration: CFTimeInterval = 0.2, completionDelegate: AnyObject? = nil , isClockwise: Bool) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        
        if isClockwise{
            rotateAnimation.toValue = CGFloat(2 * Double.pi)
        }else{
            rotateAnimation.toValue = CGFloat(-2 * Double.pi)
        }
        rotateAnimation.duration = duration
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    //This is method for giving buttons to their Actions
    @objc public func onClickMenuItemButton(sender: UIButton){
        delegate?.didClickOnCircularMenuButton(self , indexForButton: sender.tag , button: sender)
        onClickMenuButton()
    }
    
    //This is method for getting cerculer CGPoints using geometry and trigometry
    private func setupCGPoints()->[CGPoint]{
        var arrayCGPoint:[CGPoint] = []
        
        let origineX = self.frame.origin.x + self.frame.width / 2
        let origineY = self.frame.origin.y + self.frame.height / 2
        switch circularButtonPositon {
        case .bottomRight:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX - (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY - (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
            
        case .bottomLeft:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX + (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY - (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .topLeft:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX + (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .topRight:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX - (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .center:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX + (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .centerLeft:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX + (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .centerRight:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX - (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .centerTop:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX - (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY - (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        case .centerBottom:
            let angleArray = findAngles()
            for i in 0...numberOfMenuItems - 1{
                arrayCGPoint.append(CGPoint.init(x: origineX - (menuRedius * CGFloat(sin(angleArray[i]))), y: origineY + (menuRedius * CGFloat(cos(angleArray[i])))))
            }
            break
        }
        return arrayCGPoint
    }
    
    //This method is used for find the angles for button where they need to set
    private func findAngles()->[CGFloat]{
        var array: [CGFloat] = []
        switch circularButtonPositon{
        case .center:
            let anglePartSize = (CGFloat(Double.pi) * 2) / CGFloat(numberOfMenuItems)
            for i in 0...numberOfMenuItems-1{
                array.append( CGFloat(i) * anglePartSize)
            }
            break
        case .centerLeft:
            let anglePartSize = (CGFloat(Double.pi)) / CGFloat(numberOfMenuItems - 1)
            for i in 0...numberOfMenuItems-1{
                array.append(CGFloat(i) * anglePartSize)
            }
            break
        case .centerRight:
            let anglePartSize = (CGFloat(Double.pi)) / CGFloat(numberOfMenuItems - 1)
            for i in 0...numberOfMenuItems-1{
                array.append(CGFloat(i) * anglePartSize)
            }
            break
        case .centerTop:
            let anglePartSize = (CGFloat(Double.pi)) / CGFloat(numberOfMenuItems - 1)
            for i in 0...numberOfMenuItems-1{
                array.append((CGFloat(Double.pi) / 2) + CGFloat(i) * anglePartSize)
            }
            break
        case .centerBottom:
            let anglePartSize = (CGFloat(Double.pi)) / CGFloat(numberOfMenuItems - 1)
            for i in 0...numberOfMenuItems-1{
                array.append((CGFloat(Double.pi) / 2) + CGFloat(i) * anglePartSize)
            }
            break
        default:
            let anglePartSize = (CGFloat(Double.pi) / CGFloat(2)) / CGFloat(numberOfMenuItems - 1)
            for i in 0...numberOfMenuItems-1{
                array.append( CGFloat(i) * anglePartSize)
            }
            break
        }
        return array
    }
    
    
    //This method is used when button will Dynamically set its redius
    private func customRadiusForButton(){
        
        if(_circularButtonPositon == circularButtonPositon && isDreggable){
            self.menuRedius = _menuRedius
        }else if(circularButtonPositon == .center){
            self.menuRedius = (CGFloat(self.numberOfMenuItems) * (_menuButtonSize.width + 10.0)) / (CGFloat(Double.pi) * 2) + self.frame.width
        }else if(circularButtonPositon == .centerBottom || circularButtonPositon == .centerTop || circularButtonPositon == .centerLeft || circularButtonPositon == .centerRight ){
            self.menuRedius = CGFloat(self.numberOfMenuItems - 1) * CGFloat(self.frame.width) / CGFloat(Double.pi)
            
        }else{
            self.menuRedius = 2 * CGFloat(self.numberOfMenuItems - 1) * CGFloat(self.frame.width) / CGFloat(Double.pi)
        }
    }
    
    
    //This function is used for check at which position button is
    private func setDynamicButtonPosition()-> CircularButtonPosition{
        var isLeft: Bool = false
        var isTop: Bool = false
        var isCenterX: Bool = false
        var isCenterY: Bool = false
        let x1 = self.center.x - self._menuRedius - (self._menuButtonSize.width / 2)
        let x2 = self.center.x +  (self._menuRedius) + (self._menuButtonSize.width / 2)
        let y1 = self.center.y - self._menuRedius - (self._menuButtonSize.width / 2)
        let y2 = self.center.y +  (self._menuRedius) + (self._menuButtonSize.width / 2)
        
        if(x1 <= 0){
            isLeft = true
        }else if(x1 > 0 && x2 < self.parentViewOfMenuButton.frame.width){
            isCenterX = true
        }
        
        if(y1 <= 0){
            isTop = true
        }else if(y1 > 0 && y2 < self.parentViewOfMenuButton.frame.height){
            isCenterY = true
        }
        //For setting positions
        if(isLeft){
            if isTop{
                return .topLeft
            }else if isCenterY{
                return .centerLeft
            }else{
                return .bottomLeft
            }
        }else if isCenterX{
            if isTop{
                return .centerTop
            }else if isCenterY{
                return .center
            }else{
                return .centerBottom
            }
        }else{
            if isTop{
                return .topRight
            }else if isCenterY{
                return .centerRight
            }else{
                return .bottomRight
            }
        }
        //
    }
}
