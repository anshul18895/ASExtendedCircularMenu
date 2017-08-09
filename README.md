<p align="center">
<img src="https://github.com/anshul18895/ASExtendedCircularMenu/blob/master/Screen%20Shots/Logo.png?raw=true"  style="width: 400px;" width="400" />
</p>

## Requirements

Expand circular menu by giving only instance of the menu buttons. <br />
<br/>
<img src="https://github.com/anshul18895/ASExtendedCircularMenu/blob/master/Screen%20Shots/ScreenShot%201.png?raw=true" style="width: 250px; border: 1px 1px 0 0 #888995 solid;" width="250"></img>
<img src="https://github.com/anshul18895/ASExtendedCircularMenu/blob/master/Screen%20Shots/ScreenShot%202.png?raw=true" style="width: 250px; border: 1px 1px 0 0 #888995 solid;" width="250"></img>

## Features
- [x] Static Initialization (Static redius static position) "Not Dragabble"
- [x] Dynamic Intialization (Autometic find dynamic redius and dynamic positions) "Nor Draggable"
- [x] Draggable Intialization (Autometic find dynamic redius and dynamic positions) "Draggble + Dynamic"




## Installation

ASExtendedCircularMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod ‘ASExtendedCircularMenu’, :git => 'https://github.com/anshul18895/ASExtendedCircularMenu'
```

## Getting Started
### Varibles:










### Steps:
#### 1. Create button in inteface builder. And give it class and module ***'ASExtendedCircularMenu'***. And create refrencing outlet in viewController class.<br />
<img src="https://github.com/anshul18895/ASExtendedCircularMenu/blob/master/Screen%20Shots/interfaceBuilder.png?raw=true" style="width: 250px; border: 1px 1px 0 0 #888995 solid;" width="250"></img><br />

#### 2. Extend viewController class with ***'ASCircularButtonDelegate'***. and configure button in ***'viewDidLoad()'***.
There are three ways to configure button. 1) static 2) Dynamic 3) Draggable
##### Static Intialization
```swift
configureCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 5, menuRedius: 70, postion: .bottomLeft)
```
##### Dynamic Intiazation

```swift
configureDynamicCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 5)
```
##### Draggable Intialization
```swift
configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
```
#### 3. Call following two protocoal methods and Return button in ***`buttonForIndexAt()`*** for index in menu and set target for menu button using ***'didClickOnCircularMenuButton()'*** .
##### Calling ***'buttonForIndexAt()'*** method for returning cell instance for index of menu.
```swift
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
```

##### Calling ***'didClickOnCircularMenuButton()'*** method for setting method call on click (Setting target).
```swift
  func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
        if menuButton == colourPickerButton{
            self.viewLbl.textColor = button.backgroundColor
        }
        
    }
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

anshul18895, anshul18895@gmail.com

## License

ASExtendedCircularMenu is available under the MIT license. See the LICENSE file for more info.
