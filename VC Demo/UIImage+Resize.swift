//
//  UIImage+Resize.swift
//  VC Demo
//
//  Created by Tobias Scholze on 06.06.16.
//  Copyright © 2016 Tobias Scholze. All rights reserved.
//

import Foundation
import UIKit


extension UIImage
{
    func resizeInScaleToWidth(width width: CGFloat) -> UIImage
    {
        let ratio       = width / self.size.width
        let newHeight   = self.size.height * ratio
        
        UIGraphicsBeginImageContext(CGSizeMake(width, newHeight))
        self.drawInRect(CGRectMake(0, 0, width, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
