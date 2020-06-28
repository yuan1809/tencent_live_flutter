/// from com.tencent.rtmp.TXLiveConstants
class TXLiveConstants{

  static const int VIDEO_RESOLUTION_TYPE_360_640 = 0;
  static const int VIDEO_RESOLUTION_TYPE_540_960 = 1;
  static const int VIDEO_RESOLUTION_TYPE_720_1280 = 2;
  static const int VIDEO_RESOLUTION_TYPE_640_360 = 3;
  static const int VIDEO_RESOLUTION_TYPE_960_540 = 4;
  static const int VIDEO_RESOLUTION_TYPE_1280_720 = 5;
  static const int VIDEO_RESOLUTION_TYPE_320_480 = 6;
  static const int VIDEO_RESOLUTION_TYPE_180_320 = 7;
  static const int VIDEO_RESOLUTION_TYPE_270_480 = 8;
  static const int VIDEO_RESOLUTION_TYPE_320_180 = 9;
  static const int VIDEO_RESOLUTION_TYPE_480_270 = 10;
  static const int VIDEO_RESOLUTION_TYPE_240_320 = 11;
  static const int VIDEO_RESOLUTION_TYPE_360_480 = 12;
  static const int VIDEO_RESOLUTION_TYPE_480_640 = 13;
  static const int VIDEO_RESOLUTION_TYPE_320_240 = 14;
  static const int VIDEO_RESOLUTION_TYPE_480_360 = 15;
  static const int VIDEO_RESOLUTION_TYPE_640_480 = 16;
  static const int VIDEO_RESOLUTION_TYPE_480_480 = 17;
  static const int VIDEO_RESOLUTION_TYPE_270_270 = 18;
  static const int VIDEO_RESOLUTION_TYPE_160_160 = 19;
  static const int VIDEO_RESOLUTION_TYPE_1080_1920 = 30;
  static const int VIDEO_RESOLUTION_TYPE_1920_1080 = 31;

  /// 视频编码质量
  /// 标清：采用 360 × 640 的分辨率
  static const int VIDEO_QUALITY_STANDARD_DEFINITION = 1;
  /// 高清：采用 540 × 960 的分辨率
  static const int VIDEO_QUALITY_HIGH_DEFINITION = 2;
  /// 超清：采用 720 × 1280 的分辨率
  static const int VIDEO_QUALITY_SUPER_DEFINITION = 3;
  /// 连麦场景下的大主播使用
  static const int VIDEO_QUALITY_LINKMIC_MAIN_PUBLISHER = 4;
  /// 连麦场景下的小主播（连麦的观众）使用
  static const int VIDEO_QUALITY_LINKMIC_SUB_PUBLISHER = 5;
  /// 蓝光：采用 1080 × 1920 的分辨率
  static const int VIDEO_QUALITY_ULTRA_DEFINITION = 7;

  /// 采集的视频的旋转角度
  static const int VIDEO_ANGLE_HOME_RIGHT = 0;
  static const int VIDEO_ANGLE_HOME_DOWN = 1;
  static const int VIDEO_ANGLE_HOME_LEFT = 2;
  static const int VIDEO_ANGLE_HOME_UP = 3;

  /// 自定义采集和自定义处理开关
  static const int CUSTOM_MODE_AUDIO_CAPTURE = 1;
  static const int CUSTOM_MODE_VIDEO_CAPTURE = 2;
  static const int CUSTOM_MODE_AUDIO_PREPROCESS = 4;
  static const int CUSTOM_MODE_VIDEO_PREPROCESS = 8;
  /// 画面填充模式
  /// 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
  static const int RENDER_MODE_FULL_FILL_SCREEN = 0;
  /// 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
  static const int RENDER_MODE_ADJUST_RESOLUTION = 1;

