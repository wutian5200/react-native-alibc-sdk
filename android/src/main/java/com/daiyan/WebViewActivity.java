//package com.daiyan;
//import android.app.Activity;
//import android.content.Intent;
//import android.net.Uri;
//import android.os.Bundle;
//import android.support.annotation.Nullable;
//import android.webkit.DownloadListener;
//import android.webkit.WebChromeClient;
//import android.webkit.WebView;
//import android.view.View;
//import android.webkit.WebViewClient;
//import android.widget.Toast;
//
//import com.alibaba.baichuan.android.trade.AlibcTrade;
//import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
//import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
//import com.alibaba.baichuan.android.trade.model.OpenType;
//import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType;
//import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult;
//import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams;
//import com.alibaba.baichuan.trade.common.utils.AlibcLogger;
//
//import java.util.HashMap;
//import java.util.Map;
//
//public class WebViewActivity extends Activity {
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//
//        setContentView(R.layout.webview_activity);
//        Intent intent = getIntent();
//        if (intent != null) {
//            final String url = intent.getStringExtra("url");
//            WebView webView = findViewById(R.id.webview);
//
////            webView webView = findViewById(R.id.webview);
//            //启用支持JavaScript
//            webView.getSettings().setJavaScriptEnabled(true);
//            //启用支持DOM Storage
//            webView.getSettings().setDomStorageEnabled(true);
//            //加载web资源
////            webView.loadUrl(url);
//            //覆盖WebView默认使用第三方或系统默认浏览器打开网页的行为，使网页用WebView打开
//            webView.setWebViewClient(new WebViewClient() {
//                @Override
//                public boolean shouldOverrideUrlLoading(WebView view, String url) {
//                    return false;
//                }
//            });
//
//            webView.setDownloadListener(new DownloadListener() {
//                @Override
//                public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
//                    AlibcLogger.i("WebViewActivity", "url=" + url);
//                    // 方式1：跳转浏览器下载
//                    Uri uri = Uri.parse(url);
//                    Intent intent = new Intent(Intent.ACTION_VIEW, uri);
//                    intent.addCategory(Intent.CATEGORY_BROWSABLE);
//                    startActivity(intent);
//                    //方式2：系统的下载服务
//                }
//            });
//
//            openByUrl(url, webView);
//        }
//
//    }
//
//    private void openByUrl(String url, WebView webView) {
//        AlibcShowParams showParams = new AlibcShowParams();
//        showParams.setOpenType(OpenType.Native);
//        showParams.setClientType("taobao");
//        showParams.setBackUrl("");
////        showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpH5);
//        AlibcTaokeParams taokeParams = new AlibcTaokeParams("", "", "");
//        taokeParams.setPid("mm_112883640_11584347_72287650277");
////        taokeParams.setAdzoneid("29932014");
//        Map<String, String> trackParams = new HashMap<>();
//
//        AlibcTrade.openByUrl(WebViewActivity.this, "", url, webView,
//                new WebViewClient(), new WebChromeClient(),
//                showParams, taokeParams, trackParams, new AlibcTradeCallback() {
//                    @Override
//                    public void onTradeSuccess(AlibcTradeResult tradeResult) {
//                        AlibcLogger.i("WebViewActivity", "request success");
//                    }
//
//                    @Override
//                    public void onFailure(int code, String msg) {
//                        AlibcLogger.e("WebViewActivity", "code=" + code + ", msg=" + msg);
//                        if (code == -1) {
//                            Toast.makeText(WebViewActivity.this, msg, Toast.LENGTH_SHORT).show();
//                        }
//                    }
//                });
//    }
//}
