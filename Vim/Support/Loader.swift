//
//  Loader.swift
//  Vim
//
//  Created by Jakub Iwaszek on 18/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Loader {
    static var counter = 0
    static var loaderView: UIView?
    
    static func start() {
        counter += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loaderView = UIView.init(frame: UIScreen.main.bounds)
        loaderView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .lineSpinFadeLoader, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), padding: nil)
        loaderView?.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        let hc = loaderView!.centerYAnchor.constraint(equalTo: loader.centerYAnchor)
        let vc = loaderView!.centerXAnchor.constraint(equalTo: loader.centerXAnchor)
        
        NSLayoutConstraint.activate([hc, vc])
        
        loader.startAnimating()
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(loaderView!)
        }
    }
    
    static func stop() {
        counter -= 1
        if counter == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                loaderView!.removeFromSuperview()
            }
        } else if counter < 0 {
            counter = 0
        }
    }
    
}
