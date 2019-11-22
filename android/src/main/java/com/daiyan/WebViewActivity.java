package com.daiyan;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.Toolbar;
import android.view.DisplayCutout;
import android.view.View;
import android.view.WindowManager;
import android.webkit.DownloadListener;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.baichuan.android.trade.AlibcTrade;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType;
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult;
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams;
import com.alibaba.baichuan.trade.common.utils.AlibcLogger;
import com.jaeger.library.StatusBarUtil;

import java.util.HashMap;
import java.util.Map;

public class WebViewActivity extends Activity {
    private TextView mTextView;
    protected void setStatusBar() {
        //这里做了两件事情，1.使状态栏透明并使contentView填充到状态栏 2.预留出状态栏的位置，防止界面上的控件离顶部靠的太近。这样就可以实现开头说的第二种情况的沉浸式状态栏了
        StatusBarUtil.setTransparent(this);//全透明
//        StatusBarUtil.setTranslucent(this);

    }
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.webview_activity);
        WindowManager.LayoutParams lp = getWindow().getAttributes();
        lp.layoutInDisplayCutoutMode= WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_NEVER;

        getWindow().setAttributes(lp);

        mTextView = (TextView)this.findViewById(R.id.fh);

        mTextView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }

        });

        setStatusBar();
        Intent intent = getIntent();
        if (intent != null) {
            final String url = intent.getStringExtra("url");
            WebView webView = findViewById(R.id.webView);
            //启用支持JavaScript
            webView.getSettings().setJavaScriptEnabled(true);
            //启用支持DOM Storage
            webView.getSettings().setDomStorageEnabled(true);
            //加载web资源
//            webView.loadUrl(url);
            //覆盖WebView默认使用第三方或系统默认浏览器打开网页的行为，使网页用WebView打开
            webView.setWebViewClient(new WebViewClient() {
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, String url) {
                    System.out.println("Urll8888888" + url);
                    if(url.contains("myExit://") || url.contains("myexit://")){
                        System.out.println("Urll00000000000" + url);
                        finish();
                        return true;
                    }
                    return false;
                }
            });

            webView.setDownloadListener(new DownloadListener() {
                @Override
                public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
                    AlibcLogger.i("WebViewActivity", "url=" + url);
                    // 方式1：跳转浏览器下载
                    Uri uri = Uri.parse(url);
                    Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                    intent.addCategory(Intent.CATEGORY_BROWSABLE);
                    startActivity(intent);
                    //方式2：系统的下载服务
                }
            });

            openByUrl(url, webView);
        }

    }

    private void openByUrl(String url, WebView webView) {
        AlibcShowParams showParams = new AlibcShowParams();
        showParams.setOpenType(OpenType.Native);
        showParams.setClientType("taobao");
        showParams.setBackUrl("");
//        showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpH5);
        AlibcTaokeParams taokeParams = new AlibcTaokeParams("", "", "");
        taokeParams.setPid("mm_112883640_11584347_72287650277");
//        taokeParams.setAdzoneid("29932014");
        Map<String, String> trackParams = new HashMap<>();

        WebViewClient WebViewClient = new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                System.out.println("Urll8888888" + url);
                if(url.contains("myExit://") || url.contains("myexit://")){
                    System.out.println("Urll00000000000" + url);
                    finish();
                    return true;
                }
                return false;
            }
        };

        AlibcTrade.openByUrl(WebViewActivity.this, "", url, webView,
                WebViewClient, new WebChromeClient(),
                showParams, taokeParams, trackParams, new AlibcTradeCallback() {
                    @Override
                    public void onTradeSuccess(AlibcTradeResult tradeResult) {
                        AlibcLogger.i("WebViewActivity", "request success");
                    }

                    @Override
                    public void onFailure(int code, String msg) {
                        AlibcLogger.e("WebViewActivity", "code=" + code + ", msg=" + msg);
                        if (code == -1) {
                            Toast.makeText(WebViewActivity.this, msg, Toast.LENGTH_SHORT).show();
                        }
                    }
                });
    }
}
