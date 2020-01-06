
package com.daiyan;

import com.alibaba.baichuan.trade.biz.AlibcConstants;
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult;
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams;
import com.alibaba.baichuan.trade.biz.login.AlibcLogin;
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback;
import com.alibaba.baichuan.trade.common.utils.AlibcLogger;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Arguments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import android.support.annotation.Nullable;

import com.ali.auth.third.login.callback.LogoutCallback;
import com.ali.auth.third.ui.context.CallbackContext;
//import com.alibaba.baichuan.android.trade.adapter.login.AlibcLogin;
import com.ali.auth.third.core.model.Session;
//import com.alibaba.baichuan.android.trade.callback.AlibcLoginCallback;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;

import com.alibaba.baichuan.android.trade.AlibcTrade;
//import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
//import com.alibaba.baichuan.android.trade.constants.AlibcConstants;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
//import com.alibaba.baichuan.android.trade.model.AlibcTaokeParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.android.trade.page.AlibcAddCartPage;
import com.alibaba.baichuan.android.trade.page.AlibcBasePage;
import com.alibaba.baichuan.android.trade.page.AlibcDetailPage;
//import com.alibaba.baichuan.android.trade.page.AlibcMiniDetailPage;
//import com.alibaba.baichuan.android.trade.page.AlibcPage;
//import com.alibaba.baichuan.android.trade.page.AlibcPage;
import com.alibaba.baichuan.android.trade.page.AlibcShopPage;
import com.alibaba.baichuan.android.trade.page.AlibcMyOrdersPage;
import com.alibaba.baichuan.android.trade.page.AlibcMyCartsPage;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
//import com.alibaba.baichuan.android.trade.model.ResultType;
//import com.alibaba.baichuan.android.trade.model.TradeResult;
//import com.taobao.applink.util.TBAppLinkUtil;
//import com.alibaba.baichuan.android.trade.;

import java.util.HashMap;
import java.util.Map;

import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebChromeClient;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.List;
import android.util.Log;
import android.widget.Toast;

public class RNAlibcSdkModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;
  private final Context reactContexts;
  private static final String TAG = "RNAlibcSdkModule";

  private final static String NOT_LOGIN = "not login";
  private final static String INVALID_TRADE_RESULT = "invalid trade result";
  private final static String INVALID_PARAM = "invalid";

  private Map<String, String> exParams;//yhhpass参数
  private AlibcShowParams alibcShowParams;//页面打开方式，默认，H5，Native
  private AlibcTaokeParams alibcTaokeParams = null;//淘客参数，包括pid，unionid，subPid
  private static Activity mActivity;
  private static Alipay alipay;
  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
      CallbackContext.onActivityResult(requestCode, resultCode, intent);
    }
  };

  static private RNAlibcSdkModule mRNAlibcSdkModule = null;
  static public RNAlibcSdkModule sharedInstance(ReactApplicationContext context) {
      if(alipay == null){
          alipay = new Alipay(context);
      }
    if (mRNAlibcSdkModule == null)
      return new RNAlibcSdkModule(context);
    else
      return mRNAlibcSdkModule;
  }

    public static void init(Activity activity) {
        if (activity == null) return;
        mActivity = activity;
    }


  public RNAlibcSdkModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.reactContexts = reactContext;
    reactContext.addActivityEventListener(mActivityEventListener);

    alibcShowParams = new AlibcShowParams();//OpenType.Auto, false

    alibcShowParams.setOpenType(OpenType.Auto);

      alibcShowParams.setClientType("taobao");
      alibcShowParams.setBackUrl("alisdk://");
      exParams = new HashMap<>();
    exParams.put(AlibcConstants.ISV_CODE, "rnappisvcode");
  }

  @Override
  public String getName() {
    return "RNAlibcSdk";
  }

  /**
  * 初始化
  */
  @ReactMethod
