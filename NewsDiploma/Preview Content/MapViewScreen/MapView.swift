//
//  MapView.swift
//  NewsDiploma
//
//  Created by Alena  on 23.03.25.
//

import SwiftUI
import MapKit
//import Combine

struct MapContainerView: View {
    
  var body: some View {
      Map {
          //        Marker(<#T##title: StringProtocol##StringProtocol#>, coordinate: <#T##CLLocationCoordinate2D#>)
      }
  }
}


#Preview {
    NavigationStack {
        
        MapContainerView()
    }
}
