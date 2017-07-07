//
//  FCFontView.m
//  FCFontKeyboard
//
//  Created by zz on 2017/7/4.
//  Copyright © 2017年 FlyCatkin. All rights reserved.
//

#import "FCFontView.h"

@interface FCFontView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *fonts;
@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation FCFontView

#pragma mark - public

- (void)setInitailFont:(UIFont *)font
{
    for (int i = 0; i < self.fonts.count; i++) {
        NSString *fontName = self.fonts[i];
        if ([fontName isEqualToString:[font fontName]]) {
            self.selectIndex = i;
            [self.tableView reloadData];
            return;
        }
    }
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupFonts];
    }
    return self;
}

- (void)setupSubViews{
    [self addSubview:self.tableView];
}

- (void)setupFonts
{
    self.fonts = [[NSMutableArray alloc] initWithCapacity:243];
    [self.fonts addObject:[UIFont systemFontOfSize:16].fontName];
    for (NSString * familyName in [UIFont familyNames]) {
        NSLog(@"Font FamilyName = %@",familyName); //*输出字体族科名字
        for (NSString * fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [self.fonts addObject:fontName];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fonts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCFontViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FCFontViewCell"];
    if (!cell) {
        cell = [[FCFontViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FCFontViewCell"];
    }
    
    NSString *fontName = self.fonts[indexPath.row];
    cell.fontLabel.text = fontName;
    cell.fontLabel.font = [UIFont fontWithName:fontName size:16];
    if (indexPath.row == 0) {
        cell.fontLabel.text = @"默认字体";
    }
    if (self.selectIndex == indexPath.row) {
        cell.selectImageView.image = [UIImage imageNamed:@"fckeyboard_select"];
    }else{
        cell.selectImageView.image = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    NSString *fontName = self.fonts[indexPath.row];
    UIFont *font = [UIFont fontWithName:fontName size:16];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontViewChangeFont:)]) {
        [self.delegate fontViewChangeFont:font];
    }
}

#pragma mark - layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}


#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
@end


@implementation FCFontViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.selectImageView];
    [self addSubview:self.fontLabel];
    [self addSubview:self.downloadFontButton];
}

#pragma mark - getter

- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.frame = CGRectMake(12, 20 - 10, 20, 20);
    }
    return _selectImageView;
}

- (UILabel *)fontLabel{
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.frame = CGRectMake(CGRectGetMaxX(self.selectImageView.frame) + 12, 22 - 10, 240, 20);
        _fontLabel.textColor = [UIColor blackColor];
    }
    return _fontLabel;
}

- (UIButton *)downloadFontButton{
    if (!_downloadFontButton) {
        _downloadFontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadFontButton setTitle:@"下载" forState:UIControlStateNormal];
    }
    return _downloadFontButton;
}

@end



