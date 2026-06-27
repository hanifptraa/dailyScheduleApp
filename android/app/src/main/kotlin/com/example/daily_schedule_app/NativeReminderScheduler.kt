package com.example.daily_schedule_app

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import org.json.JSONObject

object NativeReminderScheduler {
    const val EXTRA_ID = "id"
    const val EXTRA_TITLE = "title"
    const val EXTRA_BODY = "body"
    const val EXTRA_RING = "ring"
    const val EXTRA_VIBRATE = "vibrate"
    const val EXTRA_ALARM_SOUND = "alarmSound"
    const val ACTION_REMINDER = "com.example.daily_schedule_app.ACTION_REMINDER"

    private const val PREFS_NAME = "native_reminders"
    private const val PREF_IDS = "ids"
    private const val PREF_REMINDERS = "reminders"
    private const val PREF_BACKGROUND_PERMISSION_REQUESTED = "background_permission_requested"
    private const val MISSED_REMINDER_GRACE_MS = 24 * 60 * 60 * 1000L

    private data class ReminderData(
        val id: Int,
        val title: String,
        val body: String,
        val triggerAtMillis: Long,
        val ring: Boolean,
        val vibrate: Boolean,
        val alarmSound: String
    )

    fun canScheduleExact(context: Context): Boolean {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager.canScheduleExactAlarms()
    }

