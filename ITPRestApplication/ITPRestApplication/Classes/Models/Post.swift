//
//  Post.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

class Post : ModelBase, ModelProtocol {
    var cId : String?
    var cName : String?
    var cMessage : String?
    var cMessageDate : String?

    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objecMapping = [
            "cId":"id",
            "cName":"name",
            "cMessage":"message",
            "cMessageDate":"message_date"
        
        ]
        
        return objecMapping
        
    }
    
}
