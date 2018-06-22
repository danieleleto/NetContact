//
//  ExtensionImage.swift
//  NetContact
//
//  Created by Luca Colombano on 07/06/18.
//  Copyright © 2018 Aral. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor, text: NSString) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 25)!
        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: text_style
            ] as [NSAttributedStringKey : Any]
        
        let text_h = textFont.lineHeight
        let text_y = (diameter - text_h) / 2
        let text_rect = CGRect(x: 0, y: text_y, width: diameter, height: text_h)
        
        text.draw(in: text_rect, withAttributes: textFontAttributes)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func roundRect(rectWidth: CGFloat, rectHeight: CGFloat, color: UIColor, text: NSString) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rectWidth, height: rectHeight), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        
        let textColor = UIColor.darkGray
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: text_style
            ] as [NSAttributedStringKey : Any]
        
        let text_h = textFont.lineHeight
        let text_y = (rectHeight - text_h) / 2
        let text_rect = CGRect(x: 0, y: text_y, width: rectWidth, height: text_h)
        
        text.draw(in: text_rect, withAttributes: textFontAttributes)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}
