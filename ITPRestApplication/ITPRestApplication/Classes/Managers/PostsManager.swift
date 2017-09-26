//
//  PostsManager.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

import Foundation

class PostsManager : ManagerBase {
    
    
    class func readPostsWithHandler(callback: (posts : Array<Post>?, error: AnyObject?)->()){
        
        
        ServerAPIManager.sharedInstance.readResource(ServerAPIManager.Resources.Posts) {
            (data, error) -> () in
            
            if error != nil{
               callback(posts: nil, error: error)
            
            }else{
                var posts : Array<Post> =  [Post]()
                
                if let items = data as? Array<NSDictionary> { 
                    for item in items {
                        let post : Post = Post()
                        post.fromDictionary(item as! Dictionary<String, AnyObject>, withRootNode: "message")
                        posts.append(post)
                        
                    }
                }
                callback(posts: posts, error: nil)
            }
            
        }
        
    }
    
    
    class func createPost(post : Post, withHandler callback: (success : Bool, error: AnyObject?) -> Void){
        
        let postData = post.toDictionary(withRootNode: "message")
        
        // create the resource
        ServerAPIManager.sharedInstance.createResource(ServerAPIManager.Resources.Posts, data: postData) {
            (data, error) -> () in
            
            if error != nil{
                
                callback(success: false, error: error)
                
            }else{
                
                callback(success: true, error: nil)
            }
            
            
        }
        
        
        
    }
    
    
}
