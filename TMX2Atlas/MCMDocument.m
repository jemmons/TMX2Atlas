#import "MCMDocument.h"

#import "MCMTMXParser.h"
#import "MCMMap.h"

typedef NS_ENUM(NSInteger, MCMTableSection){
  MCMTableSectionMap = 0,
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
    NSInteger mapCount = 1+1;
    NSInteger tilesetCount = 1+[[[self map] tilesets] count];
    NSInteger layerCount = 1+[[[self map] layers] count];
    numberOfRows = mapCount + tilesetCount + layerCount;
  }
  return numberOfRows;
}


#pragma mark - TABLE VIEW DELEGATE
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
  NSView *cell = nil;
  NSIndexPath *indexPath = [self indexPathForRow:row];
  if([indexPath indexAtPosition:kRow] == 0){ //Headers are the first rows in the seciton
    cell = [self headerCellForTable:tableView withIndexPath:indexPath];

  } else{
    switch([indexPath indexAtPosition:kSection]){
      case MCMTableSectionMap:
        cell = [self mapCellForTable:tableView withIndexPath:indexPath];
        break;
      case MCMTableSectionTileset:
        cell = [self tilesetCellForTable:tableView withIndexPath:indexPath];
        break;
      case MCMTableSectionLayer:
        cell = [self layerCellForTable:tableView withIndexPath:indexPath];
        break;
    }
  }
  
  return cell;
}


-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row{
  NSIndexPath *indexPath = [self indexPathForRow:row];
  return 0 == [indexPath indexAtPosition:kRow]; //the first row of each section is a header.
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
  CGFloat height = 0.0f;
  NSIndexPath *indexPath = [self indexPathForRow:row];
  if([indexPath indexAtPosition:kRow] == 0){ //It's a header
    height = 30.0f;
  } else {
    switch([indexPath indexAtPosition:kSection]){
      case MCMTableSectionMap:
        height = 200.0f;
        break;
      case MCMTableSectionTileset:
        height = 100.0f;
        break;
      case MCMTableSectionLayer:
        height = 50.0f;
        break;
    }
  }
  return height;
}


#pragma mark - UTILITY
-(NSIndexPath *)indexPathForRow:(NSInteger)row{
  NSUInteger indexes[2];
  NSUInteger mapCount = 1+1;
  NSUInteger tilesetCount = 1+[[[self map] tilesets] count];
  NSUInteger layerCount = 1+[[[self map] layers] count];
  
  if(row < mapCount){
    indexes[0] = MCMTableSectionMap;
    indexes[1] = row;
  } else if(row < mapCount + tilesetCount){
    indexes[0] = MCMTableSectionTileset;
    indexes[1] = row - mapCount;
  } else if(row < mapCount + tilesetCount + layerCount){
    indexes[0] = MCMTableSectionLayer;
    indexes[1] = row - mapCount - tilesetCount;
  }
  
  return [NSIndexPath indexPathWithIndexes:indexes length:2];
}


-(NSView *)headerCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"HeaderCell" owner:self];
  switch((MCMTableSection)[indexPath indexAtPosition:kSection]){
    case MCMTableSectionMap:
      [[cell textField] setStringValue:@"Map"];
      break;
    case MCMTableSectionTileset:
      [[cell textField] setStringValue:@"Tile Sets"];
      break;
    case MCMTableSectionLayer:
      [[cell textField] setStringValue:@"Layers"];
      break;
  }
  return cell;
}


-(NSView *)mapCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  NSUInteger row = [indexPath indexAtPosition:kRow]-1;
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
  return cell;
}


-(NSView *)tilesetCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  NSUInteger row = [indexPath indexAtPosition:kRow]-1;
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"TilesetCell" owner:self];
  return cell;
}


-(NSView *)layerCellForTable:(NSTableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
  NSUInteger row = [indexPath indexAtPosition:kRow]-1;
  NSTableCellView *cell = [tableView makeViewWithIdentifier:@"LayerCell" owner:self];
  return cell;
}
@end