//  public void init(final String pid, final Boolean forceH5, final Callback callback) {
  public void init(final String pid, final Boolean forceH5, final Promise promise) {
//      this.alibcTaokeParams = new AlibcTaokeParams("", "", "");//pid
      this.alibcTaokeParams = new AlibcTaokeParams(pid, "", "");//pid
      this.alibcTaokeParams.extraParams = new HashMap<>();
      this.alibcTaokeParams.extraParams.put("taokeAppkey", "25634417");
//      this.alibcTaokeParams.setPid("mm_113435089_555800032_109026900326");
//      this.alibcTaokeParams.extraParams.put("taokeAppkey", "25634417");
      AlibcTradeSDK.asyncInit(mActivity.getApplication(), new AlibcTradeInitCallback() {
        @Override
        public void onSuccess() {
//            AlibcTradeSDK.setForceH5(forceH5);
            promise.resolve(false);
//            callback.invoke(null, "init success");
        }

        @Override
        public void onFailure(int code, String msg) {
            WritableMap map = Arguments.createMap();
            map.putInt("code", code);
            map.putString("msg", msg);
            promise.resolve(map);
//            callback.invoke(map);
        }
    }); 
  }
            
  /**
  * 登录
  */
  @ReactMethod
//  public void login(final Callback callback) {
  public void login(final Promise promise) {
      AlibcLogin alibcLogin = AlibcLogin.getInstance();

//      alibcLogin.showLogin(new AlibcLoginCallback() {
//          @Override
//          public void onSuccess(int loginResult, String openId, String userNick) {
//              // 参数说明：
//              // loginResult(0--登录初始化成功；1--登录初始化完成；2--登录成功)
//              // openId：用户id
//              // userNick: 用户昵称
//              Log.i(TAG, "获取淘宝用户信息: " + AlibcLogin.getInstance().getSession());
//          }
//
//          @Override
//          public void onFailure(int code, String msg) {
//              // code：错误码  msg： 错误信息
//          }
//      });


      alibcLogin.showLogin(new AlibcLoginCallback() {
          @Override
          public void onSuccess(int loginResult, String openId, String userNick) {
            Session session = AlibcLogin.getInstance().getSession();
            WritableMap map = Arguments.createMap();
            map.putString("nick", session.nick);
            map.putString("avatarUrl", session.avatarUrl);
            map.putString("openId", session.openId);
            map.putString("openSid", session.openSid);
            map.putString("err", "1");
            promise.resolve(map);
//            callback.invoke(null, map);
          }
          @Override
          public void onFailure(int code, String msg) {
            WritableMap map = Arguments.createMap();
            map.putInt("code", code);
            map.putString("msg", msg);
              map.putString("err", "0");
            promise.resolve(map);
//            callback.invoke(map);
          }
      });
  }

  @ReactMethod
  public void isLogin(final Promise promise) {
      promise.resolve(AlibcLogin.getInstance().isLogin());
//      callback.invoke(null, AlibcLogin.getInstance().isLogin());
//      callback.invoke(null, AlibcLogin.getInstance().isLogin());
  }

  @ReactMethod
//  public void getUser(final Callback callback) {
  public void getUser(final Promise promise) {
      if (AlibcLogin.getInstance().isLogin()) {
        Session session = AlibcLogin.getInstance().getSession();
        WritableMap map = Arguments.createMap();
        map.putString("nick", session.nick);
        map.putString("avatarUrl", session.avatarUrl);
        map.putString("openId", session.openId);
        map.putString("openSid", session.openSid);
        map.putString("err", "1");
          promise.resolve(map);
//        callback.invoke(null, map);
      } else {
          promise.resolve(false);
//        callback.invoke(NOT_LOGIN);
      }
        
  }

  /**
  * 退出登录
  */
  @ReactMethod
