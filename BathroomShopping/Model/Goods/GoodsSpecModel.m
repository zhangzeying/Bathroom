//
//  GoodsSpecModel.m
//  BathroomShopping
//
//  Created by zzy on 8/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsSpecModel.h"

@implementation GoodsSpecModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.specColor forKey:@"specColor"];
    [aCoder encodeObject:self.specSize forKey:@"specSize"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.specStock] forKey:@"specStock"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.specPrice] forKey:@"specPrice"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.specColor = [aDecoder decodeObjectForKey:@"specColor"];
        self.specSize = [aDecoder decodeObjectForKey:@"specSize"];
        self.specStock = [[aDecoder decodeObjectForKey:@"specStock"] integerValue];
        self.specPrice = [[aDecoder decodeObjectForKey:@"specPrice"] doubleValue];
    }
    
    return self;
}
@end
