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
	
    
    func readResource(resource : Resources, callback: (data : AnyObject?, error: AnyObject?)->()) -> Void{
        
        
		let request : NSURLRequest = NSURLRequest(URL: NSURL(string: "\(baseUrl)/\(resource.rawValue)")!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if error != nil {
                callback(data: nil, error: error as AnyObject?)
            } else {
                
                if let data = data{
                    
                    let dict = self.convertJsonDataToDictionary(data)
                    
                    callback(data: dict as AnyObject?, error: nil)
                    
                }else{
                    
                    callback(data: nil, error: nil)
                    
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func createResource(resource : Resources, data : Dictionary<String, AnyObject>, callback: (data : AnyObject?, error: AnyObject?)->()) -> Void{
        
        let postData = convertDictionaryToJsonData(data)
        
        //print(convertDataToString(postData!))
        
        var request = NSMutableURLRequest(URL: NSURL(string: "\(baseUrl)/\(resource.rawValue)")!, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 30.0)
        //request.cachePolicy = .ReloadIgnoringCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
        let session = NSURLSession.sharedSession()
        
        let task = session.uploadTaskWithRequest(request as NSURLRequest,
            fromData: postData, completionHandler: {
                (data, response, error) -> Void in
                
                if let data = data{
                    
                    let dict =  self.convertJsonDataToDictionary(data)
                    callback(data: dict as AnyObject?, error: nil)
                    
                    
                }else{
                    
                    callback(data: nil, error: nil)
                    
                }
                
        }) 
        task.resume()
        
    }
    
    func delete(resource : Resources, callback:(data : AnyObject?, error: AnyObject?)->()) -> Void{
        
        
    }
    
    
    func convertDataToString(inputData : NSData) -> NSString?{
        
        let returnString = String(data: inputData, encoding: NSUTF8StringEncoding)
        //print(returnString)
        return returnString as NSString?
        
    }
    
    
    func convertDictionaryToJsonData(inputDict : Dictionary<String, AnyObject>) -> NSData?{
        
        do{
            return try NSJSONSerialization.dataWithJSONObject(inputDict, options:.PrettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    
    func convertJsonDataToDictionary(inputData : NSData) -> Array<[String:AnyObject]>? {
        guard inputData.length  > 1 else{ return nil }  // avoid processing empty responses
        
        do {
            return try NSJSONSerialization.JSONObjectWithData(inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
    func convertJsonStringToDictionary(text: String) -> Array<Dictionary<String, AnyObject>>? {
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? Array<Dictionary<String, AnyObject>>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    
    
    
}