//  public void logout(final Callback callback) {
  public void logout(final Promise promise) {
      AlibcLogin alibcLogin = AlibcLogin.getInstance();

      alibcLogin.logout( new AlibcLoginCallback() {
          @Override
          public void onSuccess(int loginResult, String openId, String userNick) {
              promise.resolve(false);
//            callback.invoke(null, "logout success");
          }

          @Override
          public void onFailure(int code, String msg) {
            WritableMap map = Arguments.createMap();
            map.putInt("code", code);
            map.putString("msg", msg);
              promise.resolve(msg);
//            callback.invoke(msg);
          }
      });
  }

  @ReactMethod
//  public void show(final ReadableMap param, final Callback callback) {
  public void show(final ReadableMap param,final String Type, final Promise promise) {
      alibcShowParams = new AlibcShowParams();//OpenType.Auto, false
      alibcShowParams.setClientType("taobao");
      alibcShowParams.setBackUrl("alisdk://");
//      alibcShowParams.setBackUrl("alisdk://");

      System.out.println("Urlll11111111111111" + Type);
    switch (Type){
        case "Auto":
            System.out.println("Urlll44444444444" + Type);
            alibcShowParams.setOpenType(OpenType.Auto);
            break;
        case "H5":
            System.out.println("Urlll55555555555" + Type);
            alibcShowParams.setOpenType(OpenType.Auto);
            break;
        case "Native":
            System.out.println("Urlll66666666666" + Type);
            alibcShowParams.setOpenType(OpenType.Native);

            break;
        default:
            System.out.println("Urlll7777777777" + Type);
            alibcShowParams.setOpenType(OpenType.Auto);
            break;
    }

    String type = param.getString("type");
    switch(type){
      case "detail":
        this._showInWebView(new AlibcDetailPage(param.getString("payload")),"detail", promise);
        break;
      case "url":
          System.out.println("Urlll11111111111111" + Type);
//          if(Type  == "H5"){
          if(Type.equals("H5")){
              System.out.println("Urlll122222222222" + Type);
              Intent intent = new Intent(mActivity, WebViewActivity.class);
              intent.putExtra("url", param.getString("payload"));
              mActivity.startActivity(intent);
          }else{
              System.out.println("Urlll133333333333333" + Type);
//              this._showInWebView(new AlibcDetailPage(param.getString("payload")),"detail", promise);
                this._showByUrl(param.getString("payload"), promise);
//
          }


        break;
      case "shop":
        this._showInWebView(new AlibcShopPage(param.getString("payload")),"shop", promise);
        break;
      case "orders":
        ReadableMap payload = param.getMap("payload");
        this._showInWebView(new AlibcMyOrdersPage(payload.getInt("orderType"), payload.getBoolean("isAllOrder")),"orders", promise);
        break;
      case "addCard":
        this._showInWebView(new AlibcAddCartPage(param.getString("payload")),"addCard", promise);
        break;
      case "mycard":
        this._showInWebView(new AlibcMyCartsPage(),"cart", promise);
        break;
      default:
          promise.resolve(false);
//        callback.invoke(INVALID_PARAM);
        break;
    }
  }

  public void showInWebView(final WebView webview, WebViewClient webViewClient, final ReadableMap param) {
    String type = param.getString("type");
    switch(type){
      case "detail":
        this._showWebView(new AlibcShopPage(param.getString("payload")));
        break;
      case "url":
        this._showWebView(new AlibcShopPage(param.getString("payload")));
        break;
      case "shop":
        this._showWebView(new AlibcShopPage(param.getString("payload")));
        break;
    case "auction":
//        PromotionsPage promotionsPage = new PromotionsPage("shop", "商家测试帐号17");
//        this._showWebView(new Ali(param.getString("payload")));
        break;
      case "orders":
        ReadableMap payload = param.getMap("payload");
        this._showWebView(new AlibcMyOrdersPage(payload.getInt("orderType"), payload.getBoolean("isAllOrder")));
        break;
      case "addCard":
        this._showWebView(new AlibcAddCartPage(param.getString("payload")));
        break;
      case "mycard":
        this._showWebView(new AlibcMyCartsPage());
        break;
      default:
        WritableMap event = Arguments.createMap();
        event.putString("type", INVALID_PARAM);
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                webview.getId(),
                "onTradeResult",
                event);
        break;
    }
  }

  private void _showByUrl(String url,  final Promise promise){
      // 以显示传入url的方式打开页面（第二个参数是套件名称）
//      alibcShowParams.setOpenType(OpenType.Native);
      AlibcShowParams showParams = new AlibcShowParams();
      showParams.setOpenType(OpenType.Native);
      showParams.setClientType("taobao");
      showParams.setBackUrl("alisdk://");
//        showParams.setNativeOpenFailedMode(AlibcFailModeType.AlibcNativeFailModeJumpH5);
      AlibcTaokeParams taokeParams = new AlibcTaokeParams("", "", "");
      taokeParams.setPid("mm_113435089_910000275_109603600237");

      taokeParams.extraParams = new HashMap<>();
      taokeParams.extraParams.put("taokeAppkey", "25634417");

      AlibcTrade.openByUrl(mActivity, "", url, null,
              new WebViewClient(), new WebChromeClient(), showParams,
              taokeParams, exParams, new AlibcTradeCallback() {
                  @Override
                  public void onTradeSuccess(AlibcTradeResult tradeResult) {
                      AlibcLogger.i(TAG, "request success");
                  }
                  @Override
                  public void onFailure(int code, String msg) {
                      AlibcLogger.e(TAG, "code=" + code + ", msg=" + msg);
                      if (code == -1) {

//                          Toast.makeText(FeatureActivity.this, msg, Toast.LENGTH_SHORT).show();
                      }
                  }
              });
  }

  private void _showInWebView(final AlibcBasePage page,final String ByCode, final Promise promise) {
      AlibcTrade.openByBizCode(mActivity, page, null, new WebViewClient(), new WebChromeClient(),
              ByCode, alibcShowParams, alibcTaokeParams, exParams, new AlibcTradeCallback() {
                  @Override
                  public void onTradeSuccess(AlibcTradeResult tradeResult) {
                      // 交易成功回调（其他情形不回调）
                      AlibcLogger.i(TAG, "open detail page success");
                  }
                  @Override
                  public void onFailure(int code, String msg) {
                      // 失败回调信息
                      AlibcLogger.e(TAG, "code=" + code + ", msg=" + msg);
                      if (code == -1) {


                      }
                  }
              });
  }



    private void _showWebView(final AlibcBasePage page) {
        AlibcTrade.openByBizCode(mActivity, page, null, new WebViewClient(),
                new WebChromeClient(), "detail", alibcShowParams, alibcTaokeParams,
                exParams, new AlibcTradeCallback() {
                    @Override
                    public void onTradeSuccess(AlibcTradeResult tradeResult) {
                        // 交易成功回调（其他情形不回调）
                        AlibcLogger.i(TAG, "open detail page success");
                    }
                    @Override
                    public void onFailure(int code, String msg) {
                        // 失败回调信息
                        AlibcLogger.e(TAG, "code=" + code + ", msg=" + msg);
                        if (code == -1) {


                        }
                    }
                });
    }


    /**
     * 支付宝 支付 开始
     */
    @ReactMethod
    public void authWithInfo(final String infoStr, final Promise promise) {
        alipay.authWithInfo(infoStr,promise);
    }


    @ReactMethod
    public void pay(final String infoStr, final Promise promise) {
        alipay.pay(infoStr,promise);
    }
    @ReactMethod
    public void payInterceptorWithUrl(final String infoStr, final Promise promise) {
        alipay.payInterceptorWithUrl(infoStr,promise);
    }
    @ReactMethod
    public void getVersion(final Promise promise) {
        alipay.getVersion(promise);
    }


}