class Config{
  static const String appName = "Allam vizsga";
  static const apiURL = "192.168.1.3:8000";
  static const loginAPI = "api/v1/users/login";
  static const registerAPI = "api/v1/users";
  static const getUsersAPI = "api/v1/users";
  static const getLivesByUserAPI = "api/v1/lives/";
  static const getSubjectsAPI ="api/v1/subject";
  static const getChaptersAPI ="api/v1/chapter";
  static const getQuestionsBySubjectAndChapterAPI = "api/v1/question/subject/chapter";
  static const maxQuizIdAPI = "api/v1/statistics/quizId";
  static const createStatAPI="api/v1/statistics";
  static const getLatestQuizAPI="api/v1/statistics/latestQuiz";
  static const getQuestionByIdAPI="api/v1/question/q/b/id";
  static const createResultAPI = "api/v1/results";
  static const getAllResultAPI = "api/v1/results";
  static const getUserResultsAPI = "api/v1/results";
  static const getLeaderBoardAPI = "api/v1/results/leaderboard";
  static const getFlashQuizAPI = "api/v1/flashquiz";
  static const getQuestionByIDs = "api/v1/question/ids";
  static const getQuestionsFromStats= "api/v1/question/fromStats";
}