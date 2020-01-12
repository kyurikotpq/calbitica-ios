//
//  HttpUtil.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class HttpUtil {
    
    func get(url: String) {
        // Get Session obj and create urlObj
        let session = URLSession.shared
        let urlObj = URL(string: url)!
        
        var request = URLRequest(url: urlObj)
        
        // Set Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        
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
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func post(url: String, data: Dictionary) {
        let session = URLSession.shared
        let urlObj = URL(string: url)!
        
        // Create a new POST Request
        var request = URLRequest(url: urlObj)
        request.httpMethod = "POST"
        
        // Set Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        
        // Turn dictionary into Data object
        let jsonData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
        
        // Make the actual request
        let task = session.uploadTask(with: request, from: jsonData) {
            responseData, response, error in
            // Do something...
            print(responseData);
        }
        
        task.resume()
    }
}
