//
//  NetworkHelper.swift
//  test
//
//  Created by Andrey on 28.07.16.
//  Copyright © 2016 AndreyPanfilov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkHelper {
    
    // MARK: Properties
    let kSiteURL: String = "https://oisushi.ru/wc-api/v3"
    let kConsumerKey: String = ""
    let kConsumerSecret: String = ""
    
    let kProductPath: String = "/products"
    
    
    
    func getMenuFromServer(slug:String, completion: ((success: Bool, menuArray:Array<MenuItem>?)-> Void)?) {

        let urlParams = [
            "consumer_key":kConsumerKey,
            "consumer_secret":kConsumerSecret,
            "filter[category]":slug,
            "filter[limit]":"100",
            ]
        
        // Fetch Request
        Alamofire.request(.GET, "\(kSiteURL)\(kProductPath)", parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let value = response.result.value!["products"] {
                        let json = JSON(value!)
                        print("JSON_Product: \(json)")
                        
                        completion!(success: true, menuArray: MenuItemFactory().createArrayFromServerDate(json))
                    }
                }
                else {
                    completion!(success: false, menuArray: nil)
                    
                    
                }
        }
    }
    
}