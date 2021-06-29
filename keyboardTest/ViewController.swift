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
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    var display = false//キーボード表示
    
    
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
        
        //キーボード表示の監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        //testTableView.tableFooterView = UIView()
        print("キーボード：\(display)")
        loadCheckList()
        
    }
    
    //    @objc func didTapView() {
    //        view.endEditing(true)
    //        //self.view.becomeFirstResponder()
    //    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        //ボタンを完了に変更する。
        addButtonItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
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
        //ボタンを非活性にする。
        //addButtonItem.isEnabled = false
        print("addButton:\(testTableView.isEditing)")
        print("addButton2:\(String(describing: cell?.testTextField.becomeFirstResponder()))")
        print("キーボードadd：\(display)")
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem){
        print("完了")
        //追加するデータに対応するインデックスパスを取得する
        let indexPath = IndexPath(row: checkList.count - 1, section: 0)
        //追加したセル
        let cell = testTableView.cellForRow(at: indexPath) as? ListTableViewCell
        //キーボードを閉じる処理
        //cell?.testTextField.resignFirstResponder()
        print("完了：\(indexPath.row)")
        //セルのデータをcheckListに格納する。
//        if cell?.testTextField.text != "" {
//            //データを入力する
//            self.checkList[indexPath.row].text = cell?.testTextField.text
//            self.saveCheckList()
//        } else {
//            let item = checkList[indexPath.row]
//            context.delete(item)
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            do {
//                checkList = try context.fetch(Item.fetchRequest())
//            }
//            catch{
//                print("Error delete \(error)")
//            }
//            loadCheckList()
//        }
        //cell?.testTextField.resignFirstResponder()
        view.endEditing(true)
        //追加に変更
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "すべて削除しますか？", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "削除", style: .default) { [self] (yes) in
            do {
            let data = try context.fetch(request)
            
            
            for task in data {
                
                context.delete(task)
            }
            self.saveCheckList()
            
            
        }
        catch{
            print("読み込み失敗！")
        }
            
            print("削除")
            self.loadCheckList()
        }
        
        let no = UIAlertAction(title: "キャンセル", style: .default) { (no) in
            print("キャンセル")
        }
        
        
        
        
        alert.addAction(yes)
        alert.addAction(no)
        
        //画面にアラートを出す。
        present(alert, animated: true, completion: nil)
        print("delete")
    }
    
    @objc func keyboardDidAppear() {
        display = true
    }
    @objc func keyboardDidDisappear() {
        display = false
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
        
        //if checkList.count != 0 {
            cell.testTextField.text = checkList[indexPath.row].text
            cell.checkBoxButton.isSelected = checkList[indexPath.row].check
            
            //取り消し線の処理
            if checkList[indexPath.row].check {
                let str : NSMutableAttributedString = NSMutableAttributedString(string:checkList[indexPath.row].text ?? "")
                
                str.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, str.length))
                cell.testTextField.attributedText = str
            }
       // }
        
        return cell
    }
    
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = testTableView.indexPath(for: sender){
            
            checkList[selectedIndexPath.row].check = !checkList[selectedIndexPath.row].check
            
            testTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
            self.saveCheckList()
            
        }
    }
    
    //編集したセルのテキストフィールドを保存
    func editTextField(sender: ListTableViewCell) {
        if let selectedIndexPath = testTableView.indexPath(for: sender){
            print("リターンキー：\(selectedIndexPath)")
            //キーボードを閉じる処理
            //sender.testTextField.resignFirstResponder()
            //sender.testTextField.becomeFirstResponder()
            //セルのデータをcheckListに格納する。
            if sender.testTextField.text != ""{
            checkList[selectedIndexPath.row].text = sender.testTextField.text
            //testTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let item = checkList[selectedIndexPath.row]
                context.delete(item)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                do {
                    checkList = try context.fetch(Item.fetchRequest())
                }
                catch{
                    print("Error delete \(error)")
                }
                //空欄になったセルのデータをリロードする。
                testTableView.deleteRows(at: [selectedIndexPath], with: .automatic)
            }
            
            
            self.saveCheckList()
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        for num in 0...checkList.count - 1{
//        //追加するデータに対応するインデックスパスを取得する
//        let indexPath = IndexPath(row: num, section: 0)
//        //let indexPath = IndexPath(row: 0, section: 0)
//        //追加したセル
//        let cell = testTableView.cellForRow(at: indexPath) as? ListTableViewCell
//
//        //セルのデータをcheckListに格納する。
//        if cell?.testTextField.text != "" {
//            //データを入力する
//            self.checkList[indexPath.row].text = cell?.testTextField.text
//        } else {
//            let item = checkList[indexPath.row]
//            context.delete(item)
//
//        }
//
//        }
//        self.loadCheckList()
//        self.saveCheckList()
        //キーボードを閉じる処理
        //cell?.testTextField.resignFirstResponder()
        //view.endEditing(true)
        
        
        //追加に変更
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
        return true
    }
    
    //MARK: - CoreData
    
    func loadCheckList() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            checkList = try context.fetch(request)
        } catch {
            print("Error loading checklist \(error)")
        }
       
        //testTableView.reloadData()
        
    }
    
    func saveCheckList() {
        do {
            try context.save()
        } catch {
            print("Error saving Item \(error)")
        }
        
        //testTableView.reloadData()
        
    }
    
    //MARK: - Delete cell CoreData
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete{
            let task = checkList[indexPath.row]
            context.delete(task)
            //(UIApplication.shared.delegate as! AppDelegate).saveContext()
            //self.saveCheckList()
            do {
                checkList = try context.fetch(Item.fetchRequest())
            }
            catch{
                print("Error delete \(error)")
            }
        }
        //追加に変更
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
        //loadCheckList()
        testTableView.reloadData()
        
    }
    
    //MARK: - 編集中のセルを削除させないようにする。（下のセル）
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //indexPath.row == checkList.count - 1  ? .none : .delete
        if indexPath.row == checkList.count - 1 && display {
            return .none
        } else {
            return .delete
        }

        }
    
    
    
    
    
}

