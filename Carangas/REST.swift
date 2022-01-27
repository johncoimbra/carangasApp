//
//  REST.swift
//  Carangas
//
//  Created by Luis Eduardo Silva Oliveira on 26/01/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["ContentType": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config //obs: quando usamos o return, isso quer dizer que estamos devolvendo o objeto                          "config" com todas as configurações acima setadas, para o objeto "configuration"
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCars(onComplete: @escaping ([Cars]) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let cars = try JSONDecoder().decode([Cars].self, from: data)
                        onComplete(cars)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                    
                } else {
                    print("Algum status inválido pelo servidor!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                print(error!)
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
    }
