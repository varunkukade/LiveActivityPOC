//
//  FoodDeliveryTrackerAttributes.swift
//  FoodDeliveryTrackerExtension
//
//  Created by Varun Kukade on 14/11/24.
//

import Foundation
import ActivityKit
import WidgetKit
import SwiftUI

struct FoodDeliveryTrackerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
      // Dynamic stateful properties about your activity go here!
      struct RiderInfo: Codable, Hashable {
        var riderName: String;
        var riderRating: Float;
      }
      let riderInfo: RiderInfo;
      var status: String;
    }

    // Fixed non-changing properties about your activity go here!
    var noOfItems: Int;
    var recordID: Int;
}

