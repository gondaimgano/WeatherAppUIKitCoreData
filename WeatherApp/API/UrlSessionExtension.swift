//
//  UrlSessionExtension.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 9/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//


import Foundation

enum HTTPError: Error {
    case socketError(Error)
    case serverSideError(Int)
    var localizedDescription: String!{
        
        switch self {
       case .serverSideError(let errorCode):
                 switch errorCode {
                 
                 case 400,401,403:
                     return "Invalid API keys please try again"
                 case 404:
                     return "Not Found"
                 case 502,503:
                     return "Server Temporarily down"
                 default:
                    print(errorCode)
                     return "Something went wrong - please try again"
                 }
            
        case .socketError(let error):
        
            return  error.localizedDescription
       
       
        }
    }
}
//MARK:- CORE URLSESSION EXTENSION LIBRARY
extension URLSession {



    typealias DataTaskResult = Result<Data, HTTPError>

    func dataTask(with request: WeatherAPI.ENDPOINT.LOOKUP, completionHandler: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request.buildRequest) { (data, response, error) in
            if let error = error {
                
                completionHandler(.failure(HTTPError.socketError(error)))
                return
            }
            if let response = response as? HTTPURLResponse,(200..<300).contains(response.statusCode){
                 completionHandler(.success((data!)))
            } else{
                if let response = response as? HTTPURLResponse{
                completionHandler(.failure(HTTPError.serverSideError(response.statusCode)))
                return
                }
            }
          
            
           
        }
    }
}

