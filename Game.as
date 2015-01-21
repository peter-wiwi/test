/**
 * Game.as
 *
 * Main application file for the project 
 */
package {
	
	import Bro.Blit.BlitRenderer;
	import Bro.BroRenderer;
	if ( CONFIG::enable_gpu ) {
		import Bro.Molehill.MolehillRenderer;
	}
	
	import Cache.Init.ZCacheComponent;
	import Cache.Managers.ZCacheLoadingManager;
	
	import Classes.Business;
	import Classes.CityModeManager;
	import Classes.CityRunSpace;
	import Classes.CloudManager;
	import Classes.ConnectionStatus;
	import Classes.ConstructionSite;
	import Classes.Defcon;
	import Classes.EnvironmentTile;
	import Classes.GameModules;
	import Classes.GameViewport;
	import Classes.HelperClickRewardUtil;
	import Classes.HolidayTree;
	import Classes.IdleDialogManager;
	import Classes.Item;
	import Classes.Managers.FreezeManager;
	import Classes.Managers.GameZaspManager;
	import Classes.Managers.MonorailManager;
	import Classes.Managers.TOSManager;
	import Classes.Managers.ZPreloaderManager;
	import Classes.MapResource;
	import Classes.MechanicMapResource;
	import Classes.Quest;
	import Classes.QuestComponent;
	import Classes.QuestComponentOptions;
	import Classes.Road;
	import Classes.StartUpDialogManager;
	import Classes.WatchToEarnGameFacade;
	import Classes.actions.ActionProgressBar;
	import Classes.automation.AutomatedType;
	import Classes.automation.IAutomatedObject;
	import Classes.featuredata.FeatureDataManager;
	import Classes.featuredata.FlashxPromoData;
	import Classes.featuredata.PlayerLoveData;
	import Classes.featuredata.ViralAckData;
	import Classes.gates.GateFactory;
	import Classes.inventory.Commodities;
	import Classes.util.BracketFinder;
	import Classes.util.CITYJSONEncoder;
	import Classes.util.ConsoleHelper;
	import Classes.util.DateUtil;
	import Classes.util.FilterEnum;
	import Classes.util.FrameManager;
	import Classes.util.GameTransactionManager;
	import Classes.util.GameUtil;
	import Classes.util.PaymentsPurchaseManager;
	import Classes.util.RuntimeVariableManager;
	import Classes.util.Sounds;
	import Classes.util.ZDCFeedRedemptionManager;
	import Classes.util.ZyParamsUpdateTracker;
	import Classes.virals.Creatives;
	import Classes.virals.ViralManager;
	import Classes.zbar.ZBarNotifier;
	
	import Display.DialogUI.CheckboxConfirmationDialog;
	import Display.DialogUI.GenericDialog;
	import Display.DialogUI.GlassFactoryBuildableDooberDialog;
	import Display.GenericPopup;
	import Display.RAD.Dialogs;
	import Display.UI;
	import Display.WeddingV1.view.ConsumableDialog;
	import Display.boardFinder.view.BoardFinderUnlockDialog;
	import Display.cityAtNight.view.ThreePanelDialog;
	import Display.cityAtNight.view.BuildDialog;
	import Display.hud.HUDThemeManager;
	import Display.nationalPark.view.NationalParkDialog;
	import Display.roseGarden.view.RoseGardenDialog;
	import Display.subscriptionsAccountManagementview.SubscriptionsAccountManagementDialog;
	import Display.subscriptionsAccountManagementview.SubscriptionsAccountManagementDialogModule;
	import Display.whaleRescue.view.WhaleRescueDialog;
	import Display.wildCard.view.WildCardDialog;
	import Display.newYearsResolution.view.NewYearResolutionDialog;
	
	import Engine.Classes.Viewport;
	import Engine.Classes.ViewportLayer;
	import Engine.Classes.WorldObject;
	import Engine.Classes.ZEngineIsoModules;
	import Engine.Classes.ZEngineOptions;
	import Engine.Constants;
	import Engine.Events.ReloadGameEvent;
	import Engine.Events.TransactionBatchEvent;
	import Engine.Events.TransactionEvent;
	import Engine.Events.TransactionFaultEvent;
	import Engine.Helpers.Box3DFactory;
	import Engine.Init.InitProgress;
	import Engine.Init.InitializationManager;
	import Engine.Managers.CBReportManager;
	import Engine.Managers.ErrorLogManager;
	import Engine.Managers.ErrorManager;
	import Engine.Managers.LoadingManager;
	import Engine.Managers.ProcessManager;
	import Engine.Managers.StatsManager;
	import Engine.Managers.TransactionManager;
	import Engine.Profiler.ProdAggregator;
	import Engine.Profiler.ZPanelUI;
	import Engine.Transactions.Transaction;
	import Engine.Utilities;
	import Engine.Utilities.UncaughtErrors;
	
	import Events.GenericPopupEvent;
	
	import GameMode.GMDebugPathing;
	import GameMode.GMWorldRectExporter;
	
	import Init.AMFDownloadInit;
	import Init.BootstrapInit;
	import Init.ConsoleInit;
	import Init.EffectsInit;
	import Init.EmbeddedArtInit;
	import Init.FontMapperDownloadInit;
	import Init.FontMapperInit;
	import Init.GameBootstrapInit;
	import Init.GameFacebookInit;
	import Init.GameQuestInit;
	import Init.GameSettingsDownloadInit;
	import Init.GameSettingsInit;
	import Init.GlobalsInit;
	import Init.GPUTestResults;
	import Init.LoadingInit;
	import Init.LocalizationInit;
	import Init.PreloadAssetsInit;
	import Init.QuestManagerInit;
	import Init.RenderInit;
	import Init.SNAPIInit;
	import Init.StatsInit;
	import Init.TransactionsInit;
	import Init.UIInit;
	import Init.WatchToEarnInit;
	import Init.WorldInit;
	
	import Mechanics.MechanicManager;
	
	import Modules.IncentivizedExpansions.IncentivizedExpansionsManager;
	import Modules.ScratchCards.ScratchCardCasinoManager;
	import Modules.crafting.CraftCollectionConfig;
	import Modules.guide.GuideInit;
	import Modules.matchmaking.MatchmakingManager;
	import Modules.partnerbuild.PartnerBuildManager;
	import Modules.quest.Display.QuestPopup;
	import Modules.quest.Display.QuestPopupView;
	import Modules.quest.Managers.GameQuest;
	import Modules.quest.Managers.GameQuestUtility;
	import Modules.realtime.RealtimeManager;
	import Modules.realtime.RealtimeObserver;
	import Modules.smartnpcs.SmartNPCManager;
	import Modules.stats.experiments.ExperimentDefinitions;
	import Modules.stats.experiments.ExperimentManager;
	import Modules.stats.trackers.StartupSessionTracker;
	import Modules.stats.types.*;
	
	import Transactions.TGetMFSData;
	import Transactions.TGetVisitMission;
	import Transactions.TGetWatchToEarnConfiguration;
	import Transactions.TProgressQuestTask;
	import Transactions.TRefreshUser;
	import Transactions.TRequestNightChange;
	import Transactions.TSaveOptions;
	import Transactions.TServiceCall;
	import Transactions.TUnwither;
	import Transactions.TGlobalLeaderBoard;//yanzhang
	
	import cipro.Profiler.GameTagManager;
	import cipro.Profiler.RuntimeProfiler;
	
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.zynga.application.IApplication;
	import com.zynga.application.IObjectRegistry;
	import com.zynga.application.validation.IValidationClient;
	import com.zynga.application.validation.IValidationManager;
	import com.zynga.application.validation.ValidationManager;
	import com.zynga.core.util.Utils;
	import com.zynga.localization.LocalizationEvent;
	import com.zynga.profiler.ZyngaProfilerPopupPanel;
	import com.zynga.serialization.JSON;
	import com.zynga.skelly.render.IRenderer;
	import com.zynga.skelly.render.RenderManager;
	
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.aswing.AsWingManager;
	import org.aswing.RepaintManager;
	
	import plugin.ConsoleStub;
	import plugin.MonsterStub;
	import plugin.PluginLoader;
	
	import tool.ObjectEditor;
	import tool.OffsetEditor;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Display.lapsedPayer.view.LapsedPayerDialog;
	import Classes.Residence;
	import Engine.Interfaces.IMetaDataProvider;
	import Display.doubleRainbow.view.DoubleRainbowDialog;
	import Classes.sim.NPCVisitBatchManager;
	import Classes.sim.RoadManager;
	import Classes.Managers.ParadeManager;
	import Display.aplsVillageview.view.AplsVillageDialog;
	import Display.lotteryV2.view.LotteryV2Dialog;
	import Classes.Managers.LotteryManager;
	import Display.globalLeaderboard.GlobalLeaderboardData;
	import Classes.Managers.Data.ParadeItemVO;
	import Classes.announcements.AnnouncementManager;
	import Classes.announcements.AnnouncementData;
	import Display.subscriptionsDialog.view.SubscriptionsDialogSingle;
	import Display.treasureCave.view.TreasureDialog;
	import Display.WorldFilters;


//	import com.demonsters.debugger.MonsterDebugger;
	
	[SWF(backgroundColor="0xffffff", frameRate="30", width="760", height="595")]
	public class Game extends BaseGame implements IApplication, IAutomatedObject {
		
		private const FRAME_RATE:int = 30;
		
		/** If true, some debug information (eg. performance) will be available in production as well as dev */
		public static const DEBUG_PRODUCTION_OVERRIDE :Boolean = false;
		
		/** True while initialization manager is running */
		protected var m_initializing :Boolean;

		/** time variable to track open/close time of FB feed dialogs */
		protected var m_feedOpenTime:Number;

		/** Warning dialog for when transactions are exceeded */
		protected var m_warningDialog:GenericDialog;
		
		private var debug_defcon:int = 0; // for testing defcon.
		
		private var m_zmcFreeze:Boolean=false;
		private var m_zmcFreezeCount:int = 0;
		private var m_zmcOpen:Boolean = false;
		
		/** Collection of transaction tracking datas for determining 'saving your city' issues. */
		private var m_pendingTransactionData:Dictionary = new Dictionary();
		private var m_completedTransactionData:Vector.<TransactionTrackingData> = new Vector.<TransactionTrackingData>();

		/** Collection of batch datas for determining 'saving your city' issues. */
		private var m_pendingBatchData:Vector.<BatchTrackingData> = new Vector.<BatchTrackingData>();
		private var m_completedBatchData:Vector.<BatchTrackingData> = new Vector.<BatchTrackingData>();

		private var m_preloaderDone:Boolean = false;

		/** Have we finished initialization? */
		private var m_initComplete:Boolean = false;

		protected var m_runspace:CityRunSpace;

		private var m_currentOverlayTintConfig:int = 0;
		
		private var m_validationManager:IValidationManager;
		
		private var m_heartbeatTimer : Timer;

		/** Profiling sampler properties. */
		//private var m_enterFrameEnabled:Boolean = true;
		//private var m_updateWorldEnabled:Boolean = true;
		//private var m_processMgrEnabled:Boolean = true;
		
		private static const ALLOWED_DOMAINS:Array = [
			"zcache.zgncdn.com",
			"city-s.assets.zgncdn.com",
			"city-s.assets1.zgncdn.com",
			"city-s.assets2.zgncdn.com",
			"city-s.assets3.zgncdn.com",
  			"zynga1-a.akamaihd.net",
  			"zynga2-a.akamaihd.net",
  			"zynga3-a.akamaihd.net",
  			"zynga4-a.akamaihd.net",
  			"zyngacv.hs.llnwd.net",
			"cityville-zc2.assets1.zgncdn.com",
			"cityville-zc2.assets2.zgncdn.com",
			"cityville-zc2.assets3.zgncdn.com",
			"cityville-zc2.assets4.zgncdn.com",
  			"cityvillefb.static.zgncdn.com"
  		];

		/** Array of crashbusters log information - earlier traces occur first in the list */
		private static var m_CBTraceLog:Array = [];

		/** Get the last game state description before we open an OOS window for crashbusters */
		private var m_lastStateDetail:String = "";

		/** Used to send CB Report to the server. */
		private var m_transactionLogLoader:URLLoader = null;
		
		private static const DELAY_FOR_STATS_SEND:int = 1000;
		
		/** constructor */
		public function Game(params:Object=null) {
						
			// start game heartbeat
			startHeartbeat();

			GlobalEngine.print("Game constructor");
			
			this.m_validationManager = new ValidationManager( this );

			// Preloader may not have been loaded from the same domain, ensure
			// cross-domain scripting is allowed.
			for each (var domain:String in ALLOWED_DOMAINS) {
				Security.allowDomain(domain);
			}

			// start with profiler disabled
			ZProfiler.stopProfile();
			ZProfiler.discardProfile();
			GameTagManager.initialize(new CityModeManager());
			ZEngineIsoModules.initialize();
			GameModules.initialize();
			
			var profCookie:int = RuntimeProfiler.enter(GameModules.GameConstructor);
			
			// Engine options
			var engineOptions:ZEngineOptions=new ZEngineOptions;
			engineOptions.viewportClass=GameViewport;
			engineOptions.zaspManagerClass = GameZaspManager;
			engineOptions.loadingManagerClass = ZCacheLoadingManager;
			engineOptions.addComponent(new ZCacheComponent());
			engineOptions.tileWidth=10;
			engineOptions.tileHeight=5;
			
			var options :QuestComponentOptions = new QuestComponentOptions();
			options.questClass = GameQuest;
			options.questUtility = GameQuestUtility;
			options.questInitClass = GameQuestInit;
			engineOptions.addComponent(new QuestComponent(options));
			
			this.enableErrorLogging();
			super(params,engineOptions);
			
			RuntimeProfiler.leave(profCookie);	
		}

		public function getArgument( name:String ) : Object
		{
			return GlobalEngine.getFlashVar( name );
		}
		
		public function markInvalid( client:IValidationClient ) : void
		{
			m_validationManager.markInvalid( client );
		}
		
		/** @inheritDoc */
		override protected function initLogging():void {
			super.initLogging();
			
			if (Config.DEBUG_MODE) {
				Config.verboseLogging = true;
				GlobalEngine.addTraceLevel("Loader", GlobalEngine.LEVEL_WARNING);
				GlobalEngine.addTraceLevel("StateMachine", GlobalEngine.LEVEL_WARNING);
				GlobalEngine.addTraceLevel("QuestManager", GlobalEngine.LEVEL_ALL);
				GlobalEngine.addTraceLevel("Guide", GlobalEngine.LEVEL_ALL);
				GlobalEngine.addTraceLevel("Doobers", GlobalEngine.LEVEL_ALL);
				GlobalEngine.addTraceLevel("AMFConnection", GlobalEngine.LEVEL_ALL);
				GlobalEngine.addTraceLevel("ZCache", GlobalEngine.LEVEL_ALL);
				GlobalEngine.addTraceLevel("Init", GlobalEngine.LEVEL_ALL);
				// (CMB) Disabling Bro logging - it is spamming the logs.
				GlobalEngine.addTraceLevel("Bro", GlobalEngine.LEVEL_NONE);
			}
		}
		
		/** Perform game initialization */
		override protected function init():void {
			initSamplers();
			StartupSessionTracker.gameLoadDone();
			StartupSessionTracker.track(StatsPhylumType.STARTUP_GAME_INIT);
            StartupSessionTracker.perf(StatsKingdomType.LOADAPP);

			Global.stage = this.stage;
			Global.parameters = this.parameters;
			
			if (Global.parameters.hasOwnProperty("ZPanelEnabled") && Global.parameters.ZPanelEnabled == "true") {
				ZPanelUI.enable(Global.parameters);
			}
			
			// for fluid canvas we want to stay centered until the UI is ready
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// activate desired Tweenlite plugins
			TweenPlugin.activate([GlowFilterPlugin]);
			
			RenderManager.init(GlobalEngine.viewport as IRenderer,stage,FRAME_RATE,false);
			// UIManager.setLookAndFeel() was moved to Init.UIInit.execute()
			// because this must be done after FontMapperInit completed to use locale fonts
			// and before stating TInitUser where HUDs are refreshed.
			//UIManager.setLookAndFeel( new CityASwingSkin() );
			//AsWingManager.setRoot( ApplicationCanvas.defaultRoot );
			Global.stage.stageFocusRect = false;  //do we need this??
			
			var bootstrapUrl:String = Config.BASE_PATH + "bootstrap.xml";
			var requestedLocale:String = GlobalEngine.getFlashVar("locale") ? GlobalEngine.getFlashVar("locale").toString() : "en_US";
			var effectsUrl:String = Config.BASE_PATH +"effectsConfig.xml";
			var embeddedArtUrl:String = Config.BASE_PATH + "EmbeddedArt.swf";
			
			if (parameters.hasOwnProperty('batch_profile')) {
				var batchProfile:int = int(parameters.batch_profile);
				if (batchProfile > 0) {
					if (batchProfile > 15) {
						batchProfile = 15;
					}
					TransactionManager.amfMaxPerBatch = 10 + 2 * batchProfile;
					TransactionManager.amfMaxWait = 7000 + 2000 * batchProfile;
					NPCVisitBatchManager.maxBatchDelaySeconds = 100 + 10 * batchProfile;
					NPCVisitBatchManager.maxMechanicsAffected = 60 + 6 * batchProfile;
					NPCVisitBatchManager.maxNumberOfUpdates = 120 + 12 * batchProfile;
				}
			}

			if (parameters.hasOwnProperty('batch_stats_sample_rate')) {
				TransactionManager.amfBatchStatsSampleRate = int(parameters.batch_stats_sample_rate);
			}
			
			// bootstrap.xml
			if (parameters.bootstrap_config_url) {
				bootstrapUrl = parameters.bootstrap_config_url;
			}
			
			// effectsConfig.xml
			if (parameters.effects_config_url) {
				effectsUrl = parameters.effects_config_url;
			}
			
			if (parameters.visitId) {
				Global.setVisiting(parameters.visitId);
			}

			if (parameters.useHttps) {
				Config.SERVICES_GATEWAY_PATH += "?useHttps=1";
			}
			
			if (parameters.embedded_art_url) {
				embeddedArtUrl = parameters.embedded_art_url;
			}
			
			// Parse experiments here so that we have access to them inside of
			// initialization actions.
			Global.experimentManager = new ExperimentManager();
			Global.experimentManager.init();
			initDAPI();
			
			// record whether asset packs are enabled
			LoadingManager.useAssetPacks = (GlobalEngine.getFlashVar("useAssetPacks") == "true");
			
			Box3DFactory.optimizeVector3Allocs = Global.experimentManager.inFramerateExperiment(ExperimentDefinitions.EXPERIMENT_OPTIMIZE_BOX3D);
			
			// start initialization
			m_initializing = true;
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.FAULT, onInitTransactionFault);
			
			// Add a listener to force refresh the game if requested.
			GlobalEngine.stage.addEventListener(ReloadGameEvent.RELOAD_GAME, onForceReloadGame);
			
			// Initialize the runtime variables first so they are available for all init actions.
			RuntimeVariableManager.init(ExternalInterface.call("getRuntimeVars"));
			
			Config.IS_TEST_ENVIRONMENT = RuntimeVariableManager.getBoolean("IS_TEST_ENVIRONMENT", false);
			
			ProcessManager.TASK_GREED = RuntimeVariableManager.getNumber("ASYNC_CLIENT_TASK_GREED", 0.8);
			ProcessManager.TASK_TICKS = RuntimeVariableManager.getInt("ASYNC_CLIENT_TASK_TICKS", 45);
			
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.FORCE_RELOAD, onInitTransactionFault);
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.RETRY, onInitTransactionFault);
			TransactionManager.getInstance().addEventListener(TransactionEvent.VERSION_MISMATCH, onInitTransactionFault);
			
			var initManager:InitializationManager = GlobalEngine.initializationManager;
			initManager.add(new RenderInit());
			if (Config.DEBUG_MODE) {
				initManager.add(new BootstrapInit(bootstrapUrl));
				initManager.add(new ConsoleInit());
			}
			initManager.add(new LoadingInit());
			initManager.add(new PreloadAssetsInit(GlobalEngine.getFlashVar("preloaded_asset_urls") as String));
			initManager.add(new GameSettingsDownloadInit());
			initManager.add(new GameSettingsInit());
			initManager.add(new EmbeddedArtInit(embeddedArtUrl));
			initManager.add(new LocalizationInit());
			initManager.add(new GameBootstrapInit(this));
			
			var skipFacebook:Boolean = (parameters.skipFacebook == true);
			if (GlobalEngine.getFlashVar('snapiEnable')!=null && parseInt(GlobalEngine.getFlashVar('snapiEnable').toString())==1) {
				initManager.add(new SNAPIInit(skipFacebook));
			} else {
				initManager.add(new GameFacebookInit(skipFacebook));
			}
			
			initManager.add(new AMFDownloadInit());
			initManager.add(new QuestManagerInit());
			initManager.add(new TransactionsInit());
			initManager.add(new GlobalsInit());
			initManager.add(new UIInit());
			initManager.add(new FontMapperDownloadInit());
			initManager.add(new FontMapperInit());
			initManager.add(new GuideInit());
			initManager.add(new EffectsInit(effectsUrl));
			initManager.add(new StatsInit(initManager));
			initManager.add(new WatchToEarnInit());
			initManager.add(new WorldInit());

			initManager.addEventListener(ProgressEvent.PROGRESS, onInitProgress);
			initManager.addEventListener(Event.COMPLETE, onAllInitComplete);
			initManager.execute();
			
			// add an event listener for errors
			if (Config.DEBUG_MODE) {
				ErrorManager.getInstance().addEventListener(ErrorEvent.ERROR, onError);
			}

			BracketFinder.test_getBracketedSubstrings();
			BracketFinder.test_substituteBracketedSubstrings();
		}
		
		private function onForceReloadGame(e:ReloadGameEvent):void {
			var message:String = ZLoc.t("Main", "RefreshGame", {'error': 0, 'errorMsg': e.message});
			UI.displayMessage(message, GenericPopup.TYPE_OK, function (event:GenericPopupEvent = null):void {
				GameUtil.reloadApp();
			}, "", true);
		}
		
		/** called whenever the initialization manager completes an action - redispatched for preloader */
		private function onInitProgress(e:ProgressEvent):void {
			dispatchEvent(e);
		}
		
		/** initializes the various ProfilerSampler samplers for top level Game object */
		private function initSamplers():void {
			var self:Game = this;
			
			ZyngaProfilerPopupPanel.addSampler({ category:"Game", name:"FrameTime", units:"ms", tagName:"Mode:All:Frame.time", rateName:"Mode:All:Frame.count", nominal:33, minimum:0, maximum:500 }); 

			ZyngaProfilerPopupPanel.addSampler({ category:"Game", name:"EnterTime", units:"ms", tagName:"Mode:All:Game.onEnterFrame.time", rateName:"Mode:All:Game.onEnterFrame.count", nominal:33, minimum:0, maximum:500
//				,isToggledFunc:function():Boolean { return self.m_enterFrameEnabled; },
//				toggleFunc:function(on:Boolean):void { self.m_enterFrameEnabled = on; } 
				});

			ZyngaProfilerPopupPanel.addSampler({ category:"Game", name:"UpdateWorld", units:"ms", tagName:"Mode:All:GameWorld.UpdateWorld.time", rateName:"Mode:All:GameWorld.UpdateWorld.count", nominal:33, minimum:0, maximum:500
//				, 
//				isToggledFunc:function():Boolean { return self.m_updateWorldEnabled; },
//				toggleFunc:function(on:Boolean):void { self.m_updateWorldEnabled = on; } 
				});
			
			ZyngaProfilerPopupPanel.addSampler({ category:"Game", name:"ProcessMgr", units:"ms", tagName:"Model:All:ProcessManager.onEnterFrame.time", rateName:"Model:All:ProcessManager.onEnterFrame.count", nominal:33, minimum:0, maximum:500
//				, isToggledFunc:function():Boolean { return self.m_processMgrEnabled; },
//				toggleFunc:function(on:Boolean):void { self.m_processMgrEnabled = on; } 
				});
		}

		private function initDAPI():void {
			var connections:Object=ExternalInterface.call("SNAPI.getAllConnections");
			var connectionFacebook:Object = (connections) ? connections[Constants.FACEBOOK_NETWORK] : null;

			if (connectionFacebook &&
					connectionFacebook.hasOwnProperty('session') &&
					connectionFacebook.session.hasOwnProperty('access_token') && connectionFacebook.session.hasOwnProperty('user_id')) {

				var userData:Object=ExternalInterface.call("getUserInfo");
				if(userData != null && userData.hasOwnProperty('zid')) {
					var experimentEnable:Boolean = Global.experimentManager.getVariant(ExperimentDefinitions.EXPERIMENT_CV_OPT_STATS) > 2;
					StatsManager.init(userData.zid, GlobalEngine.getFlashVar('zlive_app_id').toString(), connectionFacebook.session, experimentEnable);
				}
			}
		}
	

		private function displayUI():void {
			GlobalEngine.stage.align = StageAlign.TOP_LEFT;

			var numChildren:int = GlobalEngine.viewport.numChildren;
			for (var i:int = 0; i < numChildren; i++) {
				var child:DisplayObject = GlobalEngine.viewport.getChildAt(i);
				var childLayer:ViewportLayer = child as ViewportLayer;
			}
			
			addChild(GlobalEngine.viewport);

			Global.world.centerCityView(0);
			addChild(Global.worldFilters);
			addChild(Global.ui);

			UI.pumpPopupQueue();
		}

		public function preloaderDone(dialogShown:Boolean, zcacheAllowed:Boolean, zcacheAllowedPrior:Boolean):void {
			m_preloaderDone = true;	

			// If initialization completed before the preloader, display the UI
			// now. Otherwise we will do so when initialization finishes. 
			if (m_initComplete) {
				displayUI();
			}

			if (dialogShown || zcacheAllowedPrior) {
				StatsManager.count("Zcache_Stats", dialogShown.toString(), zcacheAllowed.toString(), zcacheAllowedPrior.toString());
			}
		}

		/** The function is called whenever all initialization is done */
		private function onAllInitComplete(ev:Event):void {
			m_initializing = false;
			m_initComplete = true;

			StartupSessionTracker.track(StatsPhylumType.STARTUP_GAME_INIT_COMPLETE);
			
			StartupSessionTracker.interactive();
			StartUpDialogManager.interactive = true;
			
			var flash_info:Array = Utilities.logMachineInfo();
			StatsManager.count("Flash_Info",flash_info[0],flash_info[1],flash_info[2],flash_info[3],flash_info[4]);
			
			TransactionManager.getInstance().removeEventListener(TransactionFaultEvent.FAULT, onInitTransactionFault);
			TransactionManager.getInstance().removeEventListener(TransactionFaultEvent.FORCE_RELOAD, onInitTransactionFault);
			TransactionManager.getInstance().removeEventListener(TransactionFaultEvent.RETRY, onInitTransactionFault);
			TransactionManager.getInstance().removeEventListener(TransactionEvent.VERSION_MISMATCH, onInitTransactionFault);
			
			ZyParamsUpdateTracker.initialize();
			
			var metaDataProvider:TransactionMetaDataProvider = new TransactionMetaDataProvider();
			var secureRandFaultSampleRate:int = int(GlobalEngine.getFlashVar('secureRandFaultSampleRate'));
			if (secureRandFaultSampleRate == 1 || ((Global.player.snUser.snuid % secureRandFaultSampleRate) == 1)) {
				metaDataProvider.addProvider(new SecureRandMetaDataProvider());
			}
			if (Global.player.energyDeltaLogEnabled()) {
				metaDataProvider.addProvider(new EnergyDeltaMetaDataProvider());
			}
			if (!metaDataProvider.empty) {
				TransactionManager.metaDataProvider = metaDataProvider;
			}
			
			// add an event listener to update the world
			GlobalEngine.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			GlobalEngine.stage.addEventListener(Event.RESIZE, onResize);
			GlobalEngine.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChanged);
			GlobalEngine.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveFrame);

			// add an event listener to track translation errors
			GlobalEngine.stage.addEventListener(LocalizationEvent.MISSING_TOKEN, recordMissingLoc);
			GlobalEngine.stage.addEventListener(LocalizationEvent.MISSING_TRANSLATION, recordMissingLoc);
			
			GlobalEngine.viewport.setZoom(Global.gameSettings.getNumber('defaultZoom'));
			GlobalEngine.viewport.width  = Global.ui.screenWidth;
			GlobalEngine.viewport.height = Global.ui.screenHeight;
			GlobalEngine.viewport.scaleX = 1 / Global.ui.screenScale;
			GlobalEngine.viewport.scaleY = 1 / Global.ui.screenScale;
			this.scaleX = this.scaleY = Global.ui.screenScale;
			
			// If the preloader finished before us, display the UI now. Otherwise
			// we will do so when the preloader completes. 
			if (m_preloaderDone || this.parent == Global.stage) {
				displayUI();
			}
			
			// Play music
			Sounds.unpauseMusic();
			
			// Put a listener in to make idle timer work
			GlobalEngine.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 3);
			GlobalEngine.stage.addEventListener(MouseEvent.CLICK, onStageMouseClick, false, 3);
			GlobalEngine.stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 3);
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			// Add event listeners for transactions
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.FAULT, onTransactionFault);
			TransactionManager.getInstance().addEventListener(TransactionEvent.QUEUE_LIMIT_EXCEEDED, onTransactionQueueLimitExceeded);
			TransactionManager.getInstance().addEventListener(TransactionEvent.QUEUE_LIMIT_NORMAL, onTransactionQueueLimitNormal);
			TransactionManager.getInstance().addEventListener(TransactionEvent.VERSION_MISMATCH, onTransactionVersionMismatch);
			TransactionManager.getInstance().addEventListener(TransactionEvent.RETRY_SUCCESS, onTransactionRetrySuccess);
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.DOOBER_MISMATCH, onTransactionDooberMismatch);
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.RETRY, onTransactionRetry);
			TransactionManager.getInstance().addEventListener(TransactionEvent.ADDED, onTransactionAdded);
			TransactionManager.getInstance().addEventListener(TransactionEvent.DISPATCHED, onTransactionDispatched);
			TransactionManager.getInstance().addEventListener(TransactionEvent.COMPLETED, onTransactionCompleted);
			TransactionManager.getInstance().addEventListener(TransactionBatchEvent.BATCH_DISPATCHED, onTransactionBatchDispatched);
			TransactionManager.getInstance().addEventListener(TransactionBatchEvent.BATCH_COMPLETE, onTransactionBatchCompleted);
			TransactionManager.getInstance().addEventListener(TransactionFaultEvent.FORCE_RELOAD, onTransactionForceReload);
			
			if (parameters.missionType && parameters.missionHostId) {
				GameTransactionManager.addTransaction(new TGetVisitMission(parameters.missionHostId, parameters.missionType), true);
			}
			
			// Create JS callbacks
			try {
				if (ExternalInterface.available) {
					ExternalInterface.addCallback("enableAllInput", enableAllInput);
					ExternalInterface.addCallback("disableAllInput", disableAllInput);
					ExternalInterface.addCallback("logShowFeedDialog", logShowFeedDialog);
					ExternalInterface.addCallback("logCloseFeedDialog", logCloseFeedDialog);
					ExternalInterface.addCallback("permissionDialogClosed", permissionDialogClosed);
					ExternalInterface.addCallback("cipPermissionDialogClosed", cipPermissionDialogClosed);
					ExternalInterface.addCallback("extendedPermissionsDialogClosed", extendedPermissionsDialogClosed);
					ExternalInterface.addCallback("onShowPostTOSPermissionsClose", extendedPermissionsDialogClosed);
					ExternalInterface.addCallback("onFocus", onFocus);
					ExternalInterface.addCallback("frameLoadComplete", FrameManager.frameLoadComplete);
					ExternalInterface.addCallback("freezeGame", freezeGame);
					ExternalInterface.addCallback("ZMCFreezeGame", ZMCFreezeGame);
					ExternalInterface.addCallback("thawGame", thawGame);
					ExternalInterface.addCallback("onZMCEvent", onZMCEvent);
					ExternalInterface.addCallback("onZMCOpen", onZMCOpen);
					ExternalInterface.addCallback("onZMCClose", onZMCClose);
					ExternalInterface.addCallback("setZBarQueue", setZBarQueue);
					ExternalInterface.addCallback("onZMCLoad", onZMCLoad);
					ExternalInterface.addCallback("onRTStatusChange",RealtimeManager.onRTStatusChange);
					ExternalInterface.addCallback("onRTChat", RealtimeManager.onRTChat);
					ExternalInterface.addCallback('getScreenshot', FreezeManager.exportScreenshot);
					ExternalInterface.addCallback("onRequestSent", onRequestSent);
					ExternalInterface.addCallback("processZDCFeedRedemtionOnClient", processZDCFeedRedemtionOnClient);					
					ExternalInterface.addCallback("runGrantGoodsOnClient", runGrantGoodsOnClient);
					ExternalInterface.addCallback("processInAppPurchaseOnClient",processInAppPurchaseOnClient);
					ExternalInterface.addCallback("hasPurchaseHandler",hasPurchaseHandler);
					ExternalInterface.addCallback("openWeklySubscriptionPopup",openWeklySubscriptionPopup);
					ExternalInterface.addCallback("hideSubscriptionLoading",hideSubscriptionLoading);
					ExternalInterface.addCallback("openSubscriptionFBPop",openSubscriptionFBPop);
					ExternalInterface.addCallback("mute", Sounds.mute);
					ExternalInterface.addCallback("unmute", Sounds.unmute);
					ExternalInterface.addCallback("restartMusic", Sounds.restartMusic);
                    ExternalInterface.addCallback("getWatchedCounters", getWatchedCounters);
					
					/* for testing */
					ExternalInterface.addCallback("getZoom", js_getZoom);
					ExternalInterface.addCallback("zoomIn", js_zoomIn);
					ExternalInterface.addCallback("zoomOut", js_zoomOut);
					ExternalInterface.addCallback("quickNav", js_quickNav);
					ExternalInterface.addCallback("getCiproSessionId", js_getCiproSessionId);
					
					
					ExternalInterface.call("notifyJSClientIsReady",uint(GlobalEngine.getTimer() / 1000));
				} else {
					StatsManager.count("errors", "external_interface_not_supported");
				}
			} catch (error:Error) {
				StatsManager.count("errors", "external_interface_threw_error");
			}
			
			// Asset postloading.
			if (Global.player.isNewPlayer) {
				Global.guide.loadLaterStepAssets();
			}
			
			Global.delayedAssets.addEventListener(Event.COMPLETE, onDelayedAssetsLoadComplete);
			Global.delayedAssets.startPostloading();
			
			Global.gameSettings.startPostLoading();
			
			// Setup creatives on the client, for in game feeds.
			var creativesUrl:String = Config.BASE_PATH + "creatives.xml";
			if (parameters.creatives_url) {
				creativesUrl = parameters.creatives_url;
			}
			Global.creatives = new Creatives(creativesUrl);
			
			var craftCollection:String = Config.BASE_PATH + "craft_collections.xml";
			if (parameters.craft_collections_config_url) {
				craftCollection = parameters.craft_collections_config_url;
			}
			Global.craftCollectionConfig = new CraftCollectionConfig(craftCollection);
			// delay loading of sounds if the experiment is enabled and the sfx sounds are disabled
			if (!(Global.player.options['sfxDisabled'] ==  true)) {
				Sounds.startPostloading();
			}
			
			// the server will have populated the rewards for the next reward version if the experiment is on or if the version changed
			var sweepstakesRewardData:PlayerLoveData = FeatureDataManager.instance.getFeatureDataClass("playerLove") as PlayerLoveData
			if (sweepstakesRewardData.hasRewards()) {
				sweepstakesRewardData.popDialog();
			}
			
			// flash xpromo feature - user get rewarded if upgrades from old flash version
			var flashxpromoRewardData:FlashxPromoData = FeatureDataManager.instance.getFeatureDataClass("flashxPromo") as FlashxPromoData
			
			//need to pop a toaster @ startup if in the user deserves the reward
			if (flashxpromoRewardData.mustGetReward()) {
				flashxpromoRewardData.getReward();
			}	
			//need to mark in the blob if the user has an old version of flash
			if (!flashxpromoRewardData.isFlashCurrentlyUpdated()) {
				flashxpromoRewardData.setHadOldFlash();
			}

			Global.achievementsManager.startFullUpdate();
			
			if (Global.ui) { // Pop up an empty friend bar while we load neighbor data. 
				UI.populateFriendBarData([]);
				Global.ui.m_friendBar.preload=true;
				Global.ui.m_friendBar.populateNeighbors(Global.friendbar);
				Global.ui.setFriendBarPos(0);
				Global.ui.m_friendBar.preload=false;
				HUDThemeManager.refreshChosenTheme();
			}
			
			GameTransactionManager.addTransaction(new Transactions.TInitNeighbors());
			
			// Get MFS Data
			GameTransactionManager.addTransaction(new Transactions.TGetMFSData());
			
			trace("Game init finished in " + flash.utils.getTimer() / 1000.0 + " s");
			
			Global.world.startPerformanceTracking();
			
			GlobalLeaderboardData.queryAll();//yanzhang
			GlobalLeaderboardData.refreshLB();//yanzhang
				
			
			StatsManager.count("transaction_max_queued_increased");
			TransactionManager.maxQueued = TransactionManager.DEFAULT_MAX_QUEUED * 4;
			
			//add the realtime observer which sends out realtime notifications on observed actions		
			RealtimeManager.m_realtimeObserver = new RealtimeObserver();
			
			// postpone this test until experiment manager has been initialized.
			var useTimerVariant:int =  Global.experimentManager.getVariant(ExperimentDefinitions.EXPERIMENT_TRIGGER_REPAINT);
			if (useTimerVariant == ExperimentDefinitions.USE_EVENT_TO_TRIGGER_REPAINT) {
				RepaintManager.getInstance().setAlwaysUseTimer( false );
			} else { 
				RepaintManager.getInstance().setAlwaysUseTimer( true, FRAME_RATE );
			}
			AsWingManager.setPreventNullFocus( false ); 
			
           if (WatchToEarnGameFacade.legacyEnabled) {
 				GameTransactionManager.addTransaction(new TGetWatchToEarnConfiguration(), true);
 			}

			var objectRegistry:IObjectRegistry = Global.objectRegistry;
			objectRegistry.publish( FeatureDataManager.instance )
						  .publish( IncentivizedExpansionsManager.instance )
						  .publish( MatchmakingManager.instance )
						  .publish( MechanicManager.getInstance() )
						  .publish( SmartNPCManager.instance )
						  .publish( ViralAckData.instance )
						  .publish( Global.questManager )
						  .publish( GlobalEngine.viewport, Viewport );
			
			// Now that we are finished initializing, cleanup any settings data
			// that was passed from the preloader.
			Global.parameters["settings"] = null;
			
			// We don't use BroCanvas with the blit renderer - support blit
			// background behavior by simply adding the overlayBase container to
			// the overlay viewport layer.
			if (BroRenderer.currentRenderer is BlitRenderer) {
				GlobalEngine.viewport.realOverlayBase.addChild(GlobalEngine.viewport.overlayBase);
			}
			
			// Record the results of the GPU test.
			GPUTestResults.log();
			if (Global.neighborCardManager&&Global.neighborCardManager.enabled){
				Global.neighborCardManager.notifyAllInitSuccess();
				Global.ui.m_friendBar.refreshNeighborCardTxt();
		}
		}
		
		/** This is really buggy. It works by focusing your game on a specific building on start instead of the random center.
		 *  BUT, if this is enabled in the FTUE, it will break the ftue. This needs additional work to make it avoid any tutorials
		 * */
		private function chooseInitialFocusPoint():void {
			var buildingsOfInterest:Array = new Array();
			
			// Grab list of all resources in world and process.
			var allResources:Array = Global.world.getObjectsByClass(MapResource);
			var gateFactory:GateFactory = new GateFactory();
			var costToComplete:int = 0;
			for each (var resource:MapResource in allResources) {
				if (resource is ConstructionSite) {
					// Construction site.
					var site:ConstructionSite = resource as ConstructionSite;
					if (site) {
						if(site.isExpansionLocked() == false && site.currentState == ConstructionSite.STATE_AT_GATE){
							buildingsOfInterest.push(resource);
						}
					}
				} else if (resource.isUpgradePossible()) {
					buildingsOfInterest.push(resource);
				}
			}
			
			if (buildingsOfInterest.length > 0) {
				var tempSeed:Number = DateUtil.getUnixTime() / 60;
				GameUtil.srand(tempSeed);
				var indexToUse:int = GameUtil.rand(0, buildingsOfInterest.length - 1);
				Global.world.centerOnObject(buildingsOfInterest[indexToUse], 0);
			}
		}
		
		/** Callback for missing Localization Event */
		private function recordMissingLoc(event:LocalizationEvent):void {
			StatsManager.sample(100, StatsCounterType.MISSING_TRANSLATION, event.type, event.data.pkg, event.data.key, ZLoc.instance.localeCode);
		}
		
		/** Callback on delayed assets load complete */
		private function onDelayedAssetsLoadComplete(event:Event):void {
			Global.delayedAssets.removeEventListener(Event.COMPLETE, onDelayedAssetsLoadComplete);
			StartupSessionTracker.perf(StatsKingdomType.LOADCOMPLETE);
			ZPreloaderManager.init();
		}
		
		/** Callback for transaction events during initialization, while the preloader is up */
		private function onInitTransactionFault(event:TransactionEvent):void {
			var errorType :String = ""; 
			var errorData :String ="";
			if (event is TransactionFaultEvent) {
				var faultEvent:TransactionFaultEvent = event as TransactionFaultEvent;	
				errorType = faultEvent.errorType.toString();
				errorData = (faultEvent.errorData) ? faultEvent.errorData.toString() : "";
				logErrorStats(faultEvent, true);
			}
			var message :String = "Error #" + errorType + ": " + errorData;
			InitializationManager.getInstance().setLastProgressOverride(InitProgress.TRANSACTIONS_INIT);
			handleInitError(new Error(message));
		}

		/** Callback for transaction events */
		private function onTransactionFault(event:TransactionFaultEvent):void {
			if (Config.DEBUG_MODE) {
				UI.displayMessage("errorData: " + event.errorData, GenericPopup.TYPE_OK, GameUtil.redirectHome, "", true);
				logErrorStats(event); 
			} else if (event.errorType == Transaction.OUTDATED_GAME_VERSION) {
				onTransactionVersionMismatch();
			} else {
				onTransactionGeneralError(event);
			}
		}
		
		/** Callback for transaction doober mismatch */
		private function onTransactionDooberMismatch(event:TransactionFaultEvent):void {
			if (Config.DEBUG_MODE) {
				UI.displayMessage("Doober state mismatch: " + event.errorData, GenericPopup.TYPE_OK, GameUtil.redirectHome, "", true);
				logErrorStats(event); 
			} else {
				onTransactionGeneralError(event);
			}			
		}

		/** Callback for when a transaction has failed to connect with the server and the client is retrying */
		private function onTransactionRetry(event:TransactionFaultEvent):void {
			var timeout:int = Global.gameSettings.getInt("gameConnectionMaxTimeout", 30) * 1000;
			ConnectionStatus.startTimeout(ConnectionStatus.TIMEOUT_CONNECTION_LOST, timeout, true, onConnectionTimeout);
		}

		/**
		 * Callback for when a transaction was added. This is specifically used to determine the
		 * time a transaction took to complete, and use for tracking purposes.
		 */
		private function onTransactionAdded(e:TransactionEvent):void {
			m_pendingTransactionData[e.transaction.getId()] = new TransactionTrackingData(e.transaction);
		}

		/**
		 * Callback for when a transaction was dispatched.
		 */
		private function onTransactionDispatched(e:TransactionEvent):void {
			var data:TransactionTrackingData = m_pendingTransactionData[e.transaction.getId()];
			if (data != null) {
				data.dispatchTime = GlobalEngine.currentTime;
			}
		}

		/**
		 * Callback for when a transaction has completed. This is specifically used to determine the
		 * time a transaction took to complete, and use for tracking purposes.
		 */
		private function onTransactionCompleted(e:TransactionEvent):void {
			var data:TransactionTrackingData = m_pendingTransactionData[e.transaction.getId()];
			if (data != null) {
				// Record the response time.
				data.responseTime = GlobalEngine.currentTime;
				data.serverDuration = data.transaction.rawResult['transactionTimeElapsed'];

				// Add to the completed list.
				while (m_completedTransactionData.length >= TransactionTrackingData.MAX_TRACKED) {
					m_completedTransactionData.shift();
				}
				m_completedTransactionData.push(data);

				// Delete from the pending list.
				delete m_pendingTransactionData[e.transaction.getId()];
			}
		}

		/** Callback for when a batch gets dispatched */
		private function onTransactionBatchDispatched(e:TransactionBatchEvent):void {
			var newData:BatchTrackingData = new BatchTrackingData();
			newData.dispatchTime = GlobalEngine.currentTime;
			newData.numTransactions = e.dispatchedBatchData.length;

			// Append to the front of the list.
			m_pendingBatchData.unshift(newData);
		}

		/** Callback for when a batch gets returned */
		private function onTransactionBatchCompleted(e:TransactionBatchEvent):void {
			if(Global.player && e.responseBatchData && e.responseBatchData.hasOwnProperty('extra')) {
				var extraData:Object = e.responseBatchData['extra'];
				if (extraData.hasOwnProperty('lastEnergyCheck') && extraData['lastEnergyCheck'] > 0) {
					var serverChecked:Number = extraData['lastEnergyCheck'];
					Global.player.syncLastEnergyCheck(serverChecked);
				}
			}

			if (m_pendingBatchData.length > 0) {
				// Remove from the pending list (this works b/c batches are
				// guaranteed to be processed in the order they were sent).
				var data:BatchTrackingData = m_pendingBatchData.shift();

				// Record the response time.
				data.responseTime = GlobalEngine.currentTime;

				// Accumulate the total server time.
				data.batchServerTimeElapsed = 0;
				if (e.responseBatchData && e.responseBatchData.hasOwnProperty('data') && (e.responseBatchData['data'] is Array)) {
					var responseBatchData:Array = e.responseBatchData['data'];
					for each (var currTransactionData:Object in responseBatchData) {
						if (currTransactionData) {
						if (currTransactionData.hasOwnProperty('transactionTimeElapsed')) {
							data.batchServerTimeElapsed += currTransactionData['transactionTimeElapsed'];
						}
					}
				}
				}

				// Now add to the completed list.
				while (m_completedBatchData.length >= BatchTrackingData.MAX_TRACKED) {
					m_completedBatchData.shift();
				}
				m_completedBatchData.push(data);
			}
		}

		/**
		 * Invoke to perform a stats log of transaction data.
		 */
		private function logTransactionData(reason:String):void {
			const TRANSACTION_COUNTER:String = "transaction_" + reason;
			const BATCH_COUNTER:String = "batch_" + reason;

			// Now flush the completed logs.
			m_completedTransactionData = new Vector.<TransactionTrackingData>();
			m_completedBatchData = new Vector.<BatchTrackingData>();
		}

		/** Callback for when a transaction  retry succeeds so that the connection timeout can be stopped */
		private function onTransactionRetrySuccess(event:TransactionEvent):void {
			ConnectionStatus.stopTimeout();
		}

		/** Callback for a transaction mismatch */
		private function onTransactionVersionMismatch(event:TransactionEvent=null):void {
			UI.displayMessage(ZLoc.t("Main", "OutdatedGameVersion"), GenericPopup.TYPE_OK, GameUtil.redirectHomeVersionMismatch, "", true);
		}
		
		private function onTransactionForceReload(event:TransactionFaultEvent=null):void {
			UI.displayMessage(event.errorData as String, GenericPopup.TYPE_OK, GameUtil.redirectHomeVersionMismatch, "", true);
		}


		/**
		 * Show an OOS dialog, either crash busters or old school
		 */
		private function showOOSDialog(event:TransactionFaultEvent):void {

			var crashBusterVariant:int = Global.experimentManager.getVariant(ExperimentDefinitions.FLASHVAR_CB_UX_NAME);

			//if transaction runtime is defined or you are in the crash buster variant
			if (GlobalEngine.getFlashVar(TransactionManager.FLASHVAR_CB_LOG_TRANSACTIONS) == true ||
					crashBusterVariant > 0 ) {
				//var window:FarmWindow = new FarmOOSWindow(sendCBReport,optedNotSendCBReport);

				var dialog:CheckboxConfirmationDialog;
				
				dialog = UI.displayMessageWithCheckbox(ZLoc.t("Main", "OOSGame"), ZLoc.t("Main", "OOSSendData"), false, ZLoc.t("Main", "OOSWhatWereYouDoing"), 200, GenericPopup.TYPE_OK, function():void {

					if( dialog.isChecked ) sendCBReport( event, dialog.text );

					//UI.displayMessage(ZLoc.t('Main','OOSThanks'), GenericPopup.TYPE_OK, null, "", true);
					//StatsManager.sample(100, StatsCounterType.OOS_ERROR_COMMENT, Global.m_OOSEvent.errorType.toString(), String(Global.m_OOSEvent.errorData), Global.player.uid, dialog.textField.text);
				}, "", true);

				UI.displayPopup(dialog);
			} else {
				UI.displayMessage(ZLoc.t("Main", "RefreshGame", {'error': event.errorType, 'errorMsg': event.errorData}), GenericPopup.TYPE_OK, GameUtil.redirectHome, "", true);
			}
		}

		/** Callback for all other errors */
		private function onTransactionGeneralError(event:TransactionFaultEvent):void {
			// Handle OOS (show dialog, log event)
			showOOSDialog(event);

			//UI.displayMessage(ZLoc.t("Main", "RefreshGame", {'error': event.errorType, 'errorMsg': event.errorData}), GenericPopup.TYPE_OK, GameUtil.redirectHome, "", true);
			logErrorStats(event);
		}

		/** Callback for when the queue limit has been exceeded */
		private function onTransactionQueueLimitExceeded(event:TransactionEvent):void {
			// Log the pending transactions so we can debug what is causing the
			// queue to fill up for users on prod.
			var transactionQueue:Array = [];
			var batchedTransactionQueue:Array = [];
			var transaction:Transaction;
			for each (transaction in TransactionManager.transactionQueue) {
				if (transaction is TServiceCall) {
					transactionQueue.push(TServiceCall(transaction).serviceCall);
				} else {
					transactionQueue.push(Utils.getClassName(transaction));
				}
			}
			for each (transaction in TransactionManager.batchedTransactionQueue) {
				if (transaction is TServiceCall) {
					batchedTransactionQueue.push(TServiceCall(transaction).serviceCall);
				} else {
					batchedTransactionQueue.push(Utils.getClassName(transaction));
				}
			}
			
			var message:String = "TransactionQueueLimitExceeded";
			message += " pending=" + com.zynga.serialization.JSON.encode(transactionQueue);
			message += " batched=" + com.zynga.serialization.JSON.encode(batchedTransactionQueue);
			ErrorLogManager.recordMessage(message, ErrorLogManager.LEVEL_PROD);
			
			// Start timeout for forced refresh.
			var timeout:int = Global.gameSettings.getInt("gameSaveMaxTimeout", 25) * 1000;
			ConnectionStatus.startTimeout(ConnectionStatus.TIMEOUT_SAVE_GAME, timeout, true, onConnectionTimeout);
		}

		/** Callback for when the queue limit is back to normal */
		private function onTransactionQueueLimitNormal(event:TransactionEvent):void {
			logTransactionData("queue_recover");
			ConnectionStatus.stopTimeout();
		}

		/** Callback for when the connection status times out */ 
		private function onConnectionTimeout(timeoutType:String):void {			
			var logReason:String = "unknown";
			switch (timeoutType) {
			case ConnectionStatus.TIMEOUT_SAVE_GAME:
				logReason = "queue_backup";
				break;
			case ConnectionStatus.TIMEOUT_CONNECTION_LOST:
				logReason = "retry_fail";
				break;
			}

			logTransactionData(logReason);

		}



		/** This function exists to centralize the collection of environment data for CrashBusters & the uncaught exception handler */
		private function collectEnvironmentInfo(reportData:Object):void {
			// Define an anonymous function for grabbing browser data
			const GET_NAVIGATOR_INFO:String = (<![CDATA[
					function() {
						return {
							appName: navigator.appName,
							appVersion: navigator.appVersion,
							userAgent: navigator.userAgent
						} ;
					} ]]>).toString();

			// Now fetch the browser data
			try {
				if (flash.external.ExternalInterface.available) {
					reportData["browserInfo"] = flash.external.ExternalInterface.call(GET_NAVIGATOR_INFO) ;
				}
			} catch (e:Error) {
				GlobalEngine.error("FarmGame::handleUncaughtException", "Error getting browser info: " + e) ;
			}

			// Grab the capabilities string and check to see if we're in a debug version of the player
			reportData["capabilities"] = Capabilities.serverString ;
			if ( Capabilities.isDebugger ) {
				reportData["flashPlayerType"] = "debug" ;
			} else {
				reportData["flashPlayerType"] = "standard" ;
			}

			// Grab flash player data
			var flashRevisionObject:Object = GlobalEngine.getFlashVar("flashRevision");
			if (flashRevisionObject != null) {
				reportData["revision"] = flashRevisionObject.toString() ;
			} else {
				reportData["revision"] = "0" ;
			}
			reportData["version"] = Capabilities.version;

			// Grab the signed params (useful for UID & such)
			reportData["signedParams"] = TransactionManager.additionalSignedParams;

			// Pickup experiment data
			/**
			var expDict:Dictionary = Global.experimentManager.getAllExperiments();
			var expData:Object = {};
			for (var key:* in expDict) {
				expData[key] = expDict[key];
			}
			reportData["experimentData"] = expData;
			 **/
		}



		/** Function to generate and send the CrashBusters report */
		private function sendCBReport(event:TransactionFaultEvent=null, userResponse:String=""):void {

			if (GlobalEngine.getFlashVar(TransactionManager.FLASHVAR_CB_LOG_TRANSACTIONS) < 1) {
				//user is in the ux experiment and not in the data experiment.

				StatsManager.count("crashBusters", "count", "user_opted_variant_1");
				StatsManager.sendStats(true);
				setTimeout(GameUtil.redirectHome,DELAY_FOR_STATS_SEND);
				return;
			}

			StatsManager.count("crashBusters", "count", "user_opted_send");

			// Declare var to store report data
			var userReport:Object = {};

			// Get data about the env
			collectEnvironmentInfo(userReport) ;

			// Grab CB-specific data
			userReport["transactions"] = CBReportManager.instance.transactionReport;
			userReport["lastTransactionFunc"] = TransactionManager.lastFunc;
			userReport["lastTransactionError"] = TransactionManager.lastError;
			userReport["lastTransactionErrorMsg"] = TransactionManager.lastErrorMsg;
			userReport["energy"] = Global.player.energy;
			userReport["gold"] = Global.player.gold;
			userReport["cash"] = Global.player.cash;
			userReport["goods"] = Global.player.commodities.getCount(Commodities.GOODS_COMMODITY);
			userReport["premiumGoods"] = Global.player.commodities.getCount(Commodities.PREMIUM_GOODS_COMMODITY);

			userReport["responseText"] = userResponse;

			//add most recent common UI actions
			userReport["ui_trace"] = getCBTrace();

			//add UI state detail
			userReport["ui_detail"] = m_lastStateDetail;

			// Submit the report
			sendJavaScriptReport("cb.php", userReport, "crashBusters", sendUserReportComplete, GameUtil.redirectHome) ;

			// Send the stats and reload the game
			StatsManager.sendStats(true);
		}


		/**
		 * Return the last UI trace for crashbusters
		 *
		 * @return array of string descriptions of the last several UI actions
		 */
		public static function getCBTrace():Array {
			return m_CBTraceLog;
		}


		/** Callback when crashbusters report is completed */
		private function sendUserReportComplete(evt:Event):void {

			//FarmGameUtil.redirectHome(null,true);
			//TODO tom maybe we do something more friendly here
			GameUtil.redirectHome();
		}

		/** This function manages the send of the data to the backend */
		private function sendJavaScriptReport(reportEndpoint:String, reportData:Object, statsKingdom:String, onCompleteCallback:Function = null, onErrorCallback:Function = null):void {

			// Make sure we've got a URLLoader to work with
			if (!m_transactionLogLoader) {
				m_transactionLogLoader = new URLLoader();
			}

			// Generate the URL & setup the transactionLogLoader
			m_transactionLogLoader.dataFormat = URLLoaderDataFormat.TEXT;
			if ( onCompleteCallback != null ) {
				m_transactionLogLoader.addEventListener(Event.COMPLETE, onCompleteCallback);
			}
			if ( onErrorCallback != null ) {
				m_transactionLogLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorCallback);
			}

			// Create the request
			var url:String = Config.BASE_PATH + reportEndpoint;
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;

			// Now collect all the data we're going to submit
			var requestVars:URLVariables = new URLVariables() ;
			//Swapped out FarmJSONEncoder with JSONEncoder
			var js:CITYJSONEncoder = null;
			try {
				js = new CITYJSONEncoder(reportData);
				requestVars.data = js.getString() ;

				// Do the request submission
				request.data = requestVars ;
				try {
					m_transactionLogLoader.load(request);
				} catch (error:Error) {
					StatsManager.count(statsKingdom, "errors", "Report submission failed") ;
				}
			} catch(e:Error) {
				StatsManager.count(statsKingdom, "errors", "json_encoding") ;
				throw e;
			}
			StatsManager.sendStats(true) ;
		}

		private function logErrorStats(e:TransactionFaultEvent, onUserInit:Boolean=false) :void {
			var errorFunc :String = TransactionManager.lastFunc;
			var errorType :String = "errorCode: " + e.errorType.toString();
			var errorData :String = (e.errorData) ? e.errorData.toString() : ""; 
			var debugOn :String = "test_app_mode: " + Config.DEBUG_MODE.toString();
			var transactionId :int = ((e.transaction) ? e.transaction.getId() : null);
				
			StatsManager.count(StatsCounterType.ERRORS, 
				(onUserInit) ? StatsKingdomType.TRANSACTIONS_USERINIT : StatsKingdomType.TRANSACTIONS, 
				errorFunc, errorType, debugOn, errorData);
		}

		/**
		 * Callback for mouse moves. Used to determine idle time
		 *
		 * @param	e		The mouse event
		 */
		override protected function onStageMouseMove(e:MouseEvent):void {
			StatsManager.notIdle();

			// Taken out in case this gives a performance hit.
			//Global.lastInputTick = flash.utils.getTimer();
			Global.appActive=true;
			UI.onStageMouseMove(e);
		}

		/**
		 * Callback for mouse click. Used to reset idle mission timer
		 *
		 * @param	e		The mouse event
		 */
		override protected function onStageMouseClick(event:MouseEvent):void {
			if(!Global.world || !Global.ui) {
				return;
			}
			
			Global.lastInputTick = flash.utils.getTimer();
			Global.appActive = true;
			Global.ui.mouseEnabled = false;
			// if we did a zmc freeze, and the initial timeout occurred, and player is clicking on the screen, unfreeze.
			if (m_zmcFreeze && m_zmcFreezeCount<1) {
				thawGame();
			}
		}
		
		/** Predicate for finding all open businesses */
		protected function predicateBusinessIsOpen(bus :Object) :Boolean {
			return (bus is Business && (bus as Business).isOpen() && !(bus as Business).isNeedingRoad);
		}
		
		/** Callback for key events */
		override protected function onStageKeyDown(e:KeyboardEvent):void {
			Global.lastInputTick=flash.utils.getTimer();
			Global.appActive=true;
			GlobalEngine.log("Keyboard", "Key down! keyCode: " + e.keyCode + " ctrlKey: " + e.ctrlKey + " altKey: " + e.altKey + " shiftKey: " + e.shiftKey);
			var fpsOverride :Boolean = (DEBUG_PRODUCTION_OVERRIDE && e.ctrlKey && e.altKey && e.shiftKey && String.fromCharCode(e.charCode) == 'p');
			
			if (Config.DEBUG_MODE || fpsOverride || Config.IS_TEST_ENVIRONMENT) {
				//ZProfiler uses single key shortcuts
				if (e.keyCode == Keyboard.F2) {
					trace("trying to start");
					ZProfiler.startProfile();		//F2
				}
				if (e.keyCode == Keyboard.F3) {
					//Dialogs.open(RoseGardenDialog);
					Dialogs.open(AplsVillageDialog);
				}
				if (e.keyCode == Keyboard.F4) {
					trace("trying to start");
					ZProfiler.stopProfile();
				}
				//if (e.keyCode == Keyboard.F4) ZProfiler.discardProfile();	//F4				
			}
			
			// only process CTRL-key shortcuts
			if (! e.ctrlKey) {
				return; 
			}
			var char :String = String.fromCharCode(e.charCode);
			var handled :Boolean = true;
			var targets:Array;
			var target:MapResource;
			
			// --------- This piece of code is for hotkey that will be enable only on staging bravo -------
			if(true){
				switch (char) {
					case 'l':
						IdleDialogManager.toggleHotKeyForIdlePopUp();
						break;
					default:
						handled = false;
				}
			}
			//-------------------XXXXXXXXXXXXXX-------------------------
			// In debug mode on dev machines this piece of code works
			if (Config.DEBUG_MODE || fpsOverride) {
				GlobalEngine.log("Keyboard", "Key down! char: "+String.fromCharCode(e.charCode)+" keyCode: " + e.keyCode + " ctrlKey: " + e.ctrlKey + " altKey: " + e.altKey + " shiftKey: " + e.shiftKey);
				
				//on a dev app, start with sound disabled
				if (Global.player) {
					Global.player.options['sfxDisabled'] = true;
					Global.player.options['musicDisabled'] = true;
				}
				
				switch (char) {
					case '1':							
						BroRenderer.currentRenderer.renderDebugInfo = !BroRenderer.currentRenderer.renderDebugInfo;
						break;
					case '2':
						BroRenderer.currentRenderer.disposeContext();
						break;
					case '3':
						Global.hud.visible = !Global.hud.visible;
						break;
					case 'k':
						/*var m_recipients:Array = [new FlashMFSRecipient(20022474612,"Ketan Rathod", null) ];
						while(m_recipients.length < 24){
							m_recipients.push(new FlashMFSRecipient(20022474612,"Ketan Rathod", null));
						}
						var mfsDialog:FreeGiftMFSDialog = null;
						mfsDialog = new FreeGiftMFSDialog("mysterygift_ruby", m_recipients);
						UI.displayPopup(mfsDialog);*/
						
						ScratchCardCasinoManager.popScratchCardCasinoUI();
                       	break;
					case '`':
						// two: open and/or resupply all businesses
						var bizes :Array = Global.world.getObjectsByClass(Business);
						for each (var biz :Business in bizes) {
							if (biz.isHarvestable() || biz.getState() == Business.STATE_CLOSED) {
								biz.actionQueue.addState(new ActionProgressBar(null, biz, "HARVEST!!!!!", 1));
							}
						}
						break;
					case 't':
						Display.RAD.Dialogs.open(TreasureDialog);
						break;
					case '~':	
						// tune down DEFCON for six minutes, so we don't try to skip frames  
						Global.world.forceDefcon(Defcon.DEFCON_LOWEST_LEVEL);
						// start logging
						Global.world.printPerformanceData = true;
						// print "header"
						trace("**PERF fps fpsnow npcs npcall npcvis buildings bldgall bldgvis");
						// spawn a bunch of little dudes
						// Global.world.citySim.npcManager.cheatNpcRenderTest(true, 100);
						break;
					case 'q':						
						Display.RAD.Dialogs.open(Display.subscriptionsDialog.view.SubscriptionsDialogSingle);
						break;
                    case '4':
						//Dialogs.open(LapsedPayerDialog);
						Dialogs.open(NewYearResolutionDialog);
                        //UI.displayPopup(new GlassFactoryBuildableDooberDialog("material_dtwn_koi_fish"));
                        //var glassFBBd:GlassFactoryBuildableDooberDialog = new GlassFactoryBuildableDooberDialog("material_dtwn_koi_fish");
                        //glassFBBd.startAnim();
						break;
					case '5':
						//GameTransactionManager.addTransaction(new TUnwither(TUnwither.UNWITHER_TYPE, {type: 'plot'}));
						var currentLevel:int=Global.getPlayer().level;
						UI.displayLevelUpDialog(currentLevel);
						break;
					case '7':
						var quest_name:String = UI.m_questPopoutname;				
						var quest:Quest = Global.questManager.getQuestByName(quest_name);
						if(quest == null || !(quest is Quest)){
							return;
						}
						var tasks:Vector.<Object> = quest.tasks;
						var len:int = tasks.length;
						var inx: int = 0;
						for(inx=0; inx < len; inx++){
							//var progress:QuestEvent = new QuestEvent(QuestEvent.PROGRESS, quest);
							//progress.taskCompleted = inx; 
							//dispatchEvent(progress);
							Global.questManager.setQuestTaskProgress (quest_name, inx, quest.tasks[inx].total);
							
							GameTransactionManager.addTransaction(new TProgressQuestTask(quest_name, inx));
						}
						var questPopup:QuestPopup = UI.currentPopup as QuestPopup;
						var questView:QuestPopupView = questPopup.view as QuestPopupView;
						questView.refreshCells();
						break;
					
					//case '2': Global.world.citySim.cruiseShipManager.removeCheeringScene(); break;
					case 'X':
						
						/*targets = Global.world.getObjectsByNames(["mech_stockexchange"]);
						if(targets.length) {
							MechanicManager.getInstance().handleAction(targets[0] as MechanicMapResource, "GMPlant", ["contract_stockexchange_test"]);
						}*/
						//MechanicManager.getInstance().handleAction(plane as IMechanicUser, "GMPlant", [contract.name]);
						//Global.guide.notify("LakeFrontGuide");
						targets = Global.world.getObjectsByClass(Business);
						if(targets.length) {
							var bus:Business = targets[0] as Business;
							bus.brobject.dynamic = !bus.brobject.dynamic; 
						}
						
						targets = Global.world.getObjectsByClass(Residence);
						if(targets.length) {
							var res:Residence = targets[0] as Residence;
							res.brobject.dynamic = !res.brobject.dynamic; 
						}
						break;
					case 'Q':
						//Global.guide.notify("GardenIntroGuide");
						HelperClickRewardUtil.playReward("vacationDestination", {'skipTransaction':"true"});
						break;
					case 'x':
						/*var atoasterTitle:String = ZLoc.t("Dialogs", "holiday2011EOQ_toasterTitle");
						var atoasterText:String = ZLoc.t("Dialogs","holiday2011EOQ_toasterText", {percentAmount:"50"}); //not exactly dynamic.... but oh well - Roman
						var atoasterIcon:String = Global.getAssetURL("assets/dialogs/holiday_saleTag.png");
						var atoasterButtonText:String = ZLoc.t("Dialogs","BuyNow");
						var atoasterCallback:Function = function(e:*=null):void {
							UI.displayCatalog(new CatalogParams('specials', 'winter'));
						};
						var atoaster:ActionTextToaster = new ActionTextToaster(atoasterTitle, atoasterText, atoasterButtonText, atoasterCallback, atoasterIcon);
						atoaster.duration = 5000;
						Global.ui.toaster.show(atoaster);*/
						/*targets = Global.world.getObjectsByKeywords(['airport']);
						if(targets.length) {
							var derp:MapResource = targets[0] as MapResource;
							var guitarPickConfig:Object = {toolTipHeader:"Herp", toolTipAction:"Click to derp"}
							var actionConfig:Object = {clickCallback:"tryActivateWonder"};
							var npc:DesirePeep = Global.world.citySim.npcManager.createActionDesireWalker(derp, null,null,guitarPickConfig,actionConfig, {coupon:"coupon_airport_bonus_washington", target:derp, macroSiblingKeyword:"wonderTerminal"}, NPCManager.NPC_PRIORITY_WONDER_PEEPS);
						}*/
						Global.player.inventory.addItems("material_bulldozer",1);
						Global.world.citySim.announcerManager.cycleAllAnnouncers();
						
						break;
					case 'z':
						//CustomMarketButtonManager.findItemAndShowGuide();
						var item:Item = Global.gameSettings.getItemByName("mun_meteorshow_meteorite_institute");
						var params:Dictionary = new Dictionary();
						params["treasureHuntId"] = "meteorite_institute";
						Global.treasureHuntsManager.openPickDooberDialog(item, 1, params);
						
						break;
					case 'Z':
						Global.guide.notify('glass_factory_wing_1_guide');
						break;
					case 'P':
						//FLUSH TRANSACTION QUEUE
						TransactionManager.sendAllTransactions(true);
					case 'p':
						if (Global.ui.performanceTracker) { // Toggle perf tracker with 'P' key
							Global.ui.performanceTracker.visible=!Global.ui.performanceTracker.visible;
						}
						break;
					case 'C':
						IdleDialogManager.triggerIdleDialog();
						break;
					case 'c':
						CloudManager.toggleActivation(); // Toggle ambient clouds on and off with 'C' key
						break;
					case 'a':
						EnvironmentTile.generateCache();
						break;
					case 'j':
						// offset editor tool (please don't delete)
						ObjectEditor.setActive(OffsetEditor, !ObjectEditor.editorActive(OffsetEditor));
						break;
					case '6':
						// world rect exporter tool (please don't delete) -> was 2
						Global.world.addGameMode( new GMWorldRectExporter() );
						break;
					case '6':
						// coastline object editor tool (please don't delete) -> was 3
						break;
					case 'U':
						Display.RAD.Dialogs.open(WildCardDialog);
						break;
					case 'u':
						GlobalEngine.viewport.setZoom(Global.gameSettings.getNumber('defaultZoom'));
						var worldItem:MechanicMapResource=(Global.world.getObjectById(764) as MechanicMapResource);
						Global.world.centerOnObjectWithZoomAndArrow(worldItem,1.0);
						break;
					case 'F':
					case 'f':
						Utilities.toggleFullScreen();						
						break;
					case 'e':
					case 'E':
						Global.world.citySim.toggleDebugRoadOverlay();
						Global.world.waterManager.showDbgOverlay(!Global.world.waterManager.showingDbgOverlay);
						break;
					case 'h':
						var config:ParadeItemVO = ParadeManager.getParadeConfig( 'bull_parade_2013' );
						if ( config ) {
							var startSource:MapResource = Global.world.getObjectsByNames( [config.startBuilding] )[0];
							var endSource:MapResource = Global.world.getObjectsByNames( [config.endBuilding] )[0];
							Global.world.citySim.npcManager.createParadersFromSource(startSource,endSource,config);
						}
						break;
					case 'n':
						// Global.world.citySim.npcManager.cheatNpcRenderTest(false);
						Global.world.citySim.npcManager.cheatToggleNpcVisibility();
						break;
					case 'b':
						Global.world.citySim.npcManager.cheatNpcRenderTest(true);
						/*targets = Global.world.getObjectsByClass(Business);
						if(targets.length){
							target = targets[int(Math.random()*targets.length)];
							PreyManager.addBanditWalker(new BanditData({id: 1}), target);
						}*/
						break;
					case 'v':
						Global.world.citySim.npcManager.createBusinessDesireWalker(1, true);
						break;
					case 'g':
						if(UI.isScreenFrozen()) {
							UI.thawScreen();
						} else {
							UI.freezeScreen();
						}
						break;
					case 'm':
						Global.player.subscription.openSubscriptionAnnouncePopup();
						break;
					case '8':
						// perf test for walking out from all open businesses
						var businesses :Array = Global.world.getObjectsByPredicate(predicateBusinessIsOpen);
						
						for each(var business :Business in businesses) {
						Global.world.citySim.roadManager.roadAlgorithm(business);
						Global.world.citySim.roadManager.updateAllRoadTiles();
					}
						break;
					case '9':
						//MatrixExperimentEffect.reset();
						Global.world.addGameMode(new GMDebugPathing(), false);
						break;
					case '0':
						Road.showOverlay(!Road.overlay);
						break;
					case 'G':
						GameTransactionManager.addTransaction(new TSaveOptions(Global.player.options));
						break;
					case 'd':
						Global.world.dooberManager.toogleEnableDoobers();
						break;
					case 'A':
						Global.gameSettings.testAllItemAssets();
						break;
					// SmartNpc Debugging
					case '/':
						var allowTooltips:Boolean = SmartNPCManager.instance.allowNpcTooltips;
						SmartNPCManager.instance.allowNpcTooltips = !allowTooltips;
						break;
					case '`':
						if(ConsoleStub.active == false){
							var loader :PluginLoader  = new PluginLoader("plugins/console.swf");
							loader.load(function(event:Event):void {
								if(event && event.target.content){
									ConsoleStub.install(event.target.content, Global.ui);
									ConsoleHelper.activate();
								}							
							});
						}
						break;
					case '.':
						Display.RAD.Dialogs.open(Display.WeddingV1.view.ConsumableDialog);
						break;
					case '=':
						if(MonsterStub.active == false){
							var mLoader:PluginLoader  = new PluginLoader("plugins/monster.swf");
							mLoader.load(function(event:Event):void {
								if(event && event.target.content){
									MonsterStub.install(event.target.content);
								}							
							});
						}
						break;
//					case '[':
//						MonsterDebugger.initialize(Global.ui);
//						break;
					default:
						handled = false;
				}				
			} else { // Code executes on the production environment
				if (e.keyCode == 68) { // D
//					Utilities.toggleDisplayVersion();
				} else if (e.keyCode == 70) { // F
					Utilities.toggleFullScreen();
				}
			}
	
			if (handled) {
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
		}

		/** Callback for when there is an error */
		override protected function onError(error:ErrorEvent):void {
			if (Config.DEBUG_MODE && InitializationManager.getInstance().haveAllCompleted()) {
				//Avoid stupid error loop when trying to display an error
				if (GlobalEngine.assetUrlManager != null) {
					UI.displayMessage(error.text, 0, null, "", true);
				}

				if (Global.ui && Global.ui.parent == null) {
					/** UI elements */
					if (m_preloaderDone) {
						addChild(Global.ui);
						UI.pumpPopupQueue();
					}
				}
			}
		}

		/** Exposed function called by javascript when the flash app frame gains focus */
		protected function onFocus() :void {
			if (!(m_zmcFreeze && m_zmcOpen)) {
				UI.thawScreen();
			}
		}
		
		/** Exposed function called by ZMC when a neighbor invite is accepted */
		protected function onZMCEvent(params :Array) :void {
			// grab the action name and params from js
			var action:String = '';
			if(params && params.length > 0) {
				action = params[0];
			}
			
			// handle each action
			try {
				switch (action) {
					case "acceptInvite":
						if(params.length > 1 && params[1]) {
							acceptInvite(params[1]);
						}
						break;
					case "acceptBuildingBuddy":
						if (params.length > 1 && params[1]) {
							acceptBuildingBuddy(params[1]);
						}
						break;
					case "acceptItem":
						if (params.length > 3 && params[1]) {
							if (Global.player.currLogin > int(params[3])) {
								GlobalEngine.log("acceptItem", String(params[1]) + " already in inventory. Not added.");
								break;
							}
						}
						if(params.length > 2 && params[1]) {
							var reverseGift :Boolean = (Number(params[2]) > 0);
							acceptItem(params[1], reverseGift);
						}
						break;
					case "acceptItemOnNotif":
						if(params.length > 2 && params[1]) {
							if (Global.player.inventory.getItemCountByName(params[1]) < params[2]){
								acceptItem(params[1], false);
							}
						}
						break;
					case "acceptLoot":
						if (params.length > 3 && params[1]) {
							if (Global.player.currLogin > int(params[3])) {
								GlobalEngine.log("acceptLoot", String(params[1]) + " already in inventory. Not added");
								break;
							}
						}
						//need to determine what loot was-
						if(params.length >= 2 && params[1] && params[2]) {
							var lootName:String = String(params[1]);
							var lootAmount:int = int(params[2]);
							handleLoot(lootName, lootAmount);
						}
						break;
					case "acceptTrain":
						acceptTrain();
						break;
					case "acceptHolidayItem":
						if(params.length > 2 && params[1]) {
							var reverseGift2 :Boolean = (Number(params[2]) > 0);
							acceptHolidayItem(params[1], reverseGift2);
						}						
						break;
					case "acceptValentineCard":
						break;
					case "ignoreValentineCard":
						break;
					case "acceptWorker":
					    if(params[1]){
					        Global.player.commodities.add('goods',params[1]);
					        Global.hud.updateCommodities();
					    }
					    break;
					
					case "acceptHotelVIPRequest":
						if (params[1]) {
							var hotel:WorldObject = Global.world.getObjectById(params[1]);
							if (hotel) {
								Global.world.centerOnObject(hotel);
							}
						}
						break;
				}
			} catch (pError:Error) {
				ErrorManager.addError("Error receiving ZMC call from JS:\n" + pError.message + "\n" + pError.getStackTrace() + "\n" + pError.toString());		
			}			
		}
		/** Grants the feeds reward on the client */
		protected function processZDCFeedRedemtionOnClient( data : Object ) : void{
			ZDCFeedRedemptionManager.processZDCFeedRedemtion(data);
		}
		
		/** Grants the feeds reward on the client */
		protected function processInAppPurchaseOnClient(itemId:String, amount:int = 1, transactionId:int = -1) : void{
			PaymentsPurchaseManager.processPaymentsPurchase(itemId, amount, transactionId);
		}

		protected function hasPurchaseHandler(itemId:String):Boolean{
			return PaymentsPurchaseManager.hasPurchaseHandler(itemId);
		}
		
		/** opens the weekly popup for subscribers */
		protected function openWeklySubscriptionPopup() : void{
			Display.RAD.Dialogs.open(Display.subscriptionsAccountManagementview.SubscriptionsAccountManagementDialog);
		}
		
		/** manages the loagin for subscription in app */
		protected function hideSubscriptionLoading() : void{
			Global.player.subscription.hideSubscriptionLoading();
		}
		
		/** opens the weekly popup for subscribers */
		protected function openSubscriptionFBPop() : void{
			ExternalInterface.call("openSubscriptionFBPop");
		}

		/** initially setup to dump StatsManager data to QA but we could use this for other data as well

        This is hooked up to a html button that shows in dev and staging allowing us to expose
        any state we'd like to QA (or ourselves)
        */
        protected function getWatchedCounters() : String{
            /* Format this as you'd like to see it in html.  For now quick and dirty just json encode */
			var js:CITYJSONEncoder = null;
			js = new CITYJSONEncoder(StatsManager.watchedCounters);
            return js.getString();
		}


		/**
		 * Allow javascript to set zoom
		 * 
		 * Prototype of performance automation
		 * This code could be disabled in production
		 */
		protected function js_zoomOut() : void {
			Global.world.zoomOut();
		}
		
		/**
		 * Allow javascript to retrieve current zoom level
		 * 
		 * Prototype of performance automation
		 * This code could be disabled in production
		 */
		protected function js_getZoom() : String {
			var zoomlevel:int = GlobalEngine.viewport.getZoom();
			var returnval:Object={zoom:zoomlevel}						
		
			var js:CITYJSONEncoder = null;
			js = new CITYJSONEncoder(returnval);
			return js.getString();
		}
		
		/**
		* Allow javascript to zoom in
		* 
		* Prototype of performance automation
		* This code could be disabled in production
		*/
		protected function js_zoomIn() : void {
			Global.world.zoomIn();
		}
		
		/* "nw", "ne", "sw", "se", "center" */
		protected function js_quickNav(direction:String) : void {
			Global.world.centerOnIsoPosition( Global.ui.quickNav.getMovePosition(direction), 1, null, true );
		}
		
		protected function js_getCiproSessionId(): String {
			var cipro_session_id:String = ProdAggregator.sessionId;
			var returnval:Object={session_id:cipro_session_id}						
			
			var js:CITYJSONEncoder = null;
			js = new CITYJSONEncoder(returnval);
			return js.getString();
		}

		/**
		 *  Used on ZDC for the "pokes" - currently gameboard doesn't return the item which has been granted
		 *	Ask ZDC team to provide it for us , so we don't have to hard coded here  
		 */
		protected function runGrantGoodsOnClient() :void {
			var itemAmount : int = 1; 	
			var itemName : String = 'energy_1'; 
			//Global.player.updateEnergy( energyDelta, new Array("energy", "zdc", "poke", ""));
			Global.player.inventory.addItems(itemName, itemAmount);
		}
		
		/** Add the given id to the neighbor lists and update the hud */
		protected function acceptInvite(info :Object) :void {
			
			// make sure the neighbor isn't already there
			var arr :Array = Global.player.neighbors;
			for each(var id :String in arr) {
				if(id == info.uid) {
					return;
				}
			}
			
			// append to the player's neighbor info array
			arr.push(info.uid);
			Global.player.neighbors = arr;
			
			// update the friend bar
			UI.addToFriendBarData(info);
			if (Global.ui) {
				Global.ui.m_friendBar.updateNeighbors(Global.friendbar);
			}
			
			// empty lot neighbor gates might be removed.
			if(UI.m_catalog) {
				UI.m_catalog.updateChangedCells();
			}
			
			// notify train manager to unlock the station
			Global.world.citySim.trainManager.onNeighborAdded();
		}
		
		/** Add the given id to the neighbor lists and update the hud */
		protected function acceptBuildingBuddy(info :Object) :void {
			
			// make sure the neighbor isn't already there
			var arr :Array = Global.player.nonAppFriends;
			for each(var id :String in arr) {
				if(id == info.uid) {
					return;
				}
			}
			
			// append to the player's neighbor info array
			arr.push(info.uid);
			Global.player.nonAppFriends = arr;
			
			MatchmakingManager.instance.addBuildingBuddy(info.uid);
			//MatchmakingManager.instance.popNewBuildingBuddies( [info.uid] );
			
			// update the friend bar
			UI.addToFriendBarData(info);
			if (Global.ui) {
				Global.ui.m_friendBar.updateNeighbors(Global.friendbar);
			}
			
			// empty lot neighbor gates might be removed.
			if(UI.m_catalog) {
				UI.m_catalog.updateChangedCells();
			}
			
			// notify train manager to unlock the station
			Global.world.citySim.trainManager.onNeighborAdded();
		}
		
		/** Add the given item to the player's inventory */
		protected function acceptItem(itemName :String, reverseGift :Boolean) :void {
			if (! reverseGift) {
				Global.player.inventory.addItems(itemName, 1);
			}
		}
		
		/**
		 * Adds the loot to the apropriate location.
		 * 
		 */
		protected function handleLoot(lootName:String, lootAmount:int ): void {
			switch (lootName) {
				case "coins":
					Global.player.gold += lootAmount;
					break;
				case "xp" :
					Global.player.xp += lootAmount;
					break;
				case "goods":
					Global.player.commodities.add(lootName, lootAmount);
					break;
				default:
					var lootConfig:Item = Global.gameSettings.getItemByName(lootName);
					if (Global.gameSettings.getCollectionByCollectableName(lootName) != null){
						Global.player.addCollectable(lootName);
					} else {
						Global.player.inventory.addItems(lootName, lootAmount);
					}
					break;
			}
		}
		
		/** 
		 * Special ZMC callback for accepting a holiday present so that extra updates can be called without 
		 * screwing up the exisiting addItems flow
		 * */
		protected function acceptHolidayItem(itemName:String, reverseGift:Boolean):void {
			if (! reverseGift) {
				Global.player.inventory.addItems(itemName, 1);
				
				if( HolidayTree.instance != null) {
					HolidayTree.instance.reloadImage();
				}
			}
		}
		
		/** Add the train fare reward when accepting a train request */
		protected function acceptTrain() :void {
			Global.player.gold += Global.gameSettings.getInt("trainOrderRequestCoinReward", 10);
		}
		
		/** Callback for the enter frame event */
		private function onEnterFrame(event:Event):void {
			var profCookie:int = RuntimeProfiler.enter(GameModules.GameOnEnterFrame);

			GlobalEngine.zaspManager.preUpdate();
			if (Global.world) {
				Global.world.updateWorld();
			}
			if (m_zmcFreezeCount>0) {
				m_zmcFreezeCount--;
			}
			GlobalEngine.zaspManager.postUpdate();
			RuntimeProfiler.leave(profCookie);
		}

		/** Update the app scaling based on browser zoom */
		private function onResize(event:Event) : void {
			resizeViewport();
		}

		/** Callback for when the fullscreen mode changes. */
		protected function onFullScreenChanged(evt:Event):void {
			resizeViewport();
		}	
		
		protected function resizeViewport() : void
		{
			if(GlobalEngine.viewport) 
			{
				GlobalEngine.viewport.scaleX = 1 / Global.ui.screenScale;
				GlobalEngine.viewport.scaleY = 1 / Global.ui.screenScale;
				this.scaleX = this.scaleY = Global.ui.screenScale;
				
				Global.world.updateScrollableBounds();
			}
		}
		
		/** Callback for the leave frame event */
		private function onMouseLeaveFrame(event:Event):void {
			Global.appActive=false;
		}

		/** Callback to disable all UI input when external dialog is active */
		override public function disableAllInput():void {
			super.disableAllInput();

			UI.freezeScreen();
		}

		/** Callback to re-enable all UI input when external dialog is closed */
		override public function enableAllInput():void {
			super.enableAllInput();

			UI.thawScreen();
		}
		
		public function setZBarQueue(value:Boolean):void {
			ZBarNotifier.queueNotifications = value;
		}

		/** Callback for external dialog close to log Feed Dialog Shows  */
		public function logShowFeedDialog():void {
			m_feedOpenTime=flash.utils.getTimer();
			StatsManager.count("farm_world_action", "Feed_Open");
		}

		/**
		 * Callback for closing the publish_stream permissions dialog.
		 *
		 * @param	Boolean	userAccepted	True if the user accepted extended permissions.
		 */
		public function permissionDialogClosed(permissionName:String ,userAccepted:Boolean):void {
			GlobalEngine.socialNetwork.onPermissionDialogClosed(permissionName, userAccepted);
		}
		
		public function cipPermissionDialogClosed(userAccepted:Boolean):void {
			TOSManager.instance.cipPermissionDialogClosed(userAccepted);
		}
		
		/**
		 * Callback for closing the publish_actions,user_games_activity,friends_games_activity permissions dialog.
		 */
		public function extendedPermissionsDialogClosed(rewardID:String = null):void {
			Global.world.viralMgr.extendedPermissionsDialogClosed(rewardID);
		}
		
		/** 
		 * Callback for a Request 2.0 request operation being completed 
		 *
		 * @param	String	error	"none" if successful.
		 */
		public function onRequestSent(error :String, requestType :String, requestData :Object, sentToIds :Array) :void {
			if(Global.world && Global.world.viralMgr) {
				Global.world.viralMgr.onRequestSent(error, requestType, requestData, sentToIds);
			}
		}

		/**
		 * Callback for external dialog close to log Feed Dialog Shows.
		 *
		 * @param	feedback	Feedback from the caller of this function if any.
		 */
		public function logCloseFeedDialog(feedback:Object=null):void {
			
			ViralManager.doUIThaw();
			
			var endTime:Number=flash.utils.getTimer();
			var timeDiff:int=endTime - m_feedOpenTime;

			timeDiff=int(timeDiff / 10000);
			var timeString:String;

			if (timeDiff > 6) {
				timeString=">1 minute";
			} else {
				timeString=Number(timeDiff + 1).toString() + "0 seconds";
			}

			if (feedback != null && feedback is String) {
				var feedbackStr:String=feedback as String;

				switch (feedbackStr) {
					case "posted":
						StatsManager.count("farm_world_action", "Feed_Published", timeString);
						break;
					case "closed":
						StatsManager.count("farm_world_action", "Feed_Closed", timeString);
						break;
					case "skipped":
						StatsManager.count("farm_world_action", "Feed_Skipped", timeString);
						break;
					default:
						StatsManager.count("farm_world_action", "Feed_Unknown", timeString);
						break;
				}
			} else {
				StatsManager.count("farm_world_action", "Feed_Close", timeString);
			}

			GlobalEngine.socialNetwork.onFeedClosed();
		}

		/**
		 * Callback for switching tabs on the main game page. If you are not the game page then we freeze the UI.
		 *
		 * @param	feedback	Feedback from the caller of this function if any.
		 */
		public function freezeGame(feedback:Object=null):void {
			UI.freezeScreen(false, true); // no loading dialog, yes gray hthe screen.
		}
		
		/**
		 * Callback for freezing the UI when the ZMC panel is up.
		 *
		 * @param	feedback	Feedback from the caller of this function if any.
		 */
		public function ZMCFreezeGame(feedback:Object=null):void { 
			if (!m_zmcOpen) {
				return; // never freeze when zmc is already closed.
			}
		}
		
		/**
		 * Callback for switching tabs on the main game page. If you are not the game page then we freeze the UI.
		 *
		 * @param	feedback	Feedback from the caller of this function if any.
		 */
		public function thawGame(feedback:Object=null):void {
			m_zmcFreeze = false;
			m_zmcFreezeCount=0;
			UI.thawScreen();
		}	
		
		/** Function for ZMC open stat tracking */
		public function onZMCOpen():void {
			m_zmcOpen = true;
			StatsManager.count(StatsKingdomType.ZMC_EVENT, "open");
		}
		
		/** Callback for ZMC close stat tracking */
		public function onZMCClose():void {
			m_zmcOpen = false;
			StatsManager.count(StatsKingdomType.ZMC_EVENT, "close");
			thawGame();
		}
		
		/**Callback for ZMC load */
		public function onZMCLoad():void{
		}
		
		public function startHeartbeat():void
		{
			m_heartbeatTimer = new Timer(1000);
			m_heartbeatTimer.addEventListener(TimerEvent.TIMER, broadcastHeartbeat);
			m_heartbeatTimer.start();
		}

		public function broadcastHeartbeat(event:TimerEvent):void
		{
			ExternalInterface.call('broadcastHeartbeat');
		}
		
		private function enableErrorLogging() : void
		{
			try 
			{
				var uncaughtErrorsEvents:Object = loaderInfo["uncaughtErrorEvents"];
				if (uncaughtErrorsEvents) 
				{
					// we use the string value for the event type to allow
					// the app to run on Flash 10.0 as well as 10.1+
					uncaughtErrorsEvents.addEventListener(
						"uncaughtError", uncaughtErrorHandler
					);
				}
			} 
			catch (e:*) {
				// do nothing, this flash player doesn't support this feature	
			}
		}
		
		private function disableErrorLogging() : void 
		{
			try
			{
				var uncaughtErrorsEvents:Object = loaderInfo["uncaughtErrorEvents"];
				if (uncaughtErrorsEvents) 
				{
					// we use the string value for the event type to allow
					// the app to run on Flash 10.0 as well as 10.1+
					uncaughtErrorsEvents.removeEventListener(
						"uncaughtError", uncaughtErrorHandler
					);
				}
			}
			catch (e:*) {
				// do nothing, this flash player doesn't support this feature	
			}
		}

		private function handleInitError(error:Error = null):void {
			var lastProgress:String = String(InitializationManager.getInstance().lastProgress);
			var	message:String = "Error # " + lastProgress;
			if (Config.DEBUG_MODE || Config.IS_TEST_ENVIRONMENT) { 
				if (error != null) {
					message = message + " | "  + InitializationManager.getInstance().lastProgressMetaData + " | " + error.message ;
				}
			}
			var ev:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, false, false, message);
			disableErrorLogging(); 
			dispatchEvent(ev);
			enableErrorLogging();
			if (error == null) { 
				error = new Error(message);
			}
			UncaughtErrors.log(error, null, 0, UncaughtErrors.INIT_ERROR, lastProgress, false);
		}
		
		private function uncaughtErrorHandler(e:*):void {
			var error:Error = e.error as Error;
			var errorEvent:ErrorEvent = e.error as ErrorEvent;
			if (errorEvent) {
				var errorID:int = 0;
				if ("errorID" in errorEvent) {
					errorID = errorEvent["errorID"];
				}
				error = new Error("Error #" + errorID + ": " + errorEvent.text, errorID);
			}
			
			if (error) {
				// If the error is received during the initialization sequence, dispatch
				// the error message to the preloader, so that the user can see it.
				if (!InitializationManager.getInstance().haveAllCompleted()) {
					handleInitError(error);
				} else {
					UncaughtErrors.log(error);
				}
				e.preventDefault();
			}
		}

		// For QA automation
		public function get automationState() : Object
		{
			var worldState:Object,
			metricsState:Object,
			uiState:Object,
			playerState:Object,
			transactionState:Object,
			doobersState:Object;
			
			if (Global.world) {
				worldState = Global.world.automationState;
				doobersState = Global.world.dooberManager.automationState;
			}

			if (UI.currentPopup && (UI.currentPopup is IAutomatedObject)) {
				uiState = (UI.currentPopup as IAutomatedObject).automationState;
			}

			if (Global.player) {
				playerState = Global.player.automationState
			}
			
			return {
				id			   : "CityVille",
				player		   : playerState,
				world 		   : worldState,
				doobers		   : doobersState,
				ui			   : uiState,
				metrics		   : metricsState,
				interactive	   : m_initComplete,
				automationType : AutomatedType.GAME
			};
		}
		
		private function getTransactionStates() : Object
		{
			var transactionStates:Array = [];
			for each (var transaction:TransactionTrackingData in m_completedTransactionData)
			{
				transactionStates.push(
					transaction.automationState
				);
			}
			
			return transactionStates;
		}
	}
}


