package com.example.daily_schedule_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class AlarmRingingService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private var currentId: Int = 0
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopAlarm()
            stopSelf()
            return START_NOT_STICKY
        }

        currentId = intent?.getIntExtra(NativeReminderScheduler.EXTRA_ID, 0) ?: 0
        val title = intent?.getStringExtra(NativeReminderScheduler.EXTRA_TITLE) ?: "Alarm Jadwal"
        val body = intent?.getStringExtra(NativeReminderScheduler.EXTRA_BODY) ?: "Waktunya menjalankan jadwal."
        val vibrate = intent?.getBooleanExtra(NativeReminderScheduler.EXTRA_VIBRATE, true) ?: true
        val alarmSound = intent?.getStringExtra(NativeReminderScheduler.EXTRA_ALARM_SOUND) ?: "default"

        acquireWakeLock()
        createChannel(vibrate)
        startForeground(currentId, buildNotification(currentId, title, body, vibrate))
        startSound(alarmSound)
        if (vibrate) startVibration()
        return START_STICKY
    }

    override fun onDestroy() {
        stopAlarm()
        super.onDestroy()
    }

    private fun buildNotification(id: Int, title: String, body: String, vibrate: Boolean) =
        NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(body)
            .setOngoing(true)
            .setAutoCancel(false)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(contentIntent(id), true)
            .setDefaults(if (vibrate) NotificationCompat.DEFAULT_VIBRATE else 0)
            .addAction(0, "Matikan Alarm", stopIntent(id))
            .build()

    private fun contentIntent(id: Int): PendingIntent = PendingIntent.getActivity(
        this,
        id,
        Intent(this, MainActivity::class.java),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    private fun stopIntent(id: Int): PendingIntent {
        val intent = Intent(this, AlarmRingingService::class.java).apply {
            action = ACTION_STOP
            putExtra(NativeReminderScheduler.EXTRA_ID, id)
        }
        return PendingIntent.getService(
            this,
            id + 200000,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun startSound(alarmSound: String) {
        if (mediaPlayer?.isPlaying == true) return
        val alarmUri = soundUri(alarmSound) ?: return
        runCatching {
            mediaPlayer = MediaPlayer().apply {
                setDataSource(applicationContext, alarmUri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                isLooping = true
                prepare()
                start()
            }
        }.onFailure {
            mediaPlayer?.release()
            mediaPlayer = null
        }
    }

    private fun soundUri(alarmSound: String): Uri? {
        val rawId = when (alarmSound) {
            "gentle" -> R.raw.alarm_gentle
            "focus" -> R.raw.alarm_focus
            "strong" -> R.raw.alarm_strong
            else -> 0
        }
        if (rawId != 0) {
            return Uri.parse("android.resource://$packageName/$rawId")
        }
        return RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    }

    private fun startVibration() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        val pattern = longArrayOf(0, 700, 450, 700, 1200)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
        } else {
            @Suppress("DEPRECATION")
            vibrator?.vibrate(pattern, 0)
        }
    }

    private fun stopAlarm() {
        mediaPlayer?.run {
            if (isPlaying) stop()
            release()
        }
        mediaPlayer = null
        vibrator?.cancel()
        vibrator = null
        NotificationManagerCompat.from(this).cancel(currentId)
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
    }

    private fun acquireWakeLock() {
        if (wakeLock?.isHeld == true) return
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "$packageName:ScheduleAlarmWakeLock"
        ).apply {
            setReferenceCounted(false)
            acquire(10 * 60 * 1000L)
        }
    }
    private fun createChannel(vibrate: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Alarm Jadwal Berbunyi",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Alarm jadwal yang berbunyi berulang sampai dimatikan."
                enableVibration(vibrate)
                setSound(null, null)
            }
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }

    companion object {
        private const val CHANNEL_ID = "native_schedule_alarm_ringing_v1"
        private const val ACTION_STOP = "com.example.daily_schedule_app.STOP_ALARM"

        fun start(context: Context, id: Int, title: String, body: String, vibrate: Boolean, alarmSound: String) {
            val intent = Intent(context, AlarmRingingService::class.java).apply {
                putExtra(NativeReminderScheduler.EXTRA_ID, id)
                putExtra(NativeReminderScheduler.EXTRA_TITLE, title)
                putExtra(NativeReminderScheduler.EXTRA_BODY, body)
                putExtra(NativeReminderScheduler.EXTRA_VIBRATE, vibrate)
                putExtra(NativeReminderScheduler.EXTRA_ALARM_SOUND, alarmSound)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context, id: Int) {
            val intent = Intent(context, AlarmRingingService::class.java)
            runCatching { context.stopService(intent) }
            runCatching { NotificationManagerCompat.from(context).cancel(id) }
        }
    }
}




