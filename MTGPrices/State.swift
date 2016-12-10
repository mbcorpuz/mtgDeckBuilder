//
//  State.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/28/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire

struct State: StateType {
    var decks: [Deck]!
    var cardResults: Result<[CardResult]>?
    var parameters: [String: Any]?
    var shouldSearch: Bool
    var isLoading: Bool
    var remainingRequests: Int?
    var additionalCardResults: Result<[CardResult]>?
    var isDownloadingImages: Bool
}
