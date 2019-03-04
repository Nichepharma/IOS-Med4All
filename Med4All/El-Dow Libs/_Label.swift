//
//  _Label.swift
//  FirstSwiftApp
//
//  Created by Yahia on 8/3/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

import UIKit

//http://iosfonts.com/
//http://stackoverflow.com/questions/1054558/vertically-align-text-within-a-uilabel/1054681#1054681
//HelveticaNeue
class _Label: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.*/


    init( frame : CGRect ,  txtString : String , font_Size :CGFloat = 22  ) {
        super.init(frame: frame)
        //        lbl___.frame = CGRectMake(300, 400, 400, 60)
        self.backgroundColor=UIColor.red
        self.text = txtString;
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.clear
//        self.font = UIFont(name: StaticVars.font_name, size: font_Size)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.drawText(in: self.frame)
    }



    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = text
            label.sizeToFit()
        return label.frame.height
    }
    
    

    override func drawText(in rect : CGRect) {
        let topInset = CGFloat(0), bottomInset = CGFloat(2), leftInset = CGFloat(5), rightInset = CGFloat(5)
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }
    
}
