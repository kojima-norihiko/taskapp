//
//  InputViewController.swift
//  taskapp
//
//  Created by kojima on 2020/01/10.
//  Copyright © 2020 kojima. All rights reserved.
//

import UIKit
import RealmSwift    // 追加する
import UserNotifications    // 追加
import TagListView


class InputViewController: UIViewController ,TagListViewDelegate {
    @IBOutlet weak var texttitle: UITextField!
    @IBOutlet weak var naiyo: UITextView!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var category: UITextField!
    let realm = try! Realm()    // 追加する
    let tagListView = TagListView()
    var task: Task!   // 追加する
    let MARGIN: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapGesture)

            setView()
            var category1 : Category!
            category1 = Category()
            texttitle.text = task.title
            naiyo.text = task.contents
            date.date = task.date
            category1 = task.category
        
        if(category1 != nil ){
            tagListView.addTag(category1.title)
             }
        }

        @objc func dismissKeyboard(){
            // キーボードを閉じる
            view.endEditing(true)
        }
    
    // 追加する
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.texttitle.text!
            self.task.contents = self.naiyo.text
            self.task.date = self.date.date
            self.realm.add(self.task, update: .modified)
        }
        setNotification(task: task)   // 追加
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する --- ここから ---
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default

        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }

        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    } // --- ここまで追加 ---
    
    func setView() {

        view.addSubview(tagListView)

        tagListView.frame = CGRect(x: MARGIN, y: 120, width: view.frame.width-MARGIN*2, height: 0)

        // タグの削除ボタンを有効に
        tagListView.enableRemoveButton = false

        // 今回は削除ボタン押された時の処理を行う
        tagListView.delegate = self

    // タグの見た目を設定
        tagListView.alignment = .left
        tagListView.cornerRadius = 3
       
        tagListView.textColor = UIColor.white
        tagListView.borderColor = UIColor.red
        tagListView.tagBackgroundColor = UIColor.red
        tagListView.borderWidth = 1
        tagListView.paddingX = 10
        tagListView.paddingY = 5
        tagListView.textFont = UIFont.systemFont(ofSize: 16)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let categoryViewController: CategoryViewController = segue.destination as! CategoryViewController

            var category2 :Category!
            var title = ""
            category2 = Category()
            category2 = self.task.category
        if(category2 != nil ){
            title = category2.title
        }
            categoryViewController.titlename = title
            categoryViewController.task1 = task
        }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     tagListView.removeAllTags()
        var category3 :Category!
        category3 = self.task.category
        if(category3 != nil ){
            tagListView.addTag(category3.title)
        }
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
