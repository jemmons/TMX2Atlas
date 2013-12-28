#import "MCMDocument.h"

#import "MCMTMXParser.h"
#import "MCMMap.h"
#import "MCMTileset.h"
#import "MCMLayer.h"
#import "MCMMainCellView.h"


static NSString * const kTilesetTable = @"TilesetTable";
static NSString * const kLayerTable = @"LayerTable";
static NSString * const kTilesetCell = @"TilesetCell";
static NSString * const kLayerCell = @"LayerCell";



@interface MCMDocument ()
@property MCMMap *map;
@end


@implementation MCMDocument
#pragma mark - INIT/SETUP
-(id)init{
  if((self = [super init])){
    //
  }
  return self;
}


+(BOOL)autosavesInPlace{
  return NO;
}


-(NSString *)windowNibName{
  return @"MCMDocument";
}


#pragma mark - DOCUMENT METHODS
-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
  BOOL success = YES;
  
  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithURL:url];
  [self setMap:[parser parse]];
  
  if([self map]){
    [[self titleLabel] setStringValue:[url lastPathComponent]];
    [[self detailLabel] setStringValue:@"something"];
  } else{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not parse TMX file.", nil), NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Unknown error occured.", nil), NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Try exporting the TMX again with approved settings.", nil)};
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain" code:-100 userInfo:userInfo];
    success = NO;
  }
  return success;
}


-(void)windowControllerDidLoadNib:(NSWindowController *)windowController{
  [[self titleLabel] setStringValue:[self displayName]];
  [[self detailLabel] setStringValue:[NSString stringWithFormat:@"(%lu × %lu tiles)", (unsigned long)[[self map] width], (unsigned long)[[self map] height]]];
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
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", [layer name]] attributes:@{NSFontAttributeName : [NSFont boldSystemFontOfSize:13.0f]}];
  [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %lu tiles", (unsigned long)[[layer fullTiles] count]]]];
  if( ! [layer isVisible]){
    [att addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle)} range:NSMakeRange(0, [[att string] length])];
  }
  [[cell textField] setAttributedStringValue:att];
  [cell setAlphaValue:[layer opacity]];
  return cell;
}

@end
