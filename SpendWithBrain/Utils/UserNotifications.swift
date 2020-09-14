//
//  UserNotifications.swift
//  SpendWithBrain
//
//  Created by Maxim on 09/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import UserNotifications

class CustomNotifications : NSObject {
    static let shared = CustomNotifications()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func createNotification(_ sold : Float){
        removeNotification()
        let content = UNMutableNotificationContent()
        
        content.title = "Spend with brain"
        content.body = "Your current sold is \(String(sold))"
        content.sound = UNNotificationSound.default
        
        var dateComp = DateComponents()
        dateComp.hour = 9
        dateComp.minute = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


extension CustomNotifications : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did recieve notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
