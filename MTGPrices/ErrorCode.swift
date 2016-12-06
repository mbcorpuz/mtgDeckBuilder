//
//  ErrorCode.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/29/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case badRequest = 400
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case serviceUnavailable = 503
}
