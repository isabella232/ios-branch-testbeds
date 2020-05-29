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

    // This example opens the target app using just a URI scheme.  This does NOT get Branch parameters or deferred deeplink data.
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
    
    // This example opens the target app using a Branch Link.  This does get Branch parameters and deferred deeplink data.
    @IBAction func testBranchLink() {
        
        // Since tvOS only supports app to app linking, we simply pass the advertising identifier as a query parameter
        // Also added the adpartner parameter just to indicate where this came from, not strictly necessary
        let branchLink = "https://bnctestbed.app.link/cCWdYYokQ6?$source=adpartner&$idfa=" + self.checkIdfa()
        
        guard let url = URL(string: branchLink) else { return }
        guard let uriScheme = URL(string: "branchtest://") else { return }
        
        self.openURL(url: url, uriScheme: uriScheme)
    }
    
    func checkIdfa() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // We assume the uri scheme is for the same app as the universal link url
    func openURL(url:URL, uriScheme:URL) {
        
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