  static const int RENDER_ROTATION_PORTRAIT = 0;
  static const int RENDER_ROTATION_LANDSCAPE = 270;
  /// 画面旋转角度
  /// HOME键在下方
  static const int RENDER_ROTATION_0 = 0;
  /// HOME键在左方 （注意：设置前置摄像头录制时是HOME键在右方）
  static const int RENDER_ROTATION_90 = 90;
  /// HOME键在上方
  static const int RENDER_ROTATION_180 = 180;
  /// HOME键在右方（注意：设置前置摄像头录制时是HOME键在左方）
  static const int RENDER_ROTATION_270 = 270;
  /// 本地预览画面的镜像设置功能，默认是AUTO类型。
  static const int LOCAL_VIDEO_MIRROR_TYPE_AUTO = 0;
  static const int LOCAL_VIDEO_MIRROR_TYPE_ENABLE = 1;
  static const int LOCAL_VIDEO_MIRROR_TYPE_DISABLE = 2;

  static const int AUTO_ADJUST_NONE = -1;
  static const int AUTO_ADJUST_LIVEPUSH_STRATEGY = 0;
  static const int AUTO_ADJUST_LIVEPUSH_RESOLUTION_STRATEGY = 1;
  static const int AUTO_ADJUST_REALTIME_VIDEOCHAT_STRATEGY = 5;

  /// 码率自适应算法
  static const int AUTO_ADJUST_BITRATE_STRATEGY_1 = 0;
  static const int AUTO_ADJUST_BITRATE_RESOLUTION_STRATEGY_1 = 1;
  static const int AUTO_ADJUST_BITRATE_STRATEGY_2 = 2;
  static const int AUTO_ADJUST_BITRATE_RESOLUTION_STRATEGY_2 = 3;
  static const int AUTO_ADJUST_REALTIME_BITRATE_STRATEGY = 4;
  static const int AUTO_ADJUST_REALTIME_BITRATE_RESOLUTION_STRATEGY = 5;