import Classes.automation.AutomatedType;
import Classes.automation.IAutomatedObject;

import Engine.Transactions.Transaction;

/**
 * Class to be used for transaction tracking
 */
class TransactionTrackingData implements IAutomatedObject {
	static public const MAX_TRACKED:int = 40;

	public var transaction:Transaction;
	public var addTime:Number = -1;
	public var dispatchTime:Number = -1;
	public var responseTime:Number = -1;
	public var serverDuration:Number = -1;
	
	/** Constructor */
	public function TransactionTrackingData(data:Transaction):void { transaction = data; addTime = GlobalEngine.currentTime; }

	/** Whether or not the transaction has made a full circle (assumed by the presence of a proper dispatch and response time. */
	public function get isComplete():Boolean { return (dispatchTime != -1 && responseTime != -1); }

	/** Whether or not the transaction has been dispatched. */
	public function get isDispatched():Boolean { return (dispatchTime != -1); }

	/** The time elapsed between the dispatch and response-received time. */
	public function get transactionTime():Number { return responseTime - dispatchTime; }

	public function get automationState() : Object
	{
		return {
			id			   : transaction.getId(),
			service		   : transaction.functionName,
			result		   : transaction.rawResult,
			automationType : AutomatedType.SERVICE
		};
	}
}

