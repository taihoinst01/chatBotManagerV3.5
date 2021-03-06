USE [chatMngV3_dev]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ENTITY_ORDERBY_ADD]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_ENTITY_ORDERBY_ADD] (
	@fullentity VARCHAR(2000) = ' '
	)
RETURNS @temptable TABLE (
	RESULT			VARCHAR(500)
	)
AS
--DECLARE @fullentity NVARCHAR(MAX)
--SET @fullentity = '프리미엄스페셜,가격,충돌,팬텀블랙루프다크나이트,다크나이트,다크,그린,오랜지,그린오랜지,오랜지'
BEGIN
	DECLARE @delimiter NVARCHAR(1) 
	DECLARE @item NVARCHAR(MAX)
	DECLARE @results TABLE (
		Item    NVARCHAR(MAX)
	)
	SET @delimiter = ','
	SET @item = NULL

	DECLARE @val NVARCHAR(MAX)


	SELECT 
	@fullentity = 
		ISNULL(MAX(CASE WHEN POS = 1 THEN ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 2 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 3 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 4 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 5 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 6 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 7 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 8 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 9 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 10 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 11 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 12 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 13 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 14 THEN ',' + ENTITY END),'')
		+ISNULL(MAX(CASE WHEN POS = 15 THEN ',' + ENTITY END),'')
	FROM 
		(
			SELECT	ENTITY, DENSE_RANK() OVER (ORDER BY ENTITY ASC) AS POS
			FROM	TBL_COMMON_ENTITY_DEFINE
			WHERE	CHARINDEX(ENTITY_VALUE,@fullentity) > 0
		) A

 
	WHILE LEN(@fullentity) > 0
		BEGIN
			DECLARE @index	INT
			DECLARE @Ccount	INT

			SET @index = PATINDEX('%' + @delimiter + '%', @fullentity)
			IF @index > 0
				BEGIN
					SET @item = SUBSTRING(@fullentity, 0, @index)
					SET @fullentity = SUBSTRING(@fullentity, LEN(@item + @delimiter) + 1, LEN(@fullentity))
					SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(Item,@item) > 0

					IF @Ccount = 0
						BEGIN
							SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(@item,Item) > 0
							IF @Ccount = 0
								BEGIN
									INSERT INTO @results ( Item ) VALUES ( @item )
								END
						END
					ELSE
						BEGIN
							DELETE FROM @results WHERE Item IN (SELECT ITEM FROM @results WHERE CHARINDEX(Item,@item) > 0 )
							INSERT INTO @results ( Item ) VALUES ( @item )
						END
				END
			ELSE
				BEGIN
					SET @item = @fullentity
					SET @fullentity = NULL
 
					SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(Item,@item) > 0
					IF @Ccount = 0
						BEGIN
							SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(@item,Item) > 0
							IF @Ccount = 0
								BEGIN
									INSERT INTO @results ( Item ) VALUES ( @item )
								END
						END
					ELSE
						BEGIN
							DELETE FROM @results WHERE Item IN (SELECT ITEM FROM @results WHERE CHARINDEX(Item,@item) > 0 )
							INSERT INTO @results ( Item ) VALUES ( @item )
						END
				END
			END


		SELECT @val = A.VALUE
		FROM 
			(
				SELECT  
					STUFF(
					(
						SELECT ',' + Item
						FROM @results X		
						FOR XML PATH ('')),1,1,'')
					value
			) A

		INSERT @temptable
		SELECT 
			ISNULL(MAX(CASE WHEN POS = 1 THEN VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 2 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 3 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 4 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 5 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 6 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 7 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 8 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 9 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 10 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 11 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 12 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 13 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 14 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 15 THEN ',' + VAL1 END),'') AS VAL
		FROM	
			(
				SELECT VAL1, POS 
				FROM Split2(@val,',') 
			) A
	
	RETURN;
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_OCR_VALUE_ORDERBY_ADD]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_OCR_VALUE_ORDERBY_ADD] (
	@fullVALUE VARCHAR(8000) = ' '
	)
RETURNS @temptable TABLE (
	RESULT			VARCHAR(500)
	)
