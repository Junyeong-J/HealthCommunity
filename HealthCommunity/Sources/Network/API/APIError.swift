//
//  APIError.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation

enum APIError: Error {
    case unknownResponse
    case networkError(Error)
    case invalidRequest
    case customError(statusCode: Int, message: String)
}
