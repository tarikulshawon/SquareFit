//
//  keyboard.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 22/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit


protocol changeImage {
    func changeImage(image: UIImage)
    func changeTextView(textView: UITextView,size:CGFloat)
}

protocol backButton {
    func  doneBack()
}

class keyboard: UIViewController,  indexItem, chnageColor, changeFont, aligthmentTag, chnageFontSize,  UITextViewDelegate, chnageAlpa, shadowDelegate {
    
    func opacityShadowValue(value: Double) {
        
      textView.textInputView.layer.shadowOpacity = Float(value)
         
    }
    
    func radiusShadowalue(value: Double) {
        textView.textInputView.layer.shadowRadius = CGFloat(Float(value))
    }
    
    func offsetShadowValue(value: Double) {
        
        textView.textInputView.layer.shadowOffset = .init(width: 5, height: value)
         
    }
    
    
    func changeAlpa(value: Float) {
        textView.alpha = CGFloat(value)
    }
    
    
    
    func chnageTexture(index: Int) {
        
        
    }
    
    func changeGradient(index: Int) {
        
    }
    
    public var delegateForChnageImage: changeImage?
    public var delegateForBack: backButton?

    @IBOutlet var bottomSpaceForKeyBoardView: NSLayoutConstraint!
    var keyBoardHeight = 0
    var keyboardViewExtentView: KeyboardTopView!
    var toolsView: ToolsView!
    var colorView: ColorView!
    var fontsView: FontsView!
    var shadowView: Shadow!
    var captureImage:UIImage!
    var screenSize: CGRect! = nil
    var screenWidth = 0
    var screenHeight = 0
    var topViewHieght = 60
    var removeSubviews = false
    var fontSize = 25
    var fontName = "sadiq"
    var FontHasChanged = false
    var alighment = 1
    var colorForTextView = UIColor.white
    var lineSpacing = 0
    var lineSpacingBetweenlines = 0
    var bottomConstant: CGFloat = 0
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var heightForToolsView: NSLayoutConstraint!
    @IBOutlet weak var heightOfToolBar: NSLayoutConstraint!
    @IBOutlet weak var customTabBar: UITabBar!
    var attributedT:NSAttributedString! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontName =  fontArray[0]
        
        // Notifications for when the keyboard opens/closes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        screenSize = UIScreen.main.bounds
        screenWidth = Int(screenSize.width)
        screenHeight = Int(screenSize.height)
        textView.delegate = self
        customTabBar.delegate = self
        
