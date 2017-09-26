//
//  ServerAPIManager.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

import Foundation

class ServerAPIManager : ManagerBase{
	
	static var instance : ServerAPIManager!
    
//    private static var __once: () = {
//            instance = ServerAPIManager()
//        }()
    
    let baseUrl = "http://freezing-cloud-6077.herokuapp.com"
    
    enum Resources : String {
        case Posts = "messages.json", Resource2 = "resource2", Resource3 = "resource3"
        
    }
    
    
    // check out differnt options for singleton patterns,  http://krakendev.io/blog/the-right-way-to-write-a-singleton
	static let sharedInstance = ServerAPIManager()
	
//    class var sharedInstance: ServerAPIManager {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: ServerAPIManager? = nil
//        }
//        _ = ServerAPIManager.__once
//        return Static.instance!
//    }
	
    
    func readResource(_ resource : Resources, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        
		let request : URLRequest = URLRequest(url: URL(string: "\(baseUrl)/\(resource.rawValue)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in

            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                //test
                print("PRINTING DATA")
                
                
                if let data = data{
                    
                    let dict = self.convertJsonDataToDictionary(data)
                    //print(dict)
                    callback(dict as AnyObject?, nil)
                    
                }else{
                    
                    callback(nil, nil)
                    
                }
                
            }
            
        })
        task.resume()
        
    }
    
    func createResource(_ resource : Resources, data : Dictionary<String, AnyObject>, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        let postData = convertDictionaryToJsonData(data)
        
        //print(convertDataToString(postData!))
        
        var request = URLRequest(url: URL(string: "\(baseUrl)/\(resource.rawValue)")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request as URLRequest,
            from: postData, completionHandler: {
                (data, response, error) -> Void in
                
                if let data = data{
                    
                    let dict =  self.convertJsonDataToDictionary(data)
                    callback(dict as AnyObject?, nil)
                    
                    
                }else{
                    
                    callback(nil, nil)
                    
                }
                
        }) 
        task.resume()
        
    }
    
    func deleteResource(_ postId : Int, callback:@escaping (_ success : Bool, _ error: AnyObject?)->()) -> Void{
        
        print("deleting from server api")
        let deleteString = "\(baseUrl)/messages/\(postId)"
        print("Delete String = \(deleteString)")
        
        var request = URLRequest(url: URL(string: deleteString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            //print(httpResponse.statusCode)
            
            if httpResponse.statusCode <= 204 { // 204 No Content - not good data or errors
                print("Succeeded with status code \(httpResponse.statusCode)")
                callback(true,nil)
            }else{
                print("Failed Request with status code \(httpResponse.statusCode)")
                callback(false, nil)
                
            }
            
        })
        
        task.resume()
        
    }
    
    
    func convertDataToString(_ inputData : Data) -> NSString?{
        
        let returnString = String(data: inputData, encoding: String.Encoding.utf8)
        //print(returnString)
        return returnString as NSString?
        
    }
    
    
    func convertDictionaryToJsonData(_ inputDict : Dictionary<String, AnyObject>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }  // avoid processing empty responses
        
        do {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
    func convertJsonStringToDictionary(_ text: String) -> Array<Dictionary<String, AnyObject>>? {
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String, AnyObject>>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    
    
    
}
