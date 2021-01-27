package com.example.flutter_retail_epson;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity implements MethodCallHandler {
    private static final int REQUEST_PERMISSION = 100;

    private String CHANNEL = "com.example.flutter_retail_epson";
    private MethodChannel mChannel = null;

    private MethodChannel.Result result = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        requestRuntimePermission();

        mChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        mChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Map<String, Object> args = call.arguments();
        if(call.method.equals("discoverPrinter")) {
            this.result = result;
            Intent intent = new Intent(this, DiscoverActivity.class);
            startActivityForResult(intent, 0);
        } else if(call.method.equals("checkout")){
            // Log.d("native", "Checkout");
            // String target = (String) args.get("target");
            // String items = convertData(args.get("items").toString());
            // String total = args.get("total").toString();
            // String nama = args.get("nama").toString();
            // String alamat = args.get("alamat").toString();
            // String ket = args.get("ket").toString();
            // Log.d("Target", target);
            // Log.d("Native", items);

           this.result = result;
           Intent intent = new Intent(this, EpsonActivity.class);
           intent.putExtra("target", (String) args.get("target"));
           intent.putExtra("items", convertData((String) args.get("items")));
           intent.putExtra("total", (String) args.get("total"));
           intent.putExtra("nama", (String) args.get("nama"));
           intent.putExtra("alamat", (String) args.get("alamat"));
           intent.putExtra("ket", (String) args.get("ket"));
           startActivityForResult(intent, 123);
        } else {
            result.notImplemented();
        }

    }

    private String customJustify(String data){
        String justifyText;
        String[] split = data.split("&");
        int space = 33 - split[0].length() - split[1].length();
        justifyText = split[0];
        for (int i = 0; i < space; i++) {
            justifyText  += ' ';
        }
        justifyText += split[1];
        return justifyText;
    }

    private String convertData (String raw){
        StringBuilder data = new StringBuilder();
        String[] items = raw.split("[|]");
        for (String item : items){
            String[] split = item.split(",");
            data.append(split[0] + "\n");
            data.append(customJustify(split[1]) + "\n\n");
        }
        Log.d("Native", data.toString());

        return data.toString();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(resultCode == Activity.RESULT_OK){
            if(requestCode == 0){
                String target = data.getStringExtra("Target");
                this.result.success(target);
            }

            if(requestCode == 123){
                String target = data.getStringExtra("Status");
                this.result.success(target);
            }
        }
    }

    private void requestRuntimePermission() {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.M) {
            return;
        }

        int permissionStorage = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE);
        //int permissionLocationCoarse= ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION);
        int permissionLocationFine = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION);

        List<String> requestPermissions = new ArrayList<>();

        if (permissionStorage == PackageManager.PERMISSION_DENIED) {
            requestPermissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }
        if (permissionLocationFine == PackageManager.PERMISSION_DENIED) {
            requestPermissions.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }
//        if (permissionLocationCoarse == PackageManager.PERMISSION_DENIED) {
//            requestPermissions.add(Manifest.permission.ACCESS_COARSE_LOCATION);
//        }

        if (!requestPermissions.isEmpty()) {
            ActivityCompat.requestPermissions(this, requestPermissions.toArray(new String[requestPermissions.size()]), REQUEST_PERMISSION);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String permissions[], @NonNull int[] grantResults) {
        if (requestCode != REQUEST_PERMISSION || grantResults.length == 0) {
            return;
        }

        List<String> requestPermissions = new ArrayList<>();

        for (int i = 0; i < permissions.length; i++) {
            if (permissions[i].equals(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    && grantResults[i] == PackageManager.PERMISSION_DENIED) {
                requestPermissions.add(permissions[i]);
            }
            if (permissions[i].equals(Manifest.permission.ACCESS_FINE_LOCATION)
                    && grantResults[i] == PackageManager.PERMISSION_DENIED) {
                requestPermissions.add(permissions[i]);
            }

            // If your app targets Android 9 or lower, you can declare ACCESS_COARSE_LOCATION instead.
//            if (permissions[i].equals(Manifest.permission.ACCESS_COARSE_LOCATION)
//                    && grantResults[i] == PackageManager.PERMISSION_DENIED) {
//                requestPermissions.add(permissions[i]);
//            }
        }

        if (!requestPermissions.isEmpty()) {
            ActivityCompat.requestPermissions(this, requestPermissions.toArray(new String[requestPermissions.size()]), REQUEST_PERMISSION);
        }
    }
}
