package com.oblivion.barcode

import android.content.Intent
import android.os.Bundle
import android.widget.Toast

import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "com.oblivion.barcode"
        const val KEY_NATIVE = "showNativeView"
        const val KEY_OTHER = "showOther"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == KEY_NATIVE) {
                val intent = Intent(this, NativeAndroidActivity::class.java)
                startActivity(intent)
                result.success(true)
            } else if (call.method == KEY_OTHER) {
                Toast.makeText(this, "Other activity", Toast.LENGTH_SHORT).show()
            } else {
                result.notImplemented()
            }
        }
    }
}