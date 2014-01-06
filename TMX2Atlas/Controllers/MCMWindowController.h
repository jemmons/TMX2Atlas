@import Cocoa;
@class MCMMap;


@interface MCMWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic) MCMMap *map;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *detailLabel;
@property (weak) IBOutlet NSTextField *tileDimensionLabel;
@property (weak) IBOutlet NSLayoutConstraint *tileHeightConstraint;
@property (weak) IBOutlet NSLayoutConstraint *tileWidthConstraint;
@property (weak) IBOutlet NSTableView *tilesetTable;
@property (weak) IBOutlet NSTableView *layerTable;
@end
