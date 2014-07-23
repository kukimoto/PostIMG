//
//  PostIMGViewController.h
//  PostIMG
//
//  Created by kukimoto on 10/11/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostIMGViewController : UIViewController <NSNetServiceBrowserDelegate,NSStreamDelegate, NSNetServiceDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	UIImagePickerController *imgPicker;
	IBOutlet UIImageView *image;
	IBOutlet UIButton *selectButton;
	IBOutlet UIButton *postButton;
	NSString *servername;
}
- (IBAction) selectImg;
- (IBAction) postImg;
-(void) connectToServerUsingStream:(NSString *)urlStr portNo:(uint) portNo ;



@property (nonatomic, retain) UIImagePickerController *imgPicker;



@end

