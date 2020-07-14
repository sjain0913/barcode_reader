package com.oblivion.barcode

import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.dynamsoft.barcode.Barcode
import com.dynamsoft.barcode.BarcodeReader
import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.io.File


class MainActivity : FlutterActivity() {

    private val TAG = "BarcodeReaderActivity"
    companion object {
        const val CHANNEL = "com.oblivion.barcode"
        const val KEY_NATIVE = "showNativeView"
        const val KEY_OTHER = "showOther"
        const val KEY_READ = "read"
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
            } else if (call.method == KEY_READ) {
                val message: String? = call.argument<String>("barcode")
                //Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                Toast.makeText(this, onGetBarcode(message), Toast.LENGTH_SHORT).show()
                //return@setMethodCallHandler
                // /storage/emulated/0/Download/qr.png
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        if (flutterView != null) {
            flutterView.destroy()
        }
        super.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        flutterView.onPause()
    }

    override fun onPostResume() {
        super.onPostResume()
        flutterView.onPostResume()
    }

    private fun onGetBarcode(address: String?): String? {
        Log.e(address, address)
        var locationProvider: String
        var barcodeResult = "No barcode detected"
        val file = File(address)
        if (!file.exists()) {
            barcodeResult = "No file exists: " + file.toString()
            Toast.makeText(this@MainActivity, barcodeResult, Toast.LENGTH_LONG).show()
            return null
        } else {
            val bitmap = BitmapFactory.decodeFile(file.toString())
            val reader = BarcodeReader("license")
            val result = reader.readSingle(bitmap, Barcode.QR_CODE)
            val all = result.barcodes
            barcodeResult = if (all != null && all.size == 1) {
                all[0].displayValue
            } else {
                "no barcode found: " + file.toString()
            }
            bitmap.recycle()
        }
        val reply = JSONObject()
        try {
            if (barcodeResult != null) {
                reply.put("result", barcodeResult)
            } else {
                reply.put("result", "No barcode detected")
            }
        } catch (e: JSONException) {
            Log.e(TAG, "JSON exception", e)
            return null
        }
        return reply.toString()
    }

}