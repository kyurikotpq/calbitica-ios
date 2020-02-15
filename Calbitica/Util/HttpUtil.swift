//
//  HttpUtil.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class HttpUtil {
    static func makeRequest(url: String, method: String) -> URLRequest {
        // Create URL object
        let urlObj = URL(string: url)!
        
        // Create a new POST Request
        var request = URLRequest(url: urlObj)
        request.httpMethod = method
        
        // Set Headers
        // TODO: don't allow sending if not logged in
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jwt = UserDefaults.standard.string(forKey: "jwt")
        print(jwt)
        if(jwt != nil) {
            request.setValue("Bearer \(jwt!)", forHTTPHeaderField: "Authorization")
        }
        
        return request;
    }
  
    static func get(url: String, closure: @escaping (Data) -> Void) {
        // Get Session obj and create urlObj
        let session = URLSession.shared
        let request = makeRequest(url: url, method: "GET")
        
        let task = session.dataTask(with: request) {
            responseData, response, error in
            
            if error != nil || responseData == nil {
                print("Client error!")
                // TODO: global handler
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                !(200...299).contains(httpResponse.statusCode) {
                // TODO: global handler
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                // TODO: global handler
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: responseData!, options: [])
//
//                print(json)
                if(responseData != nil) {
                    closure(responseData!) // return data to the callback (closure)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    static func post(url: String, data: [String: Any], closure: @escaping (Data) -> Void) {
        let session = URLSession.shared
        let request = makeRequest(url: url, method: "POST")
      
        // Turn dictionary into Data object
        let jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            
            // Make the actual request
            let task = session.uploadTask(with: request, from: jsonData) {
                (responseData, response, error) in
                
                if error != nil || responseData == nil {
                    print("Client error!")
                    // TODO: Global client handler
                    return
                }
                if(responseData != nil) {
//                    let json = String(data: jsonData!, encoding: String.Encoding.utf8)
//                    
//                    print(json);
                    closure(responseData!) // return data to the callback (closure)
                } 
            }
            // send the request
            task.resume()
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }

    static func put(url: String, data: [String: Any], closure: @escaping (Data) -> Void) {
        let session = URLSession.shared
        let request = makeRequest(url: url, method: "PUT")
        
        // Turn dictionary into Data object
        let jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            
            // Make the actual request
            let task = session.uploadTask(with: request, from: jsonData) {
                (responseData, response, error) in
                
                if error != nil || responseData == nil {
                    print("Client error!")
                    // TODO: Global client handler
                    return
                }
                
                if(responseData != nil) {
                    let json = String(data: jsonData!, encoding: String.Encoding.utf8)
                    
                    print(jsonData);
                    closure(responseData!) // return data to the callback (closure)
                }
            }
            // send the request
            task.resume()
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }

    // May need to change the method signature in future if
    // We want to make use of the success messages
    static func delete(url: String, closure: @escaping () -> Void) {
        // Get Session obj and create urlObj
        let session = URLSession.shared
        let request = makeRequest(url: url, method: "DELETE")
        
        let task = session.dataTask(with: request) {
            responseData, response, error in
            
            if error != nil || responseData == nil {
                print("Client error!")
                // TODO: global handler
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                // TODO: global handler
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                // TODO: global handler
                return
            }
            
            if(closure != nil) {
                closure() // run the callback (closure)
            }
        }
        
        task.resume()
    }
}
