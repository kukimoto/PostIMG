//
//  PostIMGViewController.m
//  PostIMG
//
//  Created by kukimoto on 10/11/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostIMGViewController.h"
#import "NSStreamAdditions.h"

@implementation PostIMGViewController

@synthesize imgPicker;
int flag=1;

int connectionFlag;

NSOutputStream *oStream;
NSInputStream *iStream;

//NSNetServiceBrowser* browser;
NSNetService* service;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
- (void)allertView
{
	UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Connection Error"
										message:@"There is not gatherIMG server or non Wi-Fi"
										delegate:self
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil];
	[v show];
	[v release];
}


- (void) searchService
{
	NSNetServiceBrowser* browser = [[NSNetServiceBrowser alloc] init];
	[browser setDelegate: self];
	[browser searchForServicesOfType:@"_hyperinfoterm._tcp" inDomain:@""];
}


- (void) netServiceBrowser:(NSNetServiceBrowser*)browser didFindService:(NSNetService*)netService moreComing:(BOOL)moreComing
{
	service = [[NSNetService alloc] initWithDomain:[netService domain] type:[netService type] name:[netService name] port:7777];
	if(service){
		[service setDelegate: self];
		[service resolveWithTimeout: 5.0];
		connectionFlag=1;
		NSLog(@"service found :)");
	}else{
		connectionFlag=0;
		NSLog(@"service not found :(");
	}
	NSLog(@"%d\n", connectionFlag);
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	NSLog(@"service not found :(");
	[self allertView]; 
}


- (void) netServiceDidResolveAddress:(NSNetService*)netService
{
	NSLog(@"Name: %@, Domain:%@, Type:%@,HostName:%@",   
				[netService name], [netService domain], [netService type], [netService hostName]);
	servername=[netService hostName];
	[self connectToServerUsingStream:servername portNo:50001];
	//[self recvData];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[self searchService];
	
		self.imgPicker = [[UIImagePickerController alloc]init];
		self.imgPicker.delegate = self;
		self.imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		[imgPicker release];

	/*
	}else{
		NSLog(@"OOOps");
		
		selectButton.hidden=NO;
	 
	}
	 */
}


-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:(BOOL)animated];
	[self presentModalViewController:self.imgPicker animated:YES];
}

- (IBAction)selectImg {
	[self presentModalViewController:self.imgPicker animated:YES];
}


- (IBAction) postImg{
	NSLog(@"Post");	
	[self presentModalViewController:self.imgPicker animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)imgPicker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	image.image = img;	
		[[self.imgPicker parentViewController] dismissModalViewControllerAnimated:YES];
		//[self.imgPicker dismissModalViewControllerAnimated:YES];
	[selectButton setHidden:NO];
		//selectButton.hidden=NO;
	NSLog(@"SSSSSSS");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)imgPicker{
	[self.imgPicker dismissModalViewControllerAnimated:YES];
		flag=0;	
		NSLog(@"QQQQQQQQ");
}

#pragma mark network
-(void) connectToServerUsingStream:(NSString *)urlStr 
                            portNo: (uint) portNo 
{
	NSLog(@"Connect to %@",urlStr);
	if (![urlStr isEqualToString:@""]) {
		NSURL *website = [NSURL URLWithString:urlStr];
		if (!website) {
			NSLog(@"%@ is not a valid URL");
			return;
		} else {
			[NSStream getStreamsToHostNamed:urlStr 
																 port:portNo 
													inputStream:&iStream
												 outputStream:&oStream];            
			[iStream retain];
			[oStream retain];
			
			[iStream setDelegate:self];
			[oStream setDelegate:self];
			
			[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
												 forMode:NSDefaultRunLoopMode];
			[oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
												 forMode:NSDefaultRunLoopMode];
			
			[oStream open];
			[iStream open];   
			
			
		}
	}    
	
}



@end
