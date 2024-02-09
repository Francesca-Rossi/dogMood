//
//  SexView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import SwiftUI

struct SexView: View {
    @Binding var sex: String
    var body: some View {
        HStack
        {
            Label("Gender", systemImage: "smiley")
            Picker(selection: $sex, label: Text("")) {
                Text(sexType.Girl).tag(sexType.Girl)
                Text(sexType.Boy).tag(sexType.Boy)
            }.pickerStyle(.segmented)
        }
    }
}

struct SexViewExample : View {
    @State
    private var value = "Male"
    
    var body: some View {
        SexView(sex: $value)
    }
}

#if DEBUG
struct SexViewExample_Previews : PreviewProvider {
    static var previews: some View {
        SexViewExample()
    }
}
#endif

/*struct SexView_Previews: PreviewProvider {
    static var previews: some View {
        SexView(sex: "")
    }
}*/
