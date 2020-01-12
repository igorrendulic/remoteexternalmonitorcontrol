//
//  MonitorClient.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Alamofire

class MonitorClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        return AF.request(route)
                        .responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                            completion(response.result)
        }
    }
    
    static func getMonitors(completion:@escaping (Result<[Monitor], AFError>) -> Void) {
        performRequest(route: APIRouter.monitors, completion: completion)
    }
}
