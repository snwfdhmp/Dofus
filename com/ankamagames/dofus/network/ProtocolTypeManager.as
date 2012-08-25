package com.ankamagames.dofus.network
{
    import com.ankamagames.dofus.network.types.game.achievement.*;
    import com.ankamagames.dofus.network.types.game.actions.fight.*;
    import com.ankamagames.dofus.network.types.game.character.choice.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.dofus.network.types.game.context.fight.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.party.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.quest.*;
    import com.ankamagames.dofus.network.types.game.data.items.effects.*;
    import com.ankamagames.dofus.network.types.game.friend.*;
    import com.ankamagames.dofus.network.types.game.guild.tax.*;
    import com.ankamagames.dofus.network.types.game.house.*;
    import com.ankamagames.dofus.network.types.game.interactive.*;
    import com.ankamagames.dofus.network.types.game.interactive.skill.*;
    import com.ankamagames.dofus.network.types.game.mount.*;
    import com.ankamagames.dofus.network.types.game.paddock.*;
    import com.ankamagames.dofus.network.types.game.shortcut.*;
    import com.ankamagames.jerakine.managers.*;
    import flash.utils.*;

    public class ProtocolTypeManager extends Object
    {
        private static const _typesTypes:Dictionary = new Dictionary();

        public function ProtocolTypeManager()
        {
            return;
        }// end function

        public static function getInstance(param1:Class, param2:uint)
        {
            var _loc_3:* = _typesTypes[param2];
            if (!_loc_3)
            {
                throw new Error("Type with id " + param2 + " is unknown.");
            }
            var _loc_4:* = new _loc_3;
            if (!(new _loc_3 is param1))
            {
                throw new Error("Type " + param2 + " is not a " + param1 + ".");
            }
            return _loc_4;
        }// end function

        public static function register() : void
        {
            StoreDataManager.getInstance().registerClass(new CharacterBaseInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new CharacterHardcoreInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PartyInvitationMemberInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new EntityDispositionInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new IdentifiedEntityDispositionInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FightEntityDispositionInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTeamMemberInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTeamMemberCharacterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTeamMemberMonsterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTeamMemberTaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMinimalStats(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMinimalStatsPreparation(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultListEntry(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultFighterListEntry(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultMutantListEntry(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultPlayerListEntry(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultTaxCollectorListEntry(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultAdditionalData(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultPvpData(), true, true);
            StoreDataManager.getInstance().registerClass(new FightResultExperienceData(), true, true);
            StoreDataManager.getInstance().registerClass(new AbstractFightDispellableEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTemporaryBoostEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTemporaryBoostStateEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTemporaryBoostWeaponDamagesEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTemporarySpellBoostEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTemporarySpellImmunityEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new FightTriggeredEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffect(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectInteger(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectCreature(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectLadder(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectDuration(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectDice(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectMinMax(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectString(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectMount(), true, true);
            StoreDataManager.getInstance().registerClass(new ObjectEffectDate(), true, true);
            StoreDataManager.getInstance().registerClass(new UpdateMountBoost(), true, true);
            StoreDataManager.getInstance().registerClass(new UpdateMountIntBoost(), true, true);
            StoreDataManager.getInstance().registerClass(new Shortcut(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutObject(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutObjectItem(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutObjectPreset(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutSpell(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutEmote(), true, true);
            StoreDataManager.getInstance().registerClass(new ShortcutSmiley(), true, true);
            StoreDataManager.getInstance().registerClass(new Achievement(), true, true);
            StoreDataManager.getInstance().registerClass(new AchievementStartedPercent(), true, true);
            StoreDataManager.getInstance().registerClass(new AchievementStartedValue(), true, true);
            StoreDataManager.getInstance().registerClass(new IgnoredInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new IgnoredOnlineInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FriendInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FriendOnlineInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FriendSpouseInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new FriendSpouseOnlineInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new InteractiveElementSkill(), true, true);
            StoreDataManager.getInstance().registerClass(new InteractiveElementNamedSkill(), true, true);
            StoreDataManager.getInstance().registerClass(new PartyMemberInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PartyMemberArenaInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new SkillActionDescription(), true, true);
            StoreDataManager.getInstance().registerClass(new SkillActionDescriptionTimed(), true, true);
            StoreDataManager.getInstance().registerClass(new SkillActionDescriptionCollect(), true, true);
            StoreDataManager.getInstance().registerClass(new SkillActionDescriptionCraft(), true, true);
            StoreDataManager.getInstance().registerClass(new SkillActionDescriptionCraftExtended(), true, true);
            StoreDataManager.getInstance().registerClass(new HouseInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new HouseInformationsExtended(), true, true);
            StoreDataManager.getInstance().registerClass(new PaddockInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PaddockBuyableInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PaddockAbandonnedInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PaddockPrivateInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new PaddockContentInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameContextActorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightFighterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightAIInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMonsterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMonsterWithAlignmentInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightTaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightFighterNamedInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMutantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightCharacterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayActorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNamedActorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMerchantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMerchantWithGuildInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayHumanoidInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMutantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayCharacterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMountInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNpcInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNpcWithQuestInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayGroupMonsterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayTaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayPrismInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayActorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNamedActorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMerchantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMerchantWithGuildInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayHumanoidInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMutantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayCharacterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayMountInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNpcInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayNpcWithQuestInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayGroupMonsterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayTaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameRolePlayPrismInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new HumanInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new HumanWithGuildInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new TaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new TaxCollectorInformationsInWaitForHelpState(), true, true);
            StoreDataManager.getInstance().registerClass(new QuestActiveInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new QuestActiveDetailedInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new QuestObjectiveInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new QuestObjectiveInformationsWithCompletion(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightFighterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightAIInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMonsterInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMonsterWithAlignmentInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightTaxCollectorInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightFighterNamedInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightMutantInformations(), true, true);
            StoreDataManager.getInstance().registerClass(new GameFightCharacterInformations(), true, true);
            return;
        }// end function

        _typesTypes[45] = CharacterBaseInformations;
        _typesTypes[86] = CharacterHardcoreInformations;
        _typesTypes[376] = PartyInvitationMemberInformations;
        _typesTypes[60] = EntityDispositionInformations;
        _typesTypes[107] = IdentifiedEntityDispositionInformations;
        _typesTypes[217] = FightEntityDispositionInformations;
        _typesTypes[44] = FightTeamMemberInformations;
        _typesTypes[13] = FightTeamMemberCharacterInformations;
        _typesTypes[6] = FightTeamMemberMonsterInformations;
        _typesTypes[177] = FightTeamMemberTaxCollectorInformations;
        _typesTypes[31] = GameFightMinimalStats;
        _typesTypes[360] = GameFightMinimalStatsPreparation;
        _typesTypes[16] = FightResultListEntry;
        _typesTypes[189] = FightResultFighterListEntry;
        _typesTypes[216] = FightResultMutantListEntry;
        _typesTypes[24] = FightResultPlayerListEntry;
        _typesTypes[84] = FightResultTaxCollectorListEntry;
        _typesTypes[191] = FightResultAdditionalData;
        _typesTypes[190] = FightResultPvpData;
        _typesTypes[192] = FightResultExperienceData;
        _typesTypes[206] = AbstractFightDispellableEffect;
        _typesTypes[209] = FightTemporaryBoostEffect;
        _typesTypes[214] = FightTemporaryBoostStateEffect;
        _typesTypes[211] = FightTemporaryBoostWeaponDamagesEffect;
        _typesTypes[207] = FightTemporarySpellBoostEffect;
        _typesTypes[366] = FightTemporarySpellImmunityEffect;
        _typesTypes[210] = FightTriggeredEffect;
        _typesTypes[76] = ObjectEffect;
        _typesTypes[70] = ObjectEffectInteger;
        _typesTypes[71] = ObjectEffectCreature;
        _typesTypes[81] = ObjectEffectLadder;
        _typesTypes[75] = ObjectEffectDuration;
        _typesTypes[73] = ObjectEffectDice;
        _typesTypes[82] = ObjectEffectMinMax;
        _typesTypes[74] = ObjectEffectString;
        _typesTypes[179] = ObjectEffectMount;
        _typesTypes[72] = ObjectEffectDate;
        _typesTypes[356] = UpdateMountBoost;
        _typesTypes[357] = UpdateMountIntBoost;
        _typesTypes[369] = Shortcut;
        _typesTypes[367] = ShortcutObject;
        _typesTypes[371] = ShortcutObjectItem;
        _typesTypes[370] = ShortcutObjectPreset;
        _typesTypes[368] = ShortcutSpell;
        _typesTypes[389] = ShortcutEmote;
        _typesTypes[388] = ShortcutSmiley;
        _typesTypes[363] = Achievement;
        _typesTypes[362] = AchievementStartedPercent;
        _typesTypes[361] = AchievementStartedValue;
        _typesTypes[106] = IgnoredInformations;
        _typesTypes[105] = IgnoredOnlineInformations;
        _typesTypes[78] = FriendInformations;
        _typesTypes[92] = FriendOnlineInformations;
        _typesTypes[77] = FriendSpouseInformations;
        _typesTypes[93] = FriendSpouseOnlineInformations;
        _typesTypes[219] = InteractiveElementSkill;
        _typesTypes[220] = InteractiveElementNamedSkill;
        _typesTypes[90] = PartyMemberInformations;
        _typesTypes[391] = PartyMemberArenaInformations;
        _typesTypes[102] = SkillActionDescription;
        _typesTypes[103] = SkillActionDescriptionTimed;
        _typesTypes[99] = SkillActionDescriptionCollect;
        _typesTypes[100] = SkillActionDescriptionCraft;
        _typesTypes[104] = SkillActionDescriptionCraftExtended;
        _typesTypes[111] = HouseInformations;
        _typesTypes[112] = HouseInformationsExtended;
        _typesTypes[132] = PaddockInformations;
        _typesTypes[130] = PaddockBuyableInformations;
        _typesTypes[133] = PaddockAbandonnedInformations;
        _typesTypes[131] = PaddockPrivateInformations;
        _typesTypes[183] = PaddockContentInformations;
        _typesTypes[150] = GameContextActorInformations;
        _typesTypes[143] = GameFightFighterInformations;
        _typesTypes[151] = GameFightAIInformations;
        _typesTypes[29] = GameFightMonsterInformations;
        _typesTypes[203] = GameFightMonsterWithAlignmentInformations;
        _typesTypes[48] = GameFightTaxCollectorInformations;
        _typesTypes[158] = GameFightFighterNamedInformations;
        _typesTypes[50] = GameFightMutantInformations;
        _typesTypes[46] = GameFightCharacterInformations;
        _typesTypes[141] = GameRolePlayActorInformations;
        _typesTypes[154] = GameRolePlayNamedActorInformations;
        _typesTypes[129] = GameRolePlayMerchantInformations;
        _typesTypes[146] = GameRolePlayMerchantWithGuildInformations;
        _typesTypes[159] = GameRolePlayHumanoidInformations;
        _typesTypes[3] = GameRolePlayMutantInformations;
        _typesTypes[36] = GameRolePlayCharacterInformations;
        _typesTypes[180] = GameRolePlayMountInformations;
        _typesTypes[156] = GameRolePlayNpcInformations;
        _typesTypes[383] = GameRolePlayNpcWithQuestInformations;
        _typesTypes[160] = GameRolePlayGroupMonsterInformations;
        _typesTypes[148] = GameRolePlayTaxCollectorInformations;
        _typesTypes[161] = GameRolePlayPrismInformations;
        _typesTypes[141] = GameRolePlayActorInformations;
        _typesTypes[154] = GameRolePlayNamedActorInformations;
        _typesTypes[129] = GameRolePlayMerchantInformations;
        _typesTypes[146] = GameRolePlayMerchantWithGuildInformations;
        _typesTypes[159] = GameRolePlayHumanoidInformations;
        _typesTypes[3] = GameRolePlayMutantInformations;
        _typesTypes[36] = GameRolePlayCharacterInformations;
        _typesTypes[180] = GameRolePlayMountInformations;
        _typesTypes[156] = GameRolePlayNpcInformations;
        _typesTypes[383] = GameRolePlayNpcWithQuestInformations;
        _typesTypes[160] = GameRolePlayGroupMonsterInformations;
        _typesTypes[148] = GameRolePlayTaxCollectorInformations;
        _typesTypes[161] = GameRolePlayPrismInformations;
        _typesTypes[157] = HumanInformations;
        _typesTypes[153] = HumanWithGuildInformations;
        _typesTypes[167] = TaxCollectorInformations;
        _typesTypes[166] = TaxCollectorInformationsInWaitForHelpState;
        _typesTypes[381] = QuestActiveInformations;
        _typesTypes[382] = QuestActiveDetailedInformations;
        _typesTypes[385] = QuestObjectiveInformations;
        _typesTypes[386] = QuestObjectiveInformationsWithCompletion;
        _typesTypes[143] = GameFightFighterInformations;
        _typesTypes[151] = GameFightAIInformations;
        _typesTypes[29] = GameFightMonsterInformations;
        _typesTypes[203] = GameFightMonsterWithAlignmentInformations;
        _typesTypes[48] = GameFightTaxCollectorInformations;
        _typesTypes[158] = GameFightFighterNamedInformations;
        _typesTypes[50] = GameFightMutantInformations;
        _typesTypes[46] = GameFightCharacterInformations;
    }
}