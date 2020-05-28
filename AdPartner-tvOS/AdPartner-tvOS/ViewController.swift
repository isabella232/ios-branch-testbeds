//
//  ViewController.swift
//  AdPartner-tvOS
//
//  Created by Ernest Cho on 5/28/20.
//  Copyright © 2020 Branch Metrics, Inc. All rights reserved.
//

import UIKit

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
        guard let uriScheme = URL(string:"branchtest://") else { return }
        guard let url = URL(string:"https://bnctestbed.app.link/cCWdYYokQ6?$source=adpartner") else { return }
        
        self.openURL(url: url, uriScheme: uriScheme)
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
    
    
    // This click is broken
    // "click" link for deferred deeplink data, we may need an API to submit fake clicks
    func clickBranchLink(url:URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.openAppStore()
            }
        }.resume()
    }
    
    // since tvOS does not have a webview or safari, we cannot rely on Branch's redirection to send users to the app store
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

