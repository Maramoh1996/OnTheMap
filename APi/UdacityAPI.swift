//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Maram Moh on 14/07/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import Foundation

class UdacityAPI{
    
    private static var userInfo = UserInfo()
    
    static func postSession(username: String, password: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        print("Attempting to login to Udacity")
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(nil, error)
                return
            }
            if  let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 400 {
                
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
                completionHandler(newData, nil)
            }
            else {
                completionHandler(nil,NSError(domain: "URLError", code: 0, userInfo: nil)
                )
            }
        }
        
        
        task.resume()
    }
    
    static func getUserInfo(completion: @escaping (Error?)->Void){
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        
    }
    
    
    
    static func getLocation(completion: @escaping (LocataionInfo?)->Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1//StudentLocation?limit=100&&skip=400order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var locationsData: LocataionInfo?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    do {
                        locationsData = try JSONDecoder().decode(LocataionInfo.self, from: data!)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(locationsData)
            }
            
        }
        task.resume()
        
      
    }

    static func postLocation(_ LocataionInfo: StudentLocation, completion: @escaping (String?)->Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userInfo.key ?? ".."))\", \"firstName\": \"\(userInfo.firstName ?? "..")\", \"lastName\": \"\(userInfo.lastName ?? "..")\",\"mapString\": \"\(LocataionInfo.mapString ?? "0")\", \"mediaURL\": \"\(LocataionInfo.mediaURL ?? "..")\",\"latitude\": \(LocataionInfo.latitude ?? 1), \"longitude\": \(LocataionInfo.longitude ?? 1)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
 
    
    class func logOut(completion: @escaping (String?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
