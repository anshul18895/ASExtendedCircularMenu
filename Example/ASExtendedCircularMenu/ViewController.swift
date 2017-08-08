//
//  ViewController.swift
//  ASExtendedCircularMenu
//
//  Created by anshul18895 on 08/08/2017.
//  Copyright (c) 2017 anshul18895. All rights reserved.
//

import UIKit
import ASExtendedCircularMenu
class ViewController: UIViewController,ASCircularButtonDelegate {

    @IBOutlet var shareButton: ASCircularMenuButton!
    @IBOutlet var colourPickerButton: ASCircularMenuButton!
    @IBOutlet var viewLbl: UILabel!
    let colourArray: [UIColor] = [.red , .blue , .green , .yellow , .purple , .gray ,.black , .brown]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDynamicCircularMenuButton(button: shareButton, numberOfMenuItems: 5)
        shareButton.menuButtonSize = .medium
        
        configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
        colourPickerButton.menuButtonSize = .medium
        colourPickerButton.sholudMenuButtonAnimate = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonForIndexAt(_ menuButton: ASCircularMenuButton, indexForButton: Int) -> UIButton {
        let button: UIButton = UIButton()
        if menuButton == shareButton{
            button.setBackgroundImage(UIImage.init(named: "shareicon.\(indexForButton + 1)"), for: .normal)
        }
        if menuButton == colourPickerButton{
            button.backgroundColor = colourArray[indexForButton]
        }
        return button
    }
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
        if menuButton == colourPickerButton{
            self.viewLbl.textColor = button.backgroundColor
        }
        
    }
}

