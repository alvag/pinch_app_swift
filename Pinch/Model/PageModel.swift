//
//  PageModel.swift
//  Pinch
//
//  Created by Max Alva on 12/06/23.
//

import Foundation

struct Page: Identifiable {
  let id: Int
  let imageName: String
}

extension Page {
  var thumbnailName: String {
    return "thumb-" + imageName
  }
}
