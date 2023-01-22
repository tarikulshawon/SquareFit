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
}
protocol backButton {
    func  doneBack()
}
class keyboard: UIViewController,indexItem,chnageColor,changeFont,aligthmentTag,chnageFontSize,chnageLineSpacing,chnageCharacterSpace,UITextViewDelegate{
    
    
    public var delegateForChnageImage: changeImage?
    public var delegateForBack: backButton?

    @IBOutlet var bottomSpaceForKeyBoardView: NSLayoutConstraint!
    var keyBoardHeight = 0
    var keyboardViewExtentView: KeyboardTopView!
    var toolsView: ToolsView!
    var colorView:ColorView!
    var fontsView:FontsView!
    var captureImage:UIImage!
    var screenSize: CGRect! = nil
    var screenWidth = 0
    var screenHeight = 0
    var topViewHieght = 60
    var removeSubviews = false
    var fontSize = 15
    var fontName = "sadiq"
    var FontHasChanged = false
    var alighment = 1
    var colorForTextView = UIColor.white
    var lineSpacing = 0
    var lineSpacingBetweenlines = 0
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var heightForToolsView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontName =  fontArray[0]
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        screenSize = UIScreen.main.bounds
        screenWidth = Int(screenSize.width)
        screenHeight = Int(screenSize.height)
        textView.delegate = self
        
        keyboardViewExtentView =  (UINib(nibName: "KeyboardTopView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! KeyboardTopView)
        textView.inputAccessoryView = keyboardViewExtentView
        keyboardViewExtentView.delegate = self
        
        
        
        
        toolsView =  (UINib(nibName: "ToolsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToolsView)
        
        toolsView.delegeteAlighment = self
        toolsView.delegeteFontSize = self
        toolsView.delegeteLineSpacing = self
        toolsView.delegeteCharacterSpacing = self
        
        colorView =  (UINib(nibName: "ColorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorView)
        colorView.delegateForColor = self
        
        
        
        fontsView =  (UINib(nibName: "FontsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FontsView)
        
        
        self.setAttributedString()
        
        textView.becomeFirstResponder()
        
        
        
    }
    
    func setAttributedString( )
    {
        
        
        let value=textView.font!.lineHeight + CGFloat(lineSpacingBetweenlines)
        let paragraph = NSMutableParagraphStyle()
        
        
        paragraph.lineHeightMultiple = value;
        paragraph.maximumLineHeight =  value;
        paragraph.minimumLineHeight =  value;
        
        switch (alighment) {
        case 0:
            paragraph.alignment = .left;
            break;
        case 1:
            paragraph.alignment = .center;
            break;
        case 2:
            paragraph.alignment = .right;
            break;
        case 3:
            paragraph.alignment = .justified;
        default:
            break;
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name:fontName , size:CGFloat(fontSize)) as Any,
            .foregroundColor: colorForTextView,
            NSAttributedString.Key.kern:CGFloat(lineSpacing),
            .paragraphStyle: paragraph
            
        ]
        
        
        let attributedQuote = NSAttributedString(string: textView.text, attributes: attributes)
        textView.attributedText = attributedQuote
        
        
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        self.setAttributedString()
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
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = Int(keyboardRectangle.height)
            bottomSpaceForKeyBoardView.constant = CGFloat(keyBoardHeight)
        }
    }
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        
        delegateForBack?.doneBack()

        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func toolIndexChange (index: Int)
    {
        let window =  UIApplication.shared.windows.last!
        let view = window.subviews.last!
        
        
        if(removeSubviews){
            view.removeFromSuperview()
            removeSubviews = false
        }
        
        
        if index==3
        {
            
            toolsView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            
            window.addSubview(toolsView)
            window.bringSubviewToFront(toolsView)
            
        }
        else  if index==2
        {
            
            colorView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            
            window.addSubview(colorView)
            window.bringSubviewToFront(colorView)
            
        }
        else  if index==1
        {
            
            fontsView.frame = CGRect(x: 0, y:  CGFloat(screenHeight - keyBoardHeight + topViewHieght), width:  CGFloat(screenWidth), height: CGFloat(keyBoardHeight - topViewHieght))
            fontsView.delegateForFont = self
            window.addSubview(fontsView)
            window.bringSubviewToFront(fontsView)
            
        }
        removeSubviews = true
    }
    func changeIndex(index: Int)
    {
        
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
        else
        {
            self.toolIndexChange(index: index)
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
            let window =  UIApplication.shared.windows.last!
            let view = window.subviews.last!
            
            
            
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
        colorForTextView = color
        self.setAttributedString()
        
    }
    func changeFont(name: NSString)
    {
        fontName = name as String
        self.setAttributedString()
        
    }
    func changeAlighment(index: Int) {
        
        alighment = index
        self.setAttributedString()
    }
    func chnageFontSize(size: Int)
    {
        fontSize = size
        self.setAttributedString()
        
    }
    func chnageLineSpacing(size: Int)
    {
        lineSpacing = size
        self.setAttributedString()
    }
    func chnageCharacterSpace(size: Int)
    {
        lineSpacingBetweenlines = size
        self.setAttributedString()
    }
    
}
