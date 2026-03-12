package com.ghostsave.ghost_save

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.ghostsave/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    companion object {
        var methodChannel: MethodChannel? = null

        fun sendNotificationToFlutter(title: String, text: String) {
            val data = mapOf("title" to title, "text" to text)
            // Assurez-vous d'exécuter cela sur le thread principal
            android.os.Handler(android.os.Looper.getMainLooper()).post {
                methodChannel?.invokeMethod("onNotificationReceived", data)
            }
        }
    }
}
