//
//  FoodDeliveryTrackerModule.swift
//  LiveActivityPOC
//
//  Created by Varun Kukade on 18/11/24.
//

import Foundation
import ActivityKit

// You can access Objective-C dependencies/macros in this Swift file because
// you have included the RCTBridgeModule import inside the bridging header.
// The bridging header allows Swift files in your target to access
// the Objective-C dependencies/macros.


//@objc attribute tells the Swift compiler to expose the swift class or method to the Objective-C runtime.

@objc(FoodDeliveryTrackerModule) //this registers the module with React Native
class FoodDeliveryTrackerModule: NSObject {
  
  static func areActivitiesEnabled() -> Bool {
      return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  @objc
  func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "recordID": RECORD_ID
    ]
  }
    
  static var isAtLeastIOS16_1: Bool {
      if #available(iOS 16.1, *) {
          return true
      } else {
          return false
      }
  }
  
  static var isAtLeastIOS16_2: Bool {
      if #available(iOS 16.2, *) {
          return true
      } else {
          return false
      }
  }
  
  static func getLiveActivity(for recordID: Int) -> Activity<FoodDeliveryTrackerAttributes>?{
      Activity<FoodDeliveryTrackerAttributes>.activities.first(where: {$0.attributes.recordID == recordID})
  }
  
  @objc
  func isLiveActivityActive(_ callback: RCTResponseSenderBlock) {
    // Check if there's at least one active activity in the activities array
    let isActive = Activity<FoodDeliveryTrackerAttributes>.activities.contains { activity in
      return activity.activityState == .active
    }
    callback([isActive])
  }
  
  static func ObservePushTokenUpdates() {
    guard let liveActivity = getLiveActivity(for: RECORD_ID) else{
        return
    }
    Task{
       for await pushToken in liveActivity.pushTokenUpdates {
         let pushTokenString = pushToken.reduce("") {
           $0 + String(format: "%02x", $1)
         }
         let authToken = liveActivity.attributes.authToken
         
         // Create the JSON body
         let jsonBody: [String: String] = ["token": pushTokenString]
         let httpBody: Data?

         do {
             httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
         } catch {
             print("Error converting JSON to Data:", error)
             return
         }

         // Optional binding before calling the API
         if let httpBody = httpBody {
             NetworkService.callAPI(url: "", httpMethod: "POST", httpBody: httpBody, authToken: authToken)
         } else {
             print("httpBody is nil, not calling the API.")
         }
       }
     }
  }
  
  static func ObserveLiveActivityState() {
    guard let liveActivity = getLiveActivity(for: RECORD_ID) else{
        return
    }
    Task{
       for await activityState in liveActivity.activityStateUpdates {
         switch activityState {
             case .dismissed:
                     let authToken = liveActivity.attributes.authToken;
                     
                     // Create the JSON body
                     var someValue = 2
                     let jsonBody: [String: Int] = ["some_property": someValue]
                     let httpBody: Data?

                     do {
                         httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
                     } catch {
                         print("Error converting JSON to Data:", error)
                         return
                     }

                     // Optional binding before calling the API
                     if let httpBody = httpBody {
                         NetworkService.callAPI(url: "", httpMethod: "DELETE", httpBody: httpBody, authToken: authToken)
                     } else {
                         print("httpBody is nil, not calling the API.")
                     }
             default:
                 print("Value is something else")
             }
       }
     }
  }

  
  //method exported to react native
  @objc
  func startLiveActivity(_ riderName: String, riderRating: Float,  status: String, noOfItems: Int, authToken: String) -> Void {
    if (!FoodDeliveryTrackerModule.areActivitiesEnabled()) {
          // User disabled Live Activities for the app, nothing to do
          return
    }
    if(!FoodDeliveryTrackerModule.isAtLeastIOS16_1){
      //ios version should be alleast 16.1 to support live activity
      return;
    }
    // Preparing data for the Live Activity
    
    // Store recordId to identify existence or access unique live activity later
    let activityAttributes = FoodDeliveryTrackerAttributes(noOfItems: noOfItems, recordID: RECORD_ID, authToken: authToken);
    let riderInfo = FoodDeliveryTrackerAttributes.ContentState.RiderInfo(
      riderName: riderName,
      riderRating: riderRating
    )
    let contentState = FoodDeliveryTrackerAttributes.ContentState(
      riderInfo: riderInfo,
      status: status
    )
    do {
      if #available(iOS 16.2, *) {
        //For IOS 16.2 and above: Request to start a new Live Activity
        let activityContent = ActivityContent<FoodDeliveryTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
        let _ = try Activity.request(attributes: activityAttributes, content: activityContent, pushType: .token)
      } else {
        //For IOS 16.1: Request to start a new Live Activity
        let _ = try Activity.request(attributes: activityAttributes, contentState: contentState, pushType: .token)
      }
      FoodDeliveryTrackerModule.ObservePushTokenUpdates();
      FoodDeliveryTrackerModule.ObserveLiveActivityState();
        } catch (let error) {
          // Handle errors
          print("Error requesting Live Activity \(error).")
        }
  }
  
  //method exported to react native
  @objc
  func updateLiveActivity(_ riderName: String, riderRating: Float,  status: String,  recordId: Int) -> Void {
    if (!FoodDeliveryTrackerModule.areActivitiesEnabled()) {
          // User disabled Live Activities for the app, nothing to do
          return
    }
    guard let liveActivity = FoodDeliveryTrackerModule.getLiveActivity(for: recordId) else{
        return
    }
    if(!FoodDeliveryTrackerModule.isAtLeastIOS16_1){
      //ios version should be alleast 16.1 to support live activity
      return;
    }
    do {
           Task  {
             let riderInfo = FoodDeliveryTrackerAttributes.ContentState.RiderInfo(
               riderName: riderName,
               riderRating: riderRating
             )
             let contentState = FoodDeliveryTrackerAttributes.ContentState(
               riderInfo: riderInfo,
               status: status
             )
             if #available(iOS 16.2, *) {
               let activityContent = ActivityContent<FoodDeliveryTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
               await liveActivity.update(activityContent)
             } else {
               await liveActivity.update(using: contentState)
             }
           }
        
    } catch (let error) {
      // Handle errors
      print("Error updating Live Activity \(error.localizedDescription).")
    }
  }

  @objc
  func stopLiveActivity(_ isImmediateDismissal: Bool, riderName: String, riderRating: Float,  status: String,  recordId: Int) -> Void {
    // A task is a unit of work that can run concurrently in a lightweight thread, managed by the Swift runtime
    // It helps to avoid blocking the main thread
    if (!FoodDeliveryTrackerModule.areActivitiesEnabled()) {
          // User disabled Live Activities for the app, nothing to do
          return
    }
    guard let liveActivity = FoodDeliveryTrackerModule.getLiveActivity(for: recordId) else{
        return
    }
    if(!FoodDeliveryTrackerModule.isAtLeastIOS16_1){
      //ios version should be alleast 16.1 to support live activity
      return;
    }
    Task {
      let riderInfo = FoodDeliveryTrackerAttributes.ContentState.RiderInfo(
        riderName: riderName,
        riderRating: riderRating
      )
      let contentState = FoodDeliveryTrackerAttributes.ContentState(
        riderInfo: riderInfo,
        status: status
      )
      if #available(iOS 16.2, *) {
        let activityContent = ActivityContent<FoodDeliveryTrackerAttributes.ContentState>(state: contentState,  staleDate: nil)
        await liveActivity.end(isImmediateDismissal ? nil : activityContent, dismissalPolicy: isImmediateDismissal ? .immediate : .default)
      } else {
        await liveActivity.end(using: isImmediateDismissal ? nil : contentState, dismissalPolicy: isImmediateDismissal ? .immediate : .default)
      }

    }
  }
}
