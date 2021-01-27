//
//  DiffCalculator.swift
//  VK_app
//
//  Created by macbook on 24.12.2020.
//

import Foundation

class SectionChanges {
    var insertsInts = [Int]()
    var deletesInts = [Int]()
    var updates = CellChanges()
    
    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }
    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
    
    init(inserts: [Int] = [], deletes: [Int] = [], updates: CellChanges = CellChanges()) {
        self.insertsInts = inserts
        self.deletesInts = deletes
        self.updates = updates
    }
}

class CellChanges {
    var inserts = [IndexPath]()
    var deletes = [IndexPath]()
    var reloads = [IndexPath]()
    
    init(inserts: [IndexPath] = [], deletes: [IndexPath] = [], reloads: [IndexPath] = []) {
        self.inserts = inserts
        self.deletes = deletes
        self.reloads = reloads
    }
}

struct ViewSection: Equatable {
    var sectionTitle: String
    var cells: [ViewCell]
    var index: Int
}

struct ViewCell: Equatable {
    var id: Int
    var index: Int
}

struct ReloadableSectionData{
    var items = [ViewSection]()
    
    subscript(key: String) -> ViewSection? {
        get {
            return items.filter { $0.sectionTitle == key }.first
        }
    }
    
    subscript(index: Int) -> ViewSection? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}

struct ReloadableCellData {
    var items = [ViewCell]()
    
    subscript(key: Int) -> ViewCell? {
        get {
            return items.filter { $0.id == key }.first
        }
    }
}

class RecalculateTable {
    
}
