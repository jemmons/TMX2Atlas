@import Cocoa;

@interface MCMDocument : NSDocument <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *detailLabel;
@property (weak) IBOutlet NSTextField *tileDimensionLabel;
@property (weak) IBOutlet NSLayoutConstraint *tileHeightConstraint;
@property (weak) IBOutlet NSLayoutConstraint *tileWidthConstraint;
-(IBAction)exportDocument:(id)sender;

@end
