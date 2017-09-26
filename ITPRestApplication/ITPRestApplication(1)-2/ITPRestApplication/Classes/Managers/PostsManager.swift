//
//  PostsManager.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

import Foundation

class PostsManager : ManagerBase {
    
    
    class func readPostsWithHandler(_ callback:@escaping (_ posts : Array<Post>?, _ error: AnyObject?)->()){
        
        
        ServerAPIManager.sharedInstance.readResource(ServerAPIManager.Resources.Posts) {
            (data, error) -> () in
            
            if error != nil{
               callback(nil, error)
            
            }else{
                var posts : Array<Post> =  [Post]()
                print(data)
                if let items = data as? Array<NSDictionary> { 
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String, AnyObject>, withRootNode: "message")
                        posts.append(post)
                        
                    }
                }
                callback(posts, nil)
            }
            
        }
        
    }
    
    
    class func createPost(_ post : Post, withHandler callback: @escaping (_ success : Bool, _ error: AnyObject?) -> Void){
        
        let postData = post.toDictionary(withRootNode: "message")
        
        // create the resource
        ServerAPIManager.sharedInstance.createResource(ServerAPIManager.Resources.Posts, data: postData) {
            (data, error) -> () in
            
            if error != nil{
                
                callback(false, error)
                
            }else{
                
                callback(true, nil)
            }
            
            
        }
        
    }
    
    class func deletePost(_ post: Post, withHandler callback:@escaping (_ success : Bool, _ error : AnyObject?) -> Void){
        print("Post id = \(post.cId)")
        
        ServerAPIManager.sharedInstance.deleteResource((post.cId?.intValue)!, callback: {
            (success,error) -> () in
            
            if success {
            
            callback(true, error)
            
            }else{
            
            callback(false, nil)
            }
        })
    }
    
    
}
