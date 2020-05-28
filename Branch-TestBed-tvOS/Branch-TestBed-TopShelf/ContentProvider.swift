//
//  ContentProvider.swift
//  Branch-TestBed-TopShelf
//
//  Created by Ernest Cho on 5/27/20.
//  Copyright © 2020 Branch Metrics, Inc. All rights reserved.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {
    
    // load top shelf content examples
    // typically, this would be downloaded from the app server
    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        DispatchQueue.global().async {
            let content = TVTopShelfCarouselContent(style: .details, items: [self.applinkItem(), self.uriItem()])
            completionHandler(content);
        }
    }
    
    // open self via universal link
    func applinkItem() -> TVTopShelfCarouselItem {
        let item = TVTopShelfCarouselItem(identifier: "app.link")
        item.title = "Branch Link"
        item.setImageURL(Bundle.main.url(forResource: "applink", withExtension: "png"), for: .screenScale1x)
        if let url = URL(string: "https://bnctestbed.app.link/cCWdYYokQ6?$source=topshelf") {
            item.playAction = TVTopShelfAction(url: url)
        }
        return item
    }
    
    // open self via uri
    func uriItem() -> TVTopShelfCarouselItem {
        let item = TVTopShelfCarouselItem(identifier: "uri")
        item.title = "URI Scheme"
        item.setImageURL(Bundle.main.url(forResource: "uri", withExtension: "png"), for: .screenScale1x)
        if let url = URL(string: "branchtest://topshelf") {
            item.playAction = TVTopShelfAction(url: url)
        }
        return item
    }
}
