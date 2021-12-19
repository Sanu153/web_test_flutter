class Endpoint {
  static final bool _production = true;

  static final String _SERVER_URL =
      "${_production ? 'http://3.135.32.14:3000' : 'http://192.168.29.41:3000'}";
  static final String _WEB_SOCKET_SERVER_URL =
      "${_production ? 'ws://3.135.32.14:3000' : 'ws://192.168.29.41:3000'}";

  // Authentication
  static final String LOGIN_URL = '$_SERVER_URL/users/sign_in';
  static final String REGISTER_URL = '$_SERVER_URL/users';
  static final String OTP_VERIFY_URL = '$_SERVER_URL/users/confirmation';
  static final String FORGOT_PASSWORD_VERIFY_URL =
      '$_SERVER_URL/users/password';

  // 1:
  static final String GET_ALL_PRODUCT_URL = "$_SERVER_URL/product_specs";

  // 2:
  static final String PRODUCT_SPEC_MARKET_DETAILS_URL =
      "$_SERVER_URL/product_specs";

  // 3:
  static final String PRODUCT_SPEC_DEFAULT_URL =
      "$_SERVER_URL/dashboard/product_spec/default";

  // 4:
  static final String GET_MARKET_GRAPH_URL =
      "$_SERVER_URL/dashboard/product_spec/{id}?";

  // 5:
  static final String ADD_BUYSELL_REQUEST_URL =
      "$_SERVER_URL/trades/buy_sell/request";

  // 6:
  static final String GET_BUY_SELL_REQUEST_URL =
      "$_SERVER_URL/trades/buy_sell/product_spec";

  // 7:
  static final String GET_BUY_SELL_RESPOND_URL =
      "$_SERVER_URL/trades/buy_sell/respond";

  // 8:
  static final String GET_PRODUCT_MARKET_INFO_URL =
      "$_SERVER_URL/product_specs/{id}/info?product_spec_markets=";

  // 9: General Views
  static final String GET_ANNOUNCEMENT_NEWS_URL =
      "$_SERVER_URL/announcement/news";

  // 10:
  static final String GET_ANNOUNCEMENT_TENDERS_URL =
      "$_SERVER_URL/announcement/tenders";

  // 11
  static final String GET_ANNOUNCEMENT_EVENTS_URL =
      "$_SERVER_URL/announcement/events";

  // 12: Market Subscription
  static final String GET_MARKET_SUBSCRIPTION =
      "$_SERVER_URL/product_spec_markets/{id}/subscribe";

  // 13:
  static final String GET_MARKET_UNSUBSCRIPTION =
      "$_SERVER_URL/product_spec_markets/{id}/unsubscribe";

  // 14: Portfolio Negotiation
  static final String GET_OPENED_PORTFOLIO =
      "$_SERVER_URL/trades/buy_sell/portfolio_details";

  // 15:
  static final String PORTFOLIO_NEGOTIATION =
      "$_SERVER_URL/trades/buy_sell/negotiation";

  // 16:
  static final String GET_PORTFOLIO_NEGOTIATION =
      "$_SERVER_URL/trades/buy_sell/negotiation_list?request_responder_id=";

  // 17:
  static final String GET_PORTFOLIO_NEGOTIATION_APPROVE_REJECT =
      "$_SERVER_URL/trades/order/create_order";

// 18:
  static final String GET_PORTFOLIO_GET_ORDER =
      "$_SERVER_URL/trades/order/get_orders";

  // 19:
  static final String USER_ALERT = "$_SERVER_URL/user_alerts";

  // 20:
  //  TIme Interval
  static final String TIME_INTERVAL_GRAPH_DATA =
      "$_SERVER_URL/product_specs/{productSpecId}/graph?";

  // 21: User Profile
  static final String USER_PROFILE_INFO_URL = "$_SERVER_URL/users/profile";

// 22: User Update Password
  static final String USER_UPDATE_PASSWORD_URL =
      "$_SERVER_URL/users/updatepassword";

// 23: User Update Profile
  static final String USER_UPDATE_PROFILE_URL = "$_SERVER_URL/users/updateuser";

  // 24: User Update Profile
  static final String USER_UPDATE_PROFILE_IMAGE_URL =
      "$_SERVER_URL/users/updateuserphoto";

  // 24: SupportChat Feedback
  static final String SUPPORT_CHART_FEEDBACK_URL =
      "$_SERVER_URL/user_feedbacks";

  // 25: Get Schedule
  static final String GET_SCHEDULE_URL =
      "$_SERVER_URL/trades/order/get_schedule?";

  // 26: Get Trade Contracts
  static final String GET_TRADE_CONTRACT =
      "$_SERVER_URL/trades/order/get_contract";

  // 27: Get Trade Schedule
  static final String GET_TRADE_SCHEDULE =
      "$_SERVER_URL/trades/order/get_today_schedule";

  // 28: Get History Negotiation List
  static final String GET_TRADE_REQUEST_RESPONDERS =
      "$_SERVER_URL/trades/negotiation_list";

  // 29: POST Adherence
  static final String POST_ADHERENCE =
      "$_SERVER_URL/trades/order/contract_adherence";

  // 40: POST Adherence
  static final String GET_ADHERENCE =
      "$_SERVER_URL/trades/order/{orderId}/contract_adherence";

  // 41: PUT Update Schedule
  static final String UPADTE_SCHEDULE =
      "$_SERVER_URL/trades/order/update_schedule";

  // 42: POST Like For News Announcement
  static final String POST_NEWS_LIKE_URL =
      "$_SERVER_URL/announcement/news/like";

  // 43: PUT Update Schedule
  static final String VIEW_ANNOUNCEMENT_URL = "$_SERVER_URL/announcement/view";

// 43: PUT Update Schedule
  static final String SIGNOUT_URL = "$_SERVER_URL/users/sign_out";

  // WebSocket
  static final String WEB_SOCKET_CONNECTION = "$_WEB_SOCKET_SERVER_URL/cable";
}

class ResponseStatus {
  // Status Code
  static final String CONFIRMATION_ERROR_STATUS = 'confirmation_error';
  static final String SUCCESS_STATUS = 'success';
  static final String UNAUTHENTICATION_STATUS = 'authentication_error';
  static final String VALIDATION_ERROR_STATUS = 'validation_error';
  static final String ERROR_STATUS = 'error';
  static final String FAILED_STATUS = 'failed';
}
