/*
 * Copyright (c) 2015 Verimatrix, Inc.  All Rights Reserved.
 * The Software or any portion thereof may not be reproduced in any form
 * whatsoever except as provided by license, without the written consent of
 * Verimatrix.
 *
 * THIS NOTICE MAY NOT BE REMOVED FROM THE SOFTWARE BY ANY USER THEREOF.
 * NEITHER VERIMATRIX NOR ANY PERSON OR ORGANIZATION ACTING ON BEHALF OF
 * THEM:
 *
 * 1. MAKES ANY WARRANTY OR REPRESENTATION WHATSOEVER, EXPRESS OR IMPLIED,
 *    INCLUDING ANY WARRANTY OF MERCHANTABILITY OR FITNESS FOR ANY
 *    PARTICULAR PURPOSE WITH RESPECT TO THE SOFTWARE;
 *
 * 2. ASSUMES ANY LIABILITY WHATSOEVER WITH RESPECT TO ANY USE OF THE
 *    PROGRAM OR ANY PORTION THEREOF OR WITH RESPECT TO ANY DAMAGES WHICH
 *     MAY RESULT FROM SUCH USE.
 *
 * RESTRICTED RIGHTS LEGEND:  Use, duplication or disclosure by the
 * Government is subject to restrictions set forth in subparagraphs
 * (a) through (d) of the Commercial Computer Software-Restricted Rights
 * at FAR 52.227-19 when applicable, or in subparagraph (c)(1)(ii) of the
 * Rights in Technical Data and Computer Software clause at
 * DFARS 252.227-7013, and in similar clauses in the NASA FAR supplement,
 * as applicable. Manufacturer is Verimatrix, Inc.
 */ 
//
//  AppColors.h
//  PlayVcas
//
//  Created by Matt Fite on 5/17/10.
//  Copyright 2010 Verimatrix. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 *  TangoChameleon1		#8ae234		138,226,52
 *  TangoChameleon2		#73d216		115,210,22
 *  TangoChameleon3		#4e9a06		78,154,6
 *  TangoAluminium1		#eeeeec		238,238,236
 *  TangoAluminium2		#d3d7cf		211,215,207
 *  TangoAluminium3		#babdb6		186,189,182
 *  TangoAluminium4		#888a85		136,138,133
 *  TangoAluminium5		#555753		85,87,83
 *  TangoAluminium6		#2e3436		46,52,54
 */

// Use this category to provide the consistent color scheme to use
// throughout the app

@interface UIColor (AppColors)

+(UIColor *) TangoChameleon1;
+(UIColor *) TangoChameleon2;
+(UIColor *) TangoChameleon3;
+(UIColor *) TangoAluminium1;
+(UIColor *) TangoAluminium2;
+(UIColor *) TangoAluminium3;
+(UIColor *) TangoAluminium4;
+(UIColor *) TangoAluminium5;
+(UIColor *) TangoAluminium6;


@end
