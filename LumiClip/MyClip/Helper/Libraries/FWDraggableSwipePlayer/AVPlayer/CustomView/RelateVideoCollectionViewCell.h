//
//  RelateVideoCollectionViewCell.h
//  MyClip
//
//  Created by hnc on 10/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelateVideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
