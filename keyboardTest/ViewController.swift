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
    var numberCells: Int = 0//セルの数
    var checkBox: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.delegate = self
        testTableView.dataSource = self
        
        //画面余白をタップした時の処理
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        //追加
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        //削除
        deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.leftBarButtonItem = deleteButtonItem
        
    }
    
    @objc func didTapView() {
        view.endEditing(true)
        //self.view.becomeFirstResponder()
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        numberCells += 1
        //追加するデータに対応するインデックスパスを取得する
        let indexPath = IndexPath(row: numberCells - 1, section: 0)
        //追加したデータに対応するセルを挿入する
        testTableView.insertRows(at: [indexPath], with: .automatic)
        //追加したセル
        let cell = testTableView.cellForRow(at: indexPath) as? ListTableViewCell
        //追加したセルのテキストフィールドをファーストレスポンダにする
        cell?.testTextField.becomeFirstResponder()
        print("add:\(numberCells)")
    }
    
    @objc func deleteButtonPressed(_ sender: UIBarButtonItem) {
        print("delete")
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .green
        
        return cell
    }
    
    
}

