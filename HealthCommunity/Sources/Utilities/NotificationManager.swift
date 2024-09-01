//
//  NotificationManager.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import Foundation

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    struct Names {
        static let signupSuccess = NSNotification.Name("signupSuccess")
    }
    
    func post(_ name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    func observe(_ name: NSNotification.Name, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main, using: block)
    }
    
    func removeObserver(_ observer: NSObjectProtocol) {
        NotificationCenter.default.removeObserver(observer)
    }
}
