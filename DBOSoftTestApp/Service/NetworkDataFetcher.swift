//
//  NetworkDataFetcher.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 13.03.2021.
//


import Foundation

protocol DataFetcher {
    func dataAnswerFetch(urlString: String, completion: @escaping (ResponseModel?, Error?) -> Void)
}

class NetworkDataFetcher: DataFetcher {

    private let networkService: Networking

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func dataAnswerFetch(urlString: String, completion: @escaping (ResponseModel?, Error?) -> Void) {
        networkService.request(urlString: urlString) { (data, error) in
            if let error = error {
                print("L10n.Error.errorReceivedRequestingData", error)
                completion(nil, error)
        }
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let response = try? decoder.decode(ResponseModel.self, from: data)
            completion(response, nil)
        }
    }
}
