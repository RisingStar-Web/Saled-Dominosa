//
//  Utils.m
//  Dominosa
//
//  Created by Anjona on 19/04/2017.
//  Copyright © 2017 Anjona Inc. All rights reserved.
//

#import "Utils.h"

static UIImage *navBg;

@implementation Utils

+ (UIImage*)getNavBg {
    if (!navBg) {
        UIImage *originalImage = [UIImage imageNamed:@"navbg"];
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 1, 0);
        navBg = [originalImage resizableImageWithCapInsets:insets];
    }
    return navBg;
}

+ (NSString*)localization:(const char*)str {
    if (strcmp(str, "Maximum number on dominoes") == 0) {
        return NSLocalizedString(@"MAXIMUM_NUMBER_DOMINOES", nil);
    } else if (strcmp(str, "Ensure unique solution") == 0) {
        return NSLocalizedString(@"ENSURE_UNIQUE_SOLUTION", nil);
    } else if (strcmp(str, "Game description is too short") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_SHORT", nil);
    } else if (strcmp(str, "Game description is too long") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_LONG", nil);
    } else if (strcmp(str, "Invalid syntax in game description") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_SYNTAX_INVALID", nil);
    } else if (strcmp(str, "Number out of range in game description") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_OUT_RANGE", nil);
    } else if (strcmp(str, "Incorrect number balance in game description") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_BALANCE_INCORRECT", nil);
    } else if (strcmp(str, "Missing ']' in game description") == 0) {
        return NSLocalizedString(@"ERROR_DESCRIPTION_SYNTAX_MISSING", nil);
    } else if (strcmp(str, "Game random seed") == 0) {
        return NSLocalizedString(@"GAME_RANDOM_SEED", nil);
    } else if (strcmp(str, "Game ID") == 0) {
        return NSLocalizedString(@"GAME_ID", nil);
    } else if (strcmp(str, "MINE") == 0) {
        return NSLocalizedString(@"MINE", nil);
    } else if (strcmp(str, "DEAD") == 0) {
        return NSLocalizedString(@"DEAD", nil);
    } else if (strcmp(str, "AUTOMINE") == 0) {
        return NSLocalizedString(@"AUTOMINE", nil);
    } else if (strcmp(str, "AUTOSOLVED") == 0) {
        return NSLocalizedString(@"AUTOSOLVED", nil);
    } else if (strcmp(str, "DONE") == 0) {
        return NSLocalizedString(@"DONE", nil);
    } else if (strcmp(str, "Unable to find a solution from this starting point") == 0) {
        return NSLocalizedString(@"NOSOLUTION", nil);
    } else if (strcmp(str, "Width") == 0) {
        return NSLocalizedString(@"WIDTH", nil);
    } else if (strcmp(str, "Height") == 0) {
        return NSLocalizedString(@"HEIGHT", nil);
    } else if (strcmp(str, "7x7 easy") == 0) {
        return [NSString stringWithFormat:@"7x7 %@", NSLocalizedString(@"EASY", nil)];
    } else if (strcmp(str, "7x7 tricky") == 0) {
        return [NSString stringWithFormat:@"7x7 %@", NSLocalizedString(@"TRICKY", nil)];
    } else if (strcmp(str, "7x7 hard") == 0) {
        return [NSString stringWithFormat:@"7x7 %@", NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, "10x10 easy") == 0) {
        return [NSString stringWithFormat:@"10x10 %@", NSLocalizedString(@"EASY", nil)];
    } else if (strcmp(str, "10x10 tricky") == 0) {
        return [NSString stringWithFormat:@"10x10 %@", NSLocalizedString(@"TRICKY", nil)];
    } else if (strcmp(str, "10x10 hard") == 0) {
        return [NSString stringWithFormat:@"10x10 %@", NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, "14x14 easy") == 0) {
        return [NSString stringWithFormat:@"14x14 %@", NSLocalizedString(@"EASY", nil)];
    } else if (strcmp(str, "14x14 tricky") == 0) {
        return [NSString stringWithFormat:@"14x14 %@", NSLocalizedString(@"TRICKY", nil)];
    } else if (strcmp(str, "14x14 hard") == 0) {
        return [NSString stringWithFormat:@"14x14 %@", NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, "Difficulty") == 0) {
        return NSLocalizedString(@"DIFFICULTY", nil);
    } else if (strcmp(str, "Symmetry") == 0) {
        return NSLocalizedString(@"SYMMETRY", nil);
    } else if (strcmp(str, "Easy") == 0) {
        return NSLocalizedString(@"EASY", nil);
    } else if (strcmp(str, "Tricky") == 0) {
        return NSLocalizedString(@"TRICKY", nil);
    } else if (strcmp(str, "Hard") == 0) {
        return NSLocalizedString(@"HARD", nil);
    } else if (strcmp(str, "%age of black squares") == 0) {
        return NSLocalizedString(@"AGEOFBLACKSQUARES", nil);
    } else if (strcmp(str, "Cross") == 0) {
        return NSLocalizedString(@"CROSS", nil);
    } else if (strcmp(str, "Octagon") == 0) {
        return NSLocalizedString(@"OCTAGON", nil);
    } else if (strcmp(str, "Random 5x5") == 0) {
        return NSLocalizedString(@"RANDOM55", nil);
    } else if (strcmp(str, "Random 7x7") == 0) {
        return NSLocalizedString(@"RANDOM77", nil);
    } else if (strcmp(str, "Random 9x9") == 0) {
        return NSLocalizedString(@"RANDOM99", nil);
    } else if (strcmp(str, ":None:2-way mirror:2-way rotational:4-way mirror:4-way rotational") == 0) {
        return [NSString stringWithFormat:@":%@:%@:%@:%@:%@", NSLocalizedString(@"NONE", nil), NSLocalizedString(@"2WAYMIRROR", nil), NSLocalizedString(@"2WAYROTATIONAL", nil), NSLocalizedString(@"4WAYMIRROR", nil), NSLocalizedString(@"4WAYROTATIONAL", nil)];
    } else if (strcmp(str, ":Easy:Tricky:Hard") == 0) {
        return [NSString stringWithFormat:@":%@:%@:%@", NSLocalizedString(@"EASY", nil), NSLocalizedString(@"TRICKY", nil), NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, ":Cross:Octagon:Random") == 0) {
        return [NSString stringWithFormat:@":%@:%@:%@", NSLocalizedString(@"CROSS", nil), NSLocalizedString(@"OCTAGON", nil), NSLocalizedString(@"RANDOM", nil)];
    } else if (strcmp(str, "Board type") == 0) {
        return NSLocalizedString(@"BOARDTYPE", nil);
    } else if (strcmp(str, "5x5 Easy") == 0) {
        return [NSString stringWithFormat:@"5x5 %@", NSLocalizedString(@"EASY", nil)];
    } else if (strcmp(str, "6x6 Easy") == 0) {
        return [NSString stringWithFormat:@"6x6 %@", NSLocalizedString(@"EASY", nil)];
    } else if (strcmp(str, "6x6 Normal") == 0) {
        return [NSString stringWithFormat:@"6x6 %@", NSLocalizedString(@"NORMAL", nil)];
    } else if (strcmp(str, "6x6 Hard") == 0) {
        return [NSString stringWithFormat:@"6x6 %@", NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, "6x6 Extreme") == 0) {
        return [NSString stringWithFormat:@"6x6 %@", NSLocalizedString(@"EXTREME", nil)];
    } else if (strcmp(str, "6x6 Unreasonable") == 0) {
        return [NSString stringWithFormat:@"6x6 %@", NSLocalizedString(@"UNREASONABLE", nil)];
    } else if (strcmp(str, "9x9 Normal") == 0) {
        return [NSString stringWithFormat:@"9x9 %@", NSLocalizedString(@"NORMAL", nil)];
    } else if (strcmp(str, "9x9 Hard") == 0) {
        return [NSString stringWithFormat:@"9x9 %@", NSLocalizedString(@"HARD", nil)];
    } else if (strcmp(str, "9x9 Extreme") == 0) {
        return [NSString stringWithFormat:@"9x9 %@", NSLocalizedString(@"EXTREME", nil)];
    } else if (strcmp(str, "9x9 Unreasonable") == 0) {
        return [NSString stringWithFormat:@"9x9 %@", NSLocalizedString(@"UNREASONABLE", nil)];
    } else if (strcmp(str, "Grid size") == 0) {
        return NSLocalizedString(@"GRIDSIZE", nil);
    } else if (strcmp(str, ":Easy:Normal:Hard:Extreme:Unreasonable") == 0) {
        return [NSString stringWithFormat:@":%@:%@:%@:%@:%@", NSLocalizedString(@"EASY", nil), NSLocalizedString(@"NORMAL", nil), NSLocalizedString(@"HARD", nil), NSLocalizedString(@"EXTREME", nil), NSLocalizedString(@"UNREASONABLE", nil)];
    }
    
    return [NSString stringWithUTF8String:str];
}

@end
