//
//  ViewController.swift
//  keyboardTest
//
//  Created by RyoNagai on 2021/06/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testTableView: UITableView!
    var addButtonItem: UIBarButtonItem!//追加
    var deleteButtonItem: UIBarButtonItem!//削除
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.delegate = self
        testTableView.dataSource = self
        
        //画面余白をタップした時の処理
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        
        deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.leftBarButtonItem = deleteButtonItem
        
    }
    
    @objc func didTapView() {
        view.endEditing(true)
        //self.view.becomeFirstResponder()
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add")
    }
    
    @objc func deleteButtonPressed(_ sender: UIBarButtonItem) {
        print("delete")
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .green
        
        return cell
    }
    
    
}

