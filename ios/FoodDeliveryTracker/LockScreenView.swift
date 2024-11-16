//
//  LockScreenView.swift
//  FoodDeliveryTrackerExtension
//
//  Created by Varun Kukade on 16/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Foundation

struct LockScreenView: View {
  @Environment(\.colorScheme) var colorScheme
  
  // Required arguments for the component
  var noOfItems: Int
  var riderName: String
  var riderRating: Float
  var status: String
  
  //computed properties for the component
  var textColor: Color {
    return colorScheme == .dark ? Color(hex: 0xffffff) : Color(hex: 0x000000)
  }
  
    var body: some View {
      VStack() {
        HStack() {
          VStack(alignment: .leading) {
            Image(RiderImageUrl)
              .resizable()
              .scaledToFit()
              .frame(height: 51)
            Text("\(noOfItems) items")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(textColor)
          }
          Spacer()
          VStack(alignment: .trailing) {
            Text("\(riderName)")
              .font(.system(size: 16))
              .foregroundColor(textColor)
              .padding(.top, 5)
              .padding(.bottom, 1)
            Text("\(String(format: "%.1f", riderRating)) stars")
              .font(.system(size: 16))
              .foregroundColor(textColor)
              .padding(.bottom, 1)
            
            Text("Arriving in \(status)")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(textColor)
          }
          
        }
        .padding(.all, 10)
        .frame(maxWidth: .infinity)
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
          VStack {
            Text("Contact \(riderName)")
              .font(.system(size: 15, weight: .bold))
              .foregroundColor(Color(hex: 0xFFFFFF))
          }
          .frame(maxWidth: .infinity)
          .frame(height: 40)
          .background(Color(hex: 0x4a6e7a))
          .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 10)
      }.padding(.bottom, 10)
      
    }
}

