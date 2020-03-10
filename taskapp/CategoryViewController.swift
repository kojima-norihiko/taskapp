//
//  TaskViewController.swift
//  taskapp
//
//  Created by kojima on 2020/01/22.
//  Copyright © 2020 kojima. All rights reserved.
//

import UIKit
import TagListView
import RealmSwift

class CategoryViewController: UIViewController, TagListViewDelegate , UITextFieldDelegate {
    
    let MARGIN: CGFloat = 10

        let tagListView = TagListView()
        let textField = UITextField()
        let realm = try! Realm()  // ←追加
        let caAray = try! Realm().objects(Category.self)
        var titlename :String = ""
        var task1 = Task()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setView()
            print(titlename)
            //Categoryに保存されている内容を全表示する。
            for ctg in caAray {
                tagListView.addTag(ctg.title)
                print(caAray)
            }
                updateLayout()
        }
    
        func setView() {

            view.addSubview(tagListView)
            view.addSubview(textField)

            tagListView.frame = CGRect(x: MARGIN, y: 100, width: view.frame.width-MARGIN*2, height: 0)

            // タグの削除ボタンを有効に
            tagListView.enableRemoveButton = true

            // 今回は削除ボタン押された時の処理を行う
            tagListView.delegate = self

        // タグの見た目を設定
            tagListView.alignment = .left
            tagListView.cornerRadius = 3
           
            tagListView.textColor = UIColor.black
            tagListView.borderColor = UIColor.lightGray
            tagListView.tagSelectedBackgroundColor = UIColor.red
            tagListView.borderWidth = 1
            tagListView.paddingX = 10
            tagListView.paddingY = 5
            tagListView.textFont = UIFont.systemFont(ofSize: 16)
            tagListView.tagBackgroundColor = UIColor.white

            // タグ削除ボタンの見た目を設定
            tagListView.removeButtonIconSize = 10
            tagListView.removeIconLineColor = UIColor.black

            // テキストフィールドは適当にセット
            textField.delegate = self
            textField.placeholder = "作成するcategoryを入力してください"
            textField.returnKeyType = UIReturnKeyType.done

            // レイアウト調整
        updateLayout()
        }

        // テキストフィールドの完了ボタンが押されたら
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if 0 < textField.text!.count {
                // タグを追加
                tagListView.addTag(textField.text!)

                try! realm.write {
                    //let caAray = try! Realm().objects(Category.self)
                    
                    var category1: Category!
                    category1 = Category()
                    category1.title = textField.text!
                    print(category1.title)
                    if caAray.count != 0 {
                        category1.id = caAray.max(ofProperty: "id")! + 1
                    }
                    //self.realm.add(category1, update: .modified)
                    self.realm.add(category1, update: .modified)
                }
                 
                // テキストフィールドをクリアしてレイアウト調整
                textField.text = nil
                updateLayout()
            }
            return true
        }

        // タグ削除ボタンが押された
        func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        // リストからタグ削除
            print(tagView)
            sender.removeTagView(tagView)
            try! realm.write {
                //let caAray = try! Realm().objects(Category.self)
                var category2 : Category!
                category2 = Category()
                let category3 = try! Realm().objects(Category.self).filter( "title == %@", title )
                
                category2 = category3[0]
                print(category2.title)
                self.realm.delete(category2)
                task1.category = nil
            }
            updateLayout()
        }
    
     // MARK:TagListViewDelegate
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        
        // loop over all tags and set selected to false
        sender.tagViews.forEach {$0.isSelected = false}
        tagView.isSelected = !tagView.isSelected
        try! realm.write {
            var category4 : Category!
            category4 = Category()
            let category5 = try! Realm().objects(Category.self).filter( "title == %@", title )
            
            category4 = category5[0]
            print(category4.title)
            task1.category = category4
        }
    }
        
    func updateLayout() {
            // タグ全体の高さを取得
            tagListView.frame.size = tagListView.intrinsicContentSize
            textField.frame = CGRect(x: MARGIN, y: tagListView.frame.origin.y + tagListView.frame.height + 5, width: view.frame.width-MARGIN*2, height: 40)
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
