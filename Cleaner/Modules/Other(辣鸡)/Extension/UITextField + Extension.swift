//
//  UITextField + Extension.swift
//  HippoRefuel
//
//  Created by leon on 2020/8/3.
//  Copyright © 2020 leon. All rights reserved.
//

import UIKit

/// UITextField
private var TextFieldToolBarParamKey = "TextFieldToolBarParamKey"
extension UITextField {
    
    var toolBar: UIToolbar? {
        
        set(toolBar) {
            objc_setAssociatedObject(self, &TextFieldToolBarParamKey, toolBar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &TextFieldToolBarParamKey) as? UIToolbar
        }
    }
    
    func showToolBar() {
        setupToolBar()
        self.inputAccessoryView = toolBar
    }
    
    func setupToolBar() {
        toolBar = UIToolbar()
        
        //可以让UIBarButtonItem靠右显示
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneItemDidClick))
        doneItem.tintColor = HEX("#1476FB")
        
        toolBar?.sizeToFit()
        toolBar?.items = [spaceItem, doneItem]
    }
    
    @objc func doneItemDidClick() {
        self.resignFirstResponder()
    }
}


/// UITextView
private var TextViewToolBarParamKey = "TextViewToolBarParamKey"
extension UITextView {
    var toolBar: UIToolbar? {
        
        set(toolBar) {
            objc_setAssociatedObject(self, &TextViewToolBarParamKey, toolBar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &TextViewToolBarParamKey) as? UIToolbar
        }
    }
    
    func showToolBar() {
        setupToolBar()
        self.inputAccessoryView = toolBar
    }
    
    func setupToolBar() {
        toolBar = UIToolbar()
        
        //可以让UIBarButtonItem靠右显示
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneItemDidClick))
        doneItem.tintColor = HEX("#1476FB")
        
        toolBar?.sizeToFit()
        toolBar?.items = [spaceItem, doneItem]
    }
    
    @objc func doneItemDidClick() {
        self.resignFirstResponder()
    }
}
