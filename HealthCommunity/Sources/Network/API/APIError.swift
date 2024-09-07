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
        case .auth(let authRouter):
            switch authRouter {
            case .LoginAPI:
                return [
                    400: "이메일 혹은 비밀번호를 입력해주세요.",
                    401: "이메일 또는 비밀번호가 잘못되었습니다."
                ]
            case .SignUpAPI:
                return [
                    400: "회원가입 정보가 잘못되었습니다.",
                    402: "닉네임이 공백입니다.",
                    409: "이미 가입된 유저입니다."
                ]
            case .EmailCheck:
                return [
                    400: "이메일 형식이 잘못되었습니다.",
                    409: "이메일 중복입니다."
                ]
            case .TokenAPI:
                return [
                    418: "인증토큰이 만료되었습니다. 로그인화면에서 다시 로그인해주세요."
                ]
            }
        case .post(let postRouter):
            switch postRouter {
            case .imageUpload:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .myRoutinePosts:
                return [
                    400: "유효하지 않은 값 포함",
                    
                ]
            case .postView:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .specificPost:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .userByPostAPI:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .posts:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .likeAPI:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .likeMeAPI:
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            case .deletePost(id: let id):
                return [
                    400: "이메일 형식이 잘못되었습니다."
                ]
            }
        case .profile(let profileRouter):
            switch profileRouter {
            case .myProfile:
                return [
                    401: "인증할 수 없는 토큰입니다."
                ]
            case .updateProfile:
                return [
                    401: "인증할 수 없는 토큰입니다."
                ]
            }
        case .comment(let commentRouter):
            switch commentRouter {
            case .commentPost:
                return [
                    401: "인증할 수 없는 토큰입니다."
                ]
            }
        case .payment(let payRouter):
            switch payRouter {
            case .payment(let impID, let postID):
                return [
                    401: "인증할 수 없는 토큰입니다."
                ]
            case .myPayment:
                return [
                    401: "인증할 수 없는 토큰입니다."
                ]
            }
        }
    }
}

