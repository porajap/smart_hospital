class AppUrl{
  static final String devUrl = "http://192.168.1.110:4002/app/api";
  static final String productionUrl = "https://re-loader.com/api_smarthospital/app/api";

  static final String baseUrl = devUrl;

  static final String checkPhone = "$baseUrl/check-phone";
  static final String cretePin = "$baseUrl/create-pin";
  static final String login = "$baseUrl/login";

  static final String queueByNo = "$baseUrl/queue-by-no";
  static final String booking = "$baseUrl/booking";
  static final String queueToday = "$baseUrl/queue-of-user";
  static final String confirmQueue = "$baseUrl/confirm-queue";
  static final String queueOfFront = "$baseUrl/queue-of-front";
  static final String updateHnCode = "$baseUrl/update-hn";

  static final String dataOfYear = "$baseUrl/data-of-year";
  static final String dataOfDay= "$baseUrl/data-of-day";

  static final String addToken = "$baseUrl/add-token";
}