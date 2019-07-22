//
//  LaunchScreenViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 22/07/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        let center = view.center
        let line = Line()
        line.createLine(center: center)
        view.layer.addSublayer(line)
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        imageView.layer.add(pulseAnimation, forKey: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(loaded), userInfo: nil, repeats: false)
    }
    
    @objc func loaded() {
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
        } else {
            print("login please")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Line: CAShapeLayer {
    
    override init() {
        super.init()
        
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLine(center: CGPoint) {
        let bezPath = UIBezierPath()
        let rectValue = CGFloat(100)
        let arcCenter = CGPoint(x: center.x + rectValue/2, y: center.y + rectValue/2)
        //bezPath.addArc(withCenter: arcCenter, radius: 50.0, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        bezPath.move(to: arcCenter)
        bezPath.addLine(to: CGPoint(x: arcCenter.x-rectValue, y: arcCenter.y))
        bezPath.addLine(to: CGPoint(x: arcCenter.x-rectValue, y: arcCenter.y-rectValue))
        bezPath.addLine(to: CGPoint(x: arcCenter.x, y: arcCenter.y-rectValue))
        bezPath.addLine(to: CGPoint(x: arcCenter.x, y: arcCenter.y))
        path = bezPath.cgPath
        strokeColor = UIColor.white.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = 3.5
        lineCap = CAShapeLayerLineCap.round
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1
        animation.duration = 3
        //animation.autoreverses = true
        //animation.repeatCount = .infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        add(animation, forKey: "drawLineAnimation")
    }
}
