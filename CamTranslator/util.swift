//
//  util.swift
//  CamTranslator
//
//  Created by Usman on 11/12/2019.
//  Copyright © 2019 Usman. All rights reserved.
//

import UIKit
var aView: UIView?

extension UIViewController{
    
    
    func showSpinner(){
     aView = UIView(frame: self.view.bounds)
         let activityLabel = UILabel()
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = aView!.center
        activityLabel.text = "Downloading Model"
        activityLabel.sizeToFit()

        activityLabel.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 30)
               
        activityIndicator.startAnimating()
        aView?.addSubview(activityLabel)
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
     func hideSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
