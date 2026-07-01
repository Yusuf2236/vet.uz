package uz.vetuz.vetuz

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // ⚠️ Yandex MapKit API kalitini shu yerga qo'ying.
        // Oling: https://developer.tech.yandex.ru → MapKit Mobile SDK (bepul).
        MapKitFactory.setApiKey("YANDEX_MAPKIT_API_KEY")
        super.configureFlutterEngine(flutterEngine)
    }
}
