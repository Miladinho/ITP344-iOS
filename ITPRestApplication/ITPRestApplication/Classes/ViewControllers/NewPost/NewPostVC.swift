//
//  NewPostVC.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

import UIKit

class NewPostVC: ViewControllerBase {
    
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var message: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonTouched(sender: AnyObject) {
        
        // get and format the current date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let formatedDate = dateFormatter.stringFromDate(NSDate())
        
        let post : Post = Post()
        post.cName = self.name.text
        post.cMessage = self.message.text
        post.cMessageDate = formatedDate
        
        PostsManager.createPost(post) {
            (success, error) -> Void in
            
            print(success)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }

    @IBAction func cancelButtonTouched(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }


}
