//
//  ViewController.swift
//  keyboardTest
//
//  Created by RyoNagai on 2021/06/09.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var testTableView: UITableView!
    var addButtonItem: UIBarButtonItem!//追加
    var deleteButtonItem: UIBarButtonItem!//削除
    var checkList = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.delegate = self
        testTableView.dataSource = self
        
        //画面余白をタップした時の処理
        //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        //        view.addGestureRecognizer(tapGestureRecognizer)
        //追加
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        //削除
        deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.leftBarButtonItem = deleteButtonItem
        loadCheckList()
        
    }
    
    //    @objc func didTapView() {
    //        view.endEditing(true)
    //        //self.view.becomeFirstResponder()
    //    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        //データを入力する
        let newItem = Item(context: self.context)
        newItem.check = false
        checkList.append(newItem)
        //追加するデータに対応するインデックスパスを取得する
        let indexPath = IndexPath(row: checkList.count - 1, section: 0)
        //追加したデータに対応するセルを挿入する
        testTableView.insertRows(at: [indexPath], with: .automatic)
        //追加したセル
        let cell = testTableView.cellForRow(at: indexPath) as? ListTableViewCell
        //追加したセルのテキストフィールドをファーストレスポンダにする
        cell?.testTextField.becomeFirstResponder()
        //print("add:\(checkList)")
    }
    
    @objc func deleteButtonPressed(_ sender: UIBarButtonItem) {
        print("delete")
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ListTableViewCell
        
        cell.delegate = self
        
        cell.testTextField.delegate = self
        
        if checkList.count != 0 {
            cell.testTextField.text = checkList[indexPath.row].text
            cell.checkBoxButton.isSelected = checkList[indexPath.row].check
            //取り消し線の処理
            if checkList[indexPath.row].check {
                let str : NSMutableAttributedString = NSMutableAttributedString(string:checkList[indexPath.row].text ?? "")
                
                str.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, str.length))
                cell.testTextField.attributedText = str
            }
        }
        cell.backgroundColor = .green
        
        return cell
    }
    
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = testTableView.indexPath(for: sender){
            
            checkList[selectedIndexPath.row].check = !checkList[selectedIndexPath.row].check
            
            
            
            testTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //追加するデータに対応するインデックスパスを取得する
        let indexPath = IndexPath(row: checkList.count - 1, section: 0)
        //追加したセル
        let cell = testTableView.cellForRow(at: indexPath) as? ListTableViewCell
        //キーボードを閉じる処理
        cell?.testTextField.resignFirstResponder()
        //セルのデータをcheckListに格納する。
        if cell?.testTextField.text != "" {
            //データを入力する
            self.checkList[indexPath.row].text = cell?.testTextField.text
            print("ここを通る:\(indexPath.row)")
            print(checkList)
            self.saveCheckList()
        }
        
        
        return true
    }
    
    //MARK: - CoreData
    
    func loadCheckList() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            checkList = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
       
        testTableView.reloadData()
        
    }
    
    func saveCheckList() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        testTableView.reloadData()
        
    }
    
    
    
}

