//
//  NetworkService.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 13.03.2021.
//

import Foundation

protocol Networking {
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let urlString = URL(string: urlString) else { return }
        let request = URLRequest(url: urlString)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func createDataTask(from requst: URLRequest,
                                completion: @escaping (Data?, Error?) -> Void)
        -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}
