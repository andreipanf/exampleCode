//
//  MenuItem.swift
//  test
//
//  Created by Andrey on 28.07.16.
//  Copyright © 2016 AndreyPanfilov. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuItem: NSObject {
    
    var title:String!
    var menuId:Int = 0
    var imageUrl:String!
    var weightString:String!
    var contentsString:String!
    var priceString:String!
    
    var countInOrder:Int = 0
    
    override init() {
        super.init()
    }
    
    init(json:JSON) {
        super.init()
        
        self.menuId = json["id"].intValue
        self.title = json["title"].stringValue
        self.weightString = json["weight"].stringValue
        self.priceString = json["regular_price"].stringValue
        self.contentsString = json["short_description"].stringValue
        self.imageUrl = json["images"][0]["src"].stringValue
        
    }
    
}

class MenuItemFactory:NSObject {
    
    func createArrayFromServerDate(json:JSON) -> Array<MenuItem> {
        var menuItemsArray:Array<MenuItem> = []
        for (_, item) in json {
            let menuItem = MenuItem(json: item)
            menuItemsArray.append(menuItem)
        }
        return menuItemsArray
        
    }
    
}