/**
 * Class to be used for batch tracking
 */
class BatchTrackingData {
	static public const MAX_TRACKED:int = 15;

	public var dispatchTime:Number = -1;
	public var responseTime:Number = -1;
	public var numTransactions:int = 0;
	public var batchServerTimeElapsed:Number = -1;
	/** Whether or not the batch has made a full circle (assumed by the presence of a proper dispatch and response time. */
	public function get isComplete():Boolean { return (dispatchTime != -1 && responseTime != -1); }
	/** The time elapsed between the dispatch and response-received time. */
	public function get batchTimeElapsed():Number { return responseTime - dispatchTime; }
}

import Engine.Interfaces.IMetaDataProvider;
import Classes.SecureRand;

class TransactionMetaDataProvider implements IMetaDataProvider {
	private var m_providers:Array = [];
	
	public function addProvider(provider: BaseMetaDataProvider):void {
		m_providers.push(provider);
	}
	
	public function get empty():Boolean {
		return m_providers.length == 0;
	}
	
	public function getMetaData():Object {
		var metaData:Object = {};
		for each (var provider:BaseMetaDataProvider in m_providers) {
			provider.appendMetaData(metaData);
		}
		return metaData;
	}
}

class BaseMetaDataProvider {
	public function appendMetaData(metaData:Object):void {
		// override this in subclass
	}
}

class SecureRandMetaDataProvider extends BaseMetaDataProvider {
	public override function appendMetaData(metaData:Object):void {
		metaData['secureRands'] = SecureRand.getAndClearHistory();
	}
}

class EnergyDeltaMetaDataProvider extends BaseMetaDataProvider {
	public override function appendMetaData(metaData:Object):void {
		metaData['energyDeltas'] = Global.player.getAndClearEnergyDeltaLogs();
	}
}
