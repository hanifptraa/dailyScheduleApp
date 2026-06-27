package com.example.daily_schedule_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "daily_schedule/native_reminders"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "canScheduleExact" -> result.success(NativeReminderScheduler.canScheduleExact(this))
                "requestExactAlarmPermission" -> {
                    NativeReminderScheduler.requestExactAlarmPermission(this)
                    result.success(true)
                }
                "isIgnoringBatteryOptimizations" -> result.success(NativeReminderScheduler.isIgnoringBatteryOptimizations(this))
                "canUseFullScreenIntent" -> result.success(NativeReminderScheduler.canUseFullScreenIntent(this))
                "hasBackgroundStartPermission" -> result.success(NativeReminderScheduler.hasBackgroundStartPermission(this))
                "requestIgnoreBatteryOptimizations" -> {
                    NativeReminderScheduler.requestIgnoreBatteryOptimizations(this)
                    result.success(true)
                }
                "requestBackgroundStartPermission" -> {
                    NativeReminderScheduler.requestBackgroundStartPermission(this)
                    result.success(true)
                }
                "schedule" -> {
                    val id = call.argument<Int>("id") ?: 0
                    val title = call.argument<String>("title") ?: "Pengingat Jadwal"
                    val body = call.argument<String>("body") ?: "Waktunya menjalankan jadwal."
                    val triggerAtMillis = call.argument<Long>("triggerAtMillis") ?: 0L
                    val ring = call.argument<Boolean>("ring") ?: false
                    val vibrate = call.argument<Boolean>("vibrate") ?: true
                    val alarmSound = call.argument<String>("alarmSound") ?: "default"
                    result.success(
                        NativeReminderScheduler.schedule(
                            this,
                            id,
                            title,
                            body,
                            triggerAtMillis,
                            ring,
                            vibrate,
                            alarmSound
                        )
                    )
                }
                "cancel" -> {
                    val id = call.argument<Int>("id") ?: 0
                    NativeReminderScheduler.cancel(this, id)
                    result.success(true)
                }
                "cancelAll" -> {
                    NativeReminderScheduler.cancelAll(this)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}

