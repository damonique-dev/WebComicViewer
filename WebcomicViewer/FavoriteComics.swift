//
//  FavoriteComics.swift
//  WebcomicViewer
//
//  Created by Damonique Thomas on 9/21/15.
//  Copyright © 2015 Damonique Thomas. All rights reserved.
//

import Foundation
import CoreData

class FavoriteComics: NSManagedObject {

    @NSManaged var favs: String?
    @NSManaged var title: String?
}
