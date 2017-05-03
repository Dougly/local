//
//  MTColorConstants.h
//
//
//  Created by Steven Koposov  on 05/6/16.
//  Copyright (c) 2015 Steven Koposov . All rights reserved.
//

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#pragma mark - Navigation

#define kJBColorNavigationBarTint UIColorFromHex(0xFFFFFF)
#define kJBColorNavigationTint UIColorFromHex(0x000000)

#pragma mark - Bar Chart

#define kJBColorBarChartControllerBackground UIColorFromHex(0x313131)
#define kJBColorBarChartBackground UIColorFromHex(0x3c3c3c)

#define kJBColorBarChartBarBurnedBlue UIColorFromHex(0x08bcef)
#define kJBColorBarChartBarTargetGreen UIColorFromHex(0x34b234)
#define kJBColorBarChartBarFedPuppule [UIColor colorWithRed:0.788 green:0.428 blue:0.936 alpha:1.000]

#define kJBColorBarChartHeaderSeparatorColor UIColorFromHex(0x686868)

#pragma mark - Line Chart

#define kJBColorLineChartControllerBackground UIColorFromHex(0xb7e3e4)
#define kJBColorLineChartBackground UIColorFromHex(0xb7e3e4)
#define kJBColorLineChartHeader UIColorFromHex(0x1c474e)
#define kJBColorLineChartHeaderSeparatorColor UIColorFromHex(0x8eb6b7)
#define kJBColorLineChartDefaultSolidLineColor [UIColor colorWithWhite:1.0 alpha:0.5]
#define kJBColorLineChartDefaultSolidSelectedLineColor [UIColor colorWithWhite:1.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedLineColor [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedSelectedLineColor [UIColor colorWithWhite:1.0 alpha:1.0]

#pragma mark - Tooltips

#define kJBColorTooltipColor [UIColor colorWithWhite:1.0 alpha:0.9]
#define kJBColorTooltipTextColor UIColorFromHex(0x313131)

#pragma mark - Tables

#define SDTableBodyColor UIColorFromHex(0x313131);
#define SDTableHeaderColor UIColorFromHex(0x3c3c3c);
#define SDTableTitleLabelTextColor [UIColor colorWithWhite:0.944 alpha:0.9];
#define SDTableBackgroundColor [UIColor colorWithWhite:0.120 alpha:1.000];
#define SDTableContainerColor [UIColor colorWithWhite:0.128 alpha:0.9];
#define SDTableSubContainerColor [UIColor colorWithWhite:0.686 alpha:1.000];

#pragma mark - Gauge Chart

#define GaugeColorRisk1 UIColorFromHex(0xf75e60);
#define GaugeColorRisk2 UIColorFromHex(0xf86f63);
#define GaugeColorRisk3 UIColorFromHex(0xf98367);
#define GaugeColorRisk4 UIColorFromHex(0xfb956a);
#define GaugeColorRisk5 UIColorFromHex(0xfcaa6e);
#define GaugeColorRisk6 UIColorFromHex(0xfdbd71);
#define GaugeColorRisk7 UIColorFromHex(0xfed275);
#define GaugeColorRisk8 UIColorFromHex(0xffe879);
#define GaugeColorRisk9 UIColorFromHex(0xe6e178);
#define GaugeColorRisk10 UIColorFromHex(0xcdda77);
#define GaugeColorRisk11 UIColorFromHex(0xb5d276);
#define GaugeColorRisk12 UIColorFromHex(0x9ccc74);
#define GaugeColorRisk13 UIColorFromHex(0x85c473);
#define GaugeColorRisk14 UIColorFromHex(0x6fbd72);
#define GaugeColorRisk15 UIColorFromHex(0x58b670);

/************ Brand COLORS *************************************************************/

#pragma mark - Brand Colors

#define kColorYellowRed         [UIColor colorWithRed:0.949 green:0.576 blue:0.251 alpha:1.000]
#define kColorGreenHighlighted  [UIColor colorWithRed:0.263 green:0.635 blue:0.306 alpha:0.100]

#define kColorOrange            UIColorFromHex(0xff7638)
#define kColorGreyControl       UIColorFromHex(0xeaeaea)
#define kColorGreenContext      UIColorFromHex(0x00ab64)
#define kColorFacebookControl   UIColorFromHex(0x1E296B)
#define kColorGreenControl      UIColorFromHex(0x27AE60)
#define kColorGreenBackground   UIColorFromHex(0x43A24E)
#define kColorLightGreyControl  UIColorFromHex(0xF3F4F6)
#define kColorDivider           UIColorFromHex(0xE5E5E5)
#define kColorDividerDark       UIColorFromHex(0xAFAFAF)
#define kColorTextGray          UIColorFromHex(0x444444)
#define kColorFacebook          UIColorFromHex(0x3B5998)
#define kColorTextShadowGray    UIColorFromHex(0x888888)
#define kColorTextLightGray     UIColorFromHex(0x888888)
#define kColorTextNotActiveGray UIColorFromHex(0xD0D1D2)
#define kColorTextBlack         UIColorFromHex(0x222222)

#define kTotsAmourBrandColorHEX UIColorFromHex(0x5e9fde)
#define kTotsAmourBrandColorHEX2 UIColorFromHex(0x5e9fce)

#define kLocalColor UIColorFromHex(0x939598)

#define kColorDisableControls [UIColor colorWithWhite:0.982 alpha:1.000]