        keyboardViewExtentView =  (UINib(nibName: "KeyboardTopView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! KeyboardTopView)

        keyboardViewExtentView.delegate = self
        
        
        toolsView =  (UINib(nibName: "ToolsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToolsView)
        
        toolsView.delegeteAlighment = self
        toolsView.delegeteFontSize = self
        //toolsView.delegeteLineSpacing = self
       // toolsView.delegeteCharacterSpacing = self
        toolsView.delegeteForAlpa = self
        
        colorView =  (UINib(nibName: "ColorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorView)
        colorView.delegateForColor = self
        
        
        shadowView =  (UINib(nibName: "Shadow", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Shadow)
        
        
        
        fontsView =  (UINib(nibName: "FontsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FontsView)
        
        
        //self.setAttributedString()
        
        //textView.becomeFirstResponder()
        
        textView.font =  UIFont(name:fontName , size:CGFloat(fontSize))
    }
    
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
       
        return true
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    func imageFromTextView(textView: UITextView) -> UIImage {
        
        // Make a copy of the textView first so that it can be resized
        // without affecting the original.
        let textViewCopy = UITextView(frame: textView.frame)
        
        textViewCopy.attributedText = textView.attributedText
        textViewCopy.backgroundColor = UIColor.clear
        
        // resize if the contentView is larger than the frame
        if textViewCopy.contentSize.height > textViewCopy.frame.height {
            textViewCopy.frame = CGRect(origin: CGPoint(x: 0,y :0), size: textViewCopy.contentSize)
        }
        else{
            textViewCopy.frame = CGRect(origin: CGPoint(x: 0,y :0), size: textViewCopy.contentSize)
        }
        
        // draw the text view to an image
        UIGraphicsBeginImageContextWithOptions(textViewCopy.bounds.size, false, UIScreen.main.scale)
        textViewCopy.drawHierarchy(in: textViewCopy.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        
        delegateForBack?.doneBack()
       // delegateForChnageImage?.changeTextView(textView: textView)

        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeIndex(index: Int) {
        if index==0
        {
            self.voidHidePicker()
        }
        else if index==4
        {
            self.voidHidePicker()
            let textV = UITextView(frame:self.textView.frame)
            textV.text =  self.textView.text
            self.getUpdate(textV)
            
            if(textV.text.count > 0)
            {
            let image = self.imageFromTextView(textView: textV)
            delegateForChnageImage?.changeImage(image: image)
            }
            else{
                delegateForBack?.doneBack()
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func getUpdate(_ textView: UITextView) {
        let fixedWidth: CGFloat = 150.0
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: min(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
    }
    func voidHidePicker()
    {
        
        if(removeSubviews)
        {
            keyboardViewExtentView.tabBarView.selectedItem = keyboardViewExtentView.tabBarView.items?.first
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }

            guard let firstWindow = firstScene.windows.last else {
                return
            }
            let view = firstWindow.subviews.last!
            
            
            
            UIView.animate(withDuration: 0.2, animations: {
                
                view.frame =  CGRect(x:0, y: CGFloat(self.screenHeight), width:CGFloat(self.screenWidth), height:CGFloat(self.keyBoardHeight - self.topViewHieght))
                
                
            }, completion: {
                (value: Bool) in
                
                if (value)
                {
                    view.removeFromSuperview()
                }
            })
            removeSubviews = false
        }
        
    }
    func chnageColorForView(color: UIColor)
    {
        textView.textColor = color
        
    }
    func changeFont(name: NSString)
    {
        fontName = name as String
        textView.font =  UIFont(name:fontName , size:CGFloat(fontSize))
    }
    
    func changeAlighment(index: Int) {
        
        alighment = index
        
        switch (alighment) {
        case 0:
            textView.textAlignment = .left
            break;
        case 1:
            textView.textAlignment = .center;
            break;
        case 2:
            textView.textAlignment = .right;
            break;
        case 3:
            textView.textAlignment = .justified;
        default:
            break;
        }
        
        
    }
    func chnageFontSize(size: Int)
    {
        fontSize = size
        textView.font = UIFont(name:fontName , size:CGFloat(fontSize))
        
        
    }
    func chnageLineSpacing(size: Int)
    {
        lineSpacing = size
       // self.setAttributedString()
    }
    func chnageCharacterSpace(size: Int)
    {
        lineSpacingBetweenlines = size
        //self.setAttributedString()
    }
    
}

extension keyboard: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let value = item.tag - 300
        if value == 0 {
            textView.becomeFirstResponder()

        } else if value == 1 {
            textView.endEditing(true)
            fontsView.isHidden = false
            colorView.isHidden = true
            toolsView.isHidden = true
            shadowView.isHidden = true
            
            fontsView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - keyBoardHeight))
            fontsView.delegateForFont = self
            
            fontsView.layer.zPosition = CGFloat(MAXFLOAT)
            
            view.addSubview(fontsView)
            
            fontsView.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = fontsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let leading = fontsView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = fontsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let heightConstraint = fontsView.heightAnchor.constraint(equalToConstant: 336.0)
            NSLayoutConstraint.activate([bottom, leading, trailing, heightConstraint])
        } else if value == 3 {
            textView.endEditing(true)
            fontsView.isHidden = true
            colorView.isHidden = false
            toolsView.isHidden = true
            shadowView.isHidden = true
            
            colorView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            
            view.addSubview(colorView)
            
            colorView.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = colorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let leading = colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let heightConstraint = colorView.heightAnchor.constraint(equalToConstant: 336.0)
            NSLayoutConstraint.activate([bottom, leading, trailing, heightConstraint])
        }
        else if value == 4 {
            textView.endEditing(true)
            fontsView.isHidden = true
            colorView.isHidden = true
            toolsView.isHidden = true
            shadowView.isHidden = false
            
            shadowView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            
            view.addSubview(shadowView)
            
            shadowView.translatesAutoresizingMaskIntoConstraints = false
            shadowView.delegateForShadow = self
            
            let bottom = shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let leading = shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let heightConstraint = shadowView.heightAnchor.constraint(equalToConstant: 336.0)
            NSLayoutConstraint.activate([bottom, leading, trailing, heightConstraint])
        }
        else if value == 2 {
            textView.endEditing(true)
            fontsView.isHidden = true
            colorView.isHidden = true
            toolsView.isHidden = false
            shadowView.isHidden = true
            toolsView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            
            view.addSubview(toolsView)
            toolsView.translatesAutoresizingMaskIntoConstraints = false

            let bottom = toolsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            let leading = toolsView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = toolsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let heightConstraint = toolsView.heightAnchor.constraint(equalToConstant: 336.0)
            NSLayoutConstraint.activate([bottom, leading, trailing, heightConstraint])
        } else if value == 5 {
            delegateForChnageImage?.changeTextView(textView: textView, size: CGFloat(fontSize))
            dismiss(animated: true)
        }
    }
}

extension keyboard {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, keyboardWillShow: true)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        // Keyboard's size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        // Keyboard's animation duration
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        // Change the constant
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            print("Keyboard Height: \(keyboardHeight)")
            heightForToolsView.constant = keyboardHeight
            heightOfToolBar.constant = 60
        }else {
            //viewBottomConstraint.constant = 20
        }
        
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        //moveViewWithKeyboard(notification: notification, viewBottomConstraint: , keyboardWillShow: false)
    }
}
