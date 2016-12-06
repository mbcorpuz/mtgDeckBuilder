//
//  String Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/1/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation

extension String {
    var cmcToInt: Int {
        if self == "None" {
            return -1
        } else {
            return Int(self)!
        }
    }
}
