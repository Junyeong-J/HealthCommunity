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

struct APIErrorMessages {
    static let commonMessages: [Int: String] = [
        420: "잘못된 요청입니다.",
        429: "과호출 했습니다.",
        444: "서버 호출을 실패했습니다.",
        500: "서버 오류가 발생했습니다."
    ]
    
    static func messages(for api: LSLPRouter) -> [Int: String] {
        switch api {
        case .LoginAPI:
            return [
                400: "이메일 혹은 비밀번호를 입력해주세요.",
                401: "이메일 또는 비밀번호가 잘못되었습니다."
            ]
        case .SignUpAPI:
            return [
                400: "회원가입 정보가 잘못되었습니다."
            ]
        case .EmailCheck:
            return [
                400: "이메일 형식이 잘못되었습니다."
            ]
        }
    }
}

