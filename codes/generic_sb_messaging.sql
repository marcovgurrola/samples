-- ========================================================================================================
--Description:  Generic FIFO Messaging Protocol using Microsoft's SQL Server Service Broker, used to sync
--				database with external Apps (Web Sites, middlewares) without making full data pooling.
--Author:       Marco Vinicio Gurrola Paco
--Created:      20 Jan 2013
--Modificated:	11 Aug 2014
-- ========================================================================================================

--message, contract, queue, service creation.
IF (OBJECT_ID('WebIdMsg') IS NOT NULL)
	DROP MESSAGE TYPE WebIdMsg
GO
CREATE MESSAGE TYPE WebIdMsg
VALIDATION = NONE;
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('WebQueueContract') IS NOT NULL)
	DROP CONTRACT WebIdQueueContract
GO
CREATE CONTRACT WebIdQueueContract
(WebIdMsg SENT BY INITIATOR)
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('WebIdReceiverQueue') IS NOT NULL)
	DROP QUEUE WebIdReceiverQueue
GO
CREATE QUEUE dbo.WebIdReceiverQueue
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('WebIdSenderQueue') IS NOT NULL)
	DROP QUEUE WebIdSenderQueue
GO
CREATE QUEUE dbo.WebIdSenderQueue
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('WebIdSenderService') IS NOT NULL)
	DROP SERVICE WebIdSenderService
GO
CREATE SERVICE WebIdSenderService
ON QUEUE dbo.WebIdSenderQueue
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('WebIdReceiverService') IS NOT NULL)
	DROP SERVICE WebIdReceiverService
GO
CREATE SERVICE WebIdReceiverService
ON QUEUE dbo.WebIdReceiverQueue (WebIdQueueContract)
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spSenWebIdToQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spSenWebIdToQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Adds an element into the FIFO Queue
-- ========================================================================================================
CREATE PROC [DBO].[spSenWebIdToQueue]
@id_tableName VARCHAR(50)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		BEGIN TRANSACTION

		DECLARE @conversationID UNIQUEIDENTIFIER

		BEGIN DIALOG CONVERSATION @conversationID
		FROM SERVICE WebIdSenderService
		TO SERVICE 'WebIdReceiverService'
		ON CONTRACT WebIdQueueContract;
		SEND ON CONVERSATION @conversationID
		MESSAGE TYPE WebIdMsg(@id_tableName);
		END CONVERSATION @conversationID

		COMMIT TRANSACTION

		SET NOCOUNT OFF

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		END CONVERSATION @conversationID

		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

END
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.fGetWebConversationIdFromQueue') IS NOT NULL)
	DROP FUNCTION dbo.fGetWebConversationIdFromQueue
GO

CREATE FUNCTION fGetWebConversationIdFromQueue 
(  
	@msgBin  VARBINARY(50)
)
RETURNS TABLE 
AS
RETURN
(
	SELECT TOP(1) COALESCE(CAST(conversation_group_id AS VARCHAR(50)),NULL) AS ConversationId
	FROM WebIdReceiverQueue
	WHERE message_body = @msgBin
)
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spGetWebConversationIdFromQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spGetWebConversationIdFromQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Gets the element's Conversation Id by the message content
-- ========================================================================================================
CREATE PROC [DBO].[spGetWebConversationIdFromQueue]
	@mensagem VARCHAR(50)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @msgBin AS VARBINARY(50)
		SELECT @msgBin = CAST(@mensagem AS VARBINARY(50))

		SELECT * FROM fGetWebConversationIdFromQueue(@msgBin)

		SET NOCOUNT OFF
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
END
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spGetWebIdFromQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spGetWebIdFromQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Gets(dequeues) an element from the Queue by its Conversation Id
-- ========================================================================================================
CREATE PROC [DBO].[spGetWebIdFromQueue]
(
	@ConversationId VARCHAR(50),
	@table_id VARCHAR(50) OUTPUT
)
AS
	RECEIVE CONVERT(VARCHAR(50), message_body) FROM WebIdReceiverQueue
	WHERE conversation_group_id = @ConversationId
	
	DECLARE @ch UNIQUEIDENTIFIER = NULL
	SELECT @ch = [conversation_handle] from sys.conversation_endpoints
    WHERE [conversation_id] = @ConversationId
	
	IF (@ch <> NULL)
	BEGIN
		END CONVERSATION @ch WITH CLEANUP
	END
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spGetWebIdFromGenericQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spGetWebIdFromGenericQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Gets(dequeues) an element from the Queue
-- ========================================================================================================
CREATE PROC [DBO].[spGetWebIdFromGenericQueue]
AS
	RECEIVE * FROM WebIdReceiverQueue
GO
/*-----------------------------------------*/


/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spPeeWebIdQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spPeeWebIdQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Discovers (peeks) the top 1 modified data row id
-- ========================================================================================================
CREATE PROC [DBO].[spPeeWebIdQueue]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
	
		SELECT TOP(1) conversation_group_id AS ConversationId, COALESCE(CONVERT(VARCHAR(50),
			message_body),NULL) AS QueueId
		FROM WebIdReceiverQueue

		SET NOCOUNT OFF
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
END
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spPeeWebIdsQueue') IS NOT NULL)
	DROP PROCEDURE dbo.spPeeWebIdsQueue
GO
-- ========================================================================================================
-- Author:		Marco Vinicio Gurrola Paco
-- Created: 	17/10/2012
-- Description:	Discover (peek) the modified data rows ids
-- ========================================================================================================
CREATE PROC [DBO].[spPeeWebIdsQueue]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
			
		SELECT conversation_group_id AS ConversationId,
			COALESCE(CONVERT(VARCHAR(50), message_body), NULL) AS QueueId
		FROM WebIdReceiverQueue

		SET NOCOUNT OFF

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
END
GO
/*-----------------------------------------*/

/*-----------------------------------------*/
IF (OBJECT_ID('dbo.spGetUTCDate') IS NOT NULL)
	DROP PROCEDURE dbo.spGetUTCDate
GO
CREATE PROC [DBO].[spGetUTCDate]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		SELECT CONVERT(VARCHAR(30),GETUTCDATE())
				
		SET NOCOUNT OFF

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH 
END
GO