  static const int PUSH_EVT_CONNECT_SUCC = 1001;
  static const int PUSH_EVT_PUSH_BEGIN = 1002;
  static const int PUSH_EVT_OPEN_CAMERA_SUCC = 1003;
  static const int PUSH_EVT_SCREEN_CAPTURE_SUCC = 1004;
  static const int PUSH_EVT_CHANGE_RESOLUTION = 1005;
  static const int PUSH_EVT_CHANGE_BITRATE = 1006;
  static const int PUSH_EVT_FIRST_FRAME_AVAILABLE = 1007;
  static const int PUSH_EVT_START_VIDEO_ENCODER = 1008;
  static const int PUSH_EVT_ROOM_IN = 1018;
  static const int PUSH_EVT_ROOM_IN_FAILED = 1022;
  static const int PUSH_EVT_ROOM_OUT = 1019;
  static const int PUSH_EVT_ROOM_USERLIST = 1020;
  static const int PUSH_EVT_ROOM_NEED_REENTER = 1021;
  static const int PUSH_EVT_ROOM_USER_ENTER = 1031;
  static const int PUSH_EVT_ROOM_USER_EXIT = 1032;
  static const int PUSH_EVT_ROOM_USER_VIDEO_STATE = 1033;
  static const int PUSH_EVT_ROOM_USER_AUDIO_STATE = 1034;
  static const int PUSH_ERR_OPEN_CAMERA_FAIL = -1301;
  static const int PUSH_ERR_OPEN_MIC_FAIL = -1302;
  static const int PUSH_ERR_VIDEO_ENCODE_FAIL = -1303;
  static const int PUSH_ERR_AUDIO_ENCODE_FAIL = -1304;
  static const int PUSH_ERR_UNSUPPORTED_RESOLUTION = -1305;
  static const int PUSH_ERR_UNSUPPORTED_SAMPLERATE = -1306;
  static const int PUSH_ERR_NET_DISCONNECT = -1307;
  static const int PUSH_ERR_SCREEN_CAPTURE_START_FAILED = -1308;
  static const int PUSH_ERR_SCREEN_CAPTURE_UNSURPORT = -1309;
  static const int PUSH_ERR_SCREEN_CAPTURE_DISTURBED = -1310;
  static const int PUSH_ERR_MIC_RECORD_FAIL = -1311;
  static const int PUSH_ERR_SCREEN_CAPTURE_SWITCH_DISPLAY_FAILED = -1312;
  static const int PUSH_ERR_INVALID_ADDRESS = -1313;
  static const int PUSH_WARNING_NET_BUSY = 1101;
  static const int PUSH_WARNING_RECONNECT = 1102;
  static const int PUSH_WARNING_HW_ACCELERATION_FAIL = 1103;
  static const int PUSH_WARNING_VIDEO_ENCODE_FAIL = 1104;
  static const int PUSH_WARNING_BEAUTYSURFACE_VIEW_INIT_FAIL = 1105;
  static const int PUSH_WARNING_VIDEO_ENCODE_BITRATE_OVERFLOW = 1106;
  static const int PUSH_WARNING_VIDEO_ENCODE_SW_SWITCH_HW = 1107;
  static const int PUSH_WARNING_DNS_FAIL = 3001;
  static const int PUSH_WARNING_SEVER_CONN_FAIL = 3002;
  static const int PUSH_WARNING_SHAKE_FAIL = 3003;
  static const int PUSH_WARNING_SERVER_DISCONNECT = 3004;
  static const int PUSH_WARNING_READ_WRITE_FAIL = 3005;
  static const int PUSH_WARNING_VIDEO_RENDER_FAIL = 2110;
  static const int PLAY_EVT_CONNECT_SUCC = 2001;
  static const int PLAY_EVT_RTMP_STREAM_BEGIN = 2002;
  static const int PLAY_EVT_RCV_FIRST_I_FRAME = 2003;
  static const int PLAY_EVT_PLAY_BEGIN = 2004;
  static const int PLAY_EVT_PLAY_PROGRESS = 2005;
  static const int PLAY_EVT_PLAY_END = 2006;
  static const int PLAY_EVT_PLAY_LOADING = 2007;
  static const int PLAY_EVT_START_VIDEO_DECODER = 2008;
  static const int PLAY_EVT_CHANGE_RESOLUTION = 2009;
  static const int PLAY_EVT_GET_PLAYINFO_SUCC = 2010;
  static const int PLAY_EVT_CHANGE_ROTATION = 2011;
  static const int PLAY_EVT_GET_MESSAGE = 2012;
  static const int PLAY_EVT_VOD_PLAY_PREPARED = 2013;
  static const int PLAY_EVT_VOD_LOADING_END = 2014;
  static const int PLAY_EVT_STREAM_SWITCH_SUCC = 2015;
  static const int PLAY_EVT_GET_METADATA = 2028;
  static const int PLAY_EVT_GET_FLVSESSIONKEY = 2030;
  static const int PLAY_ERR_NET_DISCONNECT = -2301;
  static const int PLAY_ERR_GET_RTMP_ACC_URL_FAIL = -2302;
  static const int PLAY_ERR_FILE_NOT_FOUND = -2303;
  static const int PLAY_ERR_HEVC_DECODE_FAIL = -2304;
  static const int PLAY_ERR_HLS_KEY = -2305;
  static const int PLAY_ERR_GET_PLAYINFO_FAIL = -2306;
  static const int PLAY_ERR_STREAM_SWITCH_FAIL = -2307;
  static const int PLAY_WARNING_VIDEO_DECODE_FAIL = 2101;
  static const int PLAY_WARNING_AUDIO_DECODE_FAIL = 2102;
  static const int PLAY_WARNING_RECONNECT = 2103;
  static const int PLAY_WARNING_RECV_DATA_LAG = 2104;
  static const int PLAY_WARNING_VIDEO_PLAY_LAG = 2105;
  static const int PLAY_WARNING_HW_ACCELERATION_FAIL = 2106;
  static const int PLAY_WARNING_VIDEO_DISCONTINUITY = 2107;
  static const int PLAY_WARNING_FIRST_IDR_HW_DECODE_FAIL = 2108;
  static const int PLAY_WARNING_DNS_FAIL = 3001;
  static const int PLAY_WARNING_SEVER_CONN_FAIL = 3002;
  static const int PLAY_WARNING_SHAKE_FAIL = 3003;
  static const int PLAY_WARNING_READ_WRITE_FAIL = 3005;
  static const int LOG_LEVEL_VERBOSE = 0;
  static const int LOG_LEVEL_DEBUG = 1;
  static const int LOG_LEVEL_INFO = 2;
  static const int LOG_LEVEL_WARN = 3;
  static const int LOG_LEVEL_ERROR = 4;
  static const int LOG_LEVEL_FATAL = 5;
  static const int LOG_LEVEL_NULL = 6;
  static const String EVT_TIME = "EVT_TIME";
  static const String EVT_DESCRIPTION = "EVT_MSG";
  static const String EVT_PARAM1 = "EVT_PARAM1";
  static const String EVT_PARAM2 = "EVT_PARAM2";
  static const String EVT_GET_MSG = "EVT_GET_MSG";
  static const String EVT_PLAY_COVER_URL = "EVT_PLAY_COVER_URL";
  static const String EVT_PLAY_URL = "EVT_PLAY_URL";
  static const String EVT_PLAY_NAME = "EVT_PLAY_NAME";
  static const String EVT_PLAY_DESCRIPTION = "EVT_PLAY_DESCRIPTION";
  static const String EVT_PLAY_PROGRESS_MS = "EVT_PLAY_PROGRESS_MS";
  static const String EVT_PLAY_DURATION_MS = "EVT_PLAY_DURATION_MS";
  static const String EVT_PLAY_PROGRESS = "EVT_PLAY_PROGRESS";
  static const String EVT_PLAY_DURATION = "EVT_PLAY_DURATION";
  static const String EVT_PLAYABLE_DURATION_MS = "EVT_PLAYABLE_DURATION_MS";
  static const String NET_STATUS_CPU_USAGE = "CPU_USAGE";
  static const String NET_STATUS_VIDEO_WIDTH = "VIDEO_WIDTH";
  static const String NET_STATUS_VIDEO_HEIGHT = "VIDEO_HEIGHT";
  static const String NET_STATUS_VIDEO_FPS = "VIDEO_FPS";
  static const String NET_STATUS_VIDEO_GOP = "VIDEO_GOP";
  static const String NET_STATUS_VIDEO_BITRATE = "VIDEO_BITRATE";
  static const String NET_STATUS_AUDIO_BITRATE = "AUDIO_BITRATE";
  static const String NET_STATUS_NET_SPEED = "NET_SPEED";
  static const String NET_STATUS_AUDIO_CACHE = "AUDIO_CACHE";
  static const String NET_STATUS_VIDEO_CACHE = "VIDEO_CACHE";
  static const String NET_STATUS_AUDIO_DROP = "AUDIO_DROP";
  static const String NET_STATUS_VIDEO_DROP = "VIDEO_DROP";
  static const String NET_STATUS_V_SUM_CACHE_SIZE = "V_SUM_CACHE_SIZE";
  static const String NET_STATUS_V_DEC_CACHE_SIZE = "V_DEC_CACHE_SIZE";
  static const String NET_STATUS_AV_PLAY_INTERVAL = "AV_PLAY_INTERVAL";
  static const String NET_STATUS_AV_RECV_INTERVAL = "AV_RECV_INTERVAL";
  static const String NET_STATUS_AUDIO_CACHE_THRESHOLD = "AUDIO_CACHE_THRESHOLD";
  static const String NET_STATUS_AUDIO_INFO = "AUDIO_PLAY_INFO";
  static const String NET_STATUS_NET_JITTER = "NET_JITTER";
  static const String NET_STATUS_SERVER_IP = "SERVER_IP";
  static const String NET_STATUS_VIDEO_DPS = "VIDEO_DPS";
  static const String NET_STATUS_QUALITY_LEVEL = "NET_QUALITY_LEVEL";
  static const int PAUSE_FLAG_PAUSE_VIDEO = 1;
  static const int PAUSE_FLAG_PAUSE_AUDIO = 2;
  static const String TXRTMPSDK_PUSHEVENT_SOURCE_OPENCAMERA = "TXRTMPSDK_PUSHEVENT_SOURCE_OPENCAMERA";
  static const String TXRTMPSDK_PUSHEVENT_SOURCE_OPENMIC = "TXRTMPSDK_PUSHEVENT_SOURCE_OPENMIC";
  static const String TXRTMPSDK_VIDEO_YUVSOURCE_LOCALCAMERA = "TXRTMPSDK_VIDEO_YUVSOURCE_LOCALCAMERA";
  static const String TXRTMPSDK_AUDIO_PCMSOURCE_LOCALMERGER = "TXRTMPSDK_AUDIO_PCMSOURCE_LOCALMERGER";

