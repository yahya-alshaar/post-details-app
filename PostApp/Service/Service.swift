//
//  Service.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import Foundation
import CoreData

extension DateFormatter {
    class var standerd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter
    }
}

class Service: NSObject {
    static let shared = Service()
    
    func generateUrl(path: String) -> URL?  {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dev.beconapp.com"
        components.path = "/api/posts/" + path
        
        return components.url
    }
    
    func fetchPostDetails(context: NSManagedObjectContext, completion: @escaping (Error?) -> ()) {
        guard let url = generateUrl(path: "task-posts/detail/") else { return }
        
        guard let token = App.account.token() else { return }
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : "Token \(token)"]
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(err)
                print("Failed to fetch post-details:", err)
                return
            }
            
            // check response
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.standerd)
                decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = context
                
                _ = try decoder.decode(Post.self, from: data)
                
                context.perform {
                    do {
                        try context.save()
                        App.coreDataStack.saveContext()
                    }catch {}
                }
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
            
        }.resume()
    }
}
