import SwiftUI

struct DataAndStorageView: View {
    
    @State private var viewModel: DataAndStorageViewModel = DataAndStorageViewModel()
    
    var body: some View {
        List {
            Section(
                header: Text("Cache Settings"),
                footer: Text("Downloaded items older than this period will be automatically deleted on app launch.")
            ) {
                Picker("Clear data after", selection: $viewModel.selectedExpirationPeriod) {
                    ForEach(CacheExpirationPeriod.allCases) { period in
                        Text(period.title).tag(period)
                    }
                }
            }
            
            Section {
                Picker("Storage engine", selection: $viewModel.selectedStorageEngine) {
                    ForEach(CacheStorageEngine.allCases) { engine in
                        Text(engine.title).tag(engine)
                    }
                }
            }
        }
    }
}

#Preview {
    DataAndStorageView()
}
