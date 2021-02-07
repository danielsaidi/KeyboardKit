//
//  KeyboardLayoutWidth.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-21.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/**
 This enum describes various ways in which a keyboard layout
 can size its items.
 */
public indirect enum KeyboardLayoutWidth: Equatable {
    
    /**
     Share any remaining width on the same row.
     */
    case available
    
    /**
     Use a percentual width of the total available row width.
     */
    case percentage(_ percent: CGFloat)
    
    /**
     Use a fixed width in points.
     */
    case points(_ points: CGFloat)
    
    /**
     This width is special and can be used to give all input
     items the same width.
     
     A system keyboard will take each row that contains this
     width type, select the row where the resulting width in
     points is smallest, then use it for every item that use
     the `input` or `inputPercentage` width types.
     */
    case reference
    
    /**
     Use the width of a `reference` item.
     */
    case useReference
    
    /**
     Use the percentual width of a `reference` item.
     */
    case useReferencePercentage(_ percent: CGFloat)
}
