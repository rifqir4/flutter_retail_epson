package com.example.flutter_retail_epson;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.epson.epos2.Epos2Exception;
import com.epson.epos2.Log;
import com.epson.epos2.printer.Printer;
import com.epson.epos2.printer.PrinterStatusInfo;
import com.epson.epos2.printer.ReceiveListener;

import java.util.HashMap;

public class EpsonActivity extends Activity implements ReceiveListener {
    private static final int DISCONNECT_INTERVAL = 500;//millseconds

    private Context mContext = null;
    public static Printer  mPrinter = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_epson);

        mContext = this;

//        int[] target = {
//                R.id.btnSampleReceipt,
//        };
//
////        for (int i = 0; i < target.length; i++) {
////            Button button = (Button)findViewById(target[i]);
////            button.setOnClickListener(this);
////        }


        initializeObject();

        try {
            Log.setLogSettings(mContext, Log.PERIOD_TEMPORARY, Log.OUTPUT_STORAGE, null, 0, 1, Log.LOGLEVEL_LOW);
        }
        catch (Exception e) {
            ShowMsg.showException(e, "setLogSettings", mContext);
        }

        runPrintReceiptSequence();
    }

    @Override
    protected void onDestroy() {

        finalizeObject();

        super.onDestroy();
    }


//    @Override
//    public void onClick(View v) {
//        Intent intent = null;
//
//        switch (v.getId()) {
//
//            case R.id.btnSampleReceipt:
//                updateButtonState(false);
//                if (!runPrintReceiptSequence()) {
//                    updateButtonState(true);
//                }
//                break;
//
//            default:
//                // Do nothing
//                break;
//        }
//    }

    private boolean runPrintReceiptSequence() {

        if (!createReceiptData()) {
            return false;
        }

        if (!printData()) {
            return false;
        }

        return true;
    }

    private String customJustify(String left, String right){
        String justifyText;
        int space = 33 - left.length() - right.length();
        justifyText = left;
        for (int i = 0; i < space; i++) {
            justifyText  += ' ';
        }
        justifyText += right;
        return justifyText;
    }

    private boolean createReceiptData() {
        String method = "";
        StringBuilder textData = new StringBuilder();
        final String divider = "--------------------------------\n";

        if (mPrinter == null) {
            return false;
        }

        try {


            method = "addTextAlign";
            mPrinter.addTextAlign(Printer.ALIGN_CENTER);

            method = "addTextSize";
            mPrinter.addTextSize(2, 2);
            method = "addText";
            mPrinter.addText("TOKO\nSOLO MAKMUR\n");

            method = "addTextSize";
            mPrinter.addTextSize(1, 1);
            method = "addFeedLine";
            mPrinter.addFeedLine(1);
            textData.append("Agen Gas, Beras, dan\n");
            textData.append("Minuman Kemasan\n\n");
            textData.append("Jl. Kasuari Raya No. 256 Perumnas 1, Kayurungin Jaya, Bekasi Selatan, Kota Bekasi, 17144\n");
            textData.append("Telp. 021-8868068\n");
            textData.append("\n");
            method = "addText";
            mPrinter.addText(textData.toString());
            textData.delete(0, textData.length());

            method = "addTextAlign";
            mPrinter.addTextAlign(Printer.ALIGN_LEFT);
            textData.append(divider);
            textData.append("Aqua Galon (Eceran)\n");
            textData.append(customJustify("3x @37.000", "101.000") + "\n\n");

            textData.append("Raja Lele (Eceran)\n");
            textData.append(customJustify("1x @50.000", "50.000") + "\n\n");
            mPrinter.addText(textData.toString());
            textData.delete(0, textData.length());

            method = "addText";
            mPrinter.addText(divider);
            mPrinter.addText(customJustify("TOTAL", "Rp. 151.000"));

            method = "addFeedLine";
            mPrinter.addFeedLine(1);
            method = "addText";
            textData.append(divider);
            textData.append("Alamat Pelanggan :\n");
            textData.append("Jl. Piranha Atas\n");
            textData.append("Keterangan :\n");
            textData.append("Rifqi Radifan\n");
            method = "addText";
            mPrinter.addText(textData.toString());
            textData.delete(0, textData.length());

            method = "addFeedLine";
            mPrinter.addFeedLine(1);
            method = "addTextAlign";
            mPrinter.addTextAlign(Printer.ALIGN_CENTER);
            method = "addText";
            mPrinter.addText("-Terima Kasih-");

            method = "addFeedLine";
            mPrinter.addFeedLine(2);

            method = "addCut";
            mPrinter.addCut(Printer.CUT_FEED);

        }
        catch (Exception e) {
            mPrinter.clearCommandBuffer();
            ShowMsg.showException(e, method, mContext);
            return false;
        }

        textData = null;

        return true;
    }

    private boolean printData() {
        if (mPrinter == null) {
            return false;
        }

        if (!connectPrinter()) {
            mPrinter.clearCommandBuffer();
            return false;
        }

        try {
            mPrinter.sendData(Printer.PARAM_DEFAULT);
        }
        catch (Exception e) {
            mPrinter.clearCommandBuffer();
            ShowMsg.showException(e, "sendData", mContext);
            try {
                mPrinter.disconnect();
            }
            catch (Exception ex) {
                // Do nothing
            }
            return false;
        }

        return true;
    }

    private boolean initializeObject() {
        try {
            mPrinter = new Printer(Printer.TM_U220,
                    Printer.MODEL_ANK,
                    mContext);
        }
        catch (Exception e) {
            ShowMsg.showException(e, "Printer", mContext);
            return false;
        }

        mPrinter.setReceiveEventListener(this);

        return true;
    }

    private void finalizeObject() {
        if (mPrinter == null) {
            return;
        }

        mPrinter.setReceiveEventListener(null);

        mPrinter = null;
    }

    private boolean connectPrinter() {
        if (mPrinter == null) {
            return false;
        }

        try {
            mPrinter.connect("USB:/dev/bus/usb/001/002", Printer.PARAM_DEFAULT);
        }
        catch (Exception e) {
            ShowMsg.showException(e, "connect", mContext);
            return false;
        }

        return true;
    }

    private void disconnectPrinter() {
        if (mPrinter == null) {
            return;
        }

        while (true) {
            try {
                mPrinter.disconnect();
                break;
            } catch (final Exception e) {
                if (e instanceof Epos2Exception) {
                    //Note: If printer is processing such as printing and so on, the disconnect API returns ERR_PROCESSING.
                    if (((Epos2Exception) e).getErrorStatus() == Epos2Exception.ERR_PROCESSING) {
                        try {
                            Thread.sleep(DISCONNECT_INTERVAL);
                        } catch (Exception ex) {
                        }
                    }else{
                        runOnUiThread(new Runnable() {
                            public synchronized void run() {
                                ShowMsg.showException(e, "disconnect", mContext);
                            }
                        });
                        break;
                    }
                }else{
                    runOnUiThread(new Runnable() {
                        public synchronized void run() {
                            ShowMsg.showException(e, "disconnect", mContext);
                        }
                    });
                    break;
                }
            }
        }

        mPrinter.clearCommandBuffer();
    }

    private String makeErrorMessage(PrinterStatusInfo status) {
        String msg = "";

        if (status.getOnline() == Printer.FALSE) {
            msg += getString(R.string.handlingmsg_err_offline);
        }
        if (status.getConnection() == Printer.FALSE) {
            msg += getString(R.string.handlingmsg_err_no_response);
        }
        if (status.getCoverOpen() == Printer.TRUE) {
            msg += getString(R.string.handlingmsg_err_cover_open);
        }
        if (status.getPaper() == Printer.PAPER_EMPTY) {
            msg += getString(R.string.handlingmsg_err_receipt_end);
        }
        if (status.getPaperFeed() == Printer.TRUE || status.getPanelSwitch() == Printer.SWITCH_ON) {
            msg += getString(R.string.handlingmsg_err_paper_feed);
        }
        if (status.getErrorStatus() == Printer.MECHANICAL_ERR || status.getErrorStatus() == Printer.AUTOCUTTER_ERR) {
            msg += getString(R.string.handlingmsg_err_autocutter);
            msg += getString(R.string.handlingmsg_err_need_recover);
        }
        if (status.getErrorStatus() == Printer.UNRECOVER_ERR) {
            msg += getString(R.string.handlingmsg_err_unrecover);
        }
        if (status.getErrorStatus() == Printer.AUTORECOVER_ERR) {
            if (status.getAutoRecoverError() == Printer.HEAD_OVERHEAT) {
                msg += getString(R.string.handlingmsg_err_overheat);
                msg += getString(R.string.handlingmsg_err_head);
            }
            if (status.getAutoRecoverError() == Printer.MOTOR_OVERHEAT) {
                msg += getString(R.string.handlingmsg_err_overheat);
                msg += getString(R.string.handlingmsg_err_motor);
            }
            if (status.getAutoRecoverError() == Printer.BATTERY_OVERHEAT) {
                msg += getString(R.string.handlingmsg_err_overheat);
                msg += getString(R.string.handlingmsg_err_battery);
            }
            if (status.getAutoRecoverError() == Printer.WRONG_PAPER) {
                msg += getString(R.string.handlingmsg_err_wrong_paper);
            }
        }
        if (status.getBatteryLevel() == Printer.BATTERY_LEVEL_0) {
            msg += getString(R.string.handlingmsg_err_battery_real_end);
        }

        return msg;
    }

//    private void updateButtonState(boolean state) {
//        Button btnReceipt = (Button)findViewById(R.id.btnSampleReceipt);
//
//        btnReceipt.setEnabled(state);
//    }

    @Override
    public void onPtrReceive(final Printer printerObj, final int code, final PrinterStatusInfo status, final String printJobId) {
        runOnUiThread(new Runnable() {
            @Override
            public synchronized void run() {
//                ShowMsg.showResult(code, "kudua", mContext);
                Intent intent = new Intent();
                intent.putExtra("Status", "Print Success");
                setResult(RESULT_OK, intent);
                finish();

                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        disconnectPrinter();
                    }
                }).start();
            }
        });
    }
}
