﻿package com.ankamagames.dofus.misc.lists
{
    import com.ankamagames.dofus.logic.common.actions.*;
    import com.ankamagames.dofus.logic.connection.actions.*;
    import com.ankamagames.dofus.logic.game.approach.actions.*;
    import com.ankamagames.dofus.logic.game.common.actions.*;
    import com.ankamagames.dofus.logic.game.common.actions.alignment.*;
    import com.ankamagames.dofus.logic.game.common.actions.chat.*;
    import com.ankamagames.dofus.logic.game.common.actions.externalGame.*;
    import com.ankamagames.dofus.logic.game.common.actions.party.*;
    import com.ankamagames.dofus.logic.game.common.actions.prism.*;
    import com.ankamagames.dofus.logic.game.common.actions.quest.*;
    import com.ankamagames.dofus.logic.game.common.actions.roleplay.*;
    import com.ankamagames.dofus.logic.game.common.actions.spectator.*;
    import com.ankamagames.dofus.logic.game.common.actions.tinsel.*;
    import com.ankamagames.dofus.logic.game.fight.actions.*;
    import com.ankamagames.dofus.logic.game.roleplay.actions.*;
    import com.ankamagames.dofus.logic.game.roleplay.actions.preset.*;
    import com.ankamagames.dofus.misc.utils.*;

    public class ApiActionList extends Object
    {
        public static const OpenPopup:DofusApiAction = new DofusApiAction("OpenPopup", OpenPopupAction);
        public static const BasicSwitchMode:DofusApiAction = new DofusApiAction("BasicSwitchMode", BasicSwitchModeAction);
        public static const ChatCommand:DofusApiAction = new DofusApiAction("ChatCommand", ChatCommandAction);
        public static const ChatLoaded:DofusApiAction = new DofusApiAction("ChatLoaded", ChatLoadedAction);
        public static const ClearChat:DofusApiAction = new DofusApiAction("ClearChat", ClearChatAction);
        public static const AuthorizedCommand:DofusApiAction = new DofusApiAction("AuthorizedCommand", AuthorizedCommandAction);
        public static const LoginValidation:DofusApiAction = new DofusApiAction("LoginValidation", LoginValidationAction);
        public static const LoginValidationWithTicket:DofusApiAction = new DofusApiAction("LoginValidationWithTicket", LoginValidationWithTicketAction);
        public static const NicknameChoiceRequest:DofusApiAction = new DofusApiAction("NicknameChoiceRequest", NicknameChoiceRequestAction);
        public static const ServerSelection:DofusApiAction = new DofusApiAction("ServerSelection", ServerSelectionAction);
        public static const AcquaintanceSearch:DofusApiAction = new DofusApiAction("AcquaintanceSearch", AcquaintanceSearchAction);
        public static const SubscribersGiftListRequest:DofusApiAction = new DofusApiAction("SubscribersGiftListRequest", SubscribersGiftListRequestAction);
        public static const NewsLoginRequest:DofusApiAction = new DofusApiAction("NewsLoginRequest", NewsLoginRequestAction);
        public static const ChangeCharacter:DofusApiAction = new DofusApiAction("ChangeCharacter", ChangeCharacterAction);
        public static const ChangeServer:DofusApiAction = new DofusApiAction("ChangeServer", ChangeServerAction);
        public static const QuitGame:DofusApiAction = new DofusApiAction("QuitGame", QuitGameAction);
        public static const ResetGame:DofusApiAction = new DofusApiAction("ResetGame", ResetGameAction);
        public static const AgreementAgreed:DofusApiAction = new DofusApiAction("AgreementAgreed", AgreementAgreedAction);
        public static const CharacterCreation:DofusApiAction = new DofusApiAction("CharacterCreation", CharacterCreationAction);
        public static const CharacterDeletion:DofusApiAction = new DofusApiAction("CharacterDeletion", CharacterDeletionAction);
        public static const CharacterNameSuggestionRequest:DofusApiAction = new DofusApiAction("CharacterNameSuggestionRequest", CharacterNameSuggestionRequestAction);
        public static const CharacterReplayRequest:DofusApiAction = new DofusApiAction("CharacterReplayRequest", CharacterReplayRequestAction);
        public static const CharacterDeselection:DofusApiAction = new DofusApiAction("CharacterDeselection", CharacterDeselectionAction);
        public static const CharacterSelection:DofusApiAction = new DofusApiAction("CharacterSelection", CharacterSelectionAction);
        public static const CharacterRecolorSelection:DofusApiAction = new DofusApiAction("CharacterRecolorSelection", CharacterRecolorSelectionAction);
        public static const CharacterRenameSelection:DofusApiAction = new DofusApiAction("CharacterRenameSelection", CharacterRenameSelectionAction);
        public static const CharacterRelookSelection:DofusApiAction = new DofusApiAction("CharacterRelookSelection", CharacterRelookSelectionAction);
        public static const GameContextQuit:DofusApiAction = new DofusApiAction("GameContextQuit", GameContextQuitAction);
        public static const OpenCurrentFight:DofusApiAction = new DofusApiAction("OpenCurrentFight", OpenCurrentFightAction);
        public static const OpenMainMenu:DofusApiAction = new DofusApiAction("OpenMainMenu", OpenMainMenuAction);
        public static const OpenMount:DofusApiAction = new DofusApiAction("OpenMount", OpenMountAction);
        public static const OpenInventory:DofusApiAction = new DofusApiAction("OpenInventory", OpenInventoryAction);
        public static const CloseInventory:DofusApiAction = new DofusApiAction("CloseInventory", CloseInventoryAction);
        public static const OpenMap:DofusApiAction = new DofusApiAction("OpenMap", OpenMapAction);
        public static const OpenBook:DofusApiAction = new DofusApiAction("OpenBook", OpenBookAction);
        public static const CloseBook:DofusApiAction = new DofusApiAction("CloseBook", CloseBookAction);
        public static const OpenServerSelection:DofusApiAction = new DofusApiAction("OpenServerSelection", OpenServerSelectionAction);
        public static const OpenSmileys:DofusApiAction = new DofusApiAction("OpenSmileys", OpenSmileysAction);
        public static const OpenTeamSearch:DofusApiAction = new DofusApiAction("OpenTeamSearch", OpenTeamSearchAction);
        public static const OpenArena:DofusApiAction = new DofusApiAction("OpenArena", OpenArenaAction);
        public static const OpenStats:DofusApiAction = new DofusApiAction("OpenStats", OpenStatsAction);
        public static const IncreaseSpellLevel:DofusApiAction = new DofusApiAction("IncreaseSpellLevel", IncreaseSpellLevelAction);
        public static const BasicWhoIsRequest:DofusApiAction = new DofusApiAction("BasicWhoIsRequest", BasicWhoIsRequestAction);
        public static const NumericWhoIsRequest:DofusApiAction = new DofusApiAction("NumericWhoIsRequest", NumericWhoIsRequestAction);
        public static const AddBehaviorToStack:DofusApiAction = new DofusApiAction("AddBehaviorToStack", AddBehaviorToStackAction);
        public static const RemoveBehaviorToStack:DofusApiAction = new DofusApiAction("RemoveBehaviorToStack", RemoveBehaviorToStackAction);
        public static const EmptyStack:DofusApiAction = new DofusApiAction("EmptyStack", EmptyStackAction);
        public static const ChallengeTargetsListRequest:DofusApiAction = new DofusApiAction("ChallengeTargetsListRequest", ChallengeTargetsListRequestAction);
        public static const GameFightReady:DofusApiAction = new DofusApiAction("GameFightReady", GameFightReadyAction);
        public static const GameFightSpellCast:DofusApiAction = new DofusApiAction("GameFightSpellCast", GameFightSpellCastAction);
        public static const GameFightTurnFinish:DofusApiAction = new DofusApiAction("GameFightTurnFinish", GameFightTurnFinishAction);
        public static const TimelineEntityClick:DofusApiAction = new DofusApiAction("TimelineEntityClick", TimelineEntityClickAction);
        public static const BannerEmptySlotClick:DofusApiAction = new DofusApiAction("BannerEmptySlotClick", BannerEmptySlotClickAction);
        public static const TimelineEntityOver:DofusApiAction = new DofusApiAction("TimelineEntityOver", TimelineEntityOverAction);
        public static const TimelineEntityOut:DofusApiAction = new DofusApiAction("TimelineEntityOut", TimelineEntityOutAction);
        public static const ToggleDematerialization:DofusApiAction = new DofusApiAction("ToggleDematerialization", ToggleDematerializationAction);
        public static const ToggleHelpWanted:DofusApiAction = new DofusApiAction("ToggleHelpWanted", ToggleHelpWantedAction);
        public static const ToggleLockFight:DofusApiAction = new DofusApiAction("ToggleLockFight", ToggleLockFightAction);
        public static const ToggleLockParty:DofusApiAction = new DofusApiAction("ToggleLockParty", ToggleLockPartyAction);
        public static const ToggleWitnessForbidden:DofusApiAction = new DofusApiAction("ToggleWitnessForbidden", ToggleWitnessForbiddenAction);
        public static const TogglePointCell:DofusApiAction = new DofusApiAction("TogglePointCell", TogglePointCellAction);
        public static const GameContextKick:DofusApiAction = new DofusApiAction("GameContextKick", GameContextKickAction);
        public static const DisableAfk:DofusApiAction = new DofusApiAction("DisableAfk", DisableAfkAction);
        public static const ShowTacticMode:DofusApiAction = new DofusApiAction("ShowTacticMode", ShowTacticModeAction);
        public static const LeaveDialogRequest:DofusApiAction = new DofusApiAction("LeaveDialogRequest", LeaveDialogRequestAction);
        public static const TeleportRequest:DofusApiAction = new DofusApiAction("TeleportRequest", TeleportRequestAction);
        public static const ObjectSetPosition:DofusApiAction = new DofusApiAction("ObjectSetPosition", ObjectSetPositionAction);
        public static const PresetSetPosition:DofusApiAction = new DofusApiAction("PresetSetPosition", PresetSetPositionAction);
        public static const ObjectDrop:DofusApiAction = new DofusApiAction("ObjectDrop", ObjectDropAction);
        public static const SpellSetPosition:DofusApiAction = new DofusApiAction("SpellSetPosition", SpellSetPositionAction);
        public static const StatsUpgradeRequest:DofusApiAction = new DofusApiAction("StatsUpgradeRequest", StatsUpgradeRequestAction);
        public static const DeleteObject:DofusApiAction = new DofusApiAction("DeleteObject", DeleteObjectAction);
        public static const ObjectUse:DofusApiAction = new DofusApiAction("ObjectUse", ObjectUseAction);
        public static const InventoryPresetDelete:DofusApiAction = new DofusApiAction("InventoryPresetDelete", InventoryPresetDeleteAction);
        public static const InventoryPresetSave:DofusApiAction = new DofusApiAction("InventoryPresetSave", InventoryPresetSaveAction);
        public static const InventoryPresetUse:DofusApiAction = new DofusApiAction("InventoryPresetUse", InventoryPresetUseAction);
        public static const InventoryPresetItemUpdateRequest:DofusApiAction = new DofusApiAction("InventoryPresetItemUpdateRequest", InventoryPresetItemUpdateRequestAction);
        public static const SwitchCreatureMode:DofusApiAction = new DofusApiAction("SwitchCreatureMode", SwitchCreatureModeAction);
        public static const NpcDialogReply:DofusApiAction = new DofusApiAction("NpcDialogReply", NpcDialogReplyAction);
        public static const InteractiveElementActivation:DofusApiAction = new DofusApiAction("InteractiveElementActivation", InteractiveElementActivationAction);
        public static const PivotCharacter:DofusApiAction = new DofusApiAction("PivotCharacter", PivotCharacterAction);
        public static const ShowAllNames:DofusApiAction = new DofusApiAction("ShowAllNames", ShowAllNamesAction);
        public static const PartyInvitation:DofusApiAction = new DofusApiAction("PartyInvitation", PartyInvitationAction);
        public static const PartyInvitationDetailsRequest:DofusApiAction = new DofusApiAction("PartyInvitationDetailsRequest", PartyInvitationDetailsRequestAction);
        public static const PartyCancelInvitation:DofusApiAction = new DofusApiAction("PartyCancelInvitation", PartyCancelInvitationAction);
        public static const PartyAcceptInvitation:DofusApiAction = new DofusApiAction("PartyAcceptInvitation", PartyAcceptInvitationAction);
        public static const PartyRefuseInvitation:DofusApiAction = new DofusApiAction("PartyRefuseInvitation", PartyRefuseInvitationAction);
        public static const PartyLeaveRequest:DofusApiAction = new DofusApiAction("PartyLeaveRequest", PartyLeaveRequestAction);
        public static const PartyKickRequest:DofusApiAction = new DofusApiAction("PartyKickRequest", PartyKickRequestAction);
        public static const PartyAbdicateThrone:DofusApiAction = new DofusApiAction("PartyAbdicateThrone", PartyAbdicateThroneAction);
        public static const PartyPledgeLoyaltyRequest:DofusApiAction = new DofusApiAction("PartyPledgeLoyaltyRequest", PartyPledgeLoyaltyRequestAction);
        public static const PartyFollowMember:DofusApiAction = new DofusApiAction("PartyFollowMember", PartyFollowMemberAction);
        public static const PartyAllFollowMember:DofusApiAction = new DofusApiAction("PartyAllFollowMember", PartyAllFollowMemberAction);
        public static const PartyStopFollowingMember:DofusApiAction = new DofusApiAction("PartyStopFollowingMember", PartyStopFollowingMemberAction);
        public static const PartyAllStopFollowingMember:DofusApiAction = new DofusApiAction("PartyAllStopFollowingMember", PartyAllStopFollowingMemberAction);
        public static const PartyShowMenu:DofusApiAction = new DofusApiAction("PartyShowMenu", PartyShowMenuAction);
        public static const MapRunningFightDetailsRequest:DofusApiAction = new DofusApiAction("MapRunningFightDetailsRequest", MapRunningFightDetailsRequestAction);
        public static const StopToListenRunningFightRequestMessage:DofusApiAction = new DofusApiAction("StopToListenRunningFight", StopToListenRunningFightAction);
        public static const JoinFightRequest:DofusApiAction = new DofusApiAction("JoinFightRequest", JoinFightRequestAction);
        public static const JoinAsSpectatorRequest:DofusApiAction = new DofusApiAction("JoinAsSpectatorRequest", JoinAsSpectatorRequestAction);
        public static const HouseGuildShare:DofusApiAction = new DofusApiAction("HouseGuildShare", HouseGuildShareAction);
        public static const HouseGuildRightsView:DofusApiAction = new DofusApiAction("HouseGuildRightsView", HouseGuildRightsViewAction);
        public static const HouseGuildRightsChange:DofusApiAction = new DofusApiAction("HouseGuildRightsChange", HouseGuildRightsChangeAction);
        public static const HouseBuy:DofusApiAction = new DofusApiAction("HouseBuy", HouseBuyAction);
        public static const LeaveDialog:DofusApiAction = new DofusApiAction("LeaveDialog", LeaveDialogAction);
        public static const HouseSell:DofusApiAction = new DofusApiAction("HouseSell", HouseSellAction);
        public static const HouseSellFromInside:DofusApiAction = new DofusApiAction("HouseSellFromInside", HouseSellFromInsideAction);
        public static const HouseKick:DofusApiAction = new DofusApiAction("HouseKick", HouseKickAction);
        public static const HouseKickMerchant:DofusApiAction = new DofusApiAction("HouseKickIndoorMerchant", HouseKickIndoorMerchantAction);
        public static const LockableChangeCode:DofusApiAction = new DofusApiAction("LockableChangeCode", LockableChangeCodeAction);
        public static const LockableUseCode:DofusApiAction = new DofusApiAction("LockableUseCode", LockableUseCodeAction);
        public static const HouseLockFromInside:DofusApiAction = new DofusApiAction("HouseLockFromInside", HouseLockFromInsideAction);
        public static const GameRolePlayFreeSoulRequest:DofusApiAction = new DofusApiAction("GameRolePlayFreeSoulRequest", GameRolePlayFreeSoulRequestAction);
        public static const QuestInfosRequest:DofusApiAction = new DofusApiAction("QuestInfosRequest", QuestInfosRequestAction);
        public static const QuestListRequest:DofusApiAction = new DofusApiAction("QuestListRequest", QuestListRequestAction);
        public static const QuestStartRequest:DofusApiAction = new DofusApiAction("QuestStartRequest", QuestStartRequestAction);
        public static const AchievementDetailedListRequest:DofusApiAction = new DofusApiAction("AchievementDetailedListRequest", AchievementDetailedListRequestAction);
        public static const AchievementDetailsRequest:DofusApiAction = new DofusApiAction("AchievementDetailsRequest", AchievementDetailsRequestAction);
        public static const AchievementRewardRequest:DofusApiAction = new DofusApiAction("AchievementRewardRequest", AchievementRewardRequestAction);
        public static const QuestObjectiveValidation:DofusApiAction = new DofusApiAction("QuestObjectiveValidation", QuestObjectiveValidationAction);
        public static const GuidedModeReturnRequest:DofusApiAction = new DofusApiAction("GuidedModeReturnRequest", GuidedModeReturnRequestAction);
        public static const GuidedModeQuitRequest:DofusApiAction = new DofusApiAction("GuidedModeQuitRequest", GuidedModeQuitRequestAction);
        public static const SetEnablePVPRequest:DofusApiAction = new DofusApiAction("SetEnablePVPRequest", SetEnablePVPRequestAction);
        public static const PrismCurrentBonusRequest:DofusApiAction = new DofusApiAction("PrismCurrentBonusRequest", PrismCurrentBonusRequestAction);
        public static const PrismBalanceRequest:DofusApiAction = new DofusApiAction("PrismBalanceRequest", PrismBalanceRequestAction);
        public static const PrismFightJoinLeaveRequest:DofusApiAction = new DofusApiAction("PrismFightJoinLeaveRequest", PrismFightJoinLeaveRequestAction);
        public static const PrismFightSwapRequest:DofusApiAction = new DofusApiAction("PrismFightSwapRequest", PrismFightSwapRequestAction);
        public static const PrismInfoJoinLeaveRequest:DofusApiAction = new DofusApiAction("PrismInfoJoinLeaveRequest", PrismInfoJoinLeaveRequestAction);
        public static const PrismWorldInformationRequest:DofusApiAction = new DofusApiAction("PrismWorldInformationRequest", PrismWorldInformationRequestAction);
        public static const PrismAttackRequest:DofusApiAction = new DofusApiAction("PrismAttackRequest", PrismAttackRequestAction);
        public static const PrismUseRequest:DofusApiAction = new DofusApiAction("PrismUseRequest", PrismUseRequestAction);
        public static const ObjectUseOnCell:DofusApiAction = new DofusApiAction("ObjectUseOnCell", ObjectUseOnCellAction);
        public static const GiftAssignRequest:DofusApiAction = new DofusApiAction("GiftAssignRequest", GiftAssignRequestAction);
        public static const NotificationUpdateFlag:DofusApiAction = new DofusApiAction("NotificationUpdateFlag", NotificationUpdateFlagAction);
        public static const NotificationReset:DofusApiAction = new DofusApiAction("NotificationReset", NotificationResetAction);
        public static const StartZoom:DofusApiAction = new DofusApiAction("StartZoom", StartZoomAction);
        public static const PlaySound:DofusApiAction = new DofusApiAction("PlaySound", PlaySoundAction);
        public static const GetPartsList:DofusApiAction = new DofusApiAction("GetPartsList", GetPartsListAction);
        public static const DownloadPart:DofusApiAction = new DofusApiAction("DownloadPart", DownloadPartAction);
        public static const GetPartInfo:DofusApiAction = new DofusApiAction("GetPartInfo", GetPartInfoAction);
        public static const ShortcutBarAddRequest:DofusApiAction = new DofusApiAction("ShortcutBarAddRequest", ShortcutBarAddRequestAction);
        public static const ShortcutBarRemoveRequest:DofusApiAction = new DofusApiAction("ShortcutBarRemoveRequest", ShortcutBarRemoveRequestAction);
        public static const ShortcutBarSwapRequest:DofusApiAction = new DofusApiAction("ShortcutBarSwapRequest", ShortcutBarSwapRequestAction);
        public static const KrosmasterTokenRequest:DofusApiAction = new DofusApiAction("KrosmasterTokenRequest", KrosmasterTokenRequestAction);
        public static const KrosmasterInventoryRequest:DofusApiAction = new DofusApiAction("KrosmasterInventoryRequest", KrosmasterInventoryRequestAction);
        public static const KrosmasterTransferRequest:DofusApiAction = new DofusApiAction("KrosmasterTransferRequest", KrosmasterTransferRequestAction);
        public static const KrosmasterPlayingStatus:DofusApiAction = new DofusApiAction("KrosmasterPlayingStatus", KrosmasterPlayingStatusAction);
        public static const TitlesAndOrnamentsListRequest:DofusApiAction = new DofusApiAction("TitlesAndOrnamentsListRequest", TitlesAndOrnamentsListRequestAction);
        public static const TitleSelectRequest:DofusApiAction = new DofusApiAction("TitleSelectRequest", TitleSelectRequestAction);
        public static const OrnamentSelectRequest:DofusApiAction = new DofusApiAction("OrnamentSelectRequest", OrnamentSelectRequestAction);

        public function ApiActionList()
        {
            return;
        }// end function

    }
}
