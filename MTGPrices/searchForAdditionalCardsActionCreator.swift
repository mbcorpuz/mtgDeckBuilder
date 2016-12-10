//
//  searchForAdditionalCardsActionCreator.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/9/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import ObjectMapper

func searchForAdditionalCardsActionCreator(url: URLConvertible, parameters: Parameters) -> Store<State>.ActionCreator {
    return { state, store in
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            // Completion handler
            
            guard let json = response.result.value else {
                print("error retrieving cards")
                let errorCode = ErrorCode(rawValue: response.response?.statusCode ?? 0)
                let apiError = ApiError(status: errorCode, type: nil, message: "Error retrieving card data")
                store.dispatch(SearchForAdditionalCards(results: Result.failure(apiError), isLoading: false, remainingRequests: nil))
                return
            }
            guard response.response?.statusCode == 200 else {
                print("error - status code isn't 200")
                // Assuming statusCode is guaranteed to have a non-optional value.
                // TODO: - Check that ^
                let apiError = Mapper<ApiError>().map(JSONObject: json)!
                store.dispatch(SearchForAdditionalCards(results: Result.failure(apiError), isLoading: false, remainingRequests: nil))
                return
            }
            
            print("no error retrieving")
            var remainingRequests: Int? = nil
            if let limitString = (response.response?.allHeaderFields["ratelimit-remaining"] as? String) {
                remainingRequests = Int(limitString)
                print("remaining requests this hour: \(remainingRequests!)")
            }
            if let retrievedCards = Mapper<ApiResult>().map(JSONObject: json) {
                store.dispatch(SearchForAdditionalCards(results: Result.success(retrievedCards.cards), isLoading: false, remainingRequests: remainingRequests))
            }
        }
        return SearchForAdditionalCards(results: nil, isLoading: true, remainingRequests: nil)
    }
}
