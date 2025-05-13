package io.otrack.app.otrack

import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, "a7bc637d-4e7e-409f-a511-930f96934a86", Analytics::class.java, Crashes::class.java)
    }
}
