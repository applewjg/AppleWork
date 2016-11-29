//
//  AppDelegate.h
//  Hope
//
//  Created by Jingui Wang on 11/21/16.
//  Copyright © 2016 jinguiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

