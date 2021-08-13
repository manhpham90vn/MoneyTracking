//
//  ApiRoute.swift
//  VIPPER
//
//  Created by Manh Pham on 3/16/21.
//

import Foundation
import Moya

protocol RetryRequestable {
    var canRetryRequest: Bool { get }
}

protocol ShowDialogableWhenError {
    var needShowDialogWhenBadStatuCode: Bool { get }
}

enum ApiRouter {
    case login
}

extension ApiRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: Configs.shared.env.apiURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
}

extension ApiRouter: AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType? {
        switch self {
        default:
            return nil
        }
    }
    
}

extension ApiRouter: RetryRequestable {
    var canRetryRequest: Bool {
        switch self {
        default:
            return true
        }
    }
}

extension ApiRouter: ShowDialogableWhenError {
    var needShowDialogWhenBadStatuCode: Bool {
        switch self {
        default:
            return true
        }
    }
}
