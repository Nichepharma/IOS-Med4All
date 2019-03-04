//
//  KeyboardHandel.swift
//  EstateRus
//
//  Created by Yahia El-Dow on 5/18/17.
//  Copyright © 2017 Production Code. All rights reserved.
//

import UIKit

class KeyboardStateListener: NSObject {
    public static let keyboardShared  = KeyboardStateListener();
    var isVisible = false
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func didShow()
    {
        isVisible = true
    }
    
    func didHide()
    {
        isVisible = false
    }
    
    
}
