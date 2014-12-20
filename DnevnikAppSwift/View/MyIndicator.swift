//
//  MyIndicator.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 13.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class MyIndicator : UIActivityIndicatorView {
    
    func make(parentView : UIView) -> UIActivityIndicatorView {
        //self.frame = CGRectMake(0,0, 50, 50)
        self.center = parentView.center
        self.hidesWhenStopped = true
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        parentView.addSubview(self)
        self.startAnimating()
        return self
    }
}
