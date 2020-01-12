//
//  CommandClient.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import Alamofire

class CommandClient: NSObject {
     @discardableResult
        private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
            return AF.request(route)
                            .responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                                completion(response.result)
            }
    }
    
    static func getCommands(completion: @escaping (Result<CommandList, AFError>) -> Void) {
        performRequest(route: APIRouter.commands, completion: completion)
    }
    
    static func executeCommand(command:Command, completion: @escaping (Result<CommandResponse,AFError>) -> Void) {
        performRequest(route: APIRouter.execute(command: command), completion: completion)
    }
}
