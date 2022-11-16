class AppUrl{
  static final String devUrl = "http://192.168.1.110:4002/app/api";
  static final String productionUrl = "https://re-loader.com/api_smarthospital/app/api";

  static final String baseUrl = productionUrl;

  static final String checkPhone = "$baseUrl/check-phone";
  static final String cretePin = "$baseUrl/create-pin";
  static final String login = "$baseUrl/login";

  //scan qr create queue
  static final String scanQr = "$baseUrl/scan-qr";

  //for get queue detail is today
  static final String queueToday = "$baseUrl/queue-of-user";

  //for user confirm queue
  static final String confirmQueue = "$baseUrl/confirm-queue";

  //get queue before
  static final String queueOfFront = "$baseUrl/queue-of-front";

  // update hn code
  static final String updateHnCode = "$baseUrl/update-hn";

  static final String booking = "$baseUrl/booking";

  static final String dataOfYear = "$baseUrl/data-of-year";
  static final String dataOfDay= "$baseUrl/data-of-day";

  static final String addToken = "$baseUrl/add-token";
}