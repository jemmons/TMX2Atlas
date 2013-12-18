@import Foundation;
@class MCMMap;

@interface MCMTMXParser : NSObject <NSXMLParserDelegate>
-(id)initWithURL:(NSURL *)aURL;
-(id)initWithData:(NSData *)someData;
-(MCMMap *)parse;
@end
