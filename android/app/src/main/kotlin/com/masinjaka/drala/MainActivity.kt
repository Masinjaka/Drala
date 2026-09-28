package com.masinjaka.drala

import android.content.Context
import android.content.res.Configuration
import android.util.DisplayMetrics
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun attachBaseContext(newBase: Context) {
        val configuration = Configuration(newBase.resources.configuration)
        configuration.densityDpi = DisplayMetrics.DENSITY_DEVICE_STABLE
        super.attachBaseContext(newBase.createConfigurationContext(configuration))
    }
}
