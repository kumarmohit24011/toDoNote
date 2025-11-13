package com.mohitbhardwaj.doNoteapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class HomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val intent = Intent(context, ListWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }

            val launchIntent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, launchIntent, PendingIntent.FLAG_IMMUTABLE)

            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val backgroundColor = prefs.getString("background_color_$appWidgetId", "white")

            val layout = if (backgroundColor == "transparent") {
                R.layout.home_widget_layout_transparent
            } else {
                R.layout.home_widget_layout
            }

            val views = RemoteViews(context.packageName, layout).apply {
                setTextViewText(R.id.widget_title, "Active Tasks")
                setRemoteAdapter(R.id.widget_task_list, intent)
                setEmptyView(R.id.widget_task_list, R.id.empty_view)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.widget_task_list)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}
