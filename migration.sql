-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('DISABLED', 'ACTIVE', 'NEWLY_CREATED', 'DEACTIVATED', 'DELETED');

-- CreateEnum
CREATE TYPE "UserJobFunction" AS ENUM ('CREATIVE', 'CUSTOMER_SUPPORT', 'DESIGN', 'EDUCATOR', 'ENGINEERING', 'FINANCE', 'FOUNDER', 'HR_LEGAL', 'MARKETING', 'OPERATIONS', 'PERSONAL', 'PRODUCT', 'PRODUCT_DESIGN', 'PRODUCT_MANAGEMENT', 'SALES', 'STUDENT', 'OTHER', 'NONE');

-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('SYSTEM', 'CUSTOMER');

-- CreateEnum
CREATE TYPE "Grantor" AS ENUM ('AUTHOR', 'ORG', 'DIRECT', 'PUBLIC');

-- CreateEnum
CREATE TYPE "TomeCreatorType" AS ENUM ('SYSTEM', 'USER', 'OTHER', 'UNKNOWN');

-- CreateEnum
CREATE TYPE "WorkspaceCreationMethod" AS ENUM ('UNKNOWN', 'SELF_SERVE', 'RETOOL', 'SELF_SERVE_ASSISTED', 'GUEST_AUTOCREATED');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'CANCELED', 'INCOMPLETE', 'INCOMPLETE_EXPIRED', 'PAST_DUE', 'TRIALING', 'UNPAID');

-- CreateEnum
CREATE TYPE "PriceType" AS ENUM ('PRO_MONTHLY', 'PRO_ANNUALLY');

