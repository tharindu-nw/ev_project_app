package com.example.ev_app;

import android.os.Bundle;

import com.facebook.FacebookSdk;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FacebookSdk.setApplicationId("310801193668386");
    FacebookSdk.sdkInitialize(getApplicationContext());
    GeneratedPluginRegistrant.registerWith(this);
  }
}
