import SwiftUI
import WidgetKit

@main
struct ScriptureCardWidgetBundle: WidgetBundle {
    var body: some Widget {
        SCVerseCardWidget()
        SCPlanProgressWidget()
    }
}
