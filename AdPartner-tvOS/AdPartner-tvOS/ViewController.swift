//
//  ViewController.swift
//  AdPartner-tvOS
//
//  Created by Ernest Cho on 5/28/20.
//  Copyright © 2020 Branch Metrics, Inc. All rights reserved.
//

import UIKit
import AdSupport

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func testURI() {
        guard let url = URL(string:"branchtest://adpartner") else { return }
        
        if (UIApplication.shared.canOpenURL(url)) {
            if #available(tvOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if (success == false) {
                        self.openAppStore()
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url)
                if (success == false) {
                    self.openAppStore()
                }
            }
        } else {
            self.openAppStore()
        }
    }
    
    @IBAction func testBranchLink() {
        // Since tvOS only supports app to app linking, we simply pass the advertising identifier as a query parameter
        let branchLink = "https://bnctestbed.app.link/cCWdYYokQ6?$source=adpartner&$idfa=" + self.checkIdfa()
        self.openURL(urlString: branchLink, uriString: "branchtest://")
    }
    
    func checkIdfa() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // We assume the uri scheme is for the same app as the universal link url
    func openURL(urlString:String, uriString:String) {
        
        guard let uriScheme = URL(string: uriString) else { return }
        guard let url = URL(string:urlString) else { return }
        
        // canOpenURL can only check URI schemes listed in the Info.plist.  It cannot check Universal Links.
        // https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl
        if (UIApplication.shared.canOpenURL(uriScheme)) {
            if #available(tvOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if (success == false) {
                        self.openAppStore()
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url)
                if (success == false) {
                    self.openAppStore()
                }
            }
            
        } else {
            self.clickBranchLink(url: url)
        }
    }
    
    func clickBranchLink(url:URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.openAppStore()
            }
        }.resume()
    }
    
    // directly open the app store if we're unable to detect the app
    func openAppStore() {
        guard let url = URL(string:"https://apps.apple.com/us/app/branch-monster-factory/id917737838?mt=8") else { return }
        
        if #available(tvOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

