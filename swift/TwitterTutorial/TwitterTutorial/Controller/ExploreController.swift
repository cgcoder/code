//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by Chandrasekaran, Gopinath on 8/7/23.
//

import UIKit

class ExploreController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        navigationItem.title = "Explore"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
