class AppUrl{
  static final String devUrl = "https://smart-hospital-api.herokuapp.com/api";
  static final String productionUrl = "";

  static final String baseUrl = devUrl;

  static final String checkPhone = "$baseUrl/check-phone";
  static final String cretePin = "$baseUrl/create-pin";
  static final String login = "$baseUrl/login";

  static final String scanQr = "$baseUrl/scan-qr";
  static final String queueToday = "$baseUrl/queue-of-user";
  static final String confirmQueue = "$baseUrl/confirm-queue";
  static final String queueOfFront = "$baseUrl/queue-of-front";
}