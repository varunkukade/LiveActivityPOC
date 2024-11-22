//
//  FoodDeliveryTrackerModule.m
//  LiveActivityPOC
//
//  Created by Varun Kukade on 20/11/24.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h> //This import allows to use obj-c macros.

//RCT_EXTERN_MODULE and RCT_EXTERN_METHOD Macros exposes class and methods to obj-c runtime


@interface RCT_EXTERN_MODULE(FoodDeliveryTrackerModule, NSObject)

+ (bool)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startLiveActivity:(nonnull NSString *)riderName
                  riderRating:(nonnull float *)riderRating
                  status:(nonnull NSString *)status
                  noOfItems:(NSInteger)noOfItems
                  authToken:(nonnull NSString *)authToken)
RCT_EXTERN_METHOD(updateLiveActivity:(nonnull NSString *)riderName
                  riderRating:(nonnull float *)riderRating
                  status:(nonnull NSString *)status
                  recordId:(NSInteger)recordId)
RCT_EXTERN_METHOD(stopLiveActivity:(BOOL)isImmediateDismissal
                  riderName:(nonnull NSString *)riderName
                  riderRating:(nonnull float *)riderRating
                  status:(nonnull NSString *)status
                  recordId:(NSInteger)recordId)
RCT_EXTERN_METHOD(isLiveActivityActive: (RCTResponseSenderBlock)callback)
@end