    fun requestExactAlarmPermission(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !canScheduleExact(context)) {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.parse("package:${context.packageName}")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            runCatching { context.startActivity(intent) }
        }
    }

    fun isIgnoringBatteryOptimizations(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isIgnoringBatteryOptimizations(context.packageName)
    }

    fun canUseFullScreenIntent(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return true
        val notificationManager = context.getSystemService(NotificationManager::class.java)
        return notificationManager.canUseFullScreenIntent()
    }

    fun hasBackgroundStartPermission(context: Context): Boolean {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getBoolean(PREF_BACKGROUND_PERMISSION_REQUESTED, false)
    }
    fun requestIgnoreBatteryOptimizations(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || isIgnoringBatteryOptimizations(context)) return
        val packageUri = Uri.parse("package:${context.packageName}")
        val requestIntent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
            data = packageUri
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        val settingsIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        runCatching { context.startActivity(requestIntent) }
            .onFailure { runCatching { context.startActivity(settingsIntent) } }
    }

    fun requestBackgroundStartPermission(context: Context) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(PREF_BACKGROUND_PERMISSION_REQUESTED, true)
            .apply()
        val manufacturer = Build.MANUFACTURER.lowercase()
        val intents = mutableListOf<Intent>()
        when {
            manufacturer.contains("xiaomi") || manufacturer.contains("redmi") || manufacturer.contains("poco") -> {
                intents += Intent().setComponent(ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity"))
                intents += Intent().setComponent(ComponentName("com.miui.powerkeeper", "com.miui.powerkeeper.ui.HiddenAppsConfigActivity")).apply {
                    putExtra("package_name", context.packageName)
                    putExtra("package_label", "Daily Schedule")
                }
            }
            manufacturer.contains("oppo") || manufacturer.contains("realme") || manufacturer.contains("oneplus") -> {
                intents += Intent().setComponent(ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity"))
                intents += Intent().setComponent(ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity"))
            }
            manufacturer.contains("vivo") || manufacturer.contains("iqoo") -> {
                intents += Intent().setComponent(ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity"))
                intents += Intent().setComponent(ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"))
            }
            manufacturer.contains("huawei") || manufacturer.contains("honor") -> {
                intents += Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"))
            }
            manufacturer.contains("samsung") -> {
                intents += Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
            }
        }
        intents += Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:${context.packageName}")
        }
        intents.firstOrNull { intent ->
            runCatching {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            }.isSuccess
        }
    }

    fun schedule(
        context: Context,
        id: Int,
        title: String,
        body: String,
        triggerAtMillis: Long,
        ring: Boolean,
        vibrate: Boolean,
        alarmSound: String
    ): Boolean {
        if (triggerAtMillis <= System.currentTimeMillis()) return false
        if (!canScheduleExact(context)) return false

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        cancel(context, id)

        val receiverIntent = Intent(context, ReminderReceiver::class.java).apply {
            action = ACTION_REMINDER
            setPackage(context.packageName)
            addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
            putExtra(EXTRA_ID, id)
            putExtra(EXTRA_TITLE, title)
            putExtra(EXTRA_BODY, body)
            putExtra(EXTRA_RING, ring)
            putExtra(EXTRA_VIBRATE, vibrate)
            putExtra(EXTRA_ALARM_SOUND, alarmSound)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            receiverIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val showIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val showPendingIntent = PendingIntent.getActivity(
            context,
            id,
            showIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val scheduled = runCatching {
            alarmManager.setAlarmClock(
                AlarmManager.AlarmClockInfo(triggerAtMillis, showPendingIntent),
                pendingIntent
            )
        }.recoverCatching {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            }
        }.isSuccess
        if (!scheduled) return false

        rememberReminder(context, ReminderData(id, title, body, triggerAtMillis, ring, vibrate, alarmSound))
        return true
    }

    fun cancel(context: Context, id: Int) {
        val intent = Intent(context, ReminderReceiver::class.java).apply {
            action = ACTION_REMINDER
            setPackage(context.packageName)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (pendingIntent != null) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
        }
        forgetReminder(context, id)
        AlarmRingingService.stop(context, id)
    }

    fun complete(context: Context, id: Int) {
        forgetReminder(context, id)
    }

    fun cancelAll(context: Context) {
        val ids = storedReminders(context).map { it.id }.toSet() + storedIds(context)
        ids.forEach { cancel(context, it) }
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .remove(PREF_IDS)
            .remove(PREF_REMINDERS)
            .apply()
    }

    fun rescheduleStored(context: Context) {
        val now = System.currentTimeMillis()
        val reminders = storedReminders(context)
        reminders.forEach { reminder ->
            when {
                reminder.triggerAtMillis > now -> schedule(
                    context,
                    reminder.id,
                    reminder.title,
                    reminder.body,
                    reminder.triggerAtMillis,
                    reminder.ring,
                    reminder.vibrate,
                    reminder.alarmSound
                )
                now - reminder.triggerAtMillis <= MISSED_REMINDER_GRACE_MS -> {
                    fireReminderNow(context, reminder)
                    forgetReminder(context, reminder.id)
                }
                else -> forgetReminder(context, reminder.id)
            }
        }
    }

    private fun fireReminderNow(context: Context, reminder: ReminderData) {
        val receiverIntent = Intent(context, ReminderReceiver::class.java).apply {
            action = ACTION_REMINDER
            setPackage(context.packageName)
            addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
            putExtra(EXTRA_ID, reminder.id)
            putExtra(EXTRA_TITLE, reminder.title)
            putExtra(EXTRA_BODY, "Terlewat saat HP mati: ${reminder.body}")
            putExtra(EXTRA_RING, reminder.ring)
            putExtra(EXTRA_VIBRATE, reminder.vibrate)
            putExtra(EXTRA_ALARM_SOUND, reminder.alarmSound)
        }
        context.sendBroadcast(receiverIntent)
    }

    private fun rememberReminder(context: Context, reminder: ReminderData) {
        val reminders = storedReminders(context)
            .filter { it.id != reminder.id }
            .plus(reminder)
        saveReminders(context, reminders)
        rememberId(context, reminder.id)
    }

    private fun forgetReminder(context: Context, id: Int) {
        val reminders = storedReminders(context).filter { it.id != id }
        saveReminders(context, reminders)
        forgetId(context, id)
    }

    private fun rememberId(context: Context, id: Int) {
        val ids = storedIds(context).toMutableSet()
        ids.add(id)
        saveIds(context, ids)
    }

    private fun forgetId(context: Context, id: Int) {
        val ids = storedIds(context).toMutableSet()
        if (ids.remove(id)) saveIds(context, ids)
    }

    private fun storedIds(context: Context): Set<Int> {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getStringSet(PREF_IDS, emptySet())
            ?.mapNotNull { it.toIntOrNull() }
            ?.toSet()
            ?: emptySet()
    }

    private fun saveIds(context: Context, ids: Set<Int>) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putStringSet(PREF_IDS, ids.map { it.toString() }.toSet())
            .apply()
    }

    private fun storedReminders(context: Context): List<ReminderData> {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getStringSet(PREF_REMINDERS, emptySet())
            ?.mapNotNull { raw ->
                runCatching {
                    val json = JSONObject(raw)
                    ReminderData(
                        id = json.getInt("id"),
                        title = json.getString("title"),
                        body = json.getString("body"),
                        triggerAtMillis = json.getLong("triggerAtMillis"),
                        ring = json.getBoolean("ring"),
                        vibrate = json.getBoolean("vibrate"),
                        alarmSound = json.optString("alarmSound", "default")
                    )
                }.getOrNull()
            }
            ?: emptyList()
    }

    private fun saveReminders(context: Context, reminders: List<ReminderData>) {
        val encoded = reminders.map { reminder ->
            JSONObject()
                .put("id", reminder.id)
                .put("title", reminder.title)
                .put("body", reminder.body)
                .put("triggerAtMillis", reminder.triggerAtMillis)
                .put("ring", reminder.ring)
                .put("vibrate", reminder.vibrate)
                .put("alarmSound", reminder.alarmSound)
                .toString()
        }.toSet()
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putStringSet(PREF_REMINDERS, encoded)
            .apply()
    }
}



