package com.ghostsave.ghost_save

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class NotificationReceiver : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        if (packageName == "com.whatsapp" || packageName == "com.whatsapp.w4b") {
            val extras = sbn.notification.extras
            val title = extras.getString(Notification.EXTRA_TITLE)
            val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()

            Log.d("NotificationReceiver", "WhatsApp Notification: Title=$title, Text=$text")

            if (title != null && text != null) {
                // Envoyer les données à Flutter via MethodChannel
                MainActivity.sendNotificationToFlutter(title, text)
            }
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Optionnel : gérer la suppression de notification
    }
}
