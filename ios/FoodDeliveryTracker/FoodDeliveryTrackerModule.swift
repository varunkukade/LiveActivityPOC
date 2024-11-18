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
  
  //method exported to react native
  @objc
  func startLiveActivity(_ riderName: Double, riderRating: Double,  status: Double, noOfItems: Int) -> Void {
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
    let activityAttributes = FoodDeliveryTrackerAttributes(recordID: RECORD_ID, noOfItems: noOfItems);
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
        } catch (let error) {
          // Handle errors
          print("Error requesting Live Activity \(error.localizedDescription).")
        }
  }
  
  //method exported to react native
  @objc
  func updateLiveActivity(_ riderName: Double, riderRating: Double,  status: Double,  recordId: Int) -> Void {
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
  func stopLiveActivity(_ isImmediateDismissal: Bool, riderName: Double, riderRating: Double,  status: Double,  recordId: Int) -> Void {
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