  /// 混响类型
  /// 关闭混响
  static const int REVERB_TYPE_0 = 0;
  /// KTV
  static const int REVERB_TYPE_1 = 1;
  /// 小房间
  static const int REVERB_TYPE_2 = 2;
  /// 大会堂
  static const int REVERB_TYPE_3 = 3;
  /// 低沉
  static const int REVERB_TYPE_4 = 4;
  /// 洪亮
  static const int REVERB_TYPE_5 = 5;
  /// 金属声
  static const int REVERB_TYPE_6 = 6;
  /// 磁性
  static const int REVERB_TYPE_7 = 7;

  /// 变声选项
  /// 关闭变声
  static const int VOICECHANGER_TYPE_0 = 0;
  /// 熊孩子
  static const int VOICECHANGER_TYPE_1 = 1;
  /// 萝莉
  static const int VOICECHANGER_TYPE_2 = 2;
  /// 大叔
  static const int VOICECHANGER_TYPE_3 = 3;
  /// 重金属
  static const int VOICECHANGER_TYPE_4 = 4;
  /// 感冒
  static const int VOICECHANGER_TYPE_5 = 5;
  /// 外国人
  static const int VOICECHANGER_TYPE_6 = 6;
  /// 困兽
  static const int VOICECHANGER_TYPE_7 = 7;
  /// 死肥仔
  static const int VOICECHANGER_TYPE_8 = 8;
  /// 强电流
  static const int VOICECHANGER_TYPE_9 = 9;
  /// 重机械
  static const int VOICECHANGER_TYPE_10 = 10;
  /// 空灵
  static const int VOICECHANGER_TYPE_11 = 11;


  static const int ENCODE_VIDEO_SOFTWARE = 0;
  static const int ENCODE_VIDEO_HARDWARE = 1;
  static const int ENCODE_VIDEO_AUTO = 2;
  static const int RTMP_CHANNEL_TYPE_AUTO = 0;
  static const int RTMP_CHANNEL_TYPE_STANDARD = 1;
  static const int RTMP_CHANNEL_TYPE_PRIVATE = 2;
  static const int BEAUTY_STYLE_SMOOTH = 0;
  static const int BEAUTY_STYLE_NATURE = 1;
  static const int BEAUTY_STYLE_HAZY = 2;

  /// 声音播放模式
  static const int AUDIO_ROUTE_SPEAKER = 0;
  static const int AUDIO_ROUTE_RECEIVER = 1;

  /// 系统音量类型
  /// 默认类型，SDK会自动选择合适的音量类型
  static const int AUDIO_VOLUME_TYPE_AUTO = 0;
  /// 仅使用媒体音量，SDK不再使用通话音量
  static const int AUDIO_VOLUME_TYPE_MEDIA = 1;
  /// 仅使用通话音量，SDK一直使用通话音量
  static const int AUDIO_VOLUME_TYPE_VOIP = 2;
}