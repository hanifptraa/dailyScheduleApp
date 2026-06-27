package com.example.daily_schedule_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class NativeReminderBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (
            action == Intent.ACTION_BOOT_COMPLETED ||
            action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            action == "android.intent.action.QUICKBOOT_POWERON" ||
            action == "com.htc.intent.action.QUICKBOOT_POWERON"
        ) {
            NativeReminderScheduler.rescheduleStored(context)
        }
    }
}
