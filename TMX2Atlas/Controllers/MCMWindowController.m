#import "MCMWindowController.h"

#import "MCMMap.h"
#import "MCMTileset.h"
#import "MCMLayer.h"

static NSString * const kTilesetTable = @"TilesetTable";
static NSString * const kLayerTable = @"LayerTable";
static NSString * const kTilesetCell = @"TilesetCell";
static NSString * const kLayerCell = @"LayerCell";


@interface MCMWindowController ()
@property MCMMap *map;
@end


@implementation MCMWindowController
#pragma mark - INIT/SETUP
-(id)initWithMap:(MCMMap *)aMap{
  if((self = [super initWithWindowNibName:@"MCMDocument"])){
    [self setMap:aMap];
  }
  return self;
}


-(void)windowDidLoad{
  [super windowDidLoad];
  
  NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[[self document] fileURL] path] error:NULL];
  NSDate *date = fileAttributes[NSFileModificationDate];
  NSString *formattedDate = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
  
  [[self dateLabel] setStringValue:formattedDate];
  [[self titleLabel] setStringValue:[[self document] displayName]];
  [[self detailLabel] setStringValue:[NSString stringWithFormat:@"%lu × %lu tiles, modified: %@", (unsigned long)[[self map] width], (unsigned long)[[self map] height], formattedDate]];
  [[self tileDimensionLabel] setStringValue:[NSString stringWithFormat:@"%lu × %lu", (unsigned long)[[self map] tileWidth], (unsigned long)[[self map] tileWidth]]];
  [[self tileWidthConstraint] setConstant:[[self map] tileWidth]];
  [[self tileHeightConstraint] setConstant:[[self map] tileHeight]];
}


#pragma mark - TABLE VIEW DATA SOURCE
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
  NSInteger numberOfRows = 0;
  if([kTilesetTable isEqualToString:[tableView identifier]]){
    numberOfRows = [[[self map] tilesets] count];
  } else if([kLayerTable isEqualToString:[tableView identifier]]){
    numberOfRows = [[[self map] layers] count];
  }
  return numberOfRows;
}


#pragma mark - TABLE VIEW DELEGATE
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
  NSView *cell = nil;
  if([kTilesetTable isEqualToString:[tableView identifier]]){
    cell = [self tilesetCellForTable:tableView atIndex:row];
  } else if([kLayerTable isEqualToString:[tableView identifier]]){
    cell = [self layerCellForTable:tableView atIndex:row];
  }
  return cell;
}


#pragma mark - UTILITY
-(NSView *)tilesetCellForTable:(NSTableView *)tableView atIndex:(NSInteger)anIndex{
  NSTableCellView *cell = [tableView makeViewWithIdentifier:kTilesetCell owner:self];
  MCMTileset *tileset = [[[self map] tilesets] objectAtIndex:anIndex];
  [[cell imageView] setImage:[tileset image]];
  [[cell textField] setStringValue:[tileset name]];
  return cell;
}


-(NSView *)layerCellForTable:(NSTableView *)tableView atIndex:(NSInteger)anIndex{
  NSTableCellView *cell = [tableView makeViewWithIdentifier:kLayerCell owner:self];
  MCMLayer *layer = [[[self map] layers] objectAtIndex:anIndex];
  
  NSString *name = [[layer name] stringByAppendingString:@":"];
  NSFont *bold = [NSFont boldSystemFontOfSize:13.0f];
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName: bold}];
  
  NSString *tiles = [NSString stringWithFormat:@" %lu tiles", (unsigned long)[[layer fullTiles] count]];
  [att appendAttributedString:[[NSAttributedString alloc] initWithString:tiles]];
  
  if( ! [layer isVisible]){
    [att addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle)} range:NSMakeRange(0, [[att string] length])];
  }
  
  [[cell textField] setAttributedStringValue:att];
  [cell setAlphaValue:[layer opacity]];
  return cell;
}


@end
