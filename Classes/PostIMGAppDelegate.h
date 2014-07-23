//
//  PostIMGAppDelegate.h
//  PostIMG
//
//  Created by kukimoto on 10/11/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostIMGViewController;

@interface PostIMGAppDelegate : NSObject <UIApplicationDelegate,NSNetServiceBrowserDelegate> {
    UIWindow *window;
    PostIMGViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PostIMGViewController *viewController;

@end

