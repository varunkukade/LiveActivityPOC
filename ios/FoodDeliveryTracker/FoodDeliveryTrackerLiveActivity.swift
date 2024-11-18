//
//  FoodDeliveryTrackerLiveActivity.swift
//  FoodDeliveryTracker
//
//  Created by Varun Kukade on 09/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

@DynamicIslandExpandedContentBuilder
    private func expandedContent(
      riderName: String,
      riderRating: Float,
      status: String,
      noOfItems: Int
    ) -> DynamicIslandExpandedContent<some View> {
      DynamicIslandExpandedRegion(.leading) {
        Image(RiderImageUrl)
            .resizable()
            .scaledToFit()
            .frame(height: 51)
        Text("\(noOfItems) items")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(hex: 0xFFFFFF))
      }
      DynamicIslandExpandedRegion(.trailing) {
        Text("\(riderName)")
            .font(.system(size: 16))
            .foregroundColor(Color(hex: 0xFFFFFF))
            .padding(.top, 5)
            .padding(.bottom, 1)
        Text("\(String(format: "%.1f", riderRating)) stars")
            .font(.system(size: 16))
            .foregroundColor(Color(hex: 0xFFFFFF))
            .padding(.bottom, 1)
            
        Text("Arriving in \(status)")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(hex: 0xFFFFFF))
      }
      
      DynamicIslandExpandedRegion(.bottom) {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            VStack {
              Text("Contact \(riderName)")
                  .font(.system(size: 15, weight: .bold))
                  .foregroundColor(Color(hex: 0xFFFFFF))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(Color(hex: 0x4a6e7a))
            .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
      }
}

struct FoodDeliveryTrackerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FoodDeliveryTrackerAttributes.self) { context in
            // Lock screen/banner UI goes here
          LockScreenView(
            noOfItems: context.attributes.noOfItems,
            riderName: context.state.riderInfo.riderName,
            riderRating: context.state.riderInfo.riderRating,
            status: context.state.status
          )

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here
              expandedContent(
                riderName: context.state.riderInfo.riderName,
                riderRating: context.state.riderInfo.riderRating,
                status: context.state.status,
                noOfItems: context.attributes.noOfItems
              )
            } compactLeading: {
              Image(RiderImageUrl)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 25)
            } compactTrailing: {
              Text(context.state.status)
                  .font(.system(size: 15, weight: .bold))
                  .foregroundColor(Color(hex: 0xFFFFFF))
            } minimal: {
              Image(RiderImageUrl)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 20)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FoodDeliveryTrackerAttributes {
    fileprivate static var preview: FoodDeliveryTrackerAttributes {
      FoodDeliveryTrackerAttributes(noOfItems: 6, recordID: RECORD_ID)
    }
}

extension FoodDeliveryTrackerAttributes.ContentState {
  fileprivate static var testData: FoodDeliveryTrackerAttributes.ContentState {
    let riderInfo = FoodDeliveryTrackerAttributes.ContentState.RiderInfo(
      riderName: "Jaun C.",
      riderRating: 4.7
    )
    return FoodDeliveryTrackerAttributes.ContentState(riderInfo: riderInfo, status: "8 min")
  }
}

#Preview("Notification", as: .content, using: FoodDeliveryTrackerAttributes.preview) {
   FoodDeliveryTrackerLiveActivity()
} contentStates: {
  FoodDeliveryTrackerAttributes.ContentState.testData
}

