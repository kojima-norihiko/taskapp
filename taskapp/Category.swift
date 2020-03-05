//
//  File.swift
//  taskapp
//
//  Created by kojima on 2020/01/22.
//  Copyright © 2020 kojima. All rights reserved.
//
import RealmSwift

class Category: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // カテゴリー
    @objc dynamic var title = ""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
