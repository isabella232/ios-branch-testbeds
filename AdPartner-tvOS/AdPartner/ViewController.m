//
//  ViewController.m
//  AdPartner
//
//  Created by Ernest Cho on 12/9/19.
//  Copyright © 2019 Branch Metrics, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Logger.h"

@interface ViewController ()
@property (nonatomic, weak, readwrite) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __unsafe_unretained typeof (self) weakSelf = self;
    [[Logger shared] registerLogBlock:^(NSString *message) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (weakSelf.label) {
                NSString *formattedMessage = [NSString stringWithFormat:@"AdPartner\n%@", message];
                [weakSelf.label setText:formattedMessage];
            }
        });
    }];
    
    [self setTitle:@"Ad partner"];
}

- (IBAction)testURI {
    NSURL *url = [NSURL URLWithString:@"branchtest://adpartner"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(tvOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^ (BOOL success) {
                if (!success) {
                    [self openAppStore];
                }
            }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            if (!success) {
                [self openAppStore];
            }
        }
    } else {
        [self openAppStore];
    }
}

- (IBAction)testBranchLink {
    [self openURL:[NSURL URLWithString:@"https://bnctestbed.app.link/cCWdYYokQ6?$source=adpartner"] uriScheme:@"branchtest://"];
}

// We assume the uri scheme is for the same app as the universal link url
- (void)openURL:(NSURL *)url uriScheme:(NSString *)uriScheme {
    
    // canOpenURL can only check URI schemes listed in the Info.plist.  It cannot check Universal Links.
    // https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:uriScheme]]) {
        if (@available(tvOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^ (BOOL success) {
                if (!success) {
                    [self openAppStore];
                }
            }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            if (!success) {
                [self openAppStore];
            }
        }
    } else {
        [self clickBranchLink:url];
    }
}

// This click is broken
// "click" link for deferred deeplink data, we may need an API to submit fake clicks
- (void)clickBranchLink:(NSURL *)linkURL {
    [[[NSURLSession sharedSession] dataTaskWithURL:linkURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openAppStore];
        });
    }] resume];
}

// since tvOS does not have a webview or safari, we cannot rely on Branch's redirection to send users to the app store
- (void)openAppStore {
    NSURL *appStoreURL = [NSURL URLWithString:@"https://apps.apple.com/us/app/branch-monster-factory/id917737838?mt=8"];
    
    if (@available(tvOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

@end