AS
--DECLARE @fullVALUE NVARCHAR(MAX)
--SET @fullVALUE = '프리미엄스페셜,가격,충돌,팬텀블랙루프다크나이트,다크나이트,다크,그린,오랜지,그린오랜지,오랜지'
BEGIN
	DECLARE @delimiter NVARCHAR(1) 
	DECLARE @item NVARCHAR(MAX)
	DECLARE @results TABLE (
		Item    NVARCHAR(MAX)
	)
	SET @delimiter = ','
	SET @item = NULL

	DECLARE @val NVARCHAR(MAX)


	SELECT 
	@fullVALUE = 
		ISNULL(MAX(CASE WHEN POS = 1 THEN VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 2 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 3 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 4 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 5 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 6 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 7 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 8 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 9 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 10 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 11 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 12 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 13 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 14 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 15 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 16 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 17 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 18 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 19 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 20 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 21 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 22 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 23 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 24 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 25 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 26 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 27 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 28 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 29 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 32 THEN ',' + VALUE END),'')
		+ISNULL(MAX(CASE WHEN POS = 31 THEN ',' + VALUE END),'')
	FROM 
		(
			SELECT	value, DENSE_RANK() OVER (ORDER BY value ASC) AS POS
			FROM	OCR_ENTITY
			WHERE	CHARINDEX(id,@fullVALUE) > 0
		) A

 
	WHILE LEN(@fullVALUE) > 0
		BEGIN
			DECLARE @index	INT
			DECLARE @Ccount	INT

			SET @index = PATINDEX('%' + @delimiter + '%', @fullVALUE)
			IF @index > 0
				BEGIN
					SET @item = SUBSTRING(@fullVALUE, 0, @index)
					SET @fullVALUE = SUBSTRING(@fullVALUE, LEN(@item + @delimiter) + 1, LEN(@fullVALUE))
					SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(Item,@item) > 0

					IF @Ccount = 0
						BEGIN
							SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(@item,Item) > 0
							IF @Ccount = 0
								BEGIN
									INSERT INTO @results ( Item ) VALUES ( @item )
								END
						END
					ELSE
						BEGIN
							DELETE FROM @results WHERE Item IN (SELECT ITEM FROM @results WHERE CHARINDEX(Item,@item) > 0 )
							INSERT INTO @results ( Item ) VALUES ( @item )
						END
				END
			ELSE
				BEGIN
					SET @item = @fullVALUE
					SET @fullVALUE = NULL
 
					SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(Item,@item) > 0
					IF @Ccount = 0
						BEGIN
							SELECT @Ccount = COUNT(*) FROM @results WHERE CHARINDEX(@item,Item) > 0
							IF @Ccount = 0
								BEGIN
									INSERT INTO @results ( Item ) VALUES ( @item )
								END
						END
					ELSE
						BEGIN
							DELETE FROM @results WHERE Item IN (SELECT ITEM FROM @results WHERE CHARINDEX(Item,@item) > 0 )
							INSERT INTO @results ( Item ) VALUES ( @item )
						END
				END
			END


		SELECT @val = A.VALUE
		FROM 
			(
				SELECT  
					STUFF(
					(
						SELECT ',' + Item
						FROM @results X		
						FOR XML PATH ('')),1,1,'')
					value
			) A

		INSERT @temptable
		SELECT 
			ISNULL(MAX(CASE WHEN POS = 1 THEN VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 2 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 3 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 4 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 5 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 6 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 7 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 8 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 9 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 10 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 11 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 12 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 13 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 14 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 15 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 16 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 17 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 18 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 19 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 20 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 21 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 22 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 23 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 24 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 25 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 26 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 27 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 28 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 29 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 32 THEN ',' + VAL1 END),'')
			+ISNULL(MAX(CASE WHEN POS = 31 THEN ',' + VAL1 END),'') AS VAL
		FROM	
			(
				SELECT VAL1, POS 
				FROM Split2(@val,',') 
			) A
	
	RETURN;
