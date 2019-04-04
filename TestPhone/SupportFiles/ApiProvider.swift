//
//  ApiProvider.swift
//  TestPhone
//
//  Created by Vitaliy Kozlov on 03/04/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import Foundation
import Alamofire
var doesTheInternetWork: Bool {
    return NetworkReachabilityManager()!.isReachable
}
func getData() {
    guard let url = URL (string: urlString) else {return}
    if doesTheInternetWork {
        Alamofire.request(url, method: .get).responseData
            { response in
                guard let contactsDataTemp = response.value else {return}
                do {
                    let list = try JSONDecoder().decode([Contact].self, from: contactsDataTemp)
                    contactsData.contacts = list
                     NotificationCenter.default.post(name: notificatonName, object: nil)
                } catch {
                    print (error)
                   contactsData.error = "JSONError"
                   NotificationCenter.default.post(name: notificatonName, object: nil)
                }
                
                }
        } else {
        print ("Internet Error")
       contactsData.error = "NoInternet"
        NotificationCenter.default.post(name: notificatonName, object: nil)
    }
}
