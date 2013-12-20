#import "MCMDocument.h"

#import "MCMTMXParser.h"
#import "MCMMap.h"
#import "MCMTileset.h"
#import "MCMMainCellView.h"


typedef NS_ENUM(NSInteger, MCMTableSection){
  MCMTableSectionHeader = 0,
  MCMTableSectionTileset,
  MCMTableSectionLayer
};
const NSUInteger kSection = 0;
const NSUInteger kRow = 1;

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
    NSLog(@"map: %@", [self map]);
  } else{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not parse TMX file.", nil), NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Unknown error occured.", nil), NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Try exporting the TMX again with approved settings.", nil)};
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain"
                                    code:-100
                                userInfo:userInfo];
    success = NO;
  }
  return success;
}


#pragma mark - TABLE VIEW DATA SOURCE
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
  NSInteger numberOfRows = 0;
  if([self map]){
    NSInteger headerCount = 1;
    NSInteger tilesetCount = [[[self map] tilesets] count];
    NSInteger layerCount = [[[self map] layers] count];
    numberOfRows = headerCount + tilesetCount + layerCount;
  }
  return numberOfRows;
}


#pragma mark - TABLE VIEW DELEGATE
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
  NSView *cell = nil;
  NSIndexPath *indexPath = [self indexPathForRow:row];
  switch([indexPath indexAtPosition:kSection]){
    case MCMTableSectionHeader:
      cell = [self headerCellForTable:tableView withIndexPath:indexPath];
      break;
    case MCMTableSectionTileset:
      cell = [self tilesetCellForTable:tableView withIndexPath:indexPath];
      break;
    case MCMTableSectionLayer:
      cell = [self layerCellForTable:tableView withIndexPath:indexPath];
      break;
  }
  
  return cell;
}


-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row{
  return 0 == row;
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
  CGFloat height = 0.0f;
  NSIndexPath *indexPath = [self indexPathForRow:row];
  switch([indexPath indexAtPosition:kSection]){
    case MCMTableSectionHeader:
      height = 30.0f;
      break;
    case MCMTableSectionTileset:
      height = 100.0f;
      break;
    case MCMTableSectionLayer:
      height = 50.0f;
      break;
  }
  return height;
}


#pragma mark - UTILITY
-(NSIndexPath *)indexPathForRow:(NSInteger)row{
  NSUInteger indexes[2];
  NSUInteger headerCount = 1;
  NSUInteger tilesetCount = [[[self map] tilesets] count];
  NSUInteger layerCount = [[[self map] layers] count];
  
  if(row < headerCount){
    indexes[kSection] = MCMTableSectionHeader;
    indexes[kRow] = row;
  } else if(row < headerCount + tilesetCount){
    indexes[kSection] = MCMTableSectionTileset;
    indexes[kRow] = row - headerCount;
  } else if(row < headerCount + tilesetCount + layerCount){
    indexes[kSection] = MCMTableSectionLayer;
    indexes[kRow] = row - headerCount - tilesetCount;
  }
  
  return [NSIndexPath indexPathWithIndexes:indexes length:2];
}


-(NSView *)headerCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  MCMMainCellView *cell = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
  [[cell textField] setStringValue:[self displayName]];
  [[cell orientationLabel] setStringValue:[NSString stringWithFormat:@"(%@)", [[self map] orientation]]];
  [[cell sizeLabel] setStringValue:[NSString stringWithFormat:@"%lu×%lu tiles", (unsigned long)[[self map] width], (unsigned long)[[self map] height]]];
  return cell;
}


-(NSView *)tilesetCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  MCMTileset *tileset = [[[self map] tilesets] objectAtIndex:[indexPath indexAtPosition:kRow]];
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"TilesetCell" owner:self];
  [[cell imageView] setImage:[tileset image]];
  [[cell textField] setStringValue:[NSString stringWithFormat:@"%@ Tileset", [tileset name]]];
  return cell;
}


-(NSView *)layerCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  NSUInteger row = [indexPath indexAtPosition:kRow]-1;
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"LayerCell" owner:self];
  return cell;
}
@end
