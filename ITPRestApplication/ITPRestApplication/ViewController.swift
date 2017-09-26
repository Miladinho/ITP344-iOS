//
//  ViewController.swift
//  ITPRestApplication
//
//  Created by Demo on 1/28/16.
//

import UIKit

class ViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts : Array<Post>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        releadTableData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Tableview Related
    
    func releadTableData(){
        PostsManager.readPostsWithHandler{
            (posts : Array<Post>?, error: AnyObject?) in
            
            self.posts = posts
            
            dispatch_async(dispatch_get_main_queue(),{
                () -> Void in
                
                self.tableView.reloadData()
                
            })
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
            
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "postsTableViewCell"
        
        let cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let post : Post = self.posts[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = post.cName
        cell.detailTextLabel?.text = post.cMessage
        print(post.cId)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}

