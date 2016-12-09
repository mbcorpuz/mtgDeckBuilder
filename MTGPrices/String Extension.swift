//
//  String Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/1/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var cmcToInt: Int {
        if self == "None" {
            return -1
        } else {
            return Int(self)!
        }
    }
    
    func createCmcImages() -> [UIImageView] {
        guard self != "None" else { return [] }
        
        var images = [UIImageView]()
        var costStrings = self.components(separatedBy: "{")
        for (index, string) in costStrings.enumerated() {
            costStrings[index] = string.replacingOccurrences(of: "}", with: "")
            if let image = UIImage(named: costStrings[index]) {
                images.append(UIImageView(image: image))
            }
        }
        
        print(images.count)
        return images
    }
}
