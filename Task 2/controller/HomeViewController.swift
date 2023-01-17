//
//  HomeViewController.swift
//  Task 2
//
//  Created by Ogabek Matyakubov on 17/01/23.
//

import UIKit
import JGProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var items: Array<Post> = Array()
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
    }
    
    func initViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        apiPostList()
        
    }
    
    func showLoading() {
        if !hud.isVisible {
            hud.textLabel.text = "Loading..."
            hud.show(in: self.view)
        }
    }
    
    func hideProgress() {
        if hud.isVisible {
            hud.dismiss(animated: true)
        }
    }
    
    func reloadTableView(posts: [Post]) {
        self.items = posts
        self.tableView.reloadData()
    }

    // MARK: - ApiCalls
    func apiPostList() {
        showLoading()
        Network.get(url: Network.API_POST_LIST, params: Network.emptyParams(), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                let posts = try! JSONDecoder().decode([Post].self, from: response.data!)
                self.reloadTableView(posts: posts)
            case .failure(let error):
                print(error)
                self.reloadTableView(posts: [])
            }
        })
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.tvTitle.text = item.body
        cell.tvBody.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}
