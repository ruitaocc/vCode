	//
//  HoshiTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class HoshiTextField: TextFieldEffects ,UITextFieldDelegate{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self;
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self;
    }
    
    @IBInspectable public var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable public var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable public var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(limmitLength==0){
            lengthLimitLabel.text = ""
            return true;
        }
        let old:NSString = textField.text as NSString
        let rep:NSString = string as NSString
        let curLength = old.length
        let selectedLength = range.length
        let replaceLength = rep.length
        let after = curLength - selectedLength + replaceLength
        if(after <= limmitLength){
            var denominator : String = String(limmitLength)
            var numerator  : String = String(after)
            lengthLimitLabel.text = numerator + "/" + denominator
            return true;
        }
        return false;
    }
    
    override public var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    
    private var inactivePlaceholderPoint: CGPoint = CGPointZero
    private var activePlaceholderPoint: CGPoint = CGPointZero
    
    // MARK: - TextFieldsEffectsProtocol
    
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(self.font)
        
        lengthLimitLabel.frame = CGRect(x: frame.size.width-20,y: placeholderInsets.y,width: 20,height: frame.size.height)
        lengthLimitLabel.font = placeholderFontFromFont(self.font)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
        
        inactivePlaceholderPoint = placeholderLabel.frame.origin
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFill: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.CGColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFill: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.CGColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() || !text.isEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.65)
        return smallerFont
    }
    
    private func rectForBorder(thickness: CGFloat, isFill: Bool) -> CGRect {
        if isFill {
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if !text.isEmpty {
            return
        }
        
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
    }
    
    override func animateViewsForTextEntry() {
        
        lengthLimitLabel.textColor = placeholderColor
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
            
            if self.text.isEmpty {
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }
            }), completion: { [unowned self] (completed) in
                
                self.layoutPlaceholderInTextRect()
                
                self.placeholderLabel.frame.origin = self.activePlaceholderPoint
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.placeholderLabel.alpha = 0.5
                })
            })
        
        self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFill: true)
    }
    
    override func animateViewsForTextDisplay() {
        if text.isEmpty {
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({ [unowned self] in
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
                }), completion: nil)
            
            self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFill: false)
        }
    }
    
    // MARK: - Overrides
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
}