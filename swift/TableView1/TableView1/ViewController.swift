//
//  ViewController.swift
//  TableView1
//
//  Created by Chandrasekaran, Gopinath on 8/7/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countriesTableView: UITableView!
    var countries = ["Germany", "India", "China", "USA"]
    static let cellIdentifier = "MagicCountryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.cellIdentifier)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath)
        let cc = tableViewCell.defaultContentConfiguration()
        
        return tableViewCell
    }
    
    
}
