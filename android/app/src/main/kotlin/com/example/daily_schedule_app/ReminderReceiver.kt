package com.example.daily_schedule_app

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val pendingResult = goAsync()
        runCatching {
            val id = intent.getIntExtra(NativeReminderScheduler.EXTRA_ID, 0)
            val title = intent.getStringExtra(NativeReminderScheduler.EXTRA_TITLE) ?: "Pengingat Jadwal"
            val body = intent.getStringExtra(NativeReminderScheduler.EXTRA_BODY) ?: "Waktunya menjalankan jadwal."
            val ring = intent.getBooleanExtra(NativeReminderScheduler.EXTRA_RING, false)
            val vibrate = intent.getBooleanExtra(NativeReminderScheduler.EXTRA_VIBRATE, true)
            val alarmSound = intent.getStringExtra(NativeReminderScheduler.EXTRA_ALARM_SOUND) ?: "default"

            if (ring) {
                AlarmRingingService.start(context, id, title, body, vibrate, alarmSound)
            } else {
                showReminderNotification(context, id, title, body, vibrate)
            }
            NativeReminderScheduler.complete(context, id)
        }.also {
            pendingResult.finish()
        }
    }

    private fun showReminderNotification(
        context: Context,
        id: Int,
        title: String,
        body: String,
        vibrate: Boolean
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        val channelId = "native_schedule_reminders"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Pengingat Jadwal",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Notifikasi pengingat jadwal."
                enableVibration(vibrate)
            }
            context.getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }

        val contentIntent = PendingIntent.getActivity(
            context,
            id,
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(body)
            .setContentIntent(contentIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setDefaults(NotificationCompat.DEFAULT_SOUND or if (vibrate) NotificationCompat.DEFAULT_VIBRATE else 0)
            .build()

        runCatching {
            NotificationManagerCompat.from(context).notify(id, notification)
        }
    }
}




