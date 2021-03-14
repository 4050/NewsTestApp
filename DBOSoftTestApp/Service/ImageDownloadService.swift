//
//  ImageUploadService.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 14.03.2021.
//

import Foundation

protocol ImageDownloadProtocol {
    func fetchImage(urlString: String, completion: @escaping (_ data: Data?) -> ())
}

class ImageDownloadService: ImageDownloadProtocol {
    func fetchImage(urlString: String, completion: @escaping (_ data: Data?) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!){ (data, _, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error fetching the image!")
                    completion(nil)
                } else {
                    completion(data)
                }
            }
        }.resume()
    }
}
