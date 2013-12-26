@import Cocoa;

@interface MCMDocument : NSDocument <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *detailLabel;

@end
