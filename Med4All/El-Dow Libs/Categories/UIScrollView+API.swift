//
//  UIScrollView+API.swift
//  Supervisor
//
//  Created by Yahia on 5/11/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

import UIKit

extension UIScrollView {

    func scrollToPage(page: CGFloat) -> UIScrollView {
        var frame: CGRect = self.frame
        frame.origin.x = frame.size.width * page
        frame.origin.y = 0;
        self.scrollRectToVisible(frame, animated: true)
        return self
}







}