-- CreateEnum
CREATE TYPE "AuditLogTransactionStatus" AS ENUM ('STARTED', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "AuditLogTransactionType" AS ENUM ('IMAGE_GENERATION', 'MANUAL_SYSTEM_CREDIT', 'API_ERROR_REFUND', 'MODERATION_FLAGGED_REFUND', 'REFERRAL_CREDIT', 'AUTO_TOME_GENERATION', 'DOC_TO_TOME_GENERATION', 'YOUTUBE_TO_TOME_GENERATION', 'TOME_PAGE_GENERATION', 'TEXT_REWRITE_GENERATION', 'SUMMARY_GENERATION');

-- CreateEnum
CREATE TYPE "CompletionPromptLogType" AS ENUM ('TOME_GENERATION', 'PAGE_GENERATION', 'TITLE_GENERATION', 'DOC_TO_TOME_TITLE_GENERATION', 'DOC_TO_TOME_IMAGE_PROMPT_GENERATION', 'YOUTUBE_TO_TOME_GENERATION', 'TEXT_REWRITE_GENERATION', 'SUMMARY_GENERATION', 'SUMMARY_HEADER_INSERTION', 'DOCUMENT_METADATA_EXTRACTION', 'LANGUAGE_DETECTION', 'OUTLINE_GENERATION', 'NOT_SPECIFIED');

-- CreateEnum
CREATE TYPE "MembershipRole" AS ENUM ('ADMIN', 'MEMBER', 'DEACTIVATED');

-- CreateEnum
CREATE TYPE "TomeAccess" AS ENUM ('PRIVATE', 'PUBLIC');

-- CreateEnum
CREATE TYPE "TomeRole" AS ENUM ('EDITOR', 'FULL', 'COMMENTER', 'VIEWER');

-- CreateEnum
CREATE TYPE "TileType" AS ENUM ('TEXT', 'IMAGE', 'FIGMA', 'AIRTABLE', 'ASANA_PROJECT', 'WEB', 'VIDEO', 'CODE', 'TWITTER', 'DEVICE', 'FRAMER', 'MIRO', 'GIPHY', 'UNSPLASH', 'BLANK', 'TABLE', 'WEBSITE', 'LOOKER', 'TEXT_SLATE', 'IMAGE_GENERATIVE');

-- CreateEnum
CREATE TYPE "VideoType" AS ENUM ('TILE', 'NARRATION');

-- CreateEnum
CREATE TYPE "VideoStatus" AS ENUM ('WAITING_FOR_UPLOAD', 'UPLOADED', 'ERRORED', 'DELETED', 'READY');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('READY', 'SENT', 'DELIVERED', 'IMPRESSED', 'CLICKED');

-- CreateEnum
CREATE TYPE "UserReferralCodeStatus" AS ENUM ('ACTIVE', 'DISABLED');

-- CreateEnum
CREATE TYPE "UserReferralRedemptionStatus" AS ENUM ('READY_TO_REDEEM', 'REWARD_REDEEMED', 'REWARD_DISABLED', 'INVALID_REDEMPTION');

-- CreateTable
CREATE TABLE "User" (
    "id" STRING NOT NULL,
    "email" STRING NOT NULL,
    "name" STRING,
    "password" STRING NOT NULL DEFAULT '',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "profileImage" STRING,
    "jobFunction" "UserJobFunction" NOT NULL DEFAULT 'NONE',
    "pending" BOOL NOT NULL DEFAULT false,
    "status" "UserStatus" NOT NULL DEFAULT 'NEWLY_CREATED',
    "type" "UserType" NOT NULL DEFAULT 'CUSTOMER',
    "auth0Id" STRING,
    "attributes" JSONB,
    "preferences" JSONB,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GuestInvitation" (
    "id" STRING NOT NULL,
    "userId" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "orgId" STRING,

    CONSTRAINT "GuestInvitation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tome" (
    "id" STRING NOT NULL,
    "slug" STRING NOT NULL DEFAULT '',
    "orgId" STRING,
    "authorId" STRING NOT NULL,
    "isTemplate" BOOL NOT NULL DEFAULT false,
    "duplicatedFromTomeId" STRING,
    "title" STRING NOT NULL,
    "description" STRING,
    "showLogo" BOOL NOT NULL DEFAULT true,
    "themeId" STRING,
    "published" BOOL NOT NULL DEFAULT false,
    "creatorType" "TomeCreatorType" NOT NULL DEFAULT 'UNKNOWN',
    "access" "TomeAccess" NOT NULL DEFAULT 'PRIVATE',
    "orgScope" "TomeRole",
    "publicScope" "TomeRole",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deleted" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "Tome_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Page" (
    "id" STRING NOT NULL,
    "tomeId" STRING,
    "position" INT4,
    "order" DECIMAL(65,30) NOT NULL,
    "overlay" JSONB,
    "layout" JSONB,
    "themeId" STRING,
    "autoThemeColor" BOOL NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deleted" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "Page_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" STRING NOT NULL,
    "pageId" STRING,
    "authorId" STRING NOT NULL,
    "content" STRING,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deleted" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Video" (
    "id" STRING NOT NULL,
    "muxPlaybackId" STRING,
    "muxAssetId" STRING,
    "muxStaticRenditionName" STRING,
    "muxProcessedAt" TIMESTAMP(3),
    "status" "VideoStatus" NOT NULL,
    "type" "VideoType" NOT NULL,
    "duration" DECIMAL(65,30),
    "authorId" STRING NOT NULL,
    "tileIds" STRING[],
    "pageIds" STRING[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Video_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tile" (
    "id" STRING NOT NULL,
    "pageId" STRING,
    "position" INT4,
    "type" "TileType" NOT NULL,
    "title" STRING,
    "content" STRING,
    "contentLink" STRING,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deleted" BOOL NOT NULL DEFAULT false,
    "imageFillType" STRING,
    "imageBackgroundColor" STRING,
    "order" DECIMAL(65,30) NOT NULL,
    "metadata" JSONB,
    "annotations" JSONB,

    CONSTRAINT "Tile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserTomeView" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "userId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "clientId" STRING,
    "grantor" "Grantor",

    CONSTRAINT "UserTomeView_pkey" PRIMARY KEY ("userId","tomeId")
);

-- CreateTable
CREATE TABLE "UnregisteredUserTomeView" (
    "anonymousId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "clientId" STRING,
    "viewedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),

    CONSTRAINT "UnregisteredUserTomeView_pkey" PRIMARY KEY ("tomeId","anonymousId")
);

-- CreateTable
CREATE TABLE "Permission" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "userId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "role" "TomeRole" NOT NULL,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPageView" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "userId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "pageId" STRING NOT NULL,
    "clientId" STRING,

    CONSTRAINT "UserPageView_pkey" PRIMARY KEY ("userId","tomeId","pageId")
);

-- CreateTable
CREATE TABLE "UserPageCommentsView" (
    "id" STRING NOT NULL,
    "userId" STRING NOT NULL,
    "pageId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "lastViewedAt" TIMESTAMP(3),

    CONSTRAINT "UserPageCommentsView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Color" (
    "id" STRING NOT NULL,
    "hex" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "orgId" STRING NOT NULL,

    CONSTRAINT "Color_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" STRING NOT NULL,
    "auth0Id" STRING NOT NULL,
    "slug" STRING NOT NULL,
    "name" STRING NOT NULL,
    "createdVia" "WorkspaceCreationMethod" NOT NULL DEFAULT 'UNKNOWN',
    "emailDomains" STRING[] DEFAULT ARRAY[]::STRING[],
    "emailDomainMatchingEnabled" BOOL NOT NULL DEFAULT false,
    "customImagePath" STRING,
    "logoImagePathGlobal" STRING,
    "logoImagePathDark" STRING,
    "logoImagePathLight" STRING,
    "shouldUseThemedLogo" BOOL NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dateBecameMultiMember" TIMESTAMP(3),
    "showTomeBrandingPreference" BOOL NOT NULL DEFAULT true,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Theme" (
    "id" STRING NOT NULL,
    "orgId" STRING,
    "name" STRING,
    "colors" JSONB NOT NULL,
    "autoThemeColor" BOOL NOT NULL DEFAULT true,
    "headingFontId" STRING,
    "paragraphFontId" STRING,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "Theme_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TypeFamily" (
    "id" STRING NOT NULL,
    "name" STRING NOT NULL,
    "section" STRING,

    CONSTRAINT "TypeFamily_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Font" (
    "id" STRING NOT NULL,
    "name" STRING,
    "weight" INT4 NOT NULL,
    "italic" BOOL NOT NULL,
    "typeFamilyId" STRING NOT NULL,
    "openTypeURL" STRING,
    "webFontURL" STRING,

    CONSTRAINT "Font_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrgUser" (
    "id" STRING NOT NULL,
    "orgId" STRING NOT NULL,
    "userId" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "role" "MembershipRole" NOT NULL DEFAULT 'MEMBER',

    CONSTRAINT "OrgUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "recipientId" STRING NOT NULL,
    "type" STRING NOT NULL,
    "payload" JSONB,
    "status" "NotificationStatus" NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationSubscription" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "subscriberId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "pageId" STRING,
    "unsubscribed" BOOL NOT NULL DEFAULT false,
    "reason" STRING,

    CONSTRAINT "NotificationSubscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SlackOAuth" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" STRING NOT NULL,
    "accessToken" STRING,
    "scope" STRING,
    "slackUserId" STRING,
    "slackTeamId" STRING,
    "slackTeamName" STRING,
    "slackEnterpriseId" STRING,
    "botChannelId" STRING,

    CONSTRAINT "SlackOAuth_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpatialComment" (
    "id" STRING NOT NULL,
    "tileId" STRING NOT NULL,
    "authorId" STRING NOT NULL,
    "positionX" DECIMAL(65,30) NOT NULL,
    "positionY" DECIMAL(65,30) NOT NULL,
    "content" STRING,
    "emoji" STRING,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deleted" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "SpatialComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TabularData" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "payload" JSONB NOT NULL,
    "tileIds" STRING[],

    CONSTRAINT "TabularData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ImageGenerationRecord" (
    "id" STRING NOT NULL,
    "userId" STRING NOT NULL,
    "tileId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "prompt" STRING NOT NULL,
    "negativePrompt" STRING,
    "engineType" STRING,
    "seeds" STRING[],
    "imagePaths" STRING[],
    "dimensionType" STRING,
    "usedCustomNegativePrompt" BOOL NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ImageGenerationRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CreditsAccount" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" STRING NOT NULL,
    "balance" FLOAT8 NOT NULL DEFAULT 0,

    CONSTRAINT "CreditsAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CreditsAuditLog" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" "AuditLogTransactionStatus" NOT NULL,
    "transactionType" "AuditLogTransactionType" NOT NULL,
    "amount" FLOAT8 NOT NULL,
    "accountId" STRING NOT NULL,

    CONSTRAINT "CreditsAuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserReferralCode" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" STRING NOT NULL,
    "code" STRING NOT NULL,
    "status" "UserReferralCodeStatus" NOT NULL,

    CONSTRAINT "UserReferralCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserReferralRedemption" (
    "id" STRING NOT NULL,
    "referralCodeId" STRING NOT NULL,
    "userId" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" "UserReferralRedemptionStatus" NOT NULL,

    CONSTRAINT "UserReferralRedemption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompletionPromptLog" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "requestQuery" JSONB NOT NULL,
    "apiResponse" JSONB NOT NULL,
    "userQuery" STRING NOT NULL,
    "responseTimeMs" INT4 NOT NULL,
    "type" "CompletionPromptLogType" NOT NULL DEFAULT 'NOT_SPECIFIED',
    "userId" STRING NOT NULL,
    "tomeId" STRING NOT NULL,
    "sessionId" STRING,
    "operationId" STRING,

    CONSTRAINT "CompletionPromptLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutoGeneratedMetadata" (
    "id" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "artStyle" STRING,
    "tomeId" STRING NOT NULL,

    CONSTRAINT "AutoGeneratedMetadata_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationBillingStatus" (
    "orgId" STRING NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "stripeSubscriptionId" STRING NOT NULL,
    "stripeSubscriptionItemId" STRING NOT NULL,
    "stripeCustomerId" STRING NOT NULL,
    "priceType" "PriceType",
    "subscriptionStatus" "SubscriptionStatus" NOT NULL,
    "subscribedSeatCount" INT4 NOT NULL,
    "lastSuccessfulBilling" TIMESTAMP(3),
    "firstDeliquentBilling" TIMESTAMP(3),
    "cancelAtPeriodEnd" BOOL NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User.email_unique" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User.auth0Id_unique" ON "User"("auth0Id");

-- CreateIndex
CREATE UNIQUE INDEX "GuestInvitation.userId_unique" ON "GuestInvitation"("userId");

-- CreateIndex
CREATE INDEX "tome_orgid_index" ON "Tome"("orgId");

-- CreateIndex
CREATE INDEX "tome_authorid_index" ON "Tome"("authorId");

-- CreateIndex
CREATE INDEX "tome_istemplate_index" ON "Tome"("isTemplate");

-- CreateIndex
CREATE INDEX "page_tomeId_index" ON "Page"("tomeId", "deleted");

-- CreateIndex
CREATE INDEX "comment_page_index" ON "Comment"("pageId", "deleted");

-- CreateIndex
CREATE INDEX "tile_page_index" ON "Tile"("pageId");

-- CreateIndex
CREATE INDEX "UserTomeView_tomeId" ON "UserTomeView"("tomeId");

-- CreateIndex
CREATE UNIQUE INDEX "Permissions" ON "Permission"("tomeId", "userId");

-- CreateIndex
CREATE INDEX "UserPageView_tomeId_pageId" ON "UserPageView"("tomeId", "pageId");

-- CreateIndex
CREATE UNIQUE INDEX "UserPageCommentsViews" ON "UserPageCommentsView"("pageId", "userId", "tomeId");

-- CreateIndex
CREATE UNIQUE INDEX "ColorOrgHex" ON "Color"("orgId", "hex");

-- CreateIndex
CREATE UNIQUE INDEX "Organization.auth0Id_unique" ON "Organization"("auth0Id");

-- CreateIndex
CREATE UNIQUE INDEX "Organization.slug_unique" ON "Organization"("slug");

-- CreateIndex
CREATE INDEX "Theme_orgId_idx" ON "Theme"("orgId");

-- CreateIndex
CREATE UNIQUE INDEX "TypeFamily_name" ON "TypeFamily"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Font_typeFamilyId_italic_weight" ON "Font"("typeFamilyId", "italic", "weight");

-- CreateIndex
CREATE INDEX "Membership_userId" ON "OrgUser"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "memberships" ON "OrgUser"("orgId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationSubscriptions" ON "NotificationSubscription"("subscriberId", "tomeId", "pageId");

-- CreateIndex
CREATE UNIQUE INDEX "SlackOAuth.userId_unique" ON "SlackOAuth"("userId");

-- CreateIndex
CREATE INDEX "ImageGenerationRecord_userId" ON "ImageGenerationRecord"("userId");

-- CreateIndex
CREATE INDEX "ImageGenerationRecord_tileId" ON "ImageGenerationRecord"("tileId");

-- CreateIndex
CREATE INDEX "ImageGenerationRecord_tomeId" ON "ImageGenerationRecord"("tomeId");

-- CreateIndex
CREATE UNIQUE INDEX "CreditsAccount.userId_unique" ON "CreditsAccount"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserReferralCode.code_unique" ON "UserReferralCode"("code");

-- CreateIndex
CREATE INDEX "UserReferralCode_userId_idx" ON "UserReferralCode"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserReferralRedemption.userId_unique" ON "UserReferralRedemption"("userId");

-- CreateIndex
CREATE INDEX "UserReferralRedemption_referralCodeId_index" ON "UserReferralRedemption"("referralCodeId");

-- CreateIndex
CREATE INDEX "UserReferralRedemption_userId_index" ON "UserReferralRedemption"("userId");

-- CreateIndex
CREATE INDEX "CompletionPromptLog.userId_index" ON "CompletionPromptLog"("userId");

-- CreateIndex
CREATE INDEX "CompletionPromptLog.tomeId_index" ON "CompletionPromptLog"("tomeId");

-- CreateIndex
CREATE UNIQUE INDEX "AutoGeneratedMetadata_tomeId_key" ON "AutoGeneratedMetadata"("tomeId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationBillingStatus_orgId_key" ON "OrganizationBillingStatus"("orgId");

-- AddForeignKey
ALTER TABLE "GuestInvitation" ADD CONSTRAINT "GuestInvitation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tome" ADD CONSTRAINT "Tome_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tome" ADD CONSTRAINT "Tome_orgId_fkey" FOREIGN KEY ("orgId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tome" ADD CONSTRAINT "Tome_themeId_fkey" FOREIGN KEY ("themeId") REFERENCES "Theme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tome" ADD CONSTRAINT "Tome_duplicatedFromTomeId_fkey" FOREIGN KEY ("duplicatedFromTomeId") REFERENCES "Tome"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Page" ADD CONSTRAINT "Page_themeId_fkey" FOREIGN KEY ("themeId") REFERENCES "Theme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Page" ADD CONSTRAINT "Page_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Video" ADD CONSTRAINT "Video_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tile" ADD CONSTRAINT "Tile_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTomeView" ADD CONSTRAINT "UserTomeView_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTomeView" ADD CONSTRAINT "UserTomeView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UnregisteredUserTomeView" ADD CONSTRAINT "UnregisteredUserTomeView_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Permission" ADD CONSTRAINT "Permission_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Permission" ADD CONSTRAINT "Permission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageView" ADD CONSTRAINT "UserPageView_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageView" ADD CONSTRAINT "UserPageView_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageView" ADD CONSTRAINT "UserPageView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageCommentsView" ADD CONSTRAINT "UserPageCommentsView_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageCommentsView" ADD CONSTRAINT "UserPageCommentsView_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPageCommentsView" ADD CONSTRAINT "UserPageCommentsView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Color" ADD CONSTRAINT "Color_orgId_fkey" FOREIGN KEY ("orgId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Theme" ADD CONSTRAINT "Theme_headingFontId_fkey" FOREIGN KEY ("headingFontId") REFERENCES "Font"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Theme" ADD CONSTRAINT "Theme_orgId_fkey" FOREIGN KEY ("orgId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Theme" ADD CONSTRAINT "Theme_paragraphFontId_fkey" FOREIGN KEY ("paragraphFontId") REFERENCES "Font"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Font" ADD CONSTRAINT "Font_typeFamilyId_fkey" FOREIGN KEY ("typeFamilyId") REFERENCES "TypeFamily"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrgUser" ADD CONSTRAINT "OrgUser_orgId_fkey" FOREIGN KEY ("orgId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrgUser" ADD CONSTRAINT "OrgUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpatialComment" ADD CONSTRAINT "SpatialComment_tileId_fkey" FOREIGN KEY ("tileId") REFERENCES "Tile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImageGenerationRecord" ADD CONSTRAINT "ImageGenerationRecord_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreditsAccount" ADD CONSTRAINT "CreditsAccount_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreditsAuditLog" ADD CONSTRAINT "CreditsAuditLog_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "CreditsAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserReferralCode" ADD CONSTRAINT "UserReferralCode_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserReferralRedemption" ADD CONSTRAINT "UserReferralRedemption_referralCodeId_fkey" FOREIGN KEY ("referralCodeId") REFERENCES "UserReferralCode"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserReferralRedemption" ADD CONSTRAINT "UserReferralRedemption_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutoGeneratedMetadata" ADD CONSTRAINT "AutoGeneratedMetadata_tomeId_fkey" FOREIGN KEY ("tomeId") REFERENCES "Tome"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationBillingStatus" ADD CONSTRAINT "OrganizationBillingStatus_orgId_fkey" FOREIGN KEY ("orgId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
