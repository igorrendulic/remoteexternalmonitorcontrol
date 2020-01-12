//
//  APIRouter.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Alamofire

enum APIRouter : URLRequestConvertible {
    
    case monitors
    case commands
    case execute(command:Command)
    
    private var method : HTTPMethod {
        switch self {
        case .monitors:
            return .get
        case .commands:
            return .get
        case .execute:
            return .post
        }
    }
    
    private var path : String {
        switch self {
        case .monitors:
            return "/monitors"
        case .commands, .execute:
            return "/commands"
        }
    }
    
    private var parameters : Parameters? {
        switch self {
        case .monitors:
            return nil
        case .commands:
            return nil
        case .execute(let command):
            return ["name":command.name, "flag":command.flag, "number":command.number, "monitor_id":command.monitor_id ?? "1"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        // common headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw AFError.parameterEncoderFailed(reason: .encoderFailed(error:error))
            }
        }
        
        return urlRequest
    }
}
