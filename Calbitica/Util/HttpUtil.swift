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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        
        return request;
    }

    static func get(url: String) {
        // Get Session obj and create urlObj
        let session = URLSession.shared
        let request = self.makeRequest(url: url, method: "GET")
        
        let task = session.dataTask(with: request) {
            responseData, response, error in
            
            if error != nil || responseData == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData!, options: [])

                // Todo: Return data so that Calbitica can use it
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    static func post(url: String, data: [String: Any]) {
        let session = URLSession.shared
        let request = self.makeRequest(url: url, method: "POST")
        
        // Turn dictionary into Data object
        let jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            
            // Make the actual request
            let task = session.uploadTask(with: request, from: jsonData) {
                responseData, response, error in
                // Do something...
                // Todo: Return data so that Calbitica can use it
                print(responseData);
            }
            
            task.resume()
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }

    static func put(url: String, data: [String: Any]) {

    }

    static func delete(url: String) {

    }
}
