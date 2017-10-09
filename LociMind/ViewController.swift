//
//  ViewController.swift
//  LociMind
//
//  Created by Ricky on 2017. 10. 4..
//  Copyright © 2017년 Ricky. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User has canceled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            if let userDeets = result {
                                print(userDeets)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged Out")
    }
    

    @IBOutlet weak var swipeProfile: UIImageView!
    
    override func viewDidLoad() {
        
        let loginButton = FBSDKLoginButton()
        
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        swipeProfile.addGestureRecognizer(gesture)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FBSDKAccessToken.current() == nil {
            //Go to Facebook Login Screen
            performSegue(withIdentifier: "logout", sender: self)
        }
    }

    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
    
        let labelPoint = gestureRecognizer.translation(in: view)
        
        swipeProfile.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - swipeProfile.center.x 
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swipeProfile.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended {
            
            //Swipe 좌우의 조건
            if swipeProfile.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
            }
            if swipeProfile.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
            }
            
            //Swipe 후 위치, 로테이션, 스케일 원상복귀
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            swipeProfile.transform = scaledAndRotated
            
            swipeProfile.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