END
GO
/****** Object:  UserDefinedFunction [dbo].[Split2]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Split2](@String VARCHAR(8000), @Delimiter CHAR(1))       
RETURNS @temptable TABLE (VAL1 VARCHAR(8000), POS int)       
 AS       
 BEGIN       
 DECLARE @idx INT       
 DECLARE @slice VARCHAR(8000)       

 SELECT @idx = 1       
     IF len(@String)<1 OR @String IS NULL  RETURN       

 WHILE @idx!= 0       
 BEGIN       
     SET @idx = charindex(@Delimiter,@String)       
     IF @idx!=0       
         SET @slice = LEFT(@String,@idx - 1)       
     ELSE       
         SET @slice = @String       

     IF(LEN(@slice)>0)  
         INSERT INTO @temptable(VAL1) VALUES(@slice)       

     SET @String = RIGHT(@String,len(@String) - @idx)       
     IF LEN(@String) = 0 BREAK 

     --Added Rownumber here:
     ;With CTE as
     (
         Select Row_number() over (Order By VAL1) as POS
         ,VAL1
         FROM  @temptable
      )      
     Update T
     set T.POS = CTE.POS
     From @temptable T
     JOIN CTE ON T.VAL1 = CTE.VAL1
 END   
 RETURN       
 END

GO
/****** Object:  Table [dbo].[TB_USER_M]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_USER_M](
	[EMP_NUM] [int] NOT NULL,
	[USER_ID] [nvarchar](200) NOT NULL,
	[SCRT_NUM] [nvarchar](500) NULL,
	[EMP_NM] [nvarchar](50) NULL,
	[EMP_ENGNM] [nvarchar](100) NULL,
	[EMAIL] [nvarchar](100) NULL,
	[M_P_NUM_1] [nvarchar](20) NULL,
	[M_P_NUM_2] [nvarchar](20) NULL,
	[M_P_NUM_3] [nvarchar](20) NULL,
	[USE_YN] [nvarchar](1) NULL,
	[REG_DT] [datetime] NULL,
	[REG_ID] [nvarchar](20) NULL,
	[MOD_DT] [datetime] NULL,
	[MOD_ID] [nvarchar](20) NULL,
	[LAST_LOGIN_DT] [datetime] NULL,
	[LAST_LOGIN_IP] [varchar](20) NULL,
	[LOGIN_FAIL_CNT] [numeric](38, 0) NULL,
	[LOGIN_FAIL_DT] [datetime] NULL,
	[LAST_SCRT_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_CHAT_RELATION_APP]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_CHAT_RELATION_APP](
	[CHAT_ID] [int] NOT NULL,
	[APP_ID] [nchar](40) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_CHATBOT_APP]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_CHATBOT_APP](
	[CHATBOT_NUM] [int] NOT NULL,
	[CHATBOT_NAME] [varchar](500) NOT NULL,
	[CULTURE] [varchar](100) NOT NULL,
	[DESCRIPTION] [varchar](1000) NULL,
	[APP_COLOR] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CHATBOT_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_CHATBOT_CONF]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_CHATBOT_CONF](
	[SID] [int] IDENTITY(1,1) NOT NULL,
	[CNF_TYPE] [nvarchar](50) NULL,
	[CNF_NM] [nvarchar](200) NULL,
	[CNF_VALUE] [nvarchar](500) NULL,
	[ORDER_NO] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_COMMON_ENTITY_DEFINE]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_COMMON_ENTITY_DEFINE](
	[ENTITY_VALUE] [nvarchar](300) NOT NULL,
	[ENTITY] [nvarchar](300) NOT NULL,
	[API_GROUP] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_DB_CONFIG]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_DB_CONFIG](
	[DB_NUM] [int] IDENTITY(1,1) NOT NULL,
	[USER_NAME] [nvarchar](50) NOT NULL,
	[PASSWORD] [nvarchar](500) NOT NULL,
	[SERVER] [nvarchar](150) NOT NULL,
	[DATABASE_NAME] [nvarchar](70) NOT NULL,
	[APP_NAME] [nvarchar](100) NOT NULL,
	[APP_ID] [nvarchar](80) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[APP_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_LUIS_APP]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_LUIS_APP](
	[APP_NUM] [int] NOT NULL,
	[SUBSC_KEY] [nvarchar](60) NOT NULL,
	[APP_ID] [nvarchar](80) NOT NULL,
	[VERSION] [nvarchar](10) NULL,
	[APP_NAME] [nvarchar](100) NULL,
	[OWNER_EMAIL] [nvarchar](60) NULL,
	[REG_DT] [date] NULL,
	[CULTURE] [nvarchar](10) NULL,
	[DESCRIPTION] [nvarchar](200) NULL,
	[APP_COLOR] [char](20) NOT NULL,
	[CHATBOT_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_URL]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_URL](
	[API_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[API_ID] [varchar](100) NOT NULL,
	[API_URL] [varchar](200) NOT NULL,
	[API_DESC] [varchar](300) NULL,
	[USE_YN] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[API_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_USER_RELATION_APP]    Script Date: 2018-05-08 오후 1:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_USER_RELATION_APP](
	[USER_ID] [nvarchar](100) NOT NULL,
	[APP_ID] [nvarchar](40) NOT NULL,
	[CHAT_ID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TBL_LUIS_APP] ADD  DEFAULT ('color_01') FOR [APP_COLOR]
GO
ALTER TABLE [dbo].[TBL_URL] ADD  DEFAULT ('Y') FOR [USE_YN]
GO
ALTER TABLE [dbo].[TBL_USER_RELATION_APP] ADD  DEFAULT ((0)) FOR [CHAT_ID]
